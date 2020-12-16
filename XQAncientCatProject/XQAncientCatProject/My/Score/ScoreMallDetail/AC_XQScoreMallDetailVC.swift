//
//  AC_XQScoreMallDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 积分商品详情
class AC_XQScoreMallDetailVC: XQACBaseVC {

    let contentView = AC_XQScoreMallDetailView()
    
    var productInfoModel: XQSMNTIntegralIntegralProductInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.payView.sideButton.xq_addTap { [unowned self] (gestrue) in
            let vc = AC_XQScoreOrderVC()
            vc.productInfoModel = self.productInfoModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if let productInfoModel = self.productInfoModel {
            self.contentView.headerView.titleLab.text = productInfoModel.ShopName
            self.contentView.headerView.moneyView.moneyLab.text = String(productInfoModel.ShopPrice)
            self.contentView.detailView.webView.loadHTMLString(productInfoModel.Description, baseURL: nil)
            
            if let url = productInfoModel.ShowImgWithAddress.sm_getImgUrl() {
                self.contentView.headerView.cycleScrollView.imageURLStringsGroup = [
                    url
                ]
                
                self.contentView.payView.priceLab.text = "\(productInfoModel.ShopPrice)积分"
            }
            
        }
        
    }
    


}
