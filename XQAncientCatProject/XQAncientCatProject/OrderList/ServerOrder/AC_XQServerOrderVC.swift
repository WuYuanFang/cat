//
//  AC_XQServerOrderVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import XQAlert

/// 寄养订单列表
class AC_XQServerOrderVC: XQACBaseVC, AC_XQServerOrderViewDelegate {
        
    let contentView = AC_XQServerOrderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name.init("RefreshServerList"), object: nil)
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
    
    /// 获取寄养数据
    @objc func getData() {
        let reqModel = XQSMNTBaseReqModel()
        XQACFosterNetwork.fosterList(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.dataArr = resModel.list ?? []
            self.contentView.tableView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.tableView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - AC_XQServerOrderViewDelegate
    
    /// 点击 cell
    func serverOrderView(_ serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.contentView.dataArr[indexPath.row]
        
        if model.State == .fostering {
            let vc = AC_XQServerOrderDetailVC()
            vc.fosterModel = self.contentView.dataArr[indexPath.row]
            vc.refreshCallback = { [unowned self] in
                self.getData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            // 没开始寄养 or 结束了
            let vc = AC_XQFosterOrderDetailVC()
            vc.fosterModel = self.contentView.dataArr[indexPath.row]
            vc.refreshCallback = { [unowned self] in
                self.getData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
//        if (model.State == .orderPlaced && model.PayType == 1) ||
//            model.State == .done ||
//            model.State == .cancel ||
//            model.State == .refundInProgress ||
//            model.State == .successfulRefund ||
//            model.State == .waitingComments {
//            // 没开始寄养 or 结束了
//            let vc = AC_XQFosterOrderDetailVC()
//            vc.fosterModel = self.contentView.dataArr[indexPath.row]
//            vc.refreshCallback = { [unowned self] in
//                self.getData()
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }else {
//
//
//
//        }
    }
    
    /// 去支付
    func serverOrderView(pay serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.contentView.dataArr[indexPath.row]
        AC_XQAlertSelectPayView.show(String(model.Id), money: model.Amount, payType: .foster, callback: { (payId, payType) in
            print("支付成功: ", payType)
            self.contentView.tableView.mj_header?.beginRefreshing()
        }) {
            print("隐藏了")
        }
        
//        let vc = AC_XQFosterOrderDetailVC()
//        vc.fosterModel = self.contentView.dataArr[indexPath.row]
//        vc.refreshCallback = { [unowned self] in
//            self.getData()
//        }
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 取消订单
    func serverOrderView(cancel serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath) {
        XQSystemAlert.alert(withTitle: "确定取消该订单吗?", message: nil, contentArr: ["确定"], cancelText: "再看看", vc: self, contentCallback: { (alert, index) in
            
            let model = self.contentView.dataArr[indexPath.row]
            
            SVProgressHUD.show(withStatus: nil)
            XQACFosterNetwork.fosteState(model.Id).subscribe(onNext: { (resModel) in
                
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                self.contentView.dataArr[indexPath.row].State = .cancel
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
    }
    
    /// 退款
    func serverOrderView(refundToOrder serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath) {
        
        XQSystemAlert.alert(withTitle: "退款", message: "确认是否要退款", contentArr: ["确定"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            let model = self.contentView.dataArr[indexPath.row]
            
            let reqModel = XQSMNTOrderRefundToOrderReqModel.init(OId: model.Id, RefundPrice: 0, Remark: "", imgArr: nil)
            
            SVProgressHUD.show(withStatus: nil)
            XQACFosterNetwork.refundToOrder(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.isProgress {
                    return
                }
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "提交退款成功")
//                self.contentView.dataArr[indexPath.row].State = .cancel
//                self.contentView.tableView.reloadData()
                self.contentView.tableView.mj_header?.beginRefreshing()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
    
    /// 点击删除
    func serverOrderView(delete serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath) {
        let model = self.contentView.dataArr[indexPath.row]
         
        XQSystemAlert.alert(withTitle: "是否要删除", message: nil, contentArr: ["删除"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            XQACFosterNetwork.deleteOrder(model.Id).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                self.contentView.dataArr.removeAll { (m) -> Bool in
                    return m.Id == model.Id
                }
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
    
}
