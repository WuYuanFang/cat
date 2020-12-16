//
//  AC_XQScoreOrderListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

/// 积分订单列表(历史记录)
class AC_XQScoreOrderListVC: XQACBaseVC, AC_XQScoreOrderListViewDelegate {
    
    let contentView = AC_XQScoreOrderListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setTitle("兑换记录")
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.delegate = self
        
        self.contentView.collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            self.getData()
        })
        
        self.contentView.collectionView.mj_header?.beginRefreshing()
        
    }
    
    func getData() {
        let reqModel = XQSMNTIntegralProductOrderReqModel.init(OrderState: .all)
        XQSMIntegralNetwork.getUserIntegralProductOrderInfo(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.collectionView.mj_header?.endRefreshing()
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.dataArr = resModel.IntegralProductsOrdersInfo ?? []
            self.contentView.collectionView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.collectionView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - AC_XQScoreOrderListViewDelegate
    
    func scoreOrderListView(_ scoreOrderListView: AC_XQScoreOrderListView, didSelectItemAt indexPath: IndexPath) {
//        let vc = AC_XQScoreOrderDetailVC()
//        vc.fosterModel = self.contentView.dataArr[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击再次购买
    func scoreOrderListView(againBuy scoreOrderListView: AC_XQScoreOrderListView, didSelectItemAt indexPath: IndexPath) {
        
        let reqModel = XQSMNTIntegralGetIntegralProductByIdReqModel.init(pId: self.contentView.dataArr[indexPath.row].PId)
        SVProgressHUD.show(withStatus: nil)
        XQSMIntegralNetwork.getIntegralProductById(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            if let pdItem = resModel.pdItem {
                SVProgressHUD.dismiss()
                let vc = AC_XQScoreMallDetailVC()
                vc.productInfoModel = pdItem
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                SVProgressHUD.showError(withStatus: "获取商品信息失败")
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    

}
