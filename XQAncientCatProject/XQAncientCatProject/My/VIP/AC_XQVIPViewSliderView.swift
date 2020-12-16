//
//  AC_XQVIPViewSliderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQVIPViewSliderView: UIView {
    
    /// 还差多少升级的 lab
    let nextLevelLab = UILabel()
    
    /// 选中的线
    let selectLineView = UIView()
    /// 底部线
    let lineView = UIView()
    /// 圆点
    let roundView = UIView()
    /// 跟随圆点的view
    let progressView = AC_XQVIPViewSliderViewProgressView()
    
    let minLab = UILabel()
    let maxLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.nextLevelLab, self.lineView, self.selectLineView, self.roundView, self.progressView, self.minLab, self.maxLab)
        
        // 布局
        self.nextLevelLab.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
        }
        
        self.progressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nextLevelLab.snp.bottom).offset(2)
            make.centerX.equalTo(self.roundView)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(3)
            make.centerY.equalTo(self.roundView)
        }
        
        self.selectLineView.snp.makeConstraints { (make) in
            make.width.equalTo(self.lineView)
            make.left.height.centerY.equalTo(self.lineView)
        }
        
        let roundSize: CGFloat = 10
        self.roundView.snp.makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp.bottom).offset(2)
            make.size.equalTo(roundSize)
            make.centerX.equalTo(self.selectLineView.snp.right)
        }
        
        self.minLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView).offset(6)
            make.left.equalTo(self.lineView)
            make.bottom.equalToSuperview()
        }
        
        self.maxLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.minLab)
            make.right.equalTo(self.lineView)
        }
        
        
        // 设置属性
        
        self.roundView.layer.cornerRadius = roundSize/2
        
        self.lineView.backgroundColor = UIColor.black
        
        self.selectLineView.backgroundColor = UIColor.white
        self.roundView.backgroundColor = UIColor.white
        
        self.minLab.textColor = UIColor.white
        self.minLab.font = UIFont.systemFont(ofSize: 12)
        
        self.maxLab.textColor = UIColor.white
        self.maxLab.font = UIFont.systemFont(ofSize: 12)
        
        self.nextLevelLab.textColor = UIColor.init(hex: "#D0DBE5")
        self.nextLevelLab.font = UIFont.systemFont(ofSize: 12)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置进度
    /// - Parameter progress: 0 ~ 1
    func setProgress(_ progress: Float) {
        var p: Float = 0
        if progress > 1 {
            p = 1
        }else if progress < 0 {
            p = 0
        }else {
            p = progress
        }
        
        self.selectLineView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.lineView).multipliedBy(p)
            make.left.height.centerY.equalTo(self.lineView)
        }
    }
    
}


class AC_XQVIPViewSliderViewProgressView: UIView {
    
    let titleLab = UILabel()
    let contentView = UIView()
    /// 箭头view
    let arrowView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.contentView, self.arrowView)
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        self.contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.arrowView.snp.top)
        }
        
        self.arrowView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(5)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(4)
            make.bottom.right.equalTo(-4)
        }
        
        // 设置属性
        self.contentView.backgroundColor = UIColor.init(hex: "#739A9D")
        self.contentView.layer.cornerRadius = 4
        
        self.arrowView.backgroundColor = UIColor.init(hex: "#739A9D")
        
        self.titleLab.font = UIFont.systemFont(ofSize: 12)
        self.titleLab.textColor = UIColor.white
        
        self.layoutIfNeeded()
        
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
        
        bezierPath.move(to: CGPoint.init(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth/2, y: maxHeight))
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: 0))
        bezierPath.close()
        
        let shape = CAShapeLayer.init()
        shape.path = bezierPath.cgPath
        self.arrowView.layer.mask = shape
    }
    
}




