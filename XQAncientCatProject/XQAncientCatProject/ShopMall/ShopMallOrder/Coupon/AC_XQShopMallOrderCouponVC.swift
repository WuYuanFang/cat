//
//  AC_XQShopMallOrderCouponVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class AC_XQShopMallOrderCouponVC: XQACBaseVC, AC_XQShopMallOrderCouponViewDelegate {

    let contentView = AC_XQShopMallOrderCouponView()
    
    /// 商品
    var cartPdList = [XQSMNTCartOrderProduInfoModel]()
    
    typealias AC_XQShopMallOrderCouponVCCallback = (_ couponListModel: XQSMNTCouponListModel?) -> ()
    var callback: AC_XQShopMallOrderCouponVCCallback?

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
        
        let reqModel = XQSMNTCartCouponByUidReqModel.init(CartPdList: self.cartPdList, BuyType: 0)
        XQSMCartNetwork.queryCanUseCouponByUid(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.dataArr = resModel.CouponList
            self.contentView.tableView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.tableView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: - responds
    
    @objc func respondsToNotUse() {
        self.callback?(nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - AC_XQShopMallOrderCouponViewDelegate
    
    func couponView(_ couponView: AC_XQShopMallOrderCouponView, didSelectRowAt indexPath: IndexPath) {
        self.callback?(self.contentView.dataArr[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }

}
