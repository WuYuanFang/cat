//
//  AC_XQWashProtectOrderDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

class AC_XQWashProtectOrderDetailView: AC_XQFosterOrderViewBaseView {

    let headerView = AC_XQFosterOrderViewHeaderView()
    
    let infoView = AC_XQWashProtectOrderDetailViewInfoView()
    
    let bottomView = AC_XQWashProtectOrderDetailViewBottomView()
    
    let statusLabel = UILabel()
    let animalImg = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.infoView, self.bottomView)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.infoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalTo(-12)
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        
        // 设置属性
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class AC_XQWashProtectOrderDetailViewBottomView: UIView {
    
    let stateL = UILabel()
    let mapBtn = QMUIButton()
    let phoneBtn = QMUIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.stateL, self.mapBtn, self.phoneBtn)
        
        
        self.phoneBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(self.mapBtn)
            make.width.equalTo(120)
        }
        
        self.mapBtn.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
            make.right.equalTo(self.phoneBtn.snp.left).offset(-20)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(120)
        }
        self.self.stateL.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(mapBtn.snp.left).offset(-10)
            make.top.bottom.equalToSuperview()
        }
        // 设置属性
        self.mapBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.mapBtn.setTitle("地图/导航", for: .normal)
        self.mapBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.mapBtn.setImage(UIImage.init(named: "address_list"), for: .normal)
        
        self.phoneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.phoneBtn.setTitle("联系商家", for: .normal)
        self.phoneBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.phoneBtn.setImage(UIImage.init(named: "order_phone"), for: .normal)
        
        // 布局
        self.stateL.textColor = .ac_mainColor
        self.stateL.textAlignment = .center
        self.stateL.font = UIFont.systemFont(ofSize: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


