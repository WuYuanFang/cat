//
//  AC_XQShopCarViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopCarViewCell: AC_XQShadowCell {
    
    let selectBtn = UIButton()
    
    let iconImgView = UIImageView()
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    let priceLab = UILabel()
    
    let numberView = XQNumberView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.selectBtn)
        self.xq_contentView.xq_addSubviews(self.iconImgView, self.titleLab, self.messageLab, self.priceLab, self.numberView)
        
        // 布局
        self.selectBtn.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.size.equalTo(20)
        }
        
        self.xq_contentView.snp.remakeConstraints { (make) in
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.left.equalTo(self.selectBtn.snp.right).offset(12)
            make.right.equalTo(-15)
        }
        
        self.iconImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 87, height: 96))
            make.left.equalTo(10)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImgView.snp.right).offset(12)
            make.right.equalTo(-12)
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
        
        self.numberView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.priceLab)
            make.right.equalTo(-12)
            make.width.equalTo(120)
        }
        
        // 设置属性
        
        self.xq_contentView.layer.shadowOpacity = 0
        self.xq_contentView.backgroundColor = UIColor.clear
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        self.iconImgView.layer.cornerRadius = 10
        self.iconImgView.layer.masksToBounds = true
        self.iconImgView.contentMode = .scaleAspectFill
        
        self.selectBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.selectBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 15)
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.systemFont(ofSize: 14)
        
        
        self.numberView.tf.backgroundColor = UIColor.init(hex: "#F3F3F3")
        self.numberView.minValue = 1
        
        self.numberView.increaseBtn.setTitle("+", for: .normal)
        self.numberView.increaseBtn.setTitleColor(UIColor.black, for: .normal)
        self.numberView.increaseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.numberView.decreaseBtn.setTitle("-", for: .normal)
        self.numberView.decreaseBtn.setTitleColor(UIColor.black, for: .normal)
        self.numberView.decreaseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        
        self.titleLab.text = "沃夫可宠物零食全期犬用"
        
        self.messageLab.text = ""
        
        self.priceLab.text = "¥1888"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
