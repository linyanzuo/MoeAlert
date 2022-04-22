//
//  BossCell.swift
//  JT
//
//  Created by apple on 2021/3/22.
//

import UIKit


/// 不匹配原因列表项
class MismatchReasonCell: UITableViewCell {

    var tagButtonArr:[UIButton] = []
    var titleArr:[UILabel] = []
 
    var model: MismatchCategoryM? {
        didSet{
            if let m = model{ configModel(m) }
        }
    }
  
    // MARK: - Life Cycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        initUI()
        layoutContentViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Methods
    private func initUI(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
        contentView.addSubview(bgView)
        contentView.addSubview(lineView)
    }
    
    private func layoutContentViews(){
        arrowView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-35)
        }
        bgView.frame = CGRect.init(x: 0, y: 60, width: lee_screenW, height: (model?.rowHeight ?? 60) - 60)
        lineView.frame = CGRect.init(x: 20, y: (model?.rowHeight ?? 60) - 1, width: lee_screenW - 20, height: 1)
    }
    
    private func configModel(_ model: MismatchCategoryM){
        if(model.isOpen){
            updateOpenViews()
            bgView.isHidden = false
            lineView.isHidden = true
            arrowView.image = UIImage.init(named: "mismatch_arrow_down")
            arrowView.sizeToFit()
        }else{
            updateCloseViews()
            bgView.isHidden = true
            lineView.isHidden = false
            arrowView.image = UIImage.init(named: "mismatch_arrow_right")
            arrowView.sizeToFit()
        }
        updateTitleColor()
        layoutContentViews()
    }
    
    
    private func updateTitleColor(){
        if(model!.selectValue.count > 0){
            titleLabel.textColor = UIColor(rgb: 0x0091FF)
        }else{
            titleLabel.textColor = UIColor(rgb: 0x333333)
        }
    }
    
    private func updateCloseViews(){
        for lb in titleArr {
            lb.removeFromSuperview()
        }
        titleArr.removeAll()
        for btn in tagButtonArr {
            btn.removeFromSuperview()
        }
        tagButtonArr.removeAll()
        
        titleLabel.frame = model!.closeViewFrameArr.first?.cgRectValue ?? .zero
        titleLabel.text = model!.sectionTitle
        
        if let datas = model?.selectValue {
            for(index, item) in datas.enumerated(){
                // 不匹配原因展示项（收起时展示）
                let label = UILabel()
                label.text = item.name
                label.textColor = UIColor(rgb: 0x0091FF)
                label.backgroundColor = boss_mainBlueAlphaColor
                label.font = UIFont.systemFont(ofSize: 10)
                label.layer.cornerRadius = CGFloat(5)
                label.layer.masksToBounds = true
                label.textAlignment = .center
                label.frame = model!.closeViewFrameArr[index+1].cgRectValue
                contentView.addSubview(label)
                titleArr.append(label)
            }
        }
    }
    
    private func updateOpenViews(){
        for btn in tagButtonArr {
            btn.removeFromSuperview()
        }
        tagButtonArr.removeAll()
        for lb in titleArr {
            lb.removeFromSuperview()
        }
        titleArr.removeAll()
        
        titleLabel.frame = model!.openViewFrameArr.first?.cgRectValue ?? .zero
        titleLabel.text = model!.sectionTitle
        if let datas = model?.values{
            for(index, item) in datas.enumerated(){
                // 不匹配原因选择项（展开时显示）
                let btn = UIButton()
                btn.setTitle(item.name, for: .normal)
                btn.setTitleColor(UIColor(rgb: 0x666666), for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                btn.backgroundColor = .white
                btn.adjustsImageWhenHighlighted = false;
                btn.tag = index + 1000
                btn.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
                btn.layer.cornerRadius = CGFloat(5)
                btn.layer.masksToBounds = true
                btn.layer.borderWidth = 1
                btn.layer.borderColor =  UIColor(rgba: 0x00000017).cgColor
                setButtonStatus(selected: item.isSelected, btn: btn)
                btn.frame =  model!.openViewFrameArr[index+1].cgRectValue
                contentView.addSubview(btn)
                tagButtonArr.append(btn)
            }
        }
    }
    
    private func setButtonStatus(selected:Bool,btn:UIButton){
        if (selected) {
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = UIColor(rgb: 0x0091FF)
            btn.layer.borderColor = UIColor(rgb: 0x0091FF).cgColor
        } else {
            btn.setTitleColor(UIColor(rgb: 0x666666), for: .normal)
            btn.backgroundColor = .white
            btn.layer.borderColor =  UIColor(rgba: 0x00000017).cgColor
        }
        btn.isSelected = selected
    }
    
    // MARK: - Event Methods
    @objc private func tapAction(btn:UIButton) {
        let tag = btn.tag - 1000
        let item = model!.values[tag]
        item.isSelected = !item.isSelected
        setButtonStatus(selected: item.isSelected, btn: btn)
        updateTitleColor()
    }
    
    lazy private var bgView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor(rgb: 0xF3F6F8)
        view.isHidden = true
        return view
    }()

    /// 组标题
    lazy private var titleLabel:UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy private var lineView:UIView = {
        let view = UIView.init()
        view.backgroundColor = UIColor(rgba: 0x00000017)
        return view
    }()
    
    private lazy var arrowView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "mismatch_arrow_right"))
        return imgV
    }()
}
