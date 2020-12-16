//
//  AC_YCMyTableViewCell.swift
//  XQAncientCatProject
//
//  Created by YCMacMini on 2020/5/31.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_YCMyTableViewCell: UITableViewCell {
    
    /// Lazy
    
    /// 标题Label
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    /// 副标题Label
    lazy var detailLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textColor = UIColor.qmui_color(withHexString: "999999")
        return lb
    }()
    
    /// 图片imageView
    lazy var pictureImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    /// Life Cycle (生命周期)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        config()
        addElement()
        layoutElement()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Config (配置)
    func config() {
        self.selectionStyle = .none
    }
    
    /// Structure （构造）
    func addElement() {
        self.contentView.xq_addSubviews(titleLabel, detailLabel, pictureImageView)
    }
    
    /// 添加布局
    func layoutElement() {
        self.pictureImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.right.equalToSuperview().offset(-29.5)
            make.width.equalTo(65)
            make.height.equalTo(28)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.pictureImageView)
            make.left.equalToSuperview().offset(26)
        }
        
        self.detailLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.titleLabel)
            make.left.equalTo(self.titleLabel.snp.right).offset(16)
        }
    }
    
}
