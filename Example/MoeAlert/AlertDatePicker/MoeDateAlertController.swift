//
//  MoeDateAlertController.swift
//  QinMi
//
//  Created by Zed on 2020/11/5.
//  Copyright © 2020 www.moemone.com. All rights reserved.
//

import Foundation
import UIKit
import MoeAlert


/// 日期弹窗控制器
open class MoeDateAlertController: MoeAlertController {
    /// 最小日期
    open var minDate: Date = Date(timeIntervalSince1970: 0)
    /// 最大日期
    open var maxDate: Date = Date()
    /// 默认选中日期
    open var defaultDate: Date?
    /// 选择器类型，默认为年月日
    public var pickerType: MoePickerType = .yearToDay
    /// 选择器做出选择后的回调闭包
    public var didSelectDateHandler: ((_ date: Date)->Void)?
    
//    public init(type: PickerType = .yearToDay, minDate: Date = Date(timeIntervalSince1970: 0), maxDate: Date = Date()) {
//        self.pickerType = type
//        self.minDate = minDate
//        self.defaultDate = minDate
//        self.maxDate = maxDate
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    public required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private var selectedDate: Date = Date()
    
    open override func animationType() -> MoeAlertAnimator.AnimationType {
        return .transformFromBottom(outOffScreen: true)
    }
    
    open override func viewToAlert() -> UIView {
        return pickerView
    }
    
    open override func addConstraintsFor(_ alertView: UIView, in superView: UIView) {
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: alertView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    private lazy var pickerView: UIView = {
        let pickerView = UIView()
        pickerView.backgroundColor = .white
        
        pickerView.addSubview(datePicker)
        pickerView.addSubview(toolView)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addConstraints([
            NSLayoutConstraint(item: datePicker, attribute: .top, relatedBy: .equal,
                               toItem: toolView, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: datePicker, attribute: .left, relatedBy: .equal,
                               toItem: pickerView, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: datePicker, attribute: .right, relatedBy: .equal,
                               toItem: pickerView, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: datePicker, attribute: .bottom, relatedBy: .equal,
                               toItem: pickerView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
        
        toolView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addConstraints([
            NSLayoutConstraint(item: toolView, attribute: .top, relatedBy: .equal,
                               toItem: pickerView, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: toolView, attribute: .left, relatedBy: .equal,
                               toItem: pickerView, attribute: .left, multiplier: 1.0, constant: 16.0),
            NSLayoutConstraint(item: toolView, attribute: .right, relatedBy: .equal,
                               toItem: pickerView, attribute: .right, multiplier: 1.0, constant: -16.0),
            NSLayoutConstraint(item: toolView, attribute: .height, relatedBy: .equal,
                               toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 49.0)
        ])
        
        return pickerView
    }()
    
    private lazy var datePicker: MoeDatePicker = {
        if maxDate.timeIntervalSince1970 < minDate.timeIntervalSince1970 { debugPrint("maxDate值小于minDate，请检查代码") }
        let picker = MoeDatePicker(frame: .zero, minDate: minDate, maxDate: maxDate, defaultDate: defaultDate, type: pickerType)
        return picker
    }()
    
    private lazy var toolView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, titleLabel, submitButton])
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    public private(set) lazy var cancelButton: UIButton = {
        let cancelBtn = UIButton(frame: .zero)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor(rgb: 0x666666), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), for: .touchUpInside)
        return cancelBtn
    }()
    
    public private(set) lazy var titleLabel: UILabel = {
        let titleLbl = UILabel(frame: .zero)
        titleLbl.textColor = UIColor(rgb: 0x999999)
        titleLbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return titleLbl
    }()
    
    public private(set) lazy var submitButton: UIButton = {
        let submitBtn = UIButton(frame: .zero)
        submitBtn.setTitle("确定", for: .normal)
        submitBtn.setTitleColor(UIColor(rgb: 0x666666), for: .normal)
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        submitBtn.addTarget(self, action: #selector(submitBtnAction(_:)), for: .touchUpInside)
        return submitBtn
    }()
}

// MARK: - 事件响应
@objc extension MoeDateAlertController {
    func maskBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func submitBtnAction(_ sender: UIButton) {
        self.didSelectDateHandler?(datePicker.selectedDate)
        self.dismiss(animated: true, completion: nil)
    }
}
