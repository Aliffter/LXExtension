//
//  MBProgressHUD+WEExpand.swift
//  WEBeautify
//
//  Created by waterpant on 2018/9/11.
//  Copyright © 2018年 waterelephant. All rights reserved.
//
import UIKit
import Foundation
import MBProgressHUD

public extension MBProgressHUD{
    
    class func hideHUDForView(view: UIView){
        self.hide(for: view, animated: true)
    }
    
    //显示等待消息
    @discardableResult
    class func showWait(_ title: String?, view: UIView? = nil)  -> MBProgressHUD  {
      
        var supView: UIView = viewToShow()
        if let v = view {
            supView = v
        }
        
        let hud = MBProgressHUD.showAdded(to: supView, animated: true)
        hud.label.text = title
        hud.margin = 14
        hud.removeFromSuperViewOnHide = true
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 12)
        hud.bezelView.style = .solidColor
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.7)

        return hud
    }
    
    //显示普通消息
    @discardableResult
    class func showTips(_ title: String?)  -> MBProgressHUD {
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .customView //模式设置为自定义视图
//        hud.customView = UIImageView(image: UIImage(named: "info")!) //自定义视图显示图片
        hud.label.text = title
        hud.label.numberOfLines = 3
        hud.margin = 12

        hud.removeFromSuperViewOnHide = true
        
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.detailsLabel.font = hud.label.font
        hud.bezelView.style = .solidColor
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.7)

        return hud
    }
    
    //显示成功消息
    class func showSuccess(_ title: String?){
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text //模式设置为自定义视图
//        hud.customView = UIImageView(image: UIImage(named: "tick")!) //自定义视图显示图片
        hud.label.text = title
        hud.label.numberOfLines = 3
        hud.margin = 12

        hud.removeFromSuperViewOnHide = true
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.detailsLabel.font = hud.label.font
        hud.bezelView.style = .solidColor
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.7)

        //HUD窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    //显示失败消息
    class func showError(_ title: String?) {
        let view = viewToShow()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text //模式设置为自定义视图
//        hud.customView = UIImageView(image: UIImage(named: "cross")!) //自定义视图显示图片
        hud.label.text = title
        hud.label.numberOfLines = 3
//        hud.label.font = .boldSystemFont(ofSize: 14)
        hud.margin = 12
        hud.removeFromSuperViewOnHide = true
        hud.label.font = UIFont.systemFont(ofSize: 14)
        hud.detailsLabel.font = hud.label.font
        hud.bezelView.style = .solidColor
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor.black.withAlphaComponent(0.7)

        //HUD窗口显示1秒后自动隐藏
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
    //获取用于显示提示框的view
    class func viewToShow() -> UIView {
        
        if let delegate = UIApplication.shared.delegate {
            if let window = delegate.window {
                if let tempWindow = window {
                    return tempWindow
                }
            }
        }
        
        let window = UIApplication.shared.keyWindow
        
        return window!
    }
    
    class func hideView(_ view: UIView = viewToShow()) {
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    class func toastMessage(to: UIView? = nil, message: String?, afterDelay: TimeInterval = 1.5) {
        if let showMessage = message {
            if showMessage.count == 0 {
                return
            }
        } else {
            return
        }
        
        var superView: UIView
        if let toView = to {
            superView = toView
        } else {
            superView = viewToShow()
        }
        
        hideView(superView)
        
        let progressHUD = MBProgressHUD.showAdded(to: superView, animated: true)
        progressHUD.label.font = UIFont.systemFont(ofSize: 14)
        progressHUD.margin = 12
        progressHUD.detailsLabel.font = progressHUD.label.font
        progressHUD.removeFromSuperViewOnHide = true
        progressHUD.mode = .text
        progressHUD.detailsLabel.text = message
        progressHUD.detailsLabel.textColor = progressHUD.label.textColor
        progressHUD.bezelView.style = .solidColor
        progressHUD.contentColor = UIColor.white
        progressHUD.bezelView.color = UIColor.black.withAlphaComponent(0.7)
        progressHUD.isUserInteractionEnabled = false
        progressHUD.hide(animated: true, afterDelay: afterDelay)
        
    }
    
    @discardableResult
    class func showHUD(to: UIView?, text: String?) -> MBProgressHUD {
        
        var superView: UIView
        if let toView = to {
            superView = toView
        } else {
            superView = viewToShow()
        }
        
        let progressHUD = MBProgressHUD.showAdded(to: superView, animated: true)
        progressHUD.removeFromSuperViewOnHide = true
        progressHUD.label.font = UIFont.systemFont(ofSize: 14)
        progressHUD.bezelView.style = .solidColor
        progressHUD.contentColor = UIColor.white.withAlphaComponent(0.9)
        progressHUD.bezelView.color = UIColor.black.withAlphaComponent(0.7)
        if let title = text {
            progressHUD.label.text = title
        }
        return progressHUD
    }
    
    @discardableResult
    func changeText(title :String, onlyText: Bool = true) -> MBProgressHUD{
        DispatchQueue.main.async {
            if onlyText {
                self.mode = .text
            }
            self.label.text = title
        }
        if isHidden {
            show(animated: true)
        }
        return self
    }
    
    
    func showInView(to: UIView? = nil)  {
        var superView: UIView
        if let toView = to {
            superView = toView
        } else {
            superView = MBProgressHUD.viewToShow()
        }
        superView.addSubview(self)
        DispatchQueue.main.async {
            self.show(animated: true)
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.hide(animated: true)
        }
    }
    
    func hide(delay: TimeInterval) {
        DispatchQueue.main.async {
            self.hide(animated: true, afterDelay: delay)
        }
    }
    
//    deinit{
//        uLog("MBProgressHUD deinit")
//    }
}



