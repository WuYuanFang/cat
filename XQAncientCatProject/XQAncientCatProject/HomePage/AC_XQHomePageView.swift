//
//  AC_XQHomePageView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

class AC_XQHomePageView: UIView {
    
    let scrollView = UIScrollView()
    
    let headerView = AC_XQHomePageViewHeaderView()
    
    let appointmentView = AC_XQHomePageViewAppointmentView()
    let shopInfoView = AC_XQHomePageViewShopInfoView()
    let hotView = AC_XQHomePageViewHotView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.xq_addSubviews(self.headerView, self.scrollView)
//        self.scrollView.xq_addSubviews(self.headerView, self.appointmentView, self.shopInfoView, self.hotView)
        self.scrollView.xq_addSubviews(self.appointmentView, self.shopInfoView, self.hotView)
        
        // 布局
        self.scrollView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
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
        
        self.appointmentView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        self.shopInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appointmentView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.hotView.snp.makeConstraints { (make) in
            make.top.equalTo(self.shopInfoView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
        
        // 设置属性
        
        
        
        
//        // 第一期不用热门推荐
//        self.hotView.removeFromSuperview()
//        self.shopInfoView.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.appointmentView.snp.bottom).offset(30)
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-25)
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
