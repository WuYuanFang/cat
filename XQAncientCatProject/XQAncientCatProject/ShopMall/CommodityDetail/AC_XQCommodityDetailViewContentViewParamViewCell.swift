//
//  AC_XQCommodityDetailViewContentViewParamViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQCommodityDetailViewContentViewParamViewCell: UITableViewCell {

    let titleLab = UILabel()
    private let lineLab = UILabel()
    let paramLab = UILabel()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.titleLab, self.lineLab, self.paramLab)
        
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        self.paramLab.snp.makeConstraints { (make) in
//            make.right.equalTo(-30)
            make.left.equalTo(self.lineLab.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        self.lineLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.selectionStyle = .none
        
        self.titleLab.textColor = UIColor.init(hex: "#666666")
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        
        self.paramLab.textColor = UIColor.init(hex: "#666666")
        self.paramLab.font = UIFont.systemFont(ofSize: 14)
        
        self.lineLab.text = "--------------------------"
        self.lineLab.textColor = UIColor.init(hex: "#666666")
        
        
        self.titleLab.text = "标题"
        self.paramLab.text = "参数信息"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
