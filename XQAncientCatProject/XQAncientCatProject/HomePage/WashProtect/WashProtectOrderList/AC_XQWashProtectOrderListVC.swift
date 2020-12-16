//
//  AC_XQWashProtectOrderListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import XQAlert

/// 预约, 洗护订单列表
class AC_XQWashProtectOrderListVC: XQACBaseVC, AC_XQWashProtectOrderListViewDelegate {
    
    let contentView = AC_XQWashProtectOrderListView()

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
    
    /// 获取预约数据
    func getData() {
        
        let reqModel = XQSMNTToShopOrderReqModel.init(State: .all)
        XQSMToShopOrderNetwork.getMyToOrder(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.dataArr = resModel.ToOrderList ?? []
            
//            #if DEBUG
//            var arr = [XQSMNTTinnyToOrderInfoModel]()
//            for item in resModel.ToOrderList ?? [] {
//                var sitem = item
//                sitem.CanRefund = true
//                sitem.State = .reserved
//                arr.append(sitem)
//            }
//            self.contentView.dataArr = arr
//            #endif
            
            self.contentView.tableView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.tableView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
        
        
    }
    
    // MARK: - AC_XQWashProtectOrderListViewDelegate
    
    /// 去支付
    func washProtectOrderListView(pay washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.contentView.dataArr[indexPath.row]
        AC_XQAlertSelectPayView.show(String(model.Id), money: model.TotalPrice, payType: .appointment, callback: { (payId, payType) in
            print("支付成功: ", payType)
            self.contentView.tableView.mj_header?.beginRefreshing()
        }) {
            print("隐藏了")
        }
        
//        let vc = AC_XQWashProtectOrderDetailVC()
//        vc.fosterModel = self.contentView.dataArr[indexPath.row]
//        vc.refreshCallback = { [unowned self] in
//            self.getData()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 退款
    func washProtectOrderListView(refund washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath) {
        XQSystemAlert.alert(withTitle: "退款", message: "确认是否要退款", contentArr: ["确定"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            let model = self.contentView.dataArr[indexPath.row]
            let reqModel = XQSMNTOrderRefundToOrderReqModel.init(OId: model.Id, RefundPrice: model.TotalPrice, Remark: "", imgArr: nil)
            SVProgressHUD.show(withStatus: nil)
            XQSMToShopOrderNetwork.refundToOrder(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.isProgress {
                    return
                }
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                self.contentView.dataArr[indexPath.row].StateDesc = "退款中"
                self.contentView.dataArr[indexPath.row].State = .refundInProgress
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
    }
    
    /// 取消订单
    func washProtectOrderListView(cancel washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath) {
        XQSystemAlert.alert(withTitle: "确定取消该订单吗?", message: nil, contentArr: ["确定"], cancelText: "再看看", vc: self, contentCallback: { (alert, index) in
            
            let model = self.contentView.dataArr[indexPath.row]
            
            let reqModel = XQSMNTCancleToOrderReqModel.init(oId: model.Id)
            SVProgressHUD.show(withStatus: nil)
            XQSMToShopOrderNetwork.cancleToOrder(reqModel).subscribe(onNext: { (resModel) in
                
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                self.contentView.dataArr[indexPath.row].StateDesc = "已取消"
                self.contentView.dataArr[indexPath.row].State = .cancel
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
    }
    
    /// 点击 cell
    func washProtectOrderListView(_ washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath) {
        let vc = AC_XQWashProtectOrderDetailVC()
        vc.fosterModel = self.contentView.dataArr[indexPath.row]
        vc.refreshCallback = { [unowned self] in
            self.getData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /// 删除
    func washProtectOrderListView(delete washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath) {
        let model = self.contentView.dataArr[indexPath.row]
        XQSystemAlert.alert(withTitle: "删除订单", message: "确定要删除订单吗?", contentArr: ["删除"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            let reqModel = XQSMNTToShopOrderDeleteOrderReqModel.init(oId: model.Id)
            
            SVProgressHUD.show(withStatus: nil)
            XQSMToShopOrderNetwork.deleteOrder(reqModel).subscribe(onNext: { (resModel) in
                
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
