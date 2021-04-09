//
//  AC_XQCouponVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

/// 优惠券
class AC_XQCouponVC: XQACBaseVC, AC_XQCouponViewDelegate {
    
    let contentView = AC_XQCouponView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.backView.setBackImg(with: UIImage.init(named: "back_arrow")?.xq_image(withTintColor: .white))
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.receiveBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.navigationController?.pushViewController(AC_XQCollectCouponVC(), animated: true)
        }
        
        self.contentView.delegate = self
        
        
        self.contentView.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            self.getData()
        })
        
        self.contentView.tableView.mj_header?.beginRefreshing()
    }
    
    func getData() {
        
        let reqModel = XQSMNTBaseReqModel.init()
        XQSMCouponNetwork.getMyAllCanUseOrder(reqModel).subscribe(onNext: { (resModel) in
            
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
    
    // MARK: - AC_XQCouponViewDelegate
    
    /// 点击立即使用
    func couponView(tapUse couponView: AC_XQCouponView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.contentView.dataArr[indexPath.row]
        
        switch model.CouponType {
        case .commodity:
            
            self.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                if let tbc = UIApplication.shared.keyWindow?.rootViewController as? XQACTBC {
                    tbc.xq_tabBar.contentView.selectBtn(1)
                }
            }
            
        case .service:
            if let model = XQSMNTToShopIndexModel.xq_getModel() {
                let vc = AC_XQWashProtectVC()
                vc.ShopInfo = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        case .otherService:
            if let model = XQSMNTToShopIndexModel.xq_getModel() {
                let vc = AC_XQFosterVC()
                vc.ShopInfo = model
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
