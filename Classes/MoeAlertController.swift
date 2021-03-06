//
//  AlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/8/29.
//
/**
 弹窗控制器的相关实现
 */

import UIKit


/// 弹窗控制器，请使用`alert.present`展示，不能使用`push`或`present`展示
open class MoeAlertController: UIViewController, MoeAlertAnimatorProtocol {
    /// 转场动画时长
    open var animationDuratoin: TimeInterval = 0.25
    /// 是否启用遮罩
    open var isMaskEnable: Bool = true {
        didSet { maskBtn.isHidden = !isMaskEnable }
    }
    /// 点击遮罩时，弹窗是否消失
    open var isDismissWhenMaskTap: Bool = true {
        didSet { maskBtn.isUserInteractionEnabled = isDismissWhenMaskTap }
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.setupTransition()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTransition()
    }

    private func setupTransition() {
        // 必须在此配置transitioningDelegate，否则present时无自定义转场动画
        transitioningDelegate = self
    }

    // MARK: - View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(maskBtn)
        view.addSubview(bezelView)
        setupConstraint()
        addConstraintsFor(bezelView, in: self.view)
        
        performSelector(onMainThread: #selector(wakeupMainThread), with: nil, waitUntilDone: false)
    }

    private func setupConstraint() {
        maskBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: maskBtn, attribute: .top, relatedBy: .equal,
                               toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .left, relatedBy: .equal,
                               toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .right, relatedBy: .equal,
                               toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: maskBtn, attribute: .bottom, relatedBy: .equal,
                               toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    // MARK: Subclass Should Override
    
    /// 为控制器选择转场动画的具体类型
    /// - Returns: 支持的转场动画类型
    open func animationType() -> MoeAlertAnimator.AnimationType {
        return .external
    }
    
    /// 子类重写该方法，返回要展示的自定义视图；
    /// 注意控制器应该持有该视图，避免被释放。但并不需要将其作为子视图添加至控制器根视图上
    /// - Returns: 自定义视图
    open func viewToAlert() -> UIView {
        fatalError("请重写`viewToAlert`方法, 在方法中返回要弹出的自定义视图")
    }
    
    /// 根据实际需求为控制器要展示的视图添加AutoLayout约束；
    /// 默认为位置居中、左右间隔屏幕24像素，高度自适应
    /// - Parameters:
    ///   - alertView: 要展示的视图，由「viewToAlert」方法返回
    ///   - superView: 要展示视图的父视图，即控制器根视图
    open func addConstraintsFor(_ alertView: UIView, in superView: UIView) {
        alertView.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints([
            NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: alertView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: superView, attribute: .left, multiplier: 1.0, constant: 24),
            NSLayoutConstraint(item: alertView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: superView, attribute: .right, multiplier: 1.0, constant: -24)
        ])
    }
    
    // MARK: - Lazy Load
    
    /// 遮罩按钮，提供灰色遮罩
    private(set) lazy var maskBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.alpha = 0.6
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(maskTapAction(_:)), for: .touchUpInside)
        btn.isHidden = !self.isMaskEnable
        return btn
    }()

    /// 底座视图，用于放置要展示的内容
    private(set) lazy var bezelView: UIView = {
        return self.viewToAlert()
    }()
}


// MARK: - 转场动画处理
extension MoeAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MoeAlertAnimator(owner: self, transitionType: .present)
        animator.animationType = animationType()
        animator.animationDuration = animationDuratoin
        return animator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MoeAlertAnimator(owner: self, transitionType: .dismiss)
        animator.animationType = animationType()
        animator.animationDuration = animationDuratoin
        return animator
    }

    // MARK: - SheetAnimatorProtocol
    public func maskViewForAnimation() -> UIView {
        return maskBtn
    }

    public func contentViewForAnimation() -> UIView {
        return bezelView
    }
}


// MARK: - 点击事件处理
@objc extension MoeAlertController {
    /// 遮罩点击事件
    open func maskTapAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func wakeupMainThread() {
        /**
         执行`present`控制器跳转时，并不会立即触发转场动画的执行。因某些原因会有延迟触发的情况
         表现为目标控制器的视图已经生成，但转场动画相关方法不执行。此时随便点击屏幕就会触发转场动画执行
         目前解决方案：
            1. 在主线中执行`present`方法实现控制器跳转
            2. 在目标控制器内，执行主线程方法（无需操作，仅唤醒主线程）
         */
    }
}
