//
//  AC_XQWashProtectOrderDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import XQAlert
import SwiftDate
import SwiftRichString

// 洗护订单详情
class AC_XQWashProtectOrderDetailVC: XQACBaseVC {

    let contentView = AC_XQWashProtectOrderDetailView()
    
    var fosterModel: XQSMNTTinnyToOrderInfoModel?
    
    typealias AC_XQWashProtectOrderDetailVCCallback = () -> ()
    var refreshCallback: AC_XQWashProtectOrderDetailVCCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setCenterTitle("订单详情")
        self.xq_navigationBar.titleLab.textColor = .white
        self.xq_navigationBar.backView.setBackImg(with: UIImage.init(named: "back_arrow")?.xq_image(withTintColor: .white))
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem(image: UIImage(named: "my_service"), style: .plain, target: self, action: #selector(servieAction)))
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.bottomView.mapBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
            if let fosterModel = self.fosterModel {
                
                let endLocation = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(fosterModel.X) ?? 0, longitude: CLLocationDegrees(fosterModel.Y) ?? 0)
                
                let amapEndLocation = CLLocationCoordinate2D.init(latitude: CLLocationDegrees(fosterModel.XOther) ?? 0, longitude: CLLocationDegrees(fosterModel.YOther) ?? 0)
                
                XQSMLocation.shared().showSelectMapAlert(endLocation, amapShopLocation: amapEndLocation, shopName: fosterModel.ShopName)
            }
            
        }
        
        self.contentView.bottomView.phoneBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if let phone = self.fosterModel?.ShopPhone, let url = URL.init(string: "tel://\(phone)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        self.reloadUI()
    }
    
    // 点击客服
    @objc func servieAction() {
        if XQSMBaseNetwork.default.token.count == 0 {
            AC_XQLoginVC.presentLogin(self)
            return
        }
        
        SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
    }
    
    func reloadUI() {
        guard let fosterModel = self.fosterModel else {
            return
        }
        
        print(fosterModel)
        
        self.contentView.headerView.titleLab.text = fosterModel.ShopName
        self.contentView.headerView.imgView.sd_setImage(with: fosterModel.PetPhotoStr.sm_getImgUrl())
        
        
        if !ac_isShowV() {
            self.contentView.infoView.vipZKView.titleLab.text = ""
            self.contentView.infoView.vipZKView.contentLab.text = ""
        }else {
            let userRankDiscount = Float(fosterModel.UserRankDiscount)/Float(10)
            if userRankDiscount >= 10 {
                self.contentView.infoView.vipZKView.contentLab.text = "无"
            }else {
                self.contentView.infoView.vipZKView.contentLab.text = "\(userRankDiscount.xq_removeDecimalPointZero())折"
            }
        }
        
        self.contentView.infoView.couponView.contentLab.text = "¥ \(fosterModel.CouponMoney)"
        
        self.contentView.infoView.serverView.contentLab.text = "¥\(fosterModel.TotalPrice)"
        self.contentView.infoView.serverView.desLab.text = fosterModel.xq_getOrderPdListPName()
        self.contentView.infoView.serverView.desDetailLab.text = fosterModel.xq_getOrderPdListInfo()
        
        self.contentView.infoView.timeView.contentLab.text = fosterModel.SubscribeTime
        self.contentView.bottomView.stateL.text = fosterModel.StateDesc
        
//        self.contentView.infoView.endTimeView.contentLab.text = fosterModel.FinishTime
        let startTime = fosterModel.SubscribeTime.xq_toDate()
        var endTime = startTime
        if let tmpMData = startTime {
            endTime = tmpMData + 1.hours + 30.minutes
        }
        self.contentView.infoView.endTimeView.contentLab.text = endTime?.xq_toString()
        
        self.contentView.infoView.moneyView.contentLab.text = "¥\(fosterModel.TotalPrice)"
        
        self.contentView.infoView.phoneView.contentLab.text = fosterModel.ReceivePhone
        self.contentView.infoView.nameView.contentLab.text = fosterModel.ReceiveMan
        self.contentView.infoView.remarkView.contentLab.text = fosterModel.Remark
        
        self.contentView.infoView.orderLab.text = "订单编号 \(fosterModel.OSN)"
        
        self.contentView.infoView.payOrReservedBtn.isHidden = true
        self.contentView.infoView.cancelOrderBtn.isHidden = true
        self.contentView.infoView.cancelOrderLab.isHidden = true
        if fosterModel.State == .waitPay {
            self.contentView.infoView.payOrReservedBtn.isHidden = false
            self.contentView.infoView.cancelOrderBtn.isHidden = false
            self.contentView.infoView.cancelOrderLab.isHidden = false
            
            self.contentView.infoView.payOrReservedBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.payToOrder()
            }
            self.contentView.infoView.cancelOrderBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.cancelOrder()
            }
        }else if fosterModel.State == .reserved {
            if fosterModel.CanRefund {
                self.contentView.infoView.payOrReservedBtn.setTitle("申请退款", for: .normal)
                self.contentView.infoView.payOrReservedBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                    self.refundToOrder()
                }
            }
        }
        
        
        
        
        if fosterModel.State == .waitPay || fosterModel.State == .cancel {
            self.contentView.infoView.payTimeLab.text = ""
        }else {
            self.contentView.infoView.payTimeLab.attributedText = "付款时间: \(fosterModel.PayTime)\n支付方式: \(getPayMode(fosterModel.PayType))".set(style: lineSpace6)
        }
    }
    
    /// 取消订单
    func cancelOrder() {
        
        XQSystemAlert.alert(withTitle: "确定取消该订单吗?", message: nil, contentArr: ["确定"], cancelText: "再看看", vc: self, contentCallback: { (alert, index) in
            
            let reqModel = XQSMNTCancleToOrderReqModel.init(oId: self.fosterModel?.Id ?? 0)
            SVProgressHUD.show(withStatus: nil)
            XQSMToShopOrderNetwork.cancleToOrder(reqModel).subscribe(onNext: { (resModel) in
                
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "取消成功")
                self.fosterModel?.StateDesc = "已取消"
                self.fosterModel?.State = .cancel
                self.reloadUI()
                self.refreshCallback?()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
    
    // 去付款
    func payToOrder() {
        guard let model = self.fosterModel else {
            return
        }
        AC_XQAlertSelectPayView.show(String(model.Id), money: model.TotalPrice, payType: .appointment, callback: { (payId, payType) in
            print("支付成功: ", payType)
            
            SVProgressHUD.show(withStatus: nil)
            self.fosterModel?.StateDesc = "已预约"
            self.fosterModel?.State = .reserved
            self.fosterModel?.PayTime = Date().xq_toString()
            // 默认，以防报错
            self.fosterModel?.PayType = "wechat"
            self.reloadUI()
            NotificationCenter.default.post(name: NSNotification.Name.init("RefreshWashList"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "支付成功")
                self.getWashOrderDetail(id: model.Id)
            }
            self.refreshCallback?()
        }) {
            print("隐藏了")
        }
    }
    
    // 申请退款
    func refundToOrder() {
        
        guard let model = self.fosterModel else {
            return
        }
        
        XQSystemAlert.alert(withTitle: "退款", message: "确认是否要退款", contentArr: ["确定"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
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
                self.fosterModel?.StateDesc = "退款中"
                self.fosterModel?.State = .cancel
                self.reloadUI()
                self.refreshCallback?()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
    }
    
    /// 获取洗护订单详情
    func getWashOrderDetail(id:Int) {
        SVProgressHUD.show(withStatus: nil)
        XQSMToShopOrderNetwork.getToOrderById(id).subscribe(onNext: { (resModel) in
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            SVProgressHUD.dismiss()
            self.fosterModel = resModel.ToOrderItem
            self.reloadUI()
            self.refreshCallback?()
        }, onError: { (error) in
//            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }

}
