//
//  UIViewExtension.swift
//  ZLSales
//
//  Created by Leo on 2020/10/14.
//  Copyright © 2020 ZLGJ. All rights reserved.
//

import UIKit


extension UIView{
    
    /// 增加点击手势
    func addTapGestureRecognizer(target: Any, action:Selector)  {
        let tap =   UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tap)
    }
    ///  圆角设置
    func addCorner(conrners: UIRectCorner , radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: conrners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// BezierPath 圆角设置
    func roundCorners(_ corners: UIRectCorner = .allCorners, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    //添加4个不同大小的圆角
    func addCorner(cornerRadii: CornerRadii, boardColor: UIColor, boardWidth: CGFloat){
        let path = createPathWithRoundedRect(bounds: self.bounds, cornerRadii:cornerRadii)
        let shapLayer = CAShapeLayer()
        shapLayer.frame = self.bounds
        shapLayer.path = path
        self.layer.mask = shapLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = shapLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = boardColor.cgColor
        borderLayer.lineWidth = boardWidth
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)

    }
    
    // MARK: - 添加渐变色
    /// 添加渐变色
    func addGradientLayer(startColor:UIColor, endColor:UIColor, direction: ZLDirection = .vertical, frame: CGRect = .zero) {
        let gradientLayer = CAGradientLayer()
        if frame == .zero{
            gradientLayer.frame = self.frame
        }else{
            gradientLayer.frame = frame
        }
        //设置渐变的主颜色
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.type = .axial
        gradientLayer.locations = [0,1]
        if direction == .vertical {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }else{
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        //将gradientLayer作为子layer添加到主layer上
//        self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK:- 绘制虚线
    /// 添加虚线
    func addDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, direction: ZLDirection = .vertical, location: ZLLocation = .center) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = self.bounds
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        //虚线长度 和 两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        
        let path = CGMutablePath()
        var startPoint : CGPoint = CGPoint(x: 0, y: 0)
        var endPoint : CGPoint = CGPoint(x: 0, y: 0)
        let height = self.layer.bounds.height
        let width = self.layer.bounds.width
        /**
         * 目前只实现了垂直方向，居中显示
         */
        switch ((direction,location)) {
        case (.vertical,.center):
            startPoint = CGPoint(x: width/2, y: 0)
            endPoint = CGPoint(x: width/2, y: height)
        default:
            break;
        }
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
    
    class func line(_ color:UIColor = UIColor.white) -> UIView {
        let line = UIView()
        line.backgroundColor = color
        return line
    }
    
}

// MARK: - 绘制虚线
extension UIView{
    /// 绘制虚线方向
    enum ZLDirection {
        /// 垂直
        case vertical
        /// 水平
        case horizontal
    }
    /// 虚线位置
    enum ZLLocation {
        case left
        case right
        case center
        case top
        case bottom
    }
    
    
    //各圆角大小
    struct CornerRadii {
        var topLeft :CGFloat = 0
        var topRight :CGFloat = 0
        var bottomLeft :CGFloat = 0
        var bottomRight :CGFloat = 0
    }
    
    //切圆角函数绘制线条
    private func createPathWithRoundedRect ( bounds:CGRect,cornerRadii:CornerRadii) -> CGPath {
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY
        
        //获取四个圆心
        let topLeftCenterX = minX +  cornerRadii.topLeft
        let topLeftCenterY = minY + cornerRadii.topLeft
        
        let topRightCenterX = maxX - cornerRadii.topRight
        let topRightCenterY = minY + cornerRadii.topRight
        
        let bottomLeftCenterX = minX +  cornerRadii.bottomLeft
        let bottomLeftCenterY = maxY - cornerRadii.bottomLeft
        
        let bottomRightCenterX = maxX -  cornerRadii.bottomRight
        let bottomRightCenterY = maxY - cornerRadii.bottomRight
        
        //虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
        let path :CGMutablePath = CGMutablePath();
        //顶 左
        path.addArc(center: CGPoint(x: topLeftCenterX, y: topLeftCenterY), radius: cornerRadii.topLeft, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 3 / 2, clockwise: false)
        //顶右
        path.addArc(center: CGPoint(x: topRightCenterX, y: topRightCenterY), radius: cornerRadii.topRight, startAngle: CGFloat.pi * 3 / 2, endAngle: 0, clockwise: false)
        //底右
        path.addArc(center: CGPoint(x: bottomRightCenterX, y: bottomRightCenterY), radius: cornerRadii.bottomRight, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: false)
        //底左
        path.addArc(center: CGPoint(x: bottomLeftCenterX, y: bottomLeftCenterY), radius: cornerRadii.bottomLeft, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: false)
        path.closeSubpath();
        return path;
    }
}


// MARK: - 设置角标

private var unsafe_badge_raw: Int = 0

struct BadgeConfig {
    /// 背景色
    var backgroundColor: UIColor = .red
    /// 字体大小
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    /// 高度
    var height: CGFloat = 15
    /// 圆角
    var cornerRadius: CGFloat = 7.5
    /// 文字颜色
    var titleColor: UIColor = .white
    /// 宽高增量
    var padding:(w: CGFloat, h: CGFloat) = (w: 6, h: 0)
    /// 默认badge中心位置为父视图右上角，根据offset进行偏移
    var offset:(left: CGFloat, top: CGFloat) = (left: -2, top: 2)
}
extension UIView {
    /// 设置角标
    func setBadgeValue(_ value: String?, config: BadgeConfig = BadgeConfig()) {
        // 关联值 目的是可以手动获取到值
        objc_setAssociatedObject(self,
                                 &unsafe_badge_raw,
                                 value,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        guard let badgeValue = value else {
            clearBadgeValue()
            return
        }
        let size = CGSize.init(width: CGFloat(MAXFLOAT) , height: CGFloat(MAXFLOAT))
        let rect = badgeValue.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)],
            context: nil
        )
        //保证 宽 > 高
        let width = rect.size.width > config.height ? rect.size.width + config.padding.w : config.height
        let badgeBtn = UIButton(
            frame: CGRect(x: 0, y: 0, width: width, height: config.height + config.padding.h)
        )
        badgeBtn.center = CGPoint(x: frame.size.width + config.offset.left , y: config.offset.top)
        badgeBtn.tag = 1008611
        badgeBtn.layer.cornerRadius = config.cornerRadius
        badgeBtn.layer.masksToBounds = true
        badgeBtn.titleLabel?.font = config.font
        badgeBtn.backgroundColor = config.backgroundColor
        badgeBtn.setTitleColor(config.titleColor, for: .normal)
        badgeBtn.setTitle(badgeValue, for: .normal)
        addSubview(badgeBtn)
        bringSubviewToFront(badgeBtn)
    }
    /// 获取badgeValue
    var badgeValue: String? {
        guard let valueStr = objc_getAssociatedObject(self, &unsafe_badge_raw) as? String,
              let value = Int(valueStr)
        else { return nil }
        if value < 0 {
            return "0"
        } else {
            return valueStr
        }
    }
    /// 清除badgeValue
    func clearBadgeValue() {
        for view in subviews {
            if (view is UIButton) && view.tag == 1008611 {
                view.removeFromSuperview()
            }
        }
    }

    /// 判断是否全是数字
    func isAllNumber(string: String) -> Bool {
        let scan: Scanner = Scanner(string: string)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
}
