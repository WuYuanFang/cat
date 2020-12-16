//
//  AC_XQFosterOrderViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/2.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQFosterOrderViewHeaderView: UIView {
    
    let titleLab = UILabel()
    let addressLab = UILabel()
    let imgView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.addressLab, self.imgView)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView).offset(4)
            make.left.equalToSuperview()
        }
        
        self.addressLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(10)
            make.left.equalTo(self.titleLab)
            make.bottom.equalToSuperview()
        }
        
        let imgViewSize: CGFloat = 40
        self.imgView.snp.makeConstraints { (make) in
            make.size.equalTo(imgViewSize)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // 设置属性
        
        self.imgView.layer.cornerRadius = imgViewSize/2
        self.imgView.layer.masksToBounds = true
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.addressLab.font = UIFont.systemFont(ofSize: 13)
        self.addressLab.textColor = UIColor.init(hex: "#666666")
        
        
        self.titleLab.text = "小古猫宠物店"
        self.addressLab.text = "广东省惠州市惠城区河南岸（距您500m）"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
