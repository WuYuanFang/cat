//
//  AC_XQShopCarViewOtherCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

class AC_XQShopCarViewOtherCell: AC_XQShadowCell {

    let selectBtn = UIButton()
    
    let iconImgView = UIImageView()
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    let priceLab = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        self.selectBtn.isSelected = selected
        if selected {
            self.selectBtn.backgroundColor = UIColor.ac_mainColor
        }else {
            self.selectBtn.backgroundColor = UIColor.clear
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.selectBtn)
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
        
        self.editLayout()
        
        // 设置属性
        
        self.xq_contentView.layer.shadowOpacity = 0
        self.xq_contentView.backgroundColor = UIColor.clear
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        self.iconImgView.layer.cornerRadius = 10
        self.iconImgView.layer.masksToBounds = true
        
        self.selectBtn.layer.cornerRadius = 8
        self.selectBtn.layer.borderWidth = 1
        self.selectBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 15)
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.systemFont(ofSize: 14)
        
        
        self.titleLab.text = "布偶猫"
        
        self.messageLab.text = "3个月 公 温顺"
        self.priceLab.text = "¥1888"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func editLayout() {
        
        self.selectBtn.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        
        self.xq_contentView.snp.remakeConstraints { (make) in
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.left.equalTo(self.selectBtn.snp.right).offset(12)
            make.right.equalTo(-15)
        }
    }

}
