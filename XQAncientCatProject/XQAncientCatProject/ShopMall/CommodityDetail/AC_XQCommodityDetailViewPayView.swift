//
//  AC_XQCommodityDetailViewPayView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

class AC_XQCommodityDetailViewPayView: UIView {
    
    private let backView = UIView()
    
    let sideButton = AC_XQSideButtonView()
    
    let priceDesLab = UILabel()
    let priceLab = UILabel()
    
    let shopCarBtn = QMUIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.backView, self.sideButton, self.priceLab, self.priceDesLab, self.shopCarBtn)
        
        // 布局
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.sideButton.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
        
        self.shopCarBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.sideButton.snp.left).offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        self.priceDesLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.priceDesLab.snp.right)
            make.centerY.equalTo(self.priceDesLab)
        }
        
        
        // 设置属性
        self.backView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        self.sideButton.titleLab.text = "购买"
        
        self.configBtn(self.shopCarBtn, img: "shopCar", title: "")
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.priceDesLab.text = "合计"
        self.priceDesLab.font = UIFont.systemFont(ofSize: 14)
        
        self.priceLab.text = "¥"
//        self.priceLab.text = "¥1727"
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
