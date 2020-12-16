//
//  AC_XQMallNaviCell.swift
//  XQAncientCatProject
//
//  Created by sinking on 2020/1/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMallNaviCell: UITableViewCell {
    
    let titleLab = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            self.titleLab.textColor = UIColor.init(hex: "#282626")
            self.contentView.backgroundColor = UIColor.white
        }else {
            self.titleLab.textColor = UIColor.init(hex: "#B2B2B2")
            self.contentView.backgroundColor = UIColor.init(hex: "#F7F7F7")
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.right.left.equalToSuperview()
        }
        
        // 设置属性
        self.titleLab.textAlignment = .center
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        self.titleLab.textColor = UIColor.init(hex: "#B2B2B2")
        self.contentView.backgroundColor = UIColor.init(hex: "#F7F7F7")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
