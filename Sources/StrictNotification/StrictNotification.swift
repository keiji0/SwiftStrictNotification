import Foundation
import Combine

/// 厳密な型を通知することができる通知オブジェクト
/// NotificationNameの文字被りを気にする必要がなく、通知に使うUserInfoデータも型指定できる
public struct StrictNotification<Value> {
    /// NotificationCenterの通知に使うName
    let name = Notification.Name("StrictNotification." + UUID().uuidString)
    /// 初期化処理
    public init() { }
}

public extension StrictNotification where Value: Any {
    /// 通知を送る
    func post(_ value: Value, object: Any? = nil) {
        NotificationCenter.default.post(
            name: name,
            object: object,
            userInfo: ["value": value]
        )
    }

    /// 通知を受け取るPublisherを取得
    func publisher(object: AnyObject? = nil) -> Publishers.Map<NotificationCenter.Publisher, Value> {
        NotificationCenter.default.publisher(for: name, object: object)
            .map{
                $0.userInfo!["value"] as! Value
            }
    }
}

/// 通知型がVoidの場合引数は空にしておきたいので、条件付きでメソッドを追加
public extension StrictNotification where Value == Void {
    /// 通知を送る
    func post(object: Any? = nil) {
        NotificationCenter.default.post(
            name: name,
            object: object,
            userInfo: nil
        )
    }
    
    /// 通知を受け取るPublisherを取得
    func publisher(object: AnyObject? = nil) -> Publishers.Map<NotificationCenter.Publisher, Void> {
        NotificationCenter.default.publisher(for: name, object: object)
            .map{ _ in () }
    }
}

