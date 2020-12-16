//
//  AC_XQSideButton.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool

/// 侧边的 button
class AC_XQSideButtonView: UIView {
    
    private let backView = UIView()
    private let contentView = UIView()
    private let imgView = UIImageView()
    
    let titleLab = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.backView, self.contentView)
        self.contentView.xq_addSubviews(self.titleLab, self.imgView)
        
        // 布局
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
        }
        
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }
        
        
        // 设置属性
        self.layer.shadowOffset = CGSize.init(width: -4, height: 8)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowColor = UIColor.ac_mainColor.cgColor
        
        self.backView.backgroundColor = UIColor.ac_mainColor
        
        self.titleLab.textColor = UIColor.white
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.imgView.isHidden = true
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backView.xq_corners_addRoundedCorners([.topLeft, .bottomLeft], withRadii: CGSize.init(width: self.frame.height/2, height: self.frame.height/2))
    }
    
    func setImg(_ img: UIImage?) {
        self.imgView.isHidden = false
        self.imgView.image = img
        
        self.titleLab.snp.remakeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(12)
            make.top.bottom.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        self.imgView.snp.remakeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(25)
        }
        
    }
    
    
}
