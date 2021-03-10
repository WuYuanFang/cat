//
//  XQUIViewExtension.swift
//  XQAncientCatProject
//
//  Created by sinking on 2019/12/26.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView


extension UIView {
    
    /// 一次添加多个view
    /// - Parameter views: 多个view
    public func xq_addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }
    
    /// 设置视图阴影
    /// - Parameters:
    ///   - view: 需要设置的视图
    ///   - cradius: 需要设置的圆角
    ///   - sColor: 阴影的颜色
    ///   - offset: 偏移量
    ///   - opacity: 透明度
    ///   - radius: 阴影半径
    func setShadow(cradius:CGFloat = 4.0,
                   opacity:Float = 0.6,
                   radius:CGFloat = 3.0,
                   sColor:UIColor = UIColor.init(fromHexString: "CCCCCC")!,
                   offset:CGSize = CGSize(width: 0, height: 0)) {
        //设置阴影颜色
        self.layer.shadowColor = sColor.cgColor
        //设置边框圆角
        self.layer.cornerRadius = cradius
        //设置透明度
        self.layer.shadowOpacity = opacity
        //设置阴影半径
        self.layer.shadowRadius = radius
        //设置阴影偏移量
        self.layer.shadowOffset = offset
    }
}


extension CMPageTitleConfig {
    
    /// 一些基础配置
    func sm_config() {
        self.cm_selectedColor = .ac_mainColor
        self.cm_normalColor = UIColor.init(hex: "#999999")
        
        self.cm_underlineColor = UIColor.black
        self.cm_underlineHeight = 4
        
        self.cm_backgroundColor = UIColor.white
        
        self.cm_switchMode = [.underline, .scale]
        
        self.cm_selectedFont = UIFont.boldSystemFont(ofSize: 16)
        self.cm_font = UIFont.boldSystemFont(ofSize: 15)
    }
    
}

extension UIView {
    
    /// 头部 s 型弯角(首页的波浪)
    /// - Parameters:
    ///   - height: 弯角总高度
    ///
    /// - note: 注意! 要弯角视图的 frame 要已经正确设置了
    func setSCornerMask(with height: CGFloat) {
        let maxWidth = self.frame.width
        let maxHeight = self.frame.height
        // 一半
        let halfHeight = height/2
        
        let bezierPath = UIBezierPath.init()
        
        // 最右边开始
        bezierPath.move(to: CGPoint.init(x: 0, y: height))
        // 直接两个控制点
//        bezierPath.addCurve(to: CGPoint.init(x: maxWidth, y: height * (3/5)),
//                            controlPoint1: CGPoint.init(x: maxWidth/3, y: -(height * 1.4)),
//                            controlPoint2: CGPoint.init(x: maxWidth * (1/2), y: height * 1.5))
        bezierPath.addCurve(to: CGPoint.init(x: maxWidth, y: height * (1/2)),
                            controlPoint1: CGPoint.init(x: maxWidth * (5/16), y: -(height * 1.25)),
                            controlPoint2: CGPoint.init(x: maxWidth * (1/2), y: height * 1.4))
        
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: maxHeight))
        bezierPath.addLine(to: CGPoint.init(x: 0, y: maxHeight))
        
        bezierPath.close()
        
        // 反转
        //        bezierPath = bezierPath.reversing()
        
        let shape = CAShapeLayer.init()
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
    }
    
    /// 头部 s 型弯角(中间是直的)
    /// - Parameters:
    ///   - height: 弯角总高度
    ///
    /// - note: 注意! 要弯角视图的 frame 要已经正确设置了
    func setSStraightCornerMask(with height: CGFloat) {
        
        let maxWidth = self.frame.width
        let maxHeight = self.frame.height
        // 一半
        let half = height/2
        
        let bezierPath = UIBezierPath.init()
        
        //        bezierPath.move(to: CGPoint.init(x: 0, y: 0))
        //        bezierPath.addLine(to: CGPoint.init(x: maxWith, y: 0))
        //        bezierPath.addQuadCurve(to: CGPoint.init(x: maxWith - half, y: half), controlPoint: CGPoint.init(x: maxWith, y: half))
        //        bezierPath.addLine(to: CGPoint.init(x: half, y: half))
        //        bezierPath.addQuadCurve(to: CGPoint.init(x: 0, y: height), controlPoint: CGPoint.init(x: 0, y: half))
        
        // 最右边开始
        bezierPath.move(to: CGPoint.init(x: maxWidth, y: 0))
        // 右边弯角
        bezierPath.addQuadCurve(to: CGPoint.init(x: maxWidth - half, y: half), controlPoint: CGPoint.init(x: maxWidth, y: half))
        bezierPath.addLine(to: CGPoint.init(x: half, y: half))
        // 左边弯角
        bezierPath.addQuadCurve(to: CGPoint.init(x: 0, y: height), controlPoint: CGPoint.init(x: 0, y: half))
        
        bezierPath.addLine(to: CGPoint.init(x: 0, y: maxHeight))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: maxHeight))
        
        bezierPath.close()
        
        // 反转
        //        bezierPath = bezierPath.reversing()
        
        let shape = CAShapeLayer.init()
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
    }
    
    
    /// 设置底部弯角(繁育图片底部)
    /// - Parameters:
    ///   - width: 弯角宽度
    ///   - height: 弯角高度
    func setBottomCorner(with width: CGFloat, height: CGFloat) {
        
        let maxWidth = self.frame.width
        let maxHeight = self.frame.height
        
        let bezierPath = UIBezierPath.init()
        
        bezierPath.move(to: CGPoint.init(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: maxHeight - height))
        
        let scale: CGFloat = 4
        
        // 右下角弯角
        bezierPath.addQuadCurve(to: CGPoint.init(x: maxWidth - width, y: maxHeight),
                                controlPoint: CGPoint.init(x: maxWidth - (width/scale), y: maxHeight - (height/scale)))
//        bezierPath.addQuadCurve(to: CGPoint.init(x: maxWidth - width, y: maxHeight), controlPoint: CGPoint.init(x: maxWidth, y: maxHeight))
        
        bezierPath.addLine(to: CGPoint.init(x: width, y: maxHeight))
        // 左下角弯角
        bezierPath.addQuadCurve(to: CGPoint.init(x: 0, y: maxHeight - height), controlPoint: CGPoint.init(x: width/scale, y: maxHeight - (height/scale)))
        
        bezierPath.close()
        
        // 反转
        //        bezierPath = bezierPath.reversing()
        
        let shape = CAShapeLayer.init()
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
        
    }
    
    
    
}


