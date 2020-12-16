//
//  AC_XQHomePageViewHotViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQHomePageViewHotViewCell: AC_XQShadowCollectionViewCell {
    
    let imgView = UIImageView()
    
    let bottomView = UIView()
    let titleLab = UILabel()
    let messageLab = UILabel()
    let arrowImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView, self.bottomView)
        self.bottomView.xq_addSubviews(self.titleLab, self.messageLab, self.arrowImgView)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(12)
            make.right.equalTo(self.arrowImgView.snp.left).offset(-5)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(8)
            make.left.equalTo(self.titleLab)
            make.right.equalTo(-12)
            make.bottom.equalTo(-12)
        }
        
        self.arrowImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(-12)
            make.size.equalTo(25)
        }
        
        // 设置属性
        self.xq_contentView.layer.cornerRadius = 0
        
        self.imgView.contentMode = .scaleAspectFill
        
        self.bottomView.backgroundColor = UIColor.ac_mainColor
        self.bottomView.layer.cornerRadius = 15
        
        self.titleLab.textColor = UIColor.white
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 15)
        
        self.messageLab.textColor = UIColor.white
        self.messageLab.font = UIFont.systemFont(ofSize: 14)
        
        self.arrowImgView.image = UIImage.init(named: "homePage_hot_arrow")
        self.arrowImgView.contentMode = .scaleAspectFit
        
        self.titleLab.text = "宠物"
        self.messageLab.text = "即将开售"
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.xq_contentView.xq_corners_addRoundedCorners([.topLeft, .bottomLeft, .bottomRight], withRadii: CGSize.init(width: 15, height: 15))
        
    }
    
}
