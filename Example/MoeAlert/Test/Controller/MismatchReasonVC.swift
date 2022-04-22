//
//  BossVC.swift
//  JT
//
//  Created by apple on 2021/3/22.
//

import UIKit
import MoeCommon
import MoeAlert


private let defultRowH:CGFloat = 50
private let maxStrLength = 200
private let bossIdentifier = "bossIdentifier"


let boss_mainBlueAlphaColor = UIColor.init(red: CGFloat(7)/CGFloat(255), green: CGFloat(132)/CGFloat(255), blue: CGFloat(255)/CGFloat(255), alpha: 0.2)


/// 不匹配原因 - 弹窗控制器
class MismatchReasonVC: MoeAlertController {
    
    // MARK: Override MoeAlertController
    
    override public func viewToAlert() -> UIView {
        return mismatchView
    }

    public override func addConstraintsFor(_ alert: UIView, in superView: UIView) {
        alert.translatesAutoresizingMaskIntoConstraints = false
        let topOffset = MScreen.navigationHeight + (84 - 44)
        alert.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(superView)
            maker.top.equalToSuperview().offset(topOffset)
        }
    }

    public override func animationType() -> MoeAlertAnimator.AnimationType {
        return .transformFromBottom(outOffScreen: true)
    }

    var dataArr:[MismatchCategoryM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isDismissWhenMaskTap = false
        setupSubviews()
    }

    private func setupSubviews() {
        view.addSubview(mismatchView)
        
        setFooterView()
        lee_inputView.updatePlaceholder()
        lee_inputView.textContainerInset = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
        dataArr = getDataWithJson()
        tableView.reloadData()
        registerNotification()
        
        lee_inputView.frame = CGRect(x: 30, y: 20, width: lee_screenW - 60, height: 90)
    }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow(noty:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardHidden(noty:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChangeFrame(noty:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    @objc private func clickAction(recognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @objc private func commitAction(){

    }
    
    @objc private func closeAction() {
        moe.dismiss()
    }
    
    private func setFooterView(){
        footerView.frame = CGRect.init(x: 0, y: 0, width: MScreen.width, height:  130)
        footerView.addSubview(lee_inputView)
        tableView.tableFooterView = footerView
    }
    
    lazy private var tableView:UITableView = {
        let tableView = UITableView.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight =  defultRowH
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: lee_screenW, height: 10))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: lee_screenW, height: lee_safeH))
        tableView.register(MismatchReasonCell.self, forCellReuseIdentifier: bossIdentifier)
//        let clickGes = UITapGestureRecognizer.init(target: self, action: #selector(clickAction(recognizer:)))
//        tableView.isUserInteractionEnabled = true
//        tableView.addGestureRecognizer(clickGes)
        return tableView
    }()
    
    
    lazy var lee_inputView:UITextView = {
        let view = UITextView.init()
        view.backgroundColor = .white
        view.textColor = UIColor(rgb: 0x222222)
        view.font = UIFont.systemFont(ofSize: 14)
        view.returnKeyType = .done
        view.delegate = self
        view.setPlaceholder("描述细节问题,以便猎头为您推荐更精准的候选人")
        view.layer.cornerRadius = CGFloat(5)
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(rgba: 0x00000017).cgColor
        return view
    }()
    
    // MARK: - MismatchView
    
    private(set) lazy var mismatchView: UIView = {
        let mismatchView = UIView()
        mismatchView.backgroundColor = .white
        mismatchView.layer.cornerRadius = 10
        mismatchView.layer.masksToBounds = true
        
        mismatchView.addSubview(topView)
        mismatchView.addSubview(tableView)
        mismatchView.addSubview(bottomView)
        topView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(mismatchView.moe.safeBottom)
        }
        return mismatchView
    }()
    
    // MARK: -- TopView
    
    private(set) lazy var topView: UIView = {
        let topView = UIView.init()
        topView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        topView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
        return topView
    }()
    
    private(set) lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mismatch_btn_close"), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        btn.layer.cornerRadius = CGFloat(5)
        btn.layer.masksToBounds = true
        return btn
    }()
    
    private(set) lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x222222)
        label.text = "不匹配原因"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: -- BottomView
    
    private(set) lazy var bottomView: UIView = {
        let bottomView = UIView.init()
        bottomView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        bottomView.addSubview(tipLbl)
        tipLbl.snp.makeConstraints { (make) in
            make.top.equalTo(confirmBtn.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
        return bottomView
    }()
    
    private(set) lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("确认", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.backgroundColor = UIColor(rgb: 0x0091FF)
        btn.adjustsImageWhenHighlighted = false;
        btn.addTarget(self, action: #selector(commitAction), for: .touchUpInside)
        btn.layer.cornerRadius = CGFloat(5)
        btn.layer.masksToBounds = true
        return btn
    }()
    
    private(set) lazy var tipLbl: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(rgb: 0x999999)
        label.text = "不匹配原因将展示给其他猎头参考"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var footerView:UIView = {
        let footerView = UIView.init()
        footerView.backgroundColor = .white
        return footerView
    }()
}

extension MismatchReasonVC:UITableViewDelegate,UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: bossIdentifier, for: indexPath) as! MismatchReasonCell
        cell.model = model
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArr[indexPath.row]
        model.isOpen = !model.isOpen
        var index = -1
        for (i,item) in dataArr.enumerated(){
            if(item.isOpen && item.sectionTitle != model.sectionTitle){
                item.isOpen = false
                index = i
                break
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.beginUpdates()
        tableView.endUpdates()
        if(index != -1){
            let idx = IndexPath.init(item: index, section: 0)
            tableView.reloadRows(at: [indexPath,idx], with: .fade)
        }else{
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
       
//        let model = dataArr[indexPath.row]
//        model.isOpen = !model.isOpen
//        for m in dataArr{
//            if(m.sectionTitle != model.sectionTitle){
//                m.isOpen = false
//            }
//        }
//        tableView.reloadData()
////        tableView.reloadRows(at: [indexPath], with: .fade)
//        view.endEditing(true)
    }
}


extension MismatchReasonVC:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            view.endEditing(true)
            return false
        }
        
        let str = textView.text + text
        if str.count >= maxStrLength {
            let rangeIndex = (str as NSString).rangeOfComposedCharacterSequence(at: maxStrLength)
            if rangeIndex.length == 1{
            }else{
                let renageRange = (str as NSString).rangeOfComposedCharacterSequences(for: NSMakeRange(0, maxStrLength))
                textView.text = String.lee_range(str, renageRange.location, renageRange.length)
                textView.updatePlaceholder()
            }
            return false
        }
        textView.updatePlaceholder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        /// 选择区域
        if let selectedRange = textView.markedTextRange {
            //获取高亮部分
            if textView.position(from: selectedRange.start, offset: 0) != nil {
                //如果在变化中是高亮部分在变，就不要计算字符了
                return
            }
        }
        if textView.text.count >= maxStrLength {
            textView.text = String.lee_perfix(textView.text, maxStrLength)
            textView.updatePlaceholder()
        }
        textView.updatePlaceholder()
    }
}


extension MismatchReasonVC{
    private func getDataWithJson() -> [MismatchCategoryM]{
        dataArr.removeAll()
        guard let path = Bundle.main.path(forResource: "BossOptions", ofType: "json"),
              let data = NSData(contentsOfFile: path)
        else {
            return []
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? Dictionary<String, Any>
            var sectionTempArr:[MismatchCategoryM] = []
            if let sectionList = json?["options"] as? Array<Dictionary<String, Any>> {
                for sectionDic in sectionList{
//                            BossSectionModel.deserialize(from: sectionDic)
                    let sectionModel = MismatchCategoryM.init()
                    if let title = sectionDic["sectionTitle"] as? String{
                        sectionModel.sectionTitle = title
                    }
                    var tempArr:[MismatchReasonM] = []
                    if let values = sectionDic["values"] as? [Dictionary<String,Any>]{
                        for valueDic in values{
                            let bossModel = MismatchReasonM.init()
                            if let id = valueDic["id"] as? String{
                                bossModel.id = id
                            }
                            if let name = valueDic["name"] as? String{
                                bossModel.name = name
                            }
                            if let isSelected = valueDic["isSelected"] as? Bool{
                                bossModel.isSelected = isSelected
                            }
                            tempArr.append(bossModel)
                        }
                        sectionModel.values = tempArr
                    }
                    sectionTempArr.append(sectionModel)
                }
                return sectionTempArr
            }
        } catch {
            return []
        }
        return []
    }

}

extension MismatchReasonVC{
    @objc func keyBoardShow(noty: Notification) {
    }
    
    @objc func keyBoardHidden(noty: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.frame = CGRect.init(x: 0, y: 0, width: lee_screenW, height: lee_screenH)
        } completion: { (result) in
        }
    }

    @objc func keyBoardWillChangeFrame(noty: Notification) {
//        tableView.scrollToRow(at: IndexPath.init(row: dataArr.count - 1, section: 0), at: .bottom, animated: false)
        guard let userInfo = noty.userInfo else {return}
        let value = userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue
        let keyboardRect = value.cgRectValue
        let keyboradHeight = keyboardRect.size.height
        let footerViewFrame = footerView.convert(footerView.bounds, to: view)
        if(footerViewFrame.maxY + keyboradHeight > lee_screenH){
            UIView.animate(withDuration: 0.3) { [weak self] in
                let newY = lee_screenH - (footerViewFrame.maxY + keyboradHeight)
                let newFrame = CGRect.init(x: 0, y: newY, width: lee_screenW, height: lee_screenH)
                print(newFrame)
                self?.view.frame = newFrame
            } completion: { (result) in
            }
        }
    }
   
}
