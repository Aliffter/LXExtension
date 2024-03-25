//
//  UIFont+WEExpand.swift
//  WEBeautify
//
//  Created by waterpant on 2018/9/7.
//  Copyright © 2018年 waterelephant. All rights reserved.
//

import UIKit

public extension UIFont {

    /**
     *  设置字体格式为 PingFangSC Regular 方法
     */
    class func systemPFRegular(ofSize fontSize :CGFloat) -> UIFont {
        return UIFont(name:"PingFangSC-Regular", size: fontSize)!
    }
    
    /**
     *  设置字体格式为 PingFangSC Medium 方法
     */
    class func systemPFMedium(ofSize:CGFloat) -> UIFont {
        return UIFont(name:"PingFangSC-Medium", size: ofSize)!
    }
    
    /**
     *  设置字体格式为 PingFangSC-Semibold方法
     */
    class func systemPFSemibold(ofSize:CGFloat) -> UIFont {
        return UIFont(name:"PingFangSC-Semibold", size: ofSize)!
    }
    
    
    /**
     *  金额显示
     *  设置字体格式为 DINAlternate-Bold方法
     */
    class func systemDinBold(ofSize:CGFloat) -> UIFont {
        return UIFont(name:"DINAlternate-Bold", size: ofSize)!
    }
    
    
    /**
     *  设置字体格式为 PingFangSC Light 方法
     */
    class func systemPFlight(ofSize:CGFloat) -> UIFont {
        return UIFont(name:"PingFangSC-Light", size: ofSize)!
    }
    
    
    
}
