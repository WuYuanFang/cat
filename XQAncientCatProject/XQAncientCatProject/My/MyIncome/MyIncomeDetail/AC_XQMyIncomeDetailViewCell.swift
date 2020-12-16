//
//  AC_XQMyIncomeDetailViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMyIncomeDetailViewCell: UITableViewCell {
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    let moneyLab = UILabel()
    
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
        
        self.contentView.xq_addSubviews(self.titleLab, self.messageLab, self.moneyLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(12)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(7)
            make.bottom.equalTo(-12)
        }
        
        self.moneyLab.snp.makeConstraints { (make) in
            make.right.equalTo(-80)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.selectionStyle = .none
        
        self.accessoryType = .disclosureIndicator
        
        self.titleLab.font = UIFont.systemFont(ofSize: 18)
        
        self.messageLab.font = UIFont.systemFont(ofSize: 13)
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        
        self.moneyLab.font = self.titleLab.font
        
        self.titleLab.text = "支付"
        self.messageLab.text = "2019-10-20 22:22:00"
        self.moneyLab.text = "-344"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
