//
//  XQFormDescView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQFormDescView: UIView {
    
    /// 行标题
    let rowDesLab = UILabel()
    
    /// 列标题
    let columnDesLab = UILabel()
    
    /// 线颜色
    var lineColor = UIColor.black
    
    private var shapeLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.rowDesLab)
        self.addSubview(self.columnDesLab)
        
        // 布局
        self.rowDesLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.columnDesLab.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        
        // 设置属性
        self.rowDesLab.textAlignment = .center
        self.columnDesLab.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawLine()
    }
    
    private var isSingle = false
    
    /// 单个标题UI
    /// 单个标题的话 ， 只有 rowDesLab 有用
    func singleTitleUI() {
        self.isSingle = true
        self.columnDesLab.isHidden = true
        
        self.rowDesLab.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.shapeLayer?.removeFromSuperlayer()
    }
    
    private func drawLine() {
        
        if self.isSingle {
            return
        }
        
        if let _ = self.shapeLayer {
            return
        }
        
        let maxWidth = self.frame.width
        let maxHeight = self.frame.height
        
        let bezierPath = UIBezierPath.init()
        
        bezierPath.move(to: CGPoint.init(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: maxHeight))
        bezierPath.addLine(to: CGPoint.init(x: 0, y: 0))
        bezierPath.close()
        
        self.shapeLayer = CAShapeLayer.init()
        self.shapeLayer?.lineWidth = 1
        self.shapeLayer?.strokeColor = self.lineColor.cgColor
        self.shapeLayer?.path = bezierPath.cgPath
        
        self.layer.addSublayer(self.shapeLayer!)
        
    }
    
}
