//
//  AC_XQShopMallViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopMallViewCell: AC_XQShadowCollectionViewCell {
    
    let imgView = UIImageView()
    
    
    let nameLab = UILabel()
    let priceLab = UILabel()
    let shopCarBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView)
        
        self.contentView.xq_addSubviews(self.nameLab, self.priceLab, self.shopCarBtn)
        
        // 布局
        
        // 高宽比
        let scale = AC_XQLiveBusinessViewCell.imgWHScale()
        self.xq_contentView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.xq_contentView.snp.width).multipliedBy(1/scale)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.xq_contentView.snp.bottom).offset(12)
            make.left.right.equalTo(self.xq_contentView)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.xq_contentView)
            make.top.equalTo(self.nameLab.snp.bottom).offset(10)
        }
        
        self.shopCarBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.xq_contentView)
            make.centerY.equalTo(self.priceLab)
            make.size.equalTo(20)
        }
        
        // 设置属性
        
//        self.imgView.backgroundColor = UIColor.ac_mainColor
        self.imgView.contentMode = .scaleAspectFill
        
        self.nameLab.textColor = UIColor.init(hex: "#999999")
        self.nameLab.font = UIFont.systemFont(ofSize: 15)
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.systemFont(ofSize: 15)
                
        self.shopCarBtn.setBackgroundImage(UIImage.init(named: "shopCar_black"), for: .normal)
//        self.shopCarBtn.backgroundColor = UIColor.ac_mainColor
        
        
        self.nameLab.text = "布偶猫"
        
        self.priceLab.text = "¥ 546"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 图片宽高比
    static func imgWHScale() -> CGFloat {
        let scale = CGFloat(162.0 / 133.0)
        
        return scale
    }
    
    /// cell size
    static func xq_cellSize() -> CGSize {
        let imgScale = self.imgWHScale()
        
        let width = (system_screenWidth - 12 * 2 - 18) / 2.0
        
        let imgHeight = width / imgScale
        
        let height = CGFloat(imgHeight + (12 + 16) + (10 + 16) + (10 + 16) + 12)
        
        return CGSize.init(width: width, height: height)
    }
    
    
    
}
