//
//  ProgressAlertController.swift
//  MoeUI
//
//  Created by Zed on 2019/9/2.
//

import MoeCommon
import MoeAlert
import UIKit


public class FeedbackController: MoeAlertController {
    var style: AlertDialog.Style
    var text: String
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(style: AlertDialog.Style, text: String) {
        self.style = style
        self.text = text
        super.init(nibName: nil, bundle: nil)
        self.animationDuratoin = 0.25
    }

    // MARK: Override Methods
    override public func viewToAlert() -> UIView {
        return self.dialog
    }

    public override func addConstraintsFor(_ alert: UIView, in superView: UIView) {
        alert.translatesAutoresizingMaskIntoConstraints = false
//        alert.snp.makeConstraints { (maker) in
//            maker.center.equalTo(superView)
//        }
        alert.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(superView)
            maker.height.equalTo(188)
        }
    }

    public override func animationType() -> MoeAlertAnimator.AnimationType {
        return .transformFromBottom(outOffScreen: true)
//        return .external
    }

    // MARK: Getter & Setter
    private(set) lazy var dialog: AlertDialog = {
        return AlertDialog(style: style, text: text)
    }()
    
//    private(set) lazy var dialog: UIView = {
//        let dialog = UIView(frame: .zero)
//        dialog.backgroundColor = .blue
//        return dialog
//    }()
}
