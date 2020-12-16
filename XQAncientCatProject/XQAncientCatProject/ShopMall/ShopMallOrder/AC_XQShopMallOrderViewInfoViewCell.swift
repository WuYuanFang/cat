//
//  AC_XQShopMallOrderViewInfoViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopMallOrderViewInfoViewCell: UITableViewCell {
    
    let xq_contentView = AC_XQShopMallOrderViewInfoViewCellContentView()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.xq_contentView)
        
        // 布局
        self.xq_contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-20)
            make.bottom.equalTo(-10)
        }
        
        
        // 设置属性
        
        self.selectionStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

class AC_XQShopMallOrderViewInfoViewCellContentView: UIView {
    
    let imgView = UIImageView()
    let nameLab = UILabel()
    let messageLab = UILabel()
    let priceLab = UILabel()
    let numberLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xq_addSubviews(self.imgView, self.nameLab, self.messageLab, self.priceLab, self.numberLab)
        
        // 布局
        
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.imgView.snp.height).multipliedBy(72.0/63.0)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(self.imgView.snp.right).offset(20)
            make.right.equalTo(self.priceLab.snp.left).offset(-5)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom).offset(6)
            make.left.right.equalTo(self.nameLab)
        }
        
        self.priceLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.priceLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        self.imgView.layer.cornerRadius = 4
        self.imgView.layer.masksToBounds = true
        self.imgView.contentMode = .scaleAspectFill
        
        self.nameLab.font = UIFont.systemFont(ofSize: 15)
        
        self.messageLab.font = self.nameLab.font
        self.messageLab.textColor = UIColor.init(hex: "#666666")
        
        self.priceLab.font = UIFont.systemFont(ofSize: 16)
        self.priceLab.textAlignment = .right
        
        self.numberLab.font = UIFont.systemFont(ofSize: 13)
        self.numberLab.textAlignment = .right
        self.numberLab.isHidden = true
        self.numberLab.textColor = UIColor.init(hex: "#999999")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 有数量的布局
    func haveNumberUILayout() {
        if !self.numberLab.isHidden {
            return
        }
        
        self.numberLab.isHidden = false
        
        self.priceLab.snp.remakeConstraints { (make) in
            make.top.equalTo(self.nameLab).offset(4)
            make.right.equalTo(-12)
        }
        
        self.numberLab.snp.remakeConstraints { (make) in
            make.top.equalTo(self.priceLab.snp.bottom).offset(4)
            make.left.equalTo(self.priceLab)
        }
        
    }
    
}



