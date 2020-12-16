//
//  AC_XQScoreOrderListViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQScoreOrderListViewCell: UICollectionViewCell {
    
    let headerView = UIView()
    let priceLab = UILabel()
    let imgView = UIImageView()
    
    let footerView = UIView()
    let titleLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.footerView)
        
        self.headerView.xq_addSubviews(self.imgView, self.priceLab)
        self.footerView.xq_addSubviews(self.titleLab)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.footerView.snp.top)
        }
        
        self.footerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.bottom.equalTo(self.priceLab.snp.top).offset(-6)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.imgView.snp.height)
        }
        
        self.priceLab.snp.contentCompressionResistanceVerticalPriority = UILayoutPriority.required.rawValue
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-4)
            make.left.equalTo(6)
            make.right.equalTo(-6)
        }
        
        self.titleLab.snp.contentCompressionResistanceVerticalPriority = UILayoutPriority.required.rawValue
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(6)
            make.right.equalTo(-6)
            make.top.equalTo(6)
            make.bottom.equalTo(-10)
        }
        
        // 设置属性
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.imgView.contentMode = .scaleAspectFill
        self.imgView.layer.masksToBounds = true
        
        self.headerView.backgroundColor = UIColor.init(hex: "#F6F6F6")
        
        //        self.footerView.backgroundColor = UIColor.ac_mainColor
        self.footerView.backgroundColor = UIColor.init(xq_rgbWithR: 192, g: 203, b: 202)
        
        
        self.titleLab.font = UIFont.systemFont(ofSize: 11)
        self.titleLab.textAlignment = .center
        self.titleLab.textColor = UIColor.white
        self.titleLab.text = "再次兑换"
        
        self.priceLab.font = UIFont.systemFont(ofSize: 11)
        self.priceLab.textAlignment = .center
        self.priceLab.textColor = UIColor.ac_mainColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
