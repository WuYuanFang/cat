//
//  AC_XQFosterCouponVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class AC_XQFosterCouponVC: XQACBaseVC, AC_XQFosterCouponViewDelegate {
    
    
    let contentView = AC_XQFosterCouponView()
    
    /// 订单钱(寄养需要)
    var orderMoney: Float = 0
    
    /// 预约，洗护
    var couponInputReqModel: XQSMNTShowToOrderCanUseCouponInputReqModel?
    
    typealias AC_XQFosterCouponVCCallback = (_ couponListModel: XQSMNTCouponListModel?) -> ()
    var callback: AC_XQFosterCouponVCCallback?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setTitle("选择优惠券")
        
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "不使用优惠券", style: .plain, target: self, action: #selector(respondsToNotUse)))
        
        self.xq_view.addSubview(self.contentView)
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
        if let couponInputReqModel = self.couponInputReqModel {
            XQSMCouponNetwork.showToOrderCanUseCoupon(couponInputReqModel).subscribe(onNext: { (resModel) in
                
                self.contentView.tableView.mj_header?.endRefreshing()
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                self.contentView.dataArr = resModel.CouponList ?? []
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.contentView.tableView.mj_header?.endRefreshing()
            }).disposed(by: self.disposeBag)
            
        }else {
            
            let reqModel = XQSMNTGetFosterCouponReqModel.init(money: self.orderMoney)
            XQSMCouponNetwork.getFosterCoupon(reqModel).subscribe(onNext: { (resModel) in
                
                self.contentView.tableView.mj_header?.endRefreshing()
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                self.contentView.dataArr = resModel.CouponList ?? []
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                self.contentView.tableView.mj_header?.endRefreshing()
            }).disposed(by: self.disposeBag)
            
        }
        
    }
    
    // MARK: - responds
    
    @objc func respondsToNotUse() {
        self.callback?(nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - AC_XQFosterCouponViewDelegate
    
    func couponView(_ couponView: AC_XQFosterCouponView, didSelectRowAt indexPath: IndexPath) {
        self.callback?(self.contentView.dataArr[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
