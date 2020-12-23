//
//  AC_XQWashProtectView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SDCycleScrollView

class AC_XQWashProtectView: UIView {

    let scrollView = UIScrollView()
    /// 轮播图
    let cycleScrollView = SDCycleScrollView()
    let bottomView = UIView()
    
    let headerView = AC_XQBreedViewHeaderView()
    
    let appointmentView = AC_XQBreedViewAppointmentTimeView()
    
    let petView = AC_XQWashProtectViewSelectPetView()
    
    let serviceView = AC_XQWashProtectViewServiceView()
    
    let takeView = AC_XQWashProtectViewTakeView()
    
    let payView = AC_XQWashProtectViewPayView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomView.xq_setBottomConcave(35)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        self.cycleScrollView.backgroundColor = UIColor.ac_mainColor
        self.xq_addSubviews(self.cycleScrollView, self.bottomView)
        self.cycleScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.cycleScrollView.snp.width).multipliedBy(285.0/375.0)
        }
        self.bottomView.backgroundColor = .white
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-FootSafeHeight)
            make.top.equalTo(self.cycleScrollView.snp.bottom).offset(-35)
        }
        
        self.bottomView.addSubview(scrollView)
        self.scrollView.xq_addSubviews(self.headerView, self.appointmentView, self.petView, self.serviceView, self.takeView, self.payView)
        // 布局
        self.scrollView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalTo(0)
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        self.petView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.appointmentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.petView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.serviceView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appointmentView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.takeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.serviceView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.payView.snp.makeConstraints { (make) in
            make.top.equalTo(self.takeView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 设置属性
        
//        self.headerView.changeUI(1)
        
        
        // 不要接送
        self.takeView.isHidden = true
        self.payView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.serviceView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
