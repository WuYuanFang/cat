//
//  XQACNavigationBarBackView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit

class XQACNavigationBarBackView: UIView {
    
    /// 默认返回的img
    private let imgView = UIImageView.init()
    /// 默认返回的title
    let titleLab = UILabel.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        
        // 设置属性
        
        self.titleLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 20)
        
        self.setBackImg(with: nil)
    }
    
    func setBackImg(with img: UIImage?) {
        self.imgView.image = img
        
        if let _ = img {
            
            self.imgView.isHidden = false
            
            self.imgView.snp.remakeConstraints { (make) in
                make.left.equalTo(self)
                make.centerY.equalTo(self)
                make.size.equalTo(CGSize.init(width: 20, height: 20))
            }
            
            self.titleLab.snp.remakeConstraints { (make) in
                make.left.equalTo(self.imgView.snp.right).offset(8)
                make.top.bottom.equalTo(self)
                make.right.equalTo(self)
            }
            
        }else {
            self.imgView.isHidden = true
            self.imgView.snp.remakeConstraints { (make) in
                
            }
            self.titleLab.snp.remakeConstraints { (make) in
                make.left.equalTo(self)
                make.top.bottom.equalTo(self)
                make.right.equalTo(self)
            }
        }
    }
    
    func setTitle(with title: String?) {
        self.titleLab.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
