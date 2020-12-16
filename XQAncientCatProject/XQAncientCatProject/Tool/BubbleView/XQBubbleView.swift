//
//  XQBubbleView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 气泡view
class XQBubbleView: UIView {

    let contentView = UIView()
    
    private var _arrowX: CGFloat = 20
    /// 箭头要指向的方向
    var arrowX: CGFloat {
        set {
            if _arrowX == newValue {
                return
            }
            
            _arrowX = newValue
            
            self.arrowView.snp.updateConstraints { (make) in
                make.centerX.equalTo(self.arrowX)
            }
            
        }
        get {
            return _arrowX
        }
    }
    
    private var _xq_backColor: UIColor = .init(hex: "#DCE3E4")
    /// 背景颜色
    var xq_backColor: UIColor {
        set {
            
            _xq_backColor = newValue
            self.contentView.backgroundColor = self.xq_backColor
            self.arrowView.backgroundColor = self.xq_backColor
        }
        get {
            return _xq_backColor
        }
    }
    
    private let shadowView = UIView()
    private let arrowView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.shadowView)
        self.addSubview(self.contentView)
        self.addSubview(self.arrowView)
        
        // 布局
        
        self.arrowView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalTo(self.arrowX)
            make.size.equalTo(12)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.arrowView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.shadowView.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(-1)
            make.right.bottom.equalTo(1)
        }
        
        // 设置属性
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.shadowOffset = CGSize.init(width: 8, height: 8)
        self.contentView.layer.shadowOpacity = 0.15
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        
        self.contentView.backgroundColor = self.xq_backColor
        self.arrowView.backgroundColor = self.xq_backColor
        
//        self.shadowView.backgroundColor = UIColor.white
//        self.shadowView.layer.cornerRadius = 15
//        self.shadowView.layer.shadowOffset = CGSize.init(width: 8, height: 8)
//        self.shadowView.layer.shadowOpacity = 0.15
//        self.shadowView.layer.shadowColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.toTriangle(with: self.arrowView)
    }
    
    
    /// 画三角形
    private func toTriangle(with v: UIView) {
        let maxWidth = v.frame.width
        let maxHeight = v.frame.height
        
        let bezierPath = UIBezierPath.init()
        
        bezierPath.move(to: CGPoint.init(x: 0, y: maxHeight))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth/2, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: maxHeight))
        bezierPath.close()
        
        let shape = CAShapeLayer.init()
        shape.path = bezierPath.cgPath
        self.arrowView.layer.mask = shape
    }
       

}
