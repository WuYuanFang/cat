//
//  AC_XQMessageListViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMessageListViewCell: AC_XQShadowCell {
    
    /// 公告喇叭
    let iconImgView = UIImageView()
    /// 头像
    let headerImgView = UIImageView()
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    let dateLab = UILabel()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.xq_contentView.xq_addSubviews(self.iconImgView, self.headerImgView, self.titleLab, self.messageLab, self.dateLab)
        
        // 布局
        
        self.iconImgView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        
        let headerImgViewSize: CGFloat = 40
        self.headerImgView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: headerImgViewSize, height: headerImgViewSize))
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(self.iconImgView.snp.right).offset(20)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(10)
            make.right.equalTo(self.dateLab)
            make.bottom.equalTo(-20)
        }
        
        self.dateLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.titleLab)
            make.right.equalTo(-20)
        }
        
        // 设置属性
        
        
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.headerImgView.layer.cornerRadius = headerImgViewSize/2
        self.headerImgView.layer.masksToBounds = true
        self.headerImgView.isHidden = true
        
        self.messageLab.font = UIFont.systemFont(ofSize: 15)
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        
        self.dateLab.font = UIFont.systemFont(ofSize: 14)
        self.dateLab.textColor = UIColor.init(hex: "#999999")
        
        self.iconImgView.image = UIImage.init(named: "loginBtn")
        
        
        self.titleLab.text = "公告提醒（APP公告）"
        self.messageLab.text = "公告提醒公告提醒公告提醒公告提醒公告提asdasdasdasdadasd"
        self.dateLab.text = "今天 13:14"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
