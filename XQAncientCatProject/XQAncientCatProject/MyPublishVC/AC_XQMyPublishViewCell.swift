//
//  AC_XQMyPublishViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class AC_XQMyPublishViewCell: AC_XQShadowCell {

    let iconImgView = UIImageView()
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    let priceLab = UILabel()
    
    let statusLab = XQPaddingLabel.init(frame: CGRect.zero, padding: UIEdgeInsets.init(top: 5, left: 8, bottom: -5, right: -8), rounded: false)
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.xq_contentView.xq_addSubviews(self.iconImgView, self.titleLab, self.messageLab, self.priceLab)
        
        // 布局
        self.iconImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 87, height: 96))
            make.left.equalTo(10)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImgView.snp.right).offset(12)
            make.top.equalTo(self.iconImgView).offset(6)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(10)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.iconImgView).offset(-8)
            make.left.equalTo(self.titleLab)
        }
        
        // 设置属性
        
        self.xq_contentView.layer.shadowOpacity = 0
        self.xq_contentView.backgroundColor = UIColor.clear
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        self.iconImgView.layer.cornerRadius = 10
        self.iconImgView.layer.masksToBounds = true
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 15)
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.systemFont(ofSize: 14)
        
        
        self.titleLab.text = "布偶猫"
        
        self.messageLab.text = "3个月 公 温顺"
        self.priceLab.text = "标价¥1888"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
