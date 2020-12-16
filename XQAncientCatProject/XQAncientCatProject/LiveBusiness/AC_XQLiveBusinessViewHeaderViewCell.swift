//
//  AC_XQLiveBusinessViewHeaderViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLiveBusinessViewHeaderViewCell: AC_XQShadowCollectionViewCell {
    
    let imgView = UIImageView()
    let nameLab = UILabel()
    let ageLab = UILabel()
    let genderImgView = UIImageView()
    let characterLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView, self.nameLab, self.ageLab, self.genderImgView, self.characterLab)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.ageLab.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.bottom.equalTo(-12)
        }
        
        self.genderImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.ageLab.snp.right).offset(6)
            make.centerY.equalTo(self.ageLab)
            make.size.equalTo(12)
        }
        
        self.characterLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.genderImgView.snp.right).offset(10)
            make.centerY.equalTo(self.ageLab)
            make.right.equalTo(-12)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.ageLab.snp.top).offset(-8)
            make.left.equalTo(self.ageLab)
        }
        
        
        // 设置属性
        
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        self.genderImgView.backgroundColor = UIColor.orange
        
        self.nameLab.textColor = UIColor.white
        self.nameLab.font = UIFont.systemFont(ofSize: 13)
        
        self.ageLab.textColor = UIColor.white
        self.ageLab.font = UIFont.systemFont(ofSize: 13)
        
        self.characterLab.textColor = UIColor.white
        self.characterLab.font = UIFont.systemFont(ofSize: 13)
        
        
        self.nameLab.text = "橘猫"
        self.ageLab.text = "3个月"
        self.characterLab.text = "温顺"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
