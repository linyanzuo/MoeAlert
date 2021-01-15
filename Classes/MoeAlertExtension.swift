//
//  AlertExtension.swift
//  MoeAlert
//
//  Created by Zed on 2020/12/31.
//


extension UIViewController: AlertNamespaceWrappable {}
public extension AlertTypeWrapperProtocol where WrappedType: UIViewController {
    /// 呈现模态视图(Model Present)，并使控制器根视图透明时可穿透（看到后面的内容）
    /// 通过「转场动画 + 控制器」形式实现的功能控件，或需要内容穿透，应该通过该方法呈现，而不是调用`present(viewController: animated: completion:)`方法
    /// - Parameters:
    ///   - viewController: 要展示的视图控制器
    ///   - animated:       转场过程是否启用动画，默认为true
    ///   - completion:     转场动画执行完成后的回调闭包
    func present(viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil)  {
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        wrappedValue.present(viewController, animated: animated, completion: completion)
    }
}


extension Array where Element: Any {
    func objectAt(_ index: Int) -> Self.Element? {
        guard self.count > index else { return nil }
        return self[index]
    }
}


extension UIColor {
    convenience init(rgb: UInt32) {
        let rgba = rgb << 8 | 0x000000FF
        self.init(rgba: rgba)
    }
    
    convenience init(rgba: UInt32) {
        let red = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat(rgba & 0x000000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension Date: AlertNamespaceWrappable {}
public extension AlertTypeWrapperProtocol where WrappedType == Date {
    /// 日期格式化
    /// - Parameter dateFormat: 格式
    /// - Returns:              格式化后的日期描述
    func format(dateFormat: String) -> String {
        return DateHelper.shared.format(date: self.wrappedValue, dateFormat: dateFormat)
    }
    
    /// 返回格式为`yyyy-MM-dd`的日期描述
    func yearToDay() -> String { return format(dateFormat: "yyyy-MM-dd") }
    /// 返回格式为`yyyy-MM-dd HH:mm`的日期描述
    func yearToMinute() -> String { return format(dateFormat: "yyyy-MM-dd HH:mm") }
    /// 返回格式为`MM-dd`的日期描述
    func monthToDay() -> String { return format(dateFormat: "MM-dd") }
    /// 返回格式为`HH:mm:ss`的日期描述
    func hourToSecond() -> String { return format(dateFormat: "HH:mm:ss") }
    
    /// 获取年月日时分秒对应的日期
    static func date(value: MoeDateValue) -> Date? {
        let dateString = "\(value.year)-\(value.month)-\(value.day) \(value.hour):\(value.minute):\(value.second)"
        return DateHelper.shared.date(dateString: dateString, dateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    /// 获取日期相应的年月日时分秒
    func components() -> MoeDateValue {
        let dc = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self.wrappedValue)
        return (year: dc.year!, month: dc.month!, day: dc.day!, hour: dc.hour!, minute: dc.minute!, second: dc.second!)
    }
}


/// 日期辅助工具
class DateHelper: NSObject {
    static let shared = DateHelper()
    private override init() { print("Create Single DateHelper Instance") }
    
    /// 日期格式化
    /// - Parameters:
    ///   - date:       日期实例
    ///   - dateFormat: 格式
    /// - Returns:      格式化后的日期描述
    func format(date: Date, dateFormat: String) -> String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
    /// 创建格式化日期
    /// - Parameters:
    ///   - dateString: 日期描述
    ///   - dateFormat: 日期格式
    /// - Returns:      日期实例
    func date(dateString: String, dateFormat: String) -> Date? {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
    private(set) lazy var dateFormatter: DateFormatter = {
        return DateFormatter()
    }()
}
