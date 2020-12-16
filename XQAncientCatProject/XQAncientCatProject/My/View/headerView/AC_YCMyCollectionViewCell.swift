//
//  AC_YCMyCollectionViewCell.swift
//  XQAncientCatProject
//
//  Created by YCMacMini on 2020/5/31.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_YCMyCollectionViewCell: UICollectionViewCell {
    
    /// Lazy
    
    /// 图片imageView
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    /// 标题label
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12)
        return lb
    }()
    
    /// 副标题
    lazy var detailLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = UIColor.qmui_color(withHexString: "999999")
        lb.font = UIFont.systemFont(ofSize: 11)
        return lb
    }()
    
    /// Life Cycle (生命周期)
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
        addElement()
        layoutElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Config (配置)
    func config() {
        self.backgroundColor = UIColor.qmui_color(withHexString: "F3F3F3")
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
    }
    
    /// Structure （构造）
    func addElement() {
        self.contentView.xq_addSubviews(imageView, titleLabel, detailLabel)
    }
    
    /// 添加布局
    func layoutElement() {
        self.imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(13.5)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(45)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.imageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        self.detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(9.5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16.5)
        }
    }
    
}
