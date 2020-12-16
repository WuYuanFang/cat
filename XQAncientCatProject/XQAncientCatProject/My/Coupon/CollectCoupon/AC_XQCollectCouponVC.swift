//
//  AC_XQCollectCouponVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

/// 领券中心
class AC_XQCollectCouponVC: XQACBaseVC, AC_XQCollectCouponViewDelegate {
    
    let contentView = AC_XQCollectCouponView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let reqModel = XQSMNTBaseReqModel.init()
        XQSMCouponNetwork.getCvp(reqModel).subscribe(onNext: { (resModel) in
            
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
    
    // MARK: - AC_XQCollectCouponViewDelegate
    
    func collectCouponView(receive collectCouponView: AC_XQCollectCouponView, didSelectRowAt indexPath: IndexPath) {
        
        let reqModel = XQSMNTCouponAddCvpReqModel.init(couponId: self.contentView.dataArr[indexPath.row].CouponTypeId)
        SVProgressHUD.show(withStatus: nil)
        XQSMCouponNetwork.addCvp(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "领取成功")
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
}
