//
//  AC_XQShopMallFilterAlertViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopMallFilterAlertViewCell: UICollectionViewCell {
    
    let titleLab = UILabel()
    
    private var _select = false
    var select: Bool {
        set {
            _select = newValue
            
            if self.select {
                self.titleLab.layer.borderWidth = 1
            }else {
                self.titleLab.layer.borderWidth = 0
            }
        }
        get {
            return _select
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        self.titleLab.textAlignment = .center
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        self.titleLab.layer.cornerRadius = 4
        self.titleLab.backgroundColor = UIColor.init(hex: "#F3F3F3")
        self.titleLab.layer.borderColor = UIColor.ac_mainColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
