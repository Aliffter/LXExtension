//
//  File.swift
//  CarLoan_iOS
//
//  Created by 赵隆晓 on 2023/5/9.
//

import UIKit

extension UITextField{
    
    
    static func initStyle(placeholder: String,
                          fontSize: CGFloat,
                          weight: UIFont.Weight = .regular,
                          textAlignment: NSTextAlignment = .left,
                          textColor: UIColor = UIColor.black,
                          tag: Int = 0) -> UITextField{
        
        let field = UITextField()
        field.placeholder = placeholder
        field.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        field.textAlignment = textAlignment
        field.textColor = textColor
        field.tag = tag
        field.clearButtonMode = .whileEditing

        return field
   }
    
    // MARK: 1.2、添加左边的图片
    /// 添加左边的图片
    /// - Parameters:
    ///   - image: 左边的图片
    ///   - leftViewFrame: 左边view的frame
    ///   - imageSize: 图片的大小
    func addLeftIcon(_ image: UIImage?,
                     leftViewFrame: CGRect,
                     imageSize: CGSize,
                     leftMargin: CGFloat = 0,
                     viewMode: UITextField.ViewMode = .always) {
        let leftView = UIView()
        leftView.frame = leftViewFrame
        let imgageView = UIImageView()
        imgageView.frame = CGRect(x: leftMargin, y: (leftViewFrame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgageView.image = image
        leftView.addSubview(imgageView)
        self.leftView = leftView
        self.leftViewMode = viewMode
    }
    
    // MARK: 1.2、添加右侧的图片
    /// 添加右侧的图片
    /// - Parameters:
    ///   - image: 右侧的图片
    ///   - leftViewFrame: 右边view的frame
    ///   - imageSize: 图片的大小
    func addRightIcon(_ image: UIImage?,
                      rightViewFrame: CGRect,
                      imageSize: CGSize,
                      leftMargin: CGFloat = 0,
                      viewMode: UITextField.ViewMode = .always,
                      target: Any? = nil,
                      action: Selector? = nil) -> UIImageView {
        let rightView = UIView()
        rightView.frame = rightViewFrame
        if let target = target, let action = action {
            rightView.addTapGestureRecognizer(target: target, action: action)
        }
        let imgageView = UIImageView()
        imgageView.frame = CGRect(x: leftMargin, y: (rightViewFrame.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
        imgageView.image = image
        rightView.addSubview(imgageView)
        self.rightView = rightView
        self.rightViewMode = viewMode
        return imgageView
    }
    
    // MARK: - 密码输入框
    static func passwordField(placeholder: String,
                          fontSize: CGFloat,
                          weight: UIFont.Weight = .regular,
                          textAlignment: NSTextAlignment = .left,
                          textColor: UIColor = UIColor.black,
                          tag: Int = 0,
                          target:Any?,
                              eyeAction: Selector ) -> UITextField{
        
        let field = UITextField()
        field.placeholder = placeholder
        field.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        field.textAlignment = textAlignment
        field.textColor = textColor
        field.tag = tag
        field.clearButtonMode = .whileEditing

        let rightV = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        let rightBtn = UIButton(frame: CGRect(x: 8, y: 8, width: 16, height: 16))
        rightBtn.setImage(UIImage(named: "eye_close_icon"), for: .normal)
        rightBtn.setImage(UIImage(named: "eye_open_icon"), for: .selected)
        rightBtn.addTarget(target, action: eyeAction, for: .touchUpInside)
        
        rightV.addSubview(rightBtn)
        field.rightView = rightV
        field.rightViewMode = .always
        field.isSecureTextEntry = true
        
        field.keyboardType = .asciiCapable
        
        return field
   }
    
    /// 录入长度限制
    func inputRestrictions(replacementString string: String, limitCount : Int = -1) -> Bool {
        /// limitCount > 0 才进行录入校验
        guard limitCount > 0 else{ return true }
        //fix 复制手机号录入
        let replaceStr = string.components(separatedBy: CharacterSet.whitespaces).joined(separator: "")
        let text = self.text?.components(separatedBy: CharacterSet.whitespaces).joined(separator: "") ?? ""
        guard  text.count < limitCount || replaceStr.count <= 0 else{
            return false
        }

        return true
    }
    
    
    /// 录入数字位数限制
    func inputNumberRestrictions(replacementString string: String, limitCount : Int = -1) -> Bool {
        /// limitCount > 0 才进行录入校验
        guard limitCount > 0 else{ return true }
        
        
        //fix 复制手机号录入
        let replaceStr = string.components(separatedBy: CharacterSet.whitespaces).joined(separator: "")
        let text = self.text?.components(separatedBy: CharacterSet.whitespaces).joined(separator: "") ?? ""

        guard  text.count < limitCount || replaceStr.count <= 0 else{
            return false
        }

        if (string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil) || replaceStr.count == 0{
            return true
        }

        return false
    }
    
    /// 小数点位数限制
    func inputDecimalRestrictions(replacementString string: String, limitCount : Int = -1) -> Bool {
        /// limitCount > 0 才进行录入校验
        guard limitCount > 0 else{ return true }
        
        let totalStr = self.text?.appending(string) ?? ""
        let regex: String = "^[0-9]+(\\.[0-9]{0,\(limitCount)})?$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        let limitDecimal = pred.evaluate(with: totalStr)

        guard  limitDecimal || string.count <= 0 else{
            return false
        }

        return true
    }
    
    /// 小数点位数限制
    func inputDecimalRestrictions(replacementString string: String, range: NSRange, limitCount : Int = -1) -> Bool {
        let totalStr = (self.text as NSString?)?.replacingCharacters(in: range, with: string)

        guard limitCount > 0 else{
//            let regex: String = "^[1-9]+([0-9]{0,\(limitCount)})?$"
            let regex: String = "^[1-9]\\d*$"

            let pred = NSPredicate(format: "SELF MATCHES %@", regex)
            let limitDecimal = pred.evaluate(with: totalStr)

            guard  limitDecimal || string.count <= 0 else{
                return false
            }

            return true
        }
        

        
        let regex: String = "^[0-9]+(\\.[0-9]{0,\(limitCount)})?$"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        let limitDecimal = pred.evaluate(with: totalStr)

        guard  limitDecimal || string.count <= 0 else{
            return false
        }

        return true
    }
}
