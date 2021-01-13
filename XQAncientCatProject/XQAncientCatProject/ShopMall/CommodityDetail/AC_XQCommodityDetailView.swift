//
//  AC_XQCommodityDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import XQProjectTool_iPhoneUI

class AC_XQCommodityDetailView: UIView {

    let scrollView = UIScrollView()
    
    let payView = AC_XQCommodityDetailViewPayView()
    
    let headerView = AC_XQCommodityDetailViewHeaderView()
    let contentView = AC_XQCommodityDetailViewContentView()
    
    private var _productInfoModel: XQSMNTProductInfoModel?
    /// 获取商品详情
    var productInfoModel: XQSMNTProductInfoModel? {
        set {
            _productInfoModel = newValue
            
            self.reloadProductInfoUI()
            if let productInfoModel = _productInfoModel {
                self.contentView.specView.reloadUI(with: productInfoModel.AttrList ?? [])
            }
        }
        get {
            return _productInfoModel
        }
    }
    
    /// 选择不同规格, 获取到的商品详情
    private var _attrProductInfoModel: XQSMNTProductInfoModel?
    /// 获取商品详情
    var attrProductInfoModel: XQSMNTProductInfoModel? {
        set {
            _productInfoModel = newValue
            _attrProductInfoModel = newValue
            
            self.reloadProductInfoUI()
            
//            if let productInfoModel = _productInfoModel {
//                self.contentView.specView.reloadUI(with: productInfoModel.AttrList ?? [])
//            }
        }
        get {
            return _attrProductInfoModel
        }
    }
    
    private func reloadProductInfoUI() {
        if let productInfoModel = self.productInfoModel {
            var imageURLStringsGroup = [URL]()
            for item in productInfoModel.Imgs ?? [] {
                if let url = item.ShowImgWithAddress.sm_getImgUrl() {
                    imageURLStringsGroup.append(url)
                }
            }
            print(imageURLStringsGroup)
            self.headerView.cycleScrollView.imageURLStringsGroup = imageURLStringsGroup
            
            self.headerView.titleLab.text = productInfoModel.Name
            self.headerView.messageLab.text = productInfoModel.ShortDesc
            
            self.headerView.moneyView.moneyLab.text = "\(productInfoModel.ShopPrice)"
            self.headerView.originMoneyLab.text = "¥\(productInfoModel.MarketPrice)"
            self.headerView.originMoneyLab.xqAtt_setStrikethroughStyle(.single, range: NSRange.init(location: 0, length: self.headerView.originMoneyLab.text?.count ?? 0))
            
            let htmlStr = String(format: "<head><style>img{max-width:%f !important;height:auto}</style></head>%@", SCREEN_WIDTH, productInfoModel.xq_description)
            
            if let data:Data = htmlStr.data(using: .unicode, allowLossyConversion: true) {
                do {
                    let attrStr = try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil)
                    self.contentView.detailView.detailLabel.attributedText = attrStr
                }catch{
                }
            }
            
//            self.contentView.detailView.webView.loadHTMLString(htmlStr, baseURL: nil)
            
            
            self.payView.priceLab.text = "¥\(productInfoModel.ShopPrice * self.contentView.specView.numberView.numberView.currentNumber)"
            
            self.headerView.commentView.numberLab.text = "(\(productInfoModel.ReviewCount))"
            self.headerView.commentView.messageLab.text = "\(productInfoModel.GoodPercent.xq_removeDecimalPointZero())%的人觉得很赞 >"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.scrollView, self.payView)
        self.scrollView.xq_addSubviews(self.headerView, self.contentView)
        
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

        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        // 设置属性
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


