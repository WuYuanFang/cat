//
//  AC_XQVIPViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/11.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQVIPViewHeaderView: UIView {
    
    let backView = UIView()
    let sliderView = AC_XQVIPViewSliderView()
    let carView = AC_XQVIPViewHeaderViewCarView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.backView, self.sliderView, self.carView)
        
        // 布局
        
        self.backView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(270)
        }
        
        self.sliderView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.carView.snp.top).offset(-30)
            make.left.right.equalTo(self.carView)
        }
        
        self.carView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
//            make.top.equalTo(157)
            make.top.equalTo(187)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(self.carView.snp.width).multipliedBy(162.0/338.0)
            make.bottom.equalTo(-20)
        }
        
        
        // 设置属性
        
        self.backView.backgroundColor = UIColor.init(hex: "#2C5659")
        
        self.carView.layer.shadowColor = UIColor.black.cgColor
        self.carView.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.carView.layer.shadowOpacity = 0.2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class AC_XQVIPViewHeaderViewCarView: UIView {
    
    let contentView = UIView()
    let backImgView = UIImageView()
    let headImgView = UIImageView()
    let nameLab = UILabel()
    let vipImgView = UIImageView()
    let phoneLab = UILabel()
    let privilegeBtn = UIButton()
    let couponView = XQTopBottomLabelView.init(frame: .zero)
    let scoreView = XQTopBottomLabelView.init(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        
        self.contentView.xq_addSubviews(self.backImgView, self.headImgView, self.nameLab, self.vipImgView, self.phoneLab, self.couponView, self.scoreView, self.privilegeBtn)
        
        // 布局
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.backImgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.headImgView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(25)
            make.size.equalTo(60)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.headImgView.snp.right).offset(8)
            make.top.equalTo(self.headImgView).offset(12)
        }
        
        self.vipImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.nameLab)
            make.left.equalTo(self.nameLab.snp.right).offset(4)
            make.size.equalTo(15)
        }
        
        self.phoneLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom).offset(3)
            make.left.equalTo(self.nameLab)
        }
        
        self.privilegeBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-30)
            make.size.equalTo(CGSize.init(width: 100, height: 30))
        }
        
        self.couponView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.headImgView).offset(12)
            make.bottom.equalTo(-16)
        }
        
        self.scoreView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.couponView)
            make.left.equalTo(self.couponView.snp.right).offset(30)
        }
        
        
        // 设置属性
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.init(hex: "#C4CCCD")
        
        
        self.headImgView.layer.cornerRadius = 30
        self.headImgView.layer.masksToBounds = true
        
        self.privilegeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.privilegeBtn.backgroundColor = UIColor.init(hex: "#81A3A5")
        self.privilegeBtn.layer.cornerRadius = 15
        self.privilegeBtn.setTitle("查看等级特权", for: .normal)
        
        
        self.nameLab.textColor = UIColor.white
        self.nameLab.font = UIFont.systemFont(ofSize: 16)
        
        self.phoneLab.textColor = UIColor.white
        self.phoneLab.font = UIFont.systemFont(ofSize: 15)
        
        self.couponView.topLabel.textColor = UIColor.white
        self.couponView.bottomLabel.textColor = UIColor.white
        self.scoreView.topLabel.textColor = UIColor.white
        self.scoreView.bottomLabel.textColor = UIColor.white
        
        self.headImgView.backgroundColor = UIColor.ac_mainColor
        
        
        self.vipImgView.contentMode = .scaleAspectFill
        
        
        self.couponView.bottomLabel.text = "优惠券"
        
        self.scoreView.bottomLabel.text = "等级积分"
        
        
//        self.couponView.topLabel.text = "0"
//        self.scoreView.topLabel.text = "100"
        
//        self.nameLab.text = "小明"
//        self.phoneLab.text = "150****6787"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


