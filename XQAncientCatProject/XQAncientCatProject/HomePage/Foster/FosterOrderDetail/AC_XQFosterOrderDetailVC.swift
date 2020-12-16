//
//  AC_XQFosterOrderDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import XQAlert

/// 寄养订单详情
class AC_XQFosterOrderDetailVC: XQACBaseVC {
    
    let contentView = AC_XQFosterOrderDetailView()
    
    var fosterModel: XQACNTFosterGM_FosterModel?
    
    typealias AC_XQFosterOrderDetailVCCallback = () -> ()
    var refreshCallback: AC_XQFosterOrderDetailVCCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setCenterTitle("订单详情")
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.bottomView.mapBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
            if let fosterModel = self.fosterModel {   
                let endLocation = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(fosterModel.x) ?? 0, longitude: CLLocationDegrees(fosterModel.y) ?? 0)
                
                let amapEndLocation = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(fosterModel.XOther) ?? 0, longitude: CLLocationDegrees(fosterModel.YOther) ?? 0)
                
                XQSMLocation.shared().showSelectMapAlert(endLocation, amapShopLocation: amapEndLocation, shopName: fosterModel.ShopName)
            }
            
        }
        
        self.contentView.bottomView.phoneBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if let phone = self.fosterModel?.phone, let url = URL.init(string: "tel://\(phone)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        self.reloadUI()
        
        print(self.fosterModel ?? "没有数据")
    }
    
    func reloadUI() {
        guard let fosterModel = self.fosterModel else {
            return
        }
        
        self.contentView.headerView.titleLab.text = fosterModel.ShopName
        self.contentView.headerView.imgView.sd_setImage(with: fosterModel.Photo.sm_getImgUrl())
        
        
        if !ac_isShowV() {
            self.contentView.infoView.vipZKView.titleLab.text = ""
            self.contentView.infoView.vipZKView.contentLab.text = ""
        }else {
            if fosterModel.MemberDiscount >= 10 {
                self.contentView.infoView.vipZKView.contentLab.text = "无"
            }else {
                self.contentView.infoView.vipZKView.contentLab.text = "\(fosterModel.MemberDiscount.xq_removeDecimalPointZero())折"
            }
        }
        
        
        self.contentView.infoView.serverView.contentLab.text = "¥\(fosterModel.dayMoeny)/天"
        self.contentView.infoView.dayView.contentLab.text = "\(fosterModel.SeveralNights)天"
        self.contentView.infoView.timeView.contentLab.text = fosterModel.StartTime
        
        //            self.contentView.infoView.timeView.contentLab.text = fosterModel.StartTime
        self.contentView.infoView.moneyView.contentLab.text = "¥\(fosterModel.Totalamount)"
        
        self.contentView.infoView.phoneView.contentLab.text = fosterModel.Mobile
        self.contentView.infoView.nameView.contentLab.text = fosterModel.Name
        self.contentView.infoView.remarkView.contentLab.text = fosterModel.Remarks
        
        self.contentView.infoView.orderLab.text = "订单编号 \(fosterModel.OSN)"
        
        self.contentView.infoView.cancelOrderBtn.isHidden = true
        self.contentView.infoView.cancelOrderLab.isHidden = true
        if fosterModel.PayType == 1, fosterModel.State != .cancel {
            self.contentView.infoView.payTimeLab.text = ""
            self.contentView.infoView.cancelOrderBtn.isHidden = false
            self.contentView.infoView.cancelOrderLab.isHidden = false
            self.contentView.infoView.cancelOrderBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.cancelOrder()
            }
            
        }else {
            self.contentView.infoView.payTimeLab.text = fosterModel.PayTime
        }
        
        
        
    }
    
    /// 取消订单
    func cancelOrder() {
        
        XQSystemAlert.alert(withTitle: "确定取消该订单吗?", message: nil, contentArr: ["确定"], cancelText: "再看看", vc: self, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            XQACFosterNetwork.fosteState(self.fosterModel?.Id ?? 0).subscribe(onNext: { (resModel) in
                
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "取消成功")
                self.fosterModel?.State = .cancel
                self.reloadUI()
                self.refreshCallback?()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
    
    
}
