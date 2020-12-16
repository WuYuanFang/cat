//
//  AC_XQShopMallSearchViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopMallSearchViewCell: AC_XQShadowCollectionViewCell {
    
    let imgView = UIImageView()
    
    
    let nameLab = UILabel()
    let priceLab = UILabel()
    let shopCarBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView)
        
        self.contentView.xq_addSubviews(self.nameLab, self.priceLab, self.shopCarBtn)
        
        // 布局
        
        // 高宽比
        self.xq_contentView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.nameLab.snp.top).offset(-12)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.nameLab.snp.contentHuggingVerticalPriority = UILayoutPriority.required.rawValue
        self.nameLab.snp.contentCompressionResistanceVerticalPriority = UILayoutPriority.required.rawValue
        self.nameLab.snp.makeConstraints { (make) in
//            make.top.equalTo(self.xq_contentView.snp.bottom).offset(12)
            make.left.right.equalTo(self.xq_contentView)
            make.bottom.equalTo(self.priceLab.snp.top).offset(-10)
        }
        
        self.priceLab.snp.contentHuggingVerticalPriority = UILayoutPriority.required.rawValue
        self.priceLab.snp.contentCompressionResistanceVerticalPriority = UILayoutPriority.required.rawValue
        self.priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.xq_contentView)
            
//            make.top.equalTo(self.nameLab.snp.bottom).offset(10)
            make.bottom.equalTo(-12)
        }
        
        self.shopCarBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.xq_contentView)
            make.centerY.equalTo(self.priceLab)
            make.size.equalTo(20)
        }
        
        // 设置属性
        
        self.imgView.backgroundColor = UIColor.ac_mainColor
//        self.imgView.contentMode = .scaleAspectFit
        self.imgView.contentMode = .scaleAspectFill
        
        self.nameLab.textColor = UIColor.init(hex: "#999999")
        self.nameLab.font = UIFont.systemFont(ofSize: 15)
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.systemFont(ofSize: 15)
        
        self.shopCarBtn.setBackgroundImage(UIImage.init(named: "shopCar_black"), for: .normal)
        
        self.nameLab.text = "布偶猫"
        
        self.priceLab.text = "¥ 546"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
