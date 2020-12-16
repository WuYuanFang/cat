//
//  AC_XQHomePageViewShopInfoView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

class AC_XQHomePageViewShopInfoView: AC_XQHomePageViewTableViewHeaderView {

    let iconImgView = UIImageView()
    let nameLab = UILabel()
    let workTimeBtn = QMUIButton()
    let addressBtn = QMUIButton()
    
    let phoneImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.iconImgView, self.nameLab, self.workTimeBtn, self.addressBtn, self.phoneImgView)
        
        // 布局
        self.iconImgView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.size.equalTo(75)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView).offset(4)
            make.left.equalTo(self.iconImgView.snp.right).offset(10)
        }
        
        self.workTimeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLab)
            make.top.equalTo(self.nameLab.snp.bottom).offset(12)
        }
        
        self.addressBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLab)
            make.top.equalTo(self.workTimeBtn.snp.bottom).offset(10)
        }
        
        self.phoneImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab)
            make.right.equalTo(-30)
            make.size.equalTo(60)
        }
        
        // 设置属性
        
        self.titleLab.text = "门店信息"
        self.subtitleLab.text = "Store Information"
        self.imgView.image = UIImage.init(named: "homePage_shopInfo")
        
        self.iconImgView.contentMode = .scaleAspectFill
//        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        self.iconImgView.layer.cornerRadius = 10
        self.iconImgView.layer.masksToBounds = true
        
        self.nameLab.font = UIFont.systemFont(ofSize: 14)
        
        self.phoneImgView.image = UIImage.init(named: "phone")
        
        self.configBtn(self.workTimeBtn, title: "")
        self.configBtn(self.addressBtn, title: "")
        
//                self.configBtn(self.workTimeBtn, title: "营业时间：09:00-19:00")
//                self.configBtn(self.addressBtn, title: "广东省惠州市惠城区河南岸（距您500m）")
//        self.nameLab.text = "小古猫时代广场店"
        self.nameLab.text = "请打开定位，获取周边门店信息"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configBtn(_ btn: QMUIButton, title: String) {
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }

}
