//
//  AC_XQSetPersonalInformationVCCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQSetPersonalInformationVCCell: UITableViewCell {

    let imgView = UIImageView()
    let titleLab = UILabel()

   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.imgView, self.titleLab)
        
        // 布局
        
        self.imgView.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.size.equalTo(40)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(16).offset(12)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.imgView.layer.cornerRadius = 15
        self.imgView.layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
