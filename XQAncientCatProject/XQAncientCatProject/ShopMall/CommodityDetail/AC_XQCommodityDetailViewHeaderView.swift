//
//  AC_XQCommodityDetailViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import SDCycleScrollView

class AC_XQCommodityDetailViewHeaderView: UIView {

    let cycleScrollView = SDCycleScrollView()
    
    let titleLab = UILabel()
    
    let moneyView = AC_XQMoneyView.init(frame: .zero, symbolToMoneySpacing: 0)
    let originMoneyLab = UILabel()
    
    let messageLab = UILabel()
    
    let commentView = AC_XQCommodityDetailViewHeaderViewCommentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.cycleScrollView, self.titleLab, self.messageLab, self.originMoneyLab, self.moneyView, self.commentView)
        
        // 布局
        
        self.cycleScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.cycleScrollView.snp.width).multipliedBy(391.0/375.0)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.cycleScrollView.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.right.equalTo(self.moneyView.snp.left).offset(-5)
        }
        
        self.originMoneyLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.originMoneyLab.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.required.rawValue
        self.originMoneyLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(-30)
        }
        
        
        self.moneyView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(self.originMoneyLab.snp.left)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(20)
            make.left.equalTo(self.titleLab)
            make.right.equalTo(self.originMoneyLab)
        }
        
        self.commentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageLab.snp.bottom).offset(12)
            make.left.equalTo(self.titleLab)
            make.right.equalTo(self.originMoneyLab)
            make.height.equalTo(30)
            make.bottom.equalToSuperview()
        }
        
        
        // 设置属性
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 18)
        self.titleLab.numberOfLines = 0
        
        self.moneyView.moneyLab.font = UIFont.boldSystemFont(ofSize: 18)
        self.moneyView.setSymbolFont(UIFont.systemFont(ofSize: 14))
        self.moneyView.moneyLab.textColor = UIColor.ac_mainColor
        self.moneyView.symbolLab.textColor = UIColor.ac_mainColor
        
        self.originMoneyLab.font = UIFont.systemFont(ofSize: 14)
        self.originMoneyLab.textColor = UIColor.init(hex: "#999999")
        
        self.messageLab.numberOfLines = 0
        self.messageLab.font = UIFont.systemFont(ofSize: 14)
        self.messageLab.textColor = UIColor.init(hex: "#666666")
        
        
//        self.titleLab.text = "小古猫宠物店(营业中）"
//        self.messageLab.text = "产品介绍产品介绍产品介绍产品介绍产品介绍产品介绍产品介绍产品介绍产品介"
        
//        self.moneyView.moneyLab.text = "727"
//        self.originMoneyLab.text = "¥999"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cycleScrollView.setBottomCorner(with: 90, height: 30)
    }

}


class AC_XQCommodityDetailViewHeaderViewCommentView: UIView {
    
    let titleLab = UILabel()
    /// 评论数量
    let numberLab = UILabel()
    /// 觉得很赞
    let messageLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.numberLab, self.messageLab)
        
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        
        self.numberLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLab.snp.right)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
        }
        
        // 设置属性
        self.titleLab.text = "商品评价"
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        
        self.numberLab.font = UIFont.systemFont(ofSize: 14)
        self.numberLab.textColor = UIColor.init(hex: "#999999")
        
        self.messageLab.font = UIFont.systemFont(ofSize: 14)
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        
//        self.numberLab.text = "(123)"
//        self.messageLab.text = "93%的人觉得很赞 >"
        
        self.numberLab.text = "()"
        self.messageLab.text = "%的人觉得很赞 >"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



