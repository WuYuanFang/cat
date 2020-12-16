//
//  XQWaterfallCollectionImageViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQWaterfallCollectionImageViewCell: UICollectionViewCell {
    
    
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imgView)
        
        // 布局
        
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        // 设置属性
        self.imgView.layer.shadowColor = UIColor.black.cgColor
//        self.imgView.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.imgView.layer.shadowOpacity = 0.15
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
