//
//  AC_XQWashProtectView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQWashProtectView: UIView {

    let scrollView = UIScrollView()
    
    let headerView = AC_XQBreedViewHeaderView()
    
    let appointmentView = AC_XQBreedViewAppointmentTimeView()
    
    let petView = AC_XQWashProtectViewSelectPetView()
    
    let serviceView = AC_XQWashProtectViewServiceView()
    
    let takeView = AC_XQWashProtectViewTakeView()
    
    let payView = AC_XQWashProtectViewPayView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        
        self.scrollView.xq_addSubviews(self.headerView, self.appointmentView, self.petView, self.serviceView, self.takeView, self.payView)
        
        // 布局
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
        
        self.headerView.changeUI(1)
        
        
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
