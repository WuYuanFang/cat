//
//  XQAlertSelectAddressViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/26.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQAlertSelectLevelViewCell: UITableViewCell {
    
    let titleLab = UILabel()
    let imgView = UIImageView()
    

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
        
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.imgView)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLab.snp.right).offset(30)
            make.size.equalTo(15)
        }
        
        // 设置属性
        
        self.selectionStyle = .none
        
        
        self.imgView.image = UIImage.init(named: "tick")
        self.imgView.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
