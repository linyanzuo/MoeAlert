//
//  UITextView.swift
//  YinYinSwift
//
//  Created by jzl on 2019/3/25.
//  Copyright © 2019年 ww. All rights reserved.
//

import Foundation
import UIKit
import MoeCommon
import SnapKit

private var lee_titleKey:String = "lee_titleKey" 

extension UITextView{
    
    static  func lee_initTextView(frame:CGRect,color:UIColor,font:UIFont)-> UITextView{
        let textView = UITextView()
        textView.frame = frame
        textView.textColor = color
        textView.font = font
        return textView
    }
    
    
    func setPlaceholder(_ placeHolder:String){
        lee_addLabel()
        placeholderLb?.text = placeHolder
    }
    
    func updatePlaceholder(){
        if(placeholderLb != nil && placeholderLb?.superview != nil){
            if(vaildStr(validStr: text)){
                placeholderLb?.isHidden = true
            }else{
                placeholderLb?.isHidden = false
            }
        }
    }
    
    func vaildStr(validStr:String?)->Bool{
        if validStr != nil {
            if (validStr!.isEmpty){
                return false
            }
            else{
                return true
            }
        }else{
            return false
        }
    }
    
    var placeholderLb: UILabel?{
        set {
            objc_setAssociatedObject(self, &lee_titleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &lee_titleKey) as? UILabel
        }
    }
    
    func lee_addLabel(){
        if (placeholderLb == nil){
            placeholderLb = UILabel.init(frame: CGRect.init(x: 15, y: 5, width: lee_screenW - 20, height: 20))
            placeholderLb?.textColor = UIColor(rgb: 0x999999)
            placeholderLb?.font = UIFont.systemFont(ofSize: 14)
            placeholderLb?.isHidden = true
        }
        if placeholderLb?.superview == nil{
            addSubview(placeholderLb!)
        }
    }
}


// MARK: - SnapKit + 屏幕适配
import SnapKit
public extension TypeWrapperProtocol where WrappedType: UIView {
    var safeTop: SnapKit.ConstraintItem {
        get {
            if #available(iOS 11.0, *) { return wrappedValue.safeAreaLayoutGuide.snp.top }
            else { return wrappedValue.snp.top }
        }
    }
    
    var safeBottom: SnapKit.ConstraintItem {
        get {
            if #available(iOS 11.0, *) { return wrappedValue.safeAreaLayoutGuide.snp.bottom }
            else { return wrappedValue.snp.bottom }
        }
    }
}
