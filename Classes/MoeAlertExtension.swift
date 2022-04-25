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
