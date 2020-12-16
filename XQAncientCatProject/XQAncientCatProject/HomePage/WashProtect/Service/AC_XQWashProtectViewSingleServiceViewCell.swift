//
//  AC_XQWashProtectViewSingleServiceViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQWashProtectViewSingleServiceViewCell: AC_XQShadowCollectionViewCell {
    
    private var _xq_isSelected: Bool = false
    /// 是否选中
    var xq_isSelected: Bool {
        set {
            _xq_isSelected = newValue
            if _xq_isSelected {
                self.xq_contentView.layer.borderColor = UIColor.ac_mainColor.cgColor
            }else {
                self.xq_contentView.layer.borderColor = UIColor.init(hex: "#CDD6D9").cgColor
            }
            
            self.roundView.isHidden = !_xq_isSelected
        }
        get {
            return _xq_isSelected
        }
    }
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    let priceLab = UILabel()
    /// 右上角圆形点
    let roundView = UILabel()
    
    /// 右下角跳转按钮
    let pushBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView, self.titleLab, self.priceLab, self.pushBtn, self.roundView)
        
        // 布局
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(35)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(7)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.pushBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceLab.snp.bottom).offset(-5)
            make.right.equalTo(-10)
            make.bottom.equalTo(-6)
            make.size.equalTo(20)
        }
        
        self.roundView.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.top.equalTo(10)
            make.size.equalTo(6)
        }
        
        // 设置属性
        self.roundView.backgroundColor = UIColor.ac_mainColor
        self.roundView.layer.cornerRadius = 3
        self.roundView.layer.masksToBounds = true
        
        self.titleLab.font = UIFont.systemFont(ofSize: 13)
        self.titleLab.textColor = UIColor.init(hex: "#999999")
        self.titleLab.textAlignment = .center
        
        self.priceLab.font = UIFont.systemFont(ofSize: 13)
        self.priceLab.textAlignment = .center
        
        self.pushBtn.setBackgroundImage(UIImage.init(named: "arrow_push_mainColor"), for: .normal)
        
        self.xq_contentView.layer.borderWidth = 1
        self.xq_isSelected = false
        
        self.titleLab.text = "高级美容"
        self.priceLab.text = "¥88"
//        self.imgView.image = UIImage.init(named: "arrow_push_mainColor")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
