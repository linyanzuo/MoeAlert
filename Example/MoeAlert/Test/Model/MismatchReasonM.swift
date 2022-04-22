//
//  BossModel.swift
//  JT
//
//  Created by apple on 2021/3/22.
//

import UIKit

let leftMarin:CGFloat = 20.0
 
let filterCloseTopMargin:CGFloat = 20
let filterCloseLeft:CGFloat = 20
let filterCloseH:CGFloat = 20

let filterOpenTopMargin:CGFloat = 10
let filterOpenLeftMargin:CGFloat = 10
let filterOpenH:CGFloat = 40


/// 不匹配原因项（列表项）
class MismatchReasonM: NSObject {
    var id:String = ""
    var name:String = ""
    var isSelected:Bool = false
}

/// 不匹配原因类别（列表组）
class MismatchCategoryM:NSObject{
    var sectionTitle:String?
    var values:[MismatchReasonM] = []
    var selectValue:[MismatchReasonM]{
        get{
            var tempArr:[MismatchReasonM] = []
            for model in values{
                if(model.isSelected){
                    tempArr.append(model)
                }
            }
            return tempArr
        }
    }
    var isOpen:Bool = false
    var rowHeight:CGFloat{
        get{
            if(isOpen){
                if let lastValue:NSValue = openViewFrameArr.last {
                    return lastValue.cgRectValue.maxY + 10
                }
            }else{
                if let lastValue:NSValue = closeViewFrameArr.last {
                    return lastValue.cgRectValue.maxY + 20
                }
            }
            return 60
        }
    }
    
    func containModel(model:MismatchReasonM) -> Bool{
        var flag = false
        for item in selectValue{
            if(item.id == model.id){
                flag = true
            }
        }
        return flag
    }
    
    // 不匹配原因展示项的Frame计算（收起时展示）
    var closeViewFrameArr: [NSValue] {
        get{
            var frameArr:[NSValue] = []
            let itemMinW:CGFloat = 20
            // Todo： 优化处理，改用字符计算
            let titleLb = UILabel.init()
            titleLb.font = UIFont.systemFont(ofSize: 14)
            titleLb.text = sectionTitle
            titleLb.sizeToFit()
            let titleFrame = CGRect.init(x: leftMarin, y: 15, width: titleLb.frame.width+5, height: 30)
            frameArr.append(NSValue(cgRect: titleFrame))
            let closeX = titleFrame.maxX + filterCloseLeft
            var x = closeX
            let maxW = lee_screenW - closeX - 30
            var y:CGFloat = 20
            let tempLb = UILabel.init()
            tempLb.font = UIFont.systemFont(ofSize: 12)
            for item in selectValue {
                tempLb.text = item.name
                tempLb.sizeToFit()
                let size = CGSize.init(width: tempLb.frame.width+5, height: 20)
                let w = max(itemMinW, min(size.width,maxW))
                if (x+w > (maxW + closeX)) {
                   x = closeX
                   y += (filterCloseH + filterCloseTopMargin)
                }
                let frame = CGRect.init(x: x, y: y, width: w, height: filterCloseH)
                frameArr.append(NSValue(cgRect: frame))
                x += (w+filterCloseLeft)
            }
            return frameArr
        }
    }
    
    var openViewFrameArr: [NSValue] {
        get{
            var frameArr:[NSValue] = []
            let itemMinW:CGFloat = 20
            // Todo： 优化处理，改用字符计算
            let titleLb = UILabel.init()
            titleLb.font = UIFont.systemFont(ofSize: 14)
            titleLb.text = sectionTitle
            titleLb.sizeToFit()
            let titleFrame = CGRect.init(x: leftMarin, y: 15, width: titleLb.frame.width+5, height: 30)
            frameArr.append(NSValue(cgRect: titleFrame))
            let maxW = lee_screenW - leftMarin - 20
            var x = leftMarin
            var y = 60 + filterOpenTopMargin
            let tempLb = UILabel.init()
            tempLb.font = UIFont.systemFont(ofSize: 15)
            for item in values {
                tempLb.text = item.name
                tempLb.sizeToFit()
                let size = CGSize.init(width: tempLb.frame.width+5, height: filterOpenH)
                let w = max(itemMinW, min(size.width,maxW)) + 10
                if(x+w>(maxW + leftMarin)){
                   x = leftMarin;
                   y += (filterOpenH + filterOpenTopMargin)
                }
                let frame = CGRect(x: x, y: y, width: w, height: filterOpenH)
                frameArr.append(NSValue(cgRect: frame))
                x += (w+filterCloseLeft)
                 
            }
            return frameArr
        }
    }
}



extension String{
    //截取前几位
    static func lee_perfix(_ str:String?, _ length:Int) -> String{
        if let value = str{
            if(value.count <= length){
                return value
            }else{
                let startIndex = value.startIndex
                let endIndex = value.index(value.startIndex, offsetBy: length)
                return String(value[startIndex ..< endIndex])
            }
        }else{
            return ""
        }
        
    }
    //截取后几位
    static func lee_suffix(_ str:String?,_ length:Int) -> String{
        if let value = str{
            if(value.count <= length){
                return value
            }else{
                let startIndex = value.index(value.endIndex, offsetBy: -length)
                let endIndex = value.endIndex
                return String(value[startIndex ..< endIndex])
            }
        }else{
            return ""
        }
    }
    //截取
    static func lee_range(_ str:String?,_ index:Int,_ length:Int) -> String{
        
        if let value = str{
            if(value.count <= length){
                return value
            }else{
                let startIndex = value.index(value.startIndex, offsetBy: index)
                let endIndex = value.index(startIndex, offsetBy: length)
                return String(value[startIndex ..< endIndex])
            }
        }else{
            return ""
        }
 
    }
}
