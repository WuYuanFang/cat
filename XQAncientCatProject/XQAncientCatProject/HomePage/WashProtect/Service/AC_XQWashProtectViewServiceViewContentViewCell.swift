//
//  AC_XQWashProtectViewServiceViewContentViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQWashProtectViewServiceViewContentViewCell: AC_XQShadowCollectionViewCell {
    
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
    let messageLab = UILabel()
    let priceLab = UILabel()
    
    /// 右上角圆形点
    let roundView = UILabel()
    
    /// 右下角跳转按钮
    let pushBtn = UIButton()
    private let pushImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView, self.titleLab, self.messageLab, self.pushBtn, self.priceLab, self.roundView)
        self.pushBtn.addSubview(self.pushImgView)
        
        // 布局
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(3)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(6)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageLab.snp.bottom).offset(10)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        let pushBtnSize: CGFloat = 15
        self.pushBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceLab.snp.bottom).offset(-4)
            make.right.equalTo(-10)
            make.bottom.equalTo(-6)
            make.size.equalTo(pushBtnSize)
        }
        
        self.pushImgView.snp.makeConstraints { (make) in
            make.top.left.equalTo(3)
            make.right.bottom.equalTo(-3)
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
        
        self.imgView.image = UIImage.init(named: "washProtect_package")
        
        self.titleLab.font = UIFont.systemFont(ofSize: 13)
        self.titleLab.textColor = UIColor.ac_mainColor
        self.titleLab.textAlignment = .center
        
        self.messageLab.font = UIFont.systemFont(ofSize: 13)
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.textAlignment = .center
        
        self.priceLab.font = UIFont.systemFont(ofSize: 13)
        self.priceLab.textAlignment = .center
//        self.messageLab.numberOfLines = 0
        
        self.pushBtn.layer.cornerRadius = pushBtnSize/2
        self.pushBtn.layer.borderWidth = 1
        self.pushBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        self.pushImgView.image = UIImage.init(named: "arrow_right_mainColor_o")
        
        self.xq_contentView.layer.borderWidth = 1
        self.xq_isSelected = false
        
        self.titleLab.text = "A"
        self.messageLab.text = "参数参数参数参数参数参数参数参数参数参数"
        self.priceLab.text = "¥88"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
