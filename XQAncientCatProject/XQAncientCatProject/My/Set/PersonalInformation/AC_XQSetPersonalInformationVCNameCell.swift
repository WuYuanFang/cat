//
//  AC_XQSetPersonalInformationVCNameCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQSetPersonalInformationVCNameCell: UITableViewCell {

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
        
        self.contentView.xq_addSubviews(self.titleLab, self.messageLab)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.selectionStyle = .none
        
        self.messageLab.textAlignment = .right
        self.messageLab.textColor = UIColor.init(hex: "#666666")
        self.messageLab.text = ""
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
