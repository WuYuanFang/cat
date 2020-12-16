//
//  AC_XQSignInViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/24.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQSignInViewCell: UICollectionViewCell {
    
    private var _xq_select: Bool = false
    /// 是否选中
    var xq_select: Bool {
        set {
            _xq_select = newValue
            
            if _xq_select {
                self.bottomLab.textColor = UIColor.white
                
                self.bottomView.backgroundColor = UIColor.init(xq_rgbWithR: 241, g: 241, b: 241)
                self.bottomContentView.backgroundColor = UIColor.init(hex: "#648C8F")
                
            }else {
                self.bottomLab.textColor = UIColor.ac_mainColor
                
                self.bottomView.backgroundColor = UIColor.clear
                self.bottomContentView.backgroundColor = UIColor.clear
            }
            
        }
        get {
            return _xq_select
        }
    }
    
    let topLab = UILabel()
    
    private let bottomView = UIView()
    private let bottomContentView = UIView()
    let bottomLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.topLab, self.bottomView)
        self.bottomView.addSubview(self.bottomContentView)
        self.bottomContentView.addSubview(self.bottomLab)
        
        // 布局
        self.topLab.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(2)
            make.right.equalTo(-2)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.bottomView.snp.width)
        }
        
        self.bottomContentView.snp.makeConstraints { (make) in
            make.top.left.equalTo(3)
            make.right.bottom.equalTo(-3)
        }
        
        self.bottomLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // 设置属性
        self.topLab.textColor = UIColor.ac_mainColor
        self.topLab.font = UIFont.systemFont(ofSize: 11)
        self.topLab.textAlignment = .center
        
        self.bottomView.backgroundColor = UIColor.init(xq_rgbWithR: 241, g: 241, b: 241)
        self.bottomContentView.backgroundColor = UIColor.init(hex: "#648C8F")
        
        self.bottomLab.textColor = UIColor.ac_mainColor
        self.bottomLab.font = UIFont.systemFont(ofSize: 11)
        self.bottomLab.textAlignment = .center
        
        self.xq_select = false
        // 这里要调用一下, 不然 layoutSubviews 没有 frame
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bottomView.layer.cornerRadius = self.bottomView.frame.width/2
        self.bottomContentView.layer.cornerRadius = self.bottomContentView.frame.width/2
        
    }
    
}
