//
//  AC_XQVIPViewPrivilegeViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQVIPViewPrivilegeViewCell: UICollectionViewCell {
    
    let imgView = UIImageView()
    private let imgBackView = UIView()
    let titleLab = UILabel()
    let discountLab = UILabel()
    let dateLab = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.imgBackView, self.titleLab, self.discountLab, self.dateLab)
        self.imgBackView.addSubview(self.imgView)
        
        // 布局
        self.imgBackView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        self.discountLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        self.dateLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.discountLab.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        // 设置属性
        self.imgView.contentMode = .scaleAspectFill
        self.imgBackView.backgroundColor = UIColor.init(hex: "#C3CDCD")
        self.imgBackView.layer.cornerRadius = 15
        self.imgBackView.layer.shadowOffset = CGSize.init(width: 0, height: 10)
        self.imgBackView.layer.shadowOpacity = 0.15
        self.imgBackView.layer.shadowColor = UIColor.black.cgColor
        
        self.titleLab.font = UIFont.systemFont(ofSize: 11)
        
        self.discountLab.font = UIFont.systemFont(ofSize: 11)
        self.discountLab.textColor = UIColor.init(hex: "#2B5357")
//        self.discountLab.textColor = UIColor.black
        self.discountLab.textAlignment = .center
        
        self.dateLab.font = UIFont.systemFont(ofSize: 11)
        self.dateLab.textColor = UIColor.init(hex: "#999999")
        
        self.titleLab.text = "寄养折扣"
        self.discountLab.text = "9.8折"
        
        // 暂时没有
//        self.dateLab.text = "3月20日重置"
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
