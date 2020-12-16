//
//  AC_XQSelectVarietiesVCHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQSelectVarietiesVCHeaderView: UITableViewHeaderFooterView {
    
    let titleLab = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.contentView.backgroundColor = UIColor.init(hex: "#F4F4F4")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
