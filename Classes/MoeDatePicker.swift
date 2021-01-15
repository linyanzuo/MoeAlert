//
//  DatePickerView.swift
//  QinMi
//
//  Created by Zed on 2020/11/5.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//

import UIKit


/// 日期值
public typealias MoeDateValue = (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int)


/// 选择器类型
public enum MoePickerType: Int {
    /// 年、月、日、时、分
    case yearToMinute
    /// 年、月、日
    case yearToDay
    /// 年、月
    case yearToMonth
    /// 月、日
    case monthToDay
}


/// 日期选择视图
public class MoeDatePicker: UIView {
    /// 选择器组件类型
    private enum ComponentType: Int {
        case year = 1
        case month = 2
        case day = 3
        case hour = 4
        case minute = 5
        case second = 6
    }
    
    init(frame: CGRect, minDate: Date, maxDate: Date, defaultDate: Date? = nil, type: MoePickerType) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.selectedDate = defaultDate ?? minDate
        self.pickerType = type
        super.init(frame: frame)
        self.setupSubviews()
        self.setupSelected()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 可选最小日期时间
    private(set) var minDate: Date
    /// 可选最大日期时间
    private(set) var maxDate: Date
    /// 选中日期时间
    private(set) var selectedDate: Date
    /// 选择器类型
    public var pickerType: MoePickerType
    
    /// 选择项的文字颜色
    public var textColor: UIColor = .black
    /// 选择项的字体
    public var textFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    
    private let kReuseLabelTag: Int = 20170411
    private let kRowHeightForComponent: CGFloat = 44
    private var formatter: DateFormatter = DateFormatter()
    
    func setupSubviews() {
        backgroundColor = .clear
        
        addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal,
                               toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: pickerView, attribute: .left, relatedBy: .equal,
                               toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: pickerView, attribute: .right, relatedBy: .equal,
                               toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: pickerView, attribute: .bottom, relatedBy: .equal,
                               toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    /// 根据选择器类型，返回各组件的类型
    private lazy var componentTypes: Array<ComponentType> = {
        switch pickerType {
        case .yearToMinute: return [.year, .month, .day, .hour, .minute]
        case .yearToDay: return [.year, .month, .day]
        case .yearToMonth: return [.year, .month]
        case .monthToDay: return [.month, .day]
        }
    }()
    
    /// 最小选择结果
    private(set) lazy var minValue: MoeDateValue = { return minDate.alert.components() }()
    /// 最大选择结果
    private(set) lazy var maxValue: MoeDateValue = { return maxDate.alert.components() }()
    /// 当前选择结果
    private(set) lazy var selectedValue: MoeDateValue = { return selectedDate.alert.components() }()
    
    /// 年在初始化时配置，操作后不需要更新
    private lazy var yearSource: Array<Int> = { return Array<Int>(minValue.year...maxValue.year) }()
    /// 月固定为1~12，操作后不需要更新
    private lazy var monthSource: Array<Int> = { return Array<Int>(1...12) }()
    /// 日根据年月不同而变化，操作后需要更新
    private lazy var daySource: Array<Int> = { return Array<Int>() }()
    /// 时固定为0~23，操作后需要不更新
    private lazy var hourSource: Array<Int> = { return Array<Int>(0..<24) }()
    /// 分固定为0~59，操作后需要不更新
    private lazy var minuteSource: Array<Int> = { return Array<Int>(0..<60) }()
    /// 秒固定为0~59，操作后需要不更新
    private lazy var secondSource: Array<Int> = { return Array<Int>(0..<60) }()
    
    /// 选择器视图
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView(frame: self.bounds)
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .clear
        return picker
    }()
}


extension MoeDatePicker: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return componentTypes.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let componentType = componentTypes.objectAt(component) else { return 0 }
        return getComponentSource(forType: componentType).count
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel? = nil
        if let reuseView = view as? UILabel, reuseView.tag == kReuseLabelTag {
            label = reuseView
        } else {
            label = self.createLabel(component: component, Selected: true)
        }
        
        if let componentType = componentTypes.objectAt(component) {
            let componentSoruce = getComponentSource(forType: componentType)
            if let source = componentSoruce.objectAt(row) {
                switch componentType {
                case .year: label!.text = "\(source)年"
                case .month: label!.text = "\(source)月"
                case .day: label!.text = "\(source)日"
                case .hour: label!.text = "\(source)时"
                case .minute: label!.text = "\(source)分"
                case .second: label!.text = "\(source)秒"
                }
            }
        }
        return label!
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kRowHeightForComponent
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let componentType = componentTypes.objectAt(component) else { return }
        let componentSource = getComponentSource(forType: componentType)
        
        // 更新选中值
        if let selected = componentSource.objectAt(row) {
            switch componentType {
            case .year: selectedValue.year = selected
            case .month: selectedValue.month = selected
            case .day: selectedValue.day = selected
            case .hour: selectedValue.hour = selected
            case .minute: selectedValue.minute = selected
            case .second: selectedValue.second = selected
            }
            if let date = Date.alert.date(value: selectedValue) { selectedDate = date }
        }
        // 若选中日之前的组件，需要刷新日的数据源及组件
        if componentType.rawValue < ComponentType.day.rawValue, let index = componentTypes.firstIndex(of: .day) {
            updateDays(ofYear: selectedValue.year, andMonth: selectedValue.month)
            pickerView.reloadComponent(index)
        }
        //判断时间是否超限
        self.checkExceedLimit()
    }
}


extension MoeDatePicker {
    /// 初始化默认选中值
    private func setupSelected() {
        if minDate.timeIntervalSince1970 > maxDate.timeIntervalSince1970 { maxDate = minDate }
        
        updateDays(ofYear: selectedValue.year, andMonth: selectedValue.month)
        selectValue(value: selectedValue, animated: false)
    }
    
    /// 获取各类型组件的数据源
    private func getComponentSource(forType componentType: ComponentType) -> Array<Int> {
        switch componentType {
        case .year: return yearSource
        case .month: return monthSource
        case .day: return daySource
        case .hour: return hourSource
        case .minute: return minuteSource
        case .second: return secondSource
        }
    }
    
    /// 获取各类型组件的选中值
    private func getComponentValue(_ value: MoeDateValue, forType componentType: ComponentType) -> Int {
        switch componentType {
        case .year: return value.year
        case .month: return value.month
        case .day: return value.day
        case .hour: return value.hour
        case .minute: return value.minute
        case .second: return value.second
        }
    }
    
    /// 更新日期数据源
    private func updateDays(ofYear year: Int, andMonth month: Int) {
        var dayNum = 0
        if [1, 3, 5, 7, 8, 10, 12].contains(month) {
            dayNum = 30
        } else if [4, 6, 9, 11].contains(month) {
            dayNum = 31
        } else {
            /** 判断闰年的标准 (四年一闰,百年不闰,四百年再闰)
             1.能整除4且不能整除100
             2.能整除400
             */
            if year % 4 == 0, year % 100 != 0 { dayNum = 29 }
            if year % 400 == 0 { dayNum = 29 }
            else { dayNum = 28 }
        }
        self.daySource = Array<Int>(1...dayNum)
    }
    
    /// 选择指定日期
    private func selectValue(value: MoeDateValue, animated: Bool = true) {
        for index in 0..<componentTypes.count {
            let type = componentTypes[index]
            let source = getComponentSource(forType: type)
            let value = getComponentValue(value, forType: type)
            if let row = source.firstIndex(of: value) {
                self.pickerView.selectRow(row, inComponent: index, animated: animated)
            }
        }
    }
    
    /// 为选择器创建文本标签
    private func createLabel(component:Int , Selected selected:Bool) -> UILabel {
        let numberOfComponent = numberOfComponents(in: pickerView)
        let componentWidth = self.bounds.size.width / CGFloat(numberOfComponent)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: componentWidth, height: kRowHeightForComponent))
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.center
        label.textColor = textColor
        label.font = textFont
        label.isUserInteractionEnabled = false
        label.tag = kReuseLabelTag
        return label
    }
    
    /// 检查是否超过限制，并自动调整为极限值
    private func checkExceedLimit() {
        if selectedDate.timeIntervalSince1970 < minDate.timeIntervalSince1970 {
            self.selectValue(value: minValue)
        }
        if selectedDate.timeIntervalSince1970 > maxDate.timeIntervalSince1970 {
            self.selectValue(value: maxValue)
        }
    }
}
