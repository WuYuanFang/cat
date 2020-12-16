//
//  AC_XQThirdPartyAuthorizationVCCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/22.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQThirdPartyAuthorizationVCCell: UITableViewCell {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    
    let messageLab = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.imgView, self.titleLab, self.messageLab)
        
        // 布局
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.messageLab.textAlignment = .right
        self.messageLab.textColor = UIColor.init(hex: "#666666")
        self.messageLab.text = "未绑定"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
