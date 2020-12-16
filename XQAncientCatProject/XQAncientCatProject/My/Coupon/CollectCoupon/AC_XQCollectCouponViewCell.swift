//
//  AC_XQCollectCouponViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProgressRoundView

class AC_XQCollectCouponViewCell: AC_XQShadowCell {

    
    
    let typeView = AC_XQCouponTypeView()
    
    /// 钱或打折
    let moneyView = AC_XQMoneyView.init(frame: .zero)
    
    let dateLab = UILabel()
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    /// 已抢
    let alreadyBuyLab = UILabel()
    /// 立即领取
    let nowBuyBtn = UIButton()
    let roundView = XQProgressLabelView()
    
    /// 抢光了
    let outOfStockImgView = UIImageView()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.xq_contentView.xq_addSubviews(self.typeView, self.moneyView, self.dateLab, self.titleLab, self.messageLab, self.roundView, self.nowBuyBtn, self.alreadyBuyLab, self.outOfStockImgView)
        
        
        // 布局
        
        self.typeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(5)
        }
        
        self.moneyView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
        }
        
        self.dateLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.moneyView)
            make.bottom.equalTo(-16)
            make.right.equalTo(self.nowBuyBtn.snp.left).offset(-5)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.moneyView.snp.right).offset(25)
            make.top.equalTo(20)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(8)
        }
        
        self.roundView.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.top.equalTo(16)
            make.size.equalTo(55)
        }
        
        self.alreadyBuyLab.snp.makeConstraints { (make) in
            make.center.equalTo(self.roundView)
        }
        
        self.nowBuyBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.roundView)
            make.top.equalTo(self.roundView.snp.bottom).offset(-6)
            make.size.equalTo(CGSize.init(width: 56, height: 20))
        }
        
        self.outOfStockImgView.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 58, height: 51))
        }
        
        
        
        
        // 设置属性
        
        self.xq_contentView.layer.cornerRadius = 0
        self.xq_contentView.layer.masksToBounds = false
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 12)
        
        self.dateLab.textColor = UIColor.init(hex: "#999999")
        self.dateLab.font = UIFont.systemFont(ofSize: 11)
        
        self.moneyView.moneyLab.textColor = UIColor.ac_mainColor
        self.moneyView.symbolLab.textColor = UIColor.ac_mainColor
        
        
        self.alreadyBuyLab.numberOfLines = 0
        self.alreadyBuyLab.text = "已抢\n50%"
        self.alreadyBuyLab.textColor = UIColor.ac_mainColor
        self.alreadyBuyLab.font = UIFont.systemFont(ofSize: 11)
        self.alreadyBuyLab.textAlignment = .center
        
        self.nowBuyBtn.setTitle("立即领取", for: .normal)
        self.nowBuyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        self.nowBuyBtn.backgroundColor = UIColor.ac_mainColor
        self.nowBuyBtn.layer.cornerRadius = 20/2
        
        self.roundView.roundView.isHidden = true
        self.roundView.lineWidth = 4
        self.roundView.minLab.isHidden = true
        self.roundView.maxLab.isHidden = true
        self.roundView.lineBackColor = UIColor.init(hex: "#F4F4F4")
        self.roundView.lineColorArr = [UIColor.ac_mainColor.cgColor, UIColor.ac_mainColor.cgColor]
        self.roundView.centerBtn.setImage(nil, for: .normal)
        self.roundView.centerBtn.setImage(nil, for: .selected)
        self.roundView.backImgView.image = nil
        
        self.outOfStockImgView.isHidden = true
        self.outOfStockImgView.image = UIImage.init(named: "coupon_sellOut")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class AC_XQCollectCouponViewCellSellOut: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


