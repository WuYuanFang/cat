//
//  AC_XQBreedViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import SDCycleScrollView

class AC_XQBreedViewHeaderView: UIView {
    
    let titleLab = UILabel()
    let timeLab = UILabel()
    let changeBtn = QMUIButton()
    let addressBtn = QMUIButton()
    
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.contentView)
        self.contentView.xq_addSubviews(self.titleLab, self.timeLab, self.changeBtn, self.addressBtn)
        
        // 布局
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { (make) in
//            make.top.equalTo(self.imgView.snp.bottom).offset(30)
            make.top.equalTo(30)
            make.left.equalTo(16)
        }
        
        self.changeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(-16)
        }
        
        self.timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(8)
        }
        
        self.addressBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.timeLab.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        
        // 设置属性
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.timeLab.font = UIFont.boldSystemFont(ofSize: 13)
        self.timeLab.textColor = UIColor.init(hex: "#666666")
        
        self.addressBtn.setTitleColor(UIColor.init(hex: "#666666"), for: .normal)
        self.addressBtn.setImage(UIImage.init(named: "address"), for: .normal)
        self.addressBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        
        self.changeBtn.setTitle("切换门店", for: .normal)
        self.changeBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.changeBtn.setImage(UIImage.init(named: "address"), for: .normal)
        self.changeBtn.imagePosition = .right
        self.changeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.changeBtn.isHidden = true
        
        
        
        self.titleLab.text = "小古猫宠物店(营业中）"
        self.timeLab.text = "营业时间：09:00-19:00"
        self.addressBtn.setTitle("广东省惠州市惠城区河南岸（距您500m）", for: .normal)
        
        self.contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.mode == 0 {
//            self.cycleScrollView.setBottomCorner(with: 90, height: 30)
        }else if self.mode == 1 {
            self.contentView.xq_setBottomConcave(self.cornetSize)
        }
        
    }
    
    private var mode: Int = 0
    private let cornetSize: CGFloat = 35
    /// 改变UI布局
    func changeUI(_ mode: Int) {
        self.mode = mode
        
        if mode == 1 {
//            self.contentView.snp.updateConstraints { (make) in
//                make.top.equalTo(self.cycleScrollView.snp.bottom).offset(-self.cornetSize)
//            }

            self.contentView.xq_setBottomConcave(self.cornetSize)
//            self.cycleScrollView.layer.mask = nil
        }
        
    }
    
}


extension UIView {
    
    /// 底部往内部凹
    func xq_setBottomConcave(_ size: CGFloat) {
        
        let maxWidth = self.frame.width
        let maxHeight = self.frame.height
        
        let bezierPath = UIBezierPath.init()
        
        bezierPath.move(to: CGPoint.init(x: 0, y: size))
        
        // 左上角弯角
        bezierPath.addQuadCurve(to: CGPoint.init(x: size, y: 0),
                                controlPoint: CGPoint.init(x: 0, y: 0))
        
        bezierPath.addLine(to: CGPoint.init(x: maxWidth - size, y: 0))
        
        // 右上角弯角
        bezierPath.addQuadCurve(to: CGPoint.init(x: maxWidth, y: size),
                                controlPoint: CGPoint.init(x: maxWidth, y: 0))
        
        
        bezierPath.addLine(to: CGPoint.init(x: maxWidth, y: maxHeight))
        bezierPath.addLine(to: CGPoint.init(x: 0, y: maxHeight))
        bezierPath.close()
        
        let shape = CAShapeLayer.init()
        shape.path = bezierPath.cgPath
        self.layer.mask = shape
        
    }
    
}



