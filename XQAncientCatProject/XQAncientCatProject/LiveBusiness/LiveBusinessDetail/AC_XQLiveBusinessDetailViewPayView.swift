//
//  AC_XQLiveBusinessDetailViewPayView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool
import QMUIKit

class AC_XQLiveBusinessDetailViewPayView: UIView {
    
    
    let backView = UIView()
    
    let sideButton = AC_XQSideButtonView()
    
    let priceDesLab = UILabel()
    let priceLab = UILabel()
    
    let customServerBtn = QMUIButton()
    let shopCarBtn = QMUIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.backView, self.sideButton, self.priceLab, self.priceDesLab, self.customServerBtn, self.shopCarBtn)
        
        // 布局
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.sideButton.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
        
        self.customServerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        self.shopCarBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.customServerBtn.snp.right).offset(8)
            make.centerY.equalTo(self.customServerBtn)
//            make.width.equalTo(60)
//            make.height.equalTo(40)
        }
        
        self.priceDesLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.shopCarBtn.snp.right).offset(10)
            make.centerY.equalTo(self.customServerBtn)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.priceDesLab.snp.right)
            make.centerY.equalTo(self.customServerBtn)
        }
        
        
        // 设置属性
        self.backView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        self.sideButton.titleLab.text = "购买"
        
        self.configBtn(self.customServerBtn, img: "contact", title: "客服")
        self.configBtn(self.shopCarBtn, img: "shopCar", title: "加入购物车")
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.priceDesLab.text = "合计"
        self.priceDesLab.font = UIFont.systemFont(ofSize: 14)
        
        self.priceLab.text = "¥1727"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backView.xq_corners_addRoundedCorners([.topLeft, .topRight], withRadii: CGSize.init(width: 50, height: 50))
    }
    
    
    func configBtn(_ btn: QMUIButton, img: String, title: String) {
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        btn.setImage(UIImage.init(named: img), for: .normal)
        btn.imagePosition = .top
        btn.spacingBetweenImageAndTitle = 5
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }
}
