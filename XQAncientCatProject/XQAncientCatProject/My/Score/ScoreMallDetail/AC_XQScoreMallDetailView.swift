//
//  AC_XQScoreMallDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SDCycleScrollView

class AC_XQScoreMallDetailView: UIView {
    
    let scrollView = UIScrollView()
    let payView = AC_XQCommodityDetailViewPayView()
    let headerView = AC_XQScoreMallDetailViewHeaderView()
    
    /// 产品详情
    let detailView = XQAutoHeightWebView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.scrollView, self.payView)
        self.scrollView.xq_addSubviews(self.headerView, self.detailView)
        
        // 布局
        
        self.scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.payView.snp.top)
        }
        
        self.payView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(95)
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.right.top.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { (make) in
            //            make.top.equalTo(self.scrollView.snp.top).offset(-XQIOSDevice.getStatusHeight())
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        self.detailView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        // 设置属性
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.payView.shopCarBtn.isHidden = true
        self.payView.sideButton.titleLab.text = "兑换"
        
        #if DEBUG
//        if let url = URL.init(string: "https://cn.bing.com") {
//        if let url = URL.init(string: "https://www.baidu.com") {
//            self.detailView.webView.load(URLRequest.init(url: url))
//        }
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class AC_XQScoreMallDetailViewHeaderView: UIView {
    
    let cycleScrollView = SDCycleScrollView()
    
    let titleLab = UILabel()
    
    let moneyView = AC_XQMoneyView.init(frame: .zero, symbolToMoneySpacing: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.cycleScrollView, self.titleLab, self.moneyView)
        
        // 布局
        
        self.cycleScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.cycleScrollView.snp.width).multipliedBy(391.0/375.0)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.cycleScrollView.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.right.equalTo(self.moneyView.snp.left).offset(-5)
            make.bottom.equalTo(-12)
        }
        
        self.moneyView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(-30)
        }
        
        // 设置属性
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.moneyView.moneyLab.font = UIFont.boldSystemFont(ofSize: 18)
        self.moneyView.setSymbolFont(UIFont.systemFont(ofSize: 14))
        self.moneyView.moneyLab.textColor = UIColor.ac_mainColor
        self.moneyView.symbolLab.textColor = UIColor.ac_mainColor
        
        self.titleLab.text = "小古猫宠物店(营业中）"
        
        self.moneyView.direction = .right
        self.moneyView.moneyLab.text = "727"
        self.moneyView.symbolLab.text = "积分"
        
        self.cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cycleScrollView.setBottomCorner(with: 90, height: 30)
    }
    
}
