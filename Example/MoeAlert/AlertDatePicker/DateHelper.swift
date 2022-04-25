//
//  DateHelper.swift
//  MoeAlert_Example
//
//  Created by Zed on 2022/4/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import MoeAlert


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
