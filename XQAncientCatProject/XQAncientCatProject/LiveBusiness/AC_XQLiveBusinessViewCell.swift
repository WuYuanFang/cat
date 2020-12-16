//
//  AC_XQLiveBusinessViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLiveBusinessViewCell: AC_XQShadowCollectionViewCell {
    
    let imgView = UIImageView()
    
    
    let nameLab = UILabel()
    let ageLab = UILabel()
    let genderImgView = UIImageView()
    let characterLab = UILabel()
    
    let priceLab = UILabel()
    let originPriceLab = UILabel()
    let addressLab = UILabel()
    
    let shopCarBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView)
        
        self.contentView.xq_addSubviews(self.nameLab, self.ageLab, self.genderImgView, self.characterLab, self.priceLab, self.originPriceLab, self.addressLab, self.shopCarBtn)
        
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
            make.left.equalTo(self.xq_contentView)
        }
        
        self.ageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLab.snp.right).offset(8)
            make.centerY.equalTo(self.nameLab)
        }
        
        self.genderImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.ageLab.snp.right).offset(8)
            make.centerY.equalTo(self.ageLab)
            make.size.equalTo(14)
        }
        
        self.characterLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.xq_contentView)
            make.top.equalTo(self.nameLab.snp.bottom).offset(10)
            make.right.equalTo(self.xq_contentView)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.xq_contentView)
            make.bottom.equalTo(self.shopCarBtn.snp.top).offset(-16)
            // 暂时不写中间的标签
//            make.top.equalTo(self.characterLab.snp.bottom).offset(35)
        }
        
        self.originPriceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.priceLab.snp.right).offset(5)
            make.bottom.equalTo(self.priceLab)
        }
        
        
        self.shopCarBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.xq_contentView)
            make.bottom.equalTo(-12)
            make.size.equalTo(20)
        }
        
        self.addressLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.xq_contentView)
            make.bottom.equalTo(self.priceLab)
        }
        
        
        
        // 设置属性
        
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        self.genderImgView.backgroundColor = UIColor.orange
        
        self.nameLab.textColor = UIColor.black
        self.nameLab.font = UIFont.systemFont(ofSize: 16)
        
        self.ageLab.textColor = UIColor.black
        self.ageLab.font = UIFont.systemFont(ofSize: 16)
        
        self.characterLab.textColor = UIColor.init(hex: "#999999")
        self.characterLab.font = UIFont.systemFont(ofSize: 14)
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.systemFont(ofSize: 16)
        
        self.originPriceLab.textColor = UIColor.init(hex: "#999999")
        self.originPriceLab.font = UIFont.systemFont(ofSize: 13)
        
        self.addressLab.textColor = UIColor.init(hex: "#999999")
        self.addressLab.font = UIFont.systemFont(ofSize: 14)
        
//        self.shopCarBtn.setBackgroundImage(UIImage.init(named: ""), for: <#T##UIControl.State#>)
        self.shopCarBtn.backgroundColor = UIColor.ac_mainColor
        
        
        self.nameLab.text = "布偶猫"
        self.ageLab.text = "3个月"
        self.characterLab.text = "纯正英国血统,温顺乖巧聪明"
        
        
        self.priceLab.text = "¥ 546"
        self.originPriceLab.text = "¥ 600"
        self.addressLab.text = "上海"
        
        
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
        
        let height = CGFloat(imgHeight + (12 + 16) + (12 + 16) + (6 + 16) + (12 + 16) + (16 + 20 + 12))
        
        return CGSize.init(width: width, height: height)
    }
    
    
}
