//
//  selfingExtension.swift
//  ZLSales
//
//  Created by Leo on 2020/10/28.
//  Copyright © 2020 ZLGJ. All rights reserved.
//

import UIKit
import CoreText
// MARK: - 常见转换
extension String {
    /// 字符串转 为 Int ；类似于OC intValue
    var intValue : Int{
        return (self as NSString).integerValue
    }
    
    var floatValue: CGFloat {
        return CGFloat(Double(self) ?? 0)
    }
    
    /// 转换成货币格式 1000 ->  1,000 保留两位小数
    var moneyString : String{
        return changeToFormatterString(.currency)
    }
    /// 自定义保留小数位数(digits)位数 默认0位
    func decimalString(_ digits: Int = 0) -> String {
        return changeToFormatterString(.currency,minDigits: 0 ,maxdigits: digits)
    }
    
    /// 强制保留2位小数位数
    func decimalTwo() -> String {
        return changeToFormatterString(.currency,minDigits: 2 ,maxdigits: 2)
    }
    /// 比分数显示
    var percentString:String{
        return changeToFormatterString(.percent)
    }
    /// 手机号格式校验
    var isPhoneNum: Bool {
        let telStr = self.components(separatedBy: CharacterSet.whitespaces).joined(separator: "")
        /// 手机号格式校验 只要1开头3-9
        let phoneRegex: String = "^(1[3-9])\\d{9}$"
        
        return telStr.regularMatch(phoneRegex)
    }
    /// 手机号格式校验
//    var isPhoneNum: Bool {
//        let telStr = self.components(separatedBy: CharacterSet.whitespaces).joined(separator: "")
//        /// 手机号格式校验
//        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
//
//        return telStr.regularMatch(phoneRegex)
//    }
    /// 正则匹配用户身份证号15或18位
    var isIdCard: Bool {
        return regularMatch("(^[0-9]{15}$)|([0-9]{17}([0-9]|X|x)$)")
        
    }
    /// 判断是否都是数字
    var isNumber: Bool {
        return regularMatch("^[0-9]*$")
    }
    
    /// 日期字符串截取 2023-06-12 09:48:18 ----> 2023-06-12
    var subDateString: String?{
        if self.count > 10{
            return self.subString(fromIndex: 0, endIndex: 9)
        }
        return self
    }

    /// 是否包含中文
    var containsChineseCharacters: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    var nilString : String? {
        if self == "nil" || self == "null" {
            return nil
        }
        return self
    }
    
    var ossPath: String?{
        get{
            var subOssPath = self
            let array = self.components(separatedBy: ".com/")
            if array.count > 1{
                subOssPath = array[1]
            }
            let lastIndex = subOssPath.lastIndex(of: "?") ?? subOssPath.endIndex
            subOssPath = String(subOssPath[subOssPath.startIndex..<lastIndex])
            return subOssPath
        }
    }
    
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
      }
     
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
      }

   
    //使用正则表达式替换
   func  pregReplace(pattern:  String , with:  String ,
                    options:  NSRegularExpression . Options  = []) ->  String  {
    
       let  regex = try!  NSRegularExpression (pattern: pattern, options: options)
       return  regex.stringByReplacingMatches( in :  self , options: [],
                                             range:  NSMakeRange (0,  self .count),
                                             withTemplate: with)
   }
    
   
   
    
    /// 字符串截取
    func subString(fromIndex index: Int, endIndex: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: index)
        let end = self.index(self.startIndex, offsetBy: endIndex)
        return String(self[start...end])
    }
    
    /// 在指定索引处插入字符串
     mutating func insert(_ string: String, at index: Int) {
         guard index >= 0 && index <= count else {
             // 如果索引越界，则不进行插入操作
             return
         }

         let insertionIndex = self.index(startIndex, offsetBy: index)
         insert(contentsOf: string, at: insertionIndex)
     }
    
    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    
    func toRange(from range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }

    
    /// 富文本设置 字体大小 行间距 字间距
    func attributedString(font: UIFont,
                          textColor: UIColor,
                          lineSpaceing: CGFloat = 0,
                          wordSpaceing: CGFloat = 0) -> NSAttributedString {
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpaceing
        let attributes = [
            NSAttributedString.Key.font             : font,
            NSAttributedString.Key.foregroundColor  : textColor,
            NSAttributedString.Key.paragraphStyle   : style,
            NSAttributedString.Key.kern             : wordSpaceing]
            
            as [NSAttributedString.Key : Any]
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        
        // 设置某一范围样式
        // attrStr.addAttribute(<#T##name: NSAttributedString.Key##NSAttributedString.Key#>, value: <#T##Any#>, range: <#T##NSRange#>)
        return attrStr
    }
    
    /// 富文本设置 - 通过range
    func attributedRangeString(font: UIFont,
                               textColor: UIColor,
                               range: NSRange,
                               rangeColor: UIColor) -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font             : font,
            NSAttributedString.Key.foregroundColor  : textColor]
            as [NSAttributedString.Key : Any]
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        // 设置某一范围样式
        attrStr.addAttribute( NSAttributedString.Key.foregroundColor, value: rangeColor, range: range)
        return attrStr
    }
    
    /// 富文本设置 , 通过包含字符串
    func attributedContentString(text: String,
                                 textColor: UIColor,
                                 contentColor: UIColor) -> NSAttributedString? {
        let attributes = [
            NSAttributedString.Key.foregroundColor  : textColor]
            as [NSAttributedString.Key : Any]
        
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        let cRange = self.range(of: text)
        guard let aRange = cRange else {
            return attrStr
        }
        let nsRange = self.nsRange(from: aRange)
        // 设置某一范围样式
        attrStr.addAttribute( NSAttributedString.Key.foregroundColor, value: contentColor, range: nsRange)
        return attrStr
    }
    
    /// 富文本设置 , 通过包含字符串
    func attributedContentStrings(texts: [String],
                                  textColor: UIColor,
                                  textFont: UIFont,
                                  contentColor: UIColor,
                                  contentFont: UIFont? = nil ) -> NSAttributedString? {
        let attributes = [
            NSAttributedString.Key.foregroundColor  : textColor,
            NSAttributedString.Key.font : textFont]
            as [NSAttributedString.Key : Any]
        
        let attrStr = NSMutableAttributedString.init(string: self, attributes: attributes)
        for text in texts {
            let cRange = self.range(of: text)
            guard let aRange = cRange else {
                break
            }
            let nsRange = self.nsRange(from: aRange)
            // 设置某一范围样式
            attrStr.addAttribute( NSAttributedString.Key.foregroundColor, value: contentColor, range: nsRange)
            attrStr.addAttribute( NSAttributedString.Key.font, value: contentFont ?? textFont, range: nsRange)
        }
        return attrStr
    }
    
    func highLightText(highLight: String, font: UIFont, color: UIColor, highLightColor: UIColor) -> NSMutableAttributedString {
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let strings = self.components(separatedBy: highLight)
        
        for i in 0..<strings.count {
            let item = strings[i]
            let dict = [NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: color]
            
            let content = NSAttributedString(string: item, attributes: dict)
            attributedStrM.append(content)
            
            if i != strings.count - 1 {
                let dict1 = [NSAttributedString.Key.font: font,
                             NSAttributedString.Key.foregroundColor: highLightColor]
                
                let content2 = NSAttributedString(string: highLight,
                                                  attributes: dict1)
                attributedStrM.append(content2)
            }
            
        }
        return attributedStrM
    }
    
    private func changeToInt() -> Int {
        if self.isEmpty {
            return 0
        }
        
        let ＋: Int8 = 43
        let －: Int8 = 45
        let ascii0: Int8 = 48
        let ascii9: Int8 = 57
        let space: Int8 = 32
        
        
        var sign: Int = 1
        
        var result: Int = 0
        
        let chars = self.utf8CString
        
        var i: Int = 0
        
        while chars[i] == space {
            i += 1
        }
        
        if chars[i] == ＋ || chars[i] == － {
            sign = chars[i] == － ? -1 : 1
            i += 1
        }
        
        while i < chars.count - 1, ascii0...ascii9 ~= chars[i] {
            
            if result > Int32.max / 10 || (result == Int32.max / 10 && Int(chars[i] - ascii0) > 7) {
                return sign == 1 ? Int(Int32.max) : Int(Int32.min)
            }
            
            result = result * 10 +  Int(chars[i] - ascii0)
            i += 1
        }
        
        return result * sign
    }
    
    func changeToFormatterString(_ style:NumberFormatter.Style,minDigits:Int = 2 , maxdigits: Int = 2) -> String {
        //从字符串转成数字
        let number = NumberFormatter().number(from: self) ?? 0
        if style == .currency {
            let numberFormatter = NumberFormatter()
            //设置number显示样式
            numberFormatter.numberStyle = .decimal
            numberFormatter.positivePrefix = ""//自定义前缀
            numberFormatter.positiveSuffix = ""//自定义后缀
            numberFormatter.usesGroupingSeparator = true //设置用组分隔
            numberFormatter.groupingSeparator = "," //分隔符号
            numberFormatter.groupingSize = 3  //分隔位数
            numberFormatter.minimumFractionDigits = minDigits //设置小数点后最少2位（不足补0）
            numberFormatter.maximumFractionDigits = maxdigits //设置小数点后最多3位

            return numberFormatter.string(from: number)!
        }
        if style == .percent {
            let numberFormatter = NumberFormatter()
            //设置number显示样式
            numberFormatter.numberStyle = .percent
            numberFormatter.positiveSuffix = "%"//自定义后缀
            numberFormatter.minimumFractionDigits = minDigits //设置小数点后最少2位（不足补0）
            numberFormatter.maximumFractionDigits = maxdigits //设置小数点后最多3位

            return numberFormatter.string(from: number)!
        }
        //小数形式
        let decimal = NumberFormatter.localizedString(from: number, number: style)
        
        return decimal
    }
    
    private func regularMatch(_ pred: String ) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pred)
        let isMatch: Bool = pred.evaluate(with: self)
        return isMatch
        
    }
}
// MARK: - 字符串宽高 或 根据宽对字符串进行截取
extension String {
    /// 获取字符串高度
    func textAutoHeight(width:CGFloat, font:UIFont) -> CGFloat{

        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics
        let rect = string.boundingRect(with:CGSize(width: width, height:0), options: [origin,lead,ssss], attributes: [NSAttributedString.Key.font:font], context:nil)
        return rect.height
    }
    /// 获取字符串宽度
    func textAutoWidth(height:CGFloat, font:UIFont) -> CGFloat {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let rect = string.boundingRect(with: CGSize(width: 0, height: height),options: [origin,lead], attributes: [NSAttributedString.Key.font :font], context: nil)
        return rect.width
    }
    
    /// 指定宽度下可见字符串
    func visibleStringWithWidth(_ width:CGFloat, font: UIFont) -> String {
        guard  width > 0  else { return "" }
        let p = NSMutableParagraphStyle()
        p.lineBreakMode = .byCharWrapping
        
        let namesAtt = NSAttributedString(string: self , attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.paragraphStyle:p])
        
        let framesetter = CTFramesetterCreateWithAttributedString(namesAtt)
        let path = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: width, height: font.lineHeight+1))
        
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: self.count), path.cgPath, nil)
        let range = CTFrameGetVisibleStringRange(frame)
        
        let resultStr = self.subString(fromIndex: 0, endIndex: range.length)
        
        return resultStr
    }
    
    /// 获得text，能够占有label多少行，使用font的lineHeight
    func calculateMaxLines(width: CGFloat, font: UIFont) -> Int {
           let maxSize = CGSize(width: width, height: CGFloat(Float.infinity))
           let charSize = font.lineHeight
           let text = NSString(string: self)
           let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil)
           let lines = Int(textSize.height/charSize)
           return lines
       }
}

extension String{
    // MARK: 3.8、url进行编码
    /// url 进行编码
    /// - Returns: 返回对应的URL
    func urlEncode() -> String {
        // 为了不把url中一些特殊字符也进行转换(以%为例)，自己添加到自付集中
        var charSet = CharacterSet.urlQueryAllowed
        charSet.insert(charactersIn: "%")
        return self.addingPercentEncoding(withAllowedCharacters: charSet) ?? ""
    }
}
