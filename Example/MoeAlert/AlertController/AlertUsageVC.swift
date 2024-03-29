//
//  HUDUsageVC.swift
//  MoeUI_Example
//
//  Created by Zed on 2019/9/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MoeCommon
import MoeUI
import MoeAlert


class AlertUsageVC: TableViewController {
    private let sectionSource: [[String]] = [
        [("View ShowSuccess"),
         ("View ShowError"),
         ("View ShowProgress")],
        [("Window ShowSuccess"),
         ("Window ShowError"),
         ("Window ShowProgress"),
         ("Window ShowToast"),
         ("Window ShowCustom")],
        [("Controller ShowSuccess"),
         ("Controller ShowError"),
         ("Controller ShowProgress")],
        [("Alert DatePikcer")]
    ]

    // MARK: Object Life Cycle
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableView.Style) {
        super.init(style: .grouped)
    }

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.moe.registerCell(cellClass: TitleCell.self)
    }

    // MARK: -- UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSource.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let indexSource = sectionSource[section]
        return indexSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titles = sectionSource[indexPath.section]
        let title = titles[indexPath.row]

        let cell = tableView.moe.dequeueCell(cellClass: TitleCell.self)
        cell.titleLabel.text = title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            debugPrint("UIView形式的弹窗展示")
            switch indexPath.row {
            case 0:
                let dialog = AlertDialog(style: .success, text: "祝贺您，操作已成功")
                Alerter.show(dialog, in: self.view.window!, with: "Success", maskEnable: true)
            case 1:
                let dialog = AlertDialog(style: .error, text: "很不幸，并没有生效")
                Alerter.show(dialog, in: self.view.window!, with: "Error", maskEnable: true)
            case 2:
                let alertView = BottomAlertView(frame: .zero)
                alertView.show(in: view.window!)
            default: debugPrint("Nothing")
            }
        } else if indexPath.section == 1 {
            debugPrint("UIWindow形式的弹窗展示")
            switch indexPath.row {
            case 0:
                let dialog = AlertDialog(style: .success, text: "Congratulation, it work!")
                Alerter.showGlobal(dialog, with: "GlobalSuccess", maskEnable: true)
            case 1:
                let dialog = AlertDialog(style: .success, text: "Unfortunately, it does't work!")
                Alerter.showGlobal(dialog, with: "GlobalError", maskEnable: true, tapHide: false)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0, execute: {
                    Alerter.hideGlobal(with: "GlobalError")
                })
            case 2:
                let dialog = AlertDialog(style: .progress, text: "Loading...")
                let id = HUD.show(customView: dialog, maskEnable: true)
                DispatchQueue.global().async {
                    self.doSomework()
                    DispatchQueue.main.async { HUD.hide(with: id) }
                }
            case 3: HUD.show(style: .toast, text: "Message here!")
            case 4:
                let customDialog = CustomDialog()
                let id = HUD.show(customView: customDialog)
                DispatchQueue.global().async {
                    self.doSomework()
                    DispatchQueue.main.async { HUD.hide(with: id) }
                }
            default: debugPrint("Nothing")
            }
        } else if indexPath.section == 2 {
            debugPrint("UIViewController形式的弹窗展示")
            switch indexPath.row {
            case 0:
                let vc = StyleAlertController(style: .success, text: "祝贺您，操作已成功")
                alert.present(viewController: vc)
            case 1:
                let vc = StyleAlertController(style: .error, text: "很不幸，并没有生效")
                alert.present(viewController: vc)
            case 2:
//                let vc = FeedbackController(style: .progress, text: "正在处理")
//                moe.transparencyPresent(viewController: vc)
                let vc = MismatchReasonVC()
                moe.transparencyPresent(viewController: vc)
            default: debugPrint("Nothing")
            }
        } else if indexPath.section == 3 {
            let vc = MoeDateAlertController()
            vc.pickerType = .yearToDay
            vc.titleLabel.text = "日期选择"
            vc.submitButton.setTitle("提交", for: .normal)
            vc.cancelButton.setTitle("返回", for: .normal)
            vc.minDate = Date()
            vc.maxDate = Date(timeIntervalSinceNow: 10000000)
            vc.didSelectDateHandler = { date in
                print(date)
            }
            self.alert.present(viewController: vc)
        }
    }

    // MARK: Others
    func doSomework() {
        // 模拟耗时操作
        sleep(3)
    }
}
