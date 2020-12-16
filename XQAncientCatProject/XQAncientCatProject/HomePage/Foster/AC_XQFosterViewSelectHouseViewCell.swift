//
//  AC_XQFosterViewSelectHouseViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQFosterViewSelectHouseViewCell: AC_XQShadowCollectionViewCell {
    
    let imgView = UIImageView()
    let nameLab = UILabel()
    let moneyLab = UILabel()
    
    let numberLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView, self.numberLab)
        self.imgView.xq_addSubviews(self.nameLab, self.moneyLab)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.imgView.snp.width).multipliedBy(90.0/100.0)
        }
        
        self.numberLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-4)
            make.left.equalTo(10)
        }
        
        self.moneyLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.nameLab)
            make.right.equalTo(-10)
        }
        
        // 设置属性
        
//        self.imgView.image = UIImage.init(named: "AppIcon")
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        self.nameLab.textColor = UIColor.white
        self.nameLab.font = UIFont.systemFont(ofSize: 13)
        
        self.moneyLab.textColor = UIColor.white
        self.moneyLab.font = UIFont.systemFont(ofSize: 13)
        
        self.numberLab.textColor = UIColor.init(hex: "#999999")
        self.numberLab.font = UIFont.systemFont(ofSize: 13)
        
        
//        self.numberLab.text = "剩余 3 空位"
//        self.nameLab.text = "公寓"
//        self.moneyLab.text = "¥99/天"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
