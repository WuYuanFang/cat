//
//  AC_XQOrderListChildrenVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import XQAlert

class AC_XQOrderListChildrenVC: XQACBaseVC, AC_XQOrderListChildrenViewDelegate {
    
    let contentView = AC_XQOrderListChildrenView()
    
    /// 状态
    var state: XQSMNTGetOrderListReqModelState = .all
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.isHidden = true
        self.xq_view.isHidden = true

        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.delegate = self
        
        self.contentView.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            self.getData()
        })
        
        self.contentView.tableView.mj_header?.beginRefreshing()
        
    }
    
    func getData() {
        let reqModel = XQSMNTGetOrderListReqModel.init(State: self.state)
        XQSMOrderNetwork.getMyOrder(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            
            self.contentView.dataArr = resModel.OrderList ?? []
            self.contentView.tableView.reloadData()
            
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.tableView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - AC_XQOrderListChildrenViewDelegate
    
    /// 查看物流
    func orderListChildrenView(viewLogistics orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath) {
//        let vc = XQSMOrderLogisticsVC()
        let vc = AC_XQOrderLogisticsVC()
        vc.orderBIModel = self.contentView.dataArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 去支付
    func orderListChildrenView(pay orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.contentView.dataArr[indexPath.row]
        
        AC_XQAlertSelectPayView.show(String(model.Oid), money: model.SurplusMoney, payType: .shopMall, callback: { (payId, payType) in
            print("支付成功: ", payType)
            self.contentView.tableView.mj_header?.beginRefreshing()
        }) {
            print("隐藏了")
        }
        
//        let vc = AC_XQShopMallOrderDetailVC()
//        vc.orderBaseInfoModel = self.contentView.dataArr[indexPath.row]
//        vc.refreshCallback = { [unowned self] in
//            self.getData()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 确认收货
    func orderListChildrenView(sureReceiveProduct orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath) {
        XQSystemAlert.alert(withTitle: "是否已收到商品?", message: nil, contentArr: ["确认"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            let model = self.contentView.dataArr[indexPath.row]
            let reqModel = XQSMNTSureReceiveProductReqModel.init(orderId: model.Oid)
            SVProgressHUD.show(withStatus: nil)
            XQSMOrderNetwork.sureReceiveProduct(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                self.contentView.dataArr[indexPath.row].OrderState = .receivedGoods
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
    
    /// 点击 cell
    func orderListChildrenView(_ orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath) {
        let vc = AC_XQShopMallOrderDetailVC()
        vc.orderBaseInfoModel = self.contentView.dataArr[indexPath.row]
        vc.refreshCallback = { [unowned self] in
            self.getData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 退款
    func orderListChildrenView(refundOrder orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath) {
        let vc = AC_XQShopRefundOrderVC()
        vc.orderBaseInfoModel = self.contentView.dataArr[indexPath.row]
        vc.refreshCallback = { [unowned self] in
            self.getData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 评价
    func orderListChildrenView(review orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath) {
        let vc = AC_XQReviewVC()
        vc.orderBaseInfoModel = self.contentView.dataArr[indexPath.row]
        vc.refreshCallback = { [unowned self] in
            self.getData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 删除
    func orderListChildrenView(delete orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.contentView.dataArr[indexPath.row]
        XQSystemAlert.alert(withTitle: "删除订单", message: "确定要删除订单吗?", contentArr: ["删除"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            XQSMOrderNetwork.deleteOrder(model.Oid).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                self.contentView.dataArr.remove(at: indexPath.row)
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
    
}
