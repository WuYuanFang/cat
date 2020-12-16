//
//  AC_XQHomePageViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQHomePageViewTableViewHeaderView: UIView {

    private let lineView = UIView()
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    let subtitleLab = UILabel()
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.lineView, self.imgView, self.titleLab, self.subtitleLab, self.contentView)
        
        // 布局
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
//            make.size.equalTo(CGSize.init(width: 4, height: 14))
            make.size.equalTo(CGSize.init(width: 0, height: 14))
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView.snp.right).offset(10.5)
            make.top.equalTo(self.lineView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(6)
            make.bottom.equalTo(self.imgView)
        }
        
        self.subtitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab.snp.right).offset(5)
            make.bottom.equalTo(self.titleLab)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(16)
            make.bottom.left.right.equalToSuperview()
        }
        
        // 设置属性
        
        self.lineView.backgroundColor = UIColor.black
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.subtitleLab.font = UIFont.italicSystemFont(ofSize: 14)
        self.subtitleLab.textColor = UIColor.init(hex: "#999999")
        
//        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        
//        self.subtitleLab.xqatt_
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 纯文字布局
    func plainTextLayout() {
        self.imgView.removeFromSuperview()
        self.lineView.removeFromSuperview()
        
        self.titleLab.snp.remakeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalToSuperview()
        }
        
    }
    

}
