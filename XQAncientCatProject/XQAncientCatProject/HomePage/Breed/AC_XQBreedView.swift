//
//  AC_XQBreedView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQBreedView: UIView {
    
    let scrollView = UIScrollView()
    
    let headerView = AC_XQBreedViewHeaderView()
    
    let appointmentView = AC_XQBreedViewAppointmentTimeView()
    
    let petView = AC_XQBreedViewSelectPetView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        
        self.scrollView.xq_addSubviews(self.headerView, self.appointmentView, self.petView)
        
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
        
        self.appointmentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.petView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appointmentView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        
        // 设置属性
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
