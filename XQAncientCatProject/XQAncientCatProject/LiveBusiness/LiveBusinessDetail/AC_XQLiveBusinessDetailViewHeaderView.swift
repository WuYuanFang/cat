//
//  AC_XQLiveBusinessDetailViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLiveBusinessDetailViewHeaderView: UIView {

    let imgView = UIImageView()
    
    let contentView = UIView()
    let maskHeight: CGFloat = 100
    
    let nameLab = UILabel()
    let genderImgView = UIImageView()
    let priceLab = UILabel()
    let messageLab = UILabel()
    
    // 还有改一个标签 view
    
    
    
    let userInfoView = AC_XQLiveBusinessDetailViewHeaderViewUserInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.contentView)
        
        self.contentView.xq_addSubviews(self.nameLab, self.genderImgView, self.priceLab, self.messageLab, self.userInfoView)
        
        // 布局
        let imgWHScale = 375.0/320.0
        self.imgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.imgView.snp.width).multipliedBy(1.0/imgWHScale)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(-self.maskHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.maskHeight - 15)
            make.left.equalTo(30)
        }
        
        self.genderImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.nameLab)
            make.left.equalTo(self.nameLab.snp.right).offset(12)
            make.size.equalTo(15)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.nameLab)
            make.right.equalTo(-30)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom).offset(16)
            make.left.equalTo(self.nameLab)
            make.right.equalTo(self.priceLab)
        }
        
        self.userInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageLab.snp.bottom).offset(48)
            make.left.equalTo(self.nameLab)
            make.right.equalTo(self.priceLab)
            make.bottom.equalTo(-12)
        }
        
        // 设置属性
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        self.contentView.backgroundColor = UIColor.white
        
        
        self.nameLab.text = "小糯米"
        self.genderImgView.backgroundColor = UIColor.ac_mainColor
        self.priceLab.text = "¥7890"
        self.messageLab.text = "温顺 乖巧 黏人，猫猫介绍猫猫介绍猫猫介绍猫猫"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.setSStraightCornerMask(with: self.maskHeight)
    }
    
}


class AC_XQLiveBusinessDetailViewHeaderViewUserInfoView: UIView {
    
    
    let imgView = UIImageView()
    let nameLab = UILabel()
    let nameImgView = UIImageView()
    
    let phoneLab = UILabel()
    let phoneImgView = UIImageView()
    
    let addressImgView = UIImageView()
    let addressLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.nameLab, self.nameImgView, self.phoneLab, self.phoneImgView, self.addressImgView, self.addressLab)
        
        // 布局
        
        let imgViewSize: CGFloat = 40
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.size.equalTo(imgViewSize)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.imgView)
            make.left.equalTo(self.imgView.snp.right).offset(16)
        }
        
        self.nameImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.nameLab)
            make.left.equalTo(self.nameLab.snp.right).offset(5)
            make.size.equalTo(12)
        }
        
        self.phoneLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.nameLab)
            make.left.equalTo(self.nameImgView.snp.right).offset(10)
        }
        
        self.phoneImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.nameLab).offset(10)
            make.right.equalTo(-16)
            make.size.equalTo(imgViewSize + 10)
        }
        
        self.addressImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom).offset(10)
            make.left.equalTo(self.nameLab)
            make.size.equalTo(15)
            make.bottom.equalTo(-30)
        }
        
        self.addressLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.addressImgView)
            make.left.equalTo(self.addressImgView.snp.right).offset(8)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.layer.cornerRadius = 20
        
        self.imgView.layer.cornerRadius = imgViewSize/2
        self.imgView.layer.masksToBounds = true
        
        self.nameLab.font = UIFont.systemFont(ofSize: 15)
        self.nameImgView.backgroundColor = UIColor.ac_mainColor
        
        self.phoneLab.font = UIFont.systemFont(ofSize: 15)
        self.phoneImgView.image = UIImage.init(named: "phone")
        
        self.addressLab.font = UIFont.systemFont(ofSize: 13)
        self.addressImgView.image = UIImage.init(named: "tick")
        
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        
        self.nameImgView.backgroundColor = UIColor.ac_mainColor
        
//        self.nameLab.text = "小明"
//        self.phoneLab.text = "150****6787"
        
//        self.addressLab.text = "发货地：湖北省武汉市"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


