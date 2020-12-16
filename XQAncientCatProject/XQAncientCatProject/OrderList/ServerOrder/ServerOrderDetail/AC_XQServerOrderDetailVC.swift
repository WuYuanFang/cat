//
//  AC_XQServerOrderDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/24.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class AC_XQServerOrderDetailVC: XQACBaseVC {

    let contentView = AC_XQServerOrderDetailView()
    
    var fosterModel: XQACNTFosterGM_FosterModel?
    
    var refreshCallback: AC_XQFosterOrderDetailVC.AC_XQFosterOrderDetailVCCallback?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.dayBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
            if let shopModel = XQSMNTToShopIndexModel.xq_getModel() {
                let vc = AC_XQFosterVC()
                vc.ShopInfo = shopModel
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                SVProgressHUD.showInfo(withStatus: "获取不到附近商店信息")
            }
            
        }
        
        self.contentView.detailBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
            if let _ = self.fosterModel {
                self.pushFoster()
            }else {
                SVProgressHUD.showInfo(withStatus: "获取不到订单信息")
            }
            
        }
        
        self.reloadUI()
        
        self.getData()
    }
    
    func pushFoster() {
        let vc = AC_XQFosterOrderDetailVC()
        vc.fosterModel = self.fosterModel
        vc.refreshCallback = { [unowned self] in
            self.refreshCallback?()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func reloadUI() {
        guard let fosterModel = self.fosterModel else {
            return
        }
        
        if fosterModel.PayType == 1, fosterModel.State != .cancel {
            // 未支付
//            self.contentView.cancelBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//
//            }
            
//            self.contentView.titleLab.text = ""
            
        }else {
            
        }
    }
    
    func getData() {
        
        guard let fosterModel = self.fosterModel else {
            return
        }
        
        XQACFosterNetwork.fosterDetails(fosterModel.Id).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.dayLab.text = "寄养还剩\(resModel.Days ?? " ")天"
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
}
