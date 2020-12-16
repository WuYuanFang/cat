//
//  AC_XQMallSearchResultViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMallSearchResultViewCell: UICollectionViewCell {
    
    let titleLab = UILabel()
    let bottomLab = UILabel()
    
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.bottomLab)
        
        
        // 布局
        self.titleLab.snp.contentHuggingVerticalPriority = UILayoutPriority.required.rawValue
        self.titleLab.snp.contentCompressionResistanceVerticalPriority = UILayoutPriority.required.rawValue
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.bottomLab.snp.top)
        }
        
        self.bottomLab.snp.contentHuggingVerticalPriority = UILayoutPriority.required.rawValue
        self.bottomLab.snp.contentCompressionResistanceVerticalPriority = UILayoutPriority.required.rawValue
        self.bottomLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        
        
        // 设置属性
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 30)
        
        self.imgView.layer.shadowColor = UIColor.black.cgColor
        self.imgView.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.imgView.layer.shadowOpacity = 0.15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
