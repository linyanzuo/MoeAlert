//
//  const.swift
//  JT
//
//  Created by apple on 2021/3/22.
//

import Foundation
import UIKit

/// 屏幕的宽度
let lee_screenW = UIScreen.main.bounds.width
/// 屏幕的高度
let lee_screenH = UIScreen.main.bounds.height

let lee_statusBarH:CGFloat = UIApplication.shared.statusBarFrame.size.height
//状态栏高度为20的时候不是iphonex
let lee_isIphoneX = (lee_statusBarH==20) ? false : true
let lee_navH:CGFloat = 44.0
let lee_navTopH:CGFloat = lee_statusBarH+lee_navH
let lee_safeH:CGFloat = lee_isIphoneX ? 34 : 0
let lee_tabBottomH:CGFloat = lee_safeH + 49
let lee_totalH:CGFloat = lee_tabBottomH+lee_navTopH
let lee_scale = lee_screenW/375.0
