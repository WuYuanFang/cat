//
//  AC_XQShopMallOrderDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/21.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQAlert
import SVProgressHUD

class AC_XQShopMallOrderDetailVC: XQACBaseVC {
    
    /// 外部传入的列表订单model
    var orderBaseInfoModel: XQSMNTOrderBaseInfoDtoModel?

    let contentView = AC_XQShopMallOrderDetailView()
    
    typealias AC_XQShopMallOrderDetailVCCallback = () -> ()
    var refreshCallback: AC_XQShopMallOrderDetailVCCallback?
    
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
        
        self.reloadUI()
        
        self.contentView.bottomView.mapBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
        }
        
        self.contentView.bottomView.phoneBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//            if let phone = self.fosterModel?.phone, let url = URL.init(string: "tel://\(phone)") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
        }
        
        
    }
    
    func reloadUI() {
        
        guard let fosterModel = self.orderBaseInfoModel else {
            return
        }
        
        self.contentView.headerView.addressModel = XQSMNTShopAddressDtoModel.init(SaId: "", Alias: "", Consignee: fosterModel.Consignee, Mobile: fosterModel.Mobile, ZipCode: "", Address: fosterModel.Address, ProvinceName: "", ProvinceId: "", CityName: "", CityId: "", AreaName: "", AreaId: "", IsDefault: false, X: "", Y: "")
        self.contentView.headerView.arrowImgView.isHidden = true
        
        if let orderProductInfo = fosterModel.ProductList?.first {
            self.contentView.infoView.productView.imgView.sd_setImage(with: orderProductInfo.ShowImg.sm_getImgUrl())
            self.contentView.infoView.productView.nameLab.text = orderProductInfo.Name
//            self.contentView.infoView.productView.priceLab.text = "¥\(orderProductInfo.ShopPrice)"
            self.contentView.infoView.productView.priceLab.text = "¥\(fosterModel.SurplusMoney)"
            
            self.contentView.infoView.buyNumberView.contentLab.text = "\(orderProductInfo.BuyCount)"
        }
        
        if !ac_isShowV() {
            self.contentView.infoView.vipZKView.titleLab.text = ""
            self.contentView.infoView.vipZKView.contentLab.text = ""
        }else {
            if fosterModel.RankDiscount >= 10 {
                self.contentView.infoView.vipZKView.contentLab.text = "无"
            }else {
                self.contentView.infoView.vipZKView.contentLab.text = "\(fosterModel.RankDiscount)折"
            }
        }
        
        
        self.contentView.infoView.moneyView.contentLab.text = "¥\(fosterModel.SurplusMoney)"
        
        self.contentView.infoView.remarkView.contentLab.text = fosterModel.BuyerRemark
        
        self.contentView.infoView.orderLab.text = "订单编号 \(fosterModel.OSN)"
        
        self.contentView.infoView.cancelOrderBtn.isHidden = true
        self.contentView.infoView.cancelOrderLab.isHidden = true
        self.contentView.infoView.cancelOrderBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
        }
        
        if fosterModel.OrderState == .waitPay {
            self.contentView.infoView.payTimeLab.text = ""
            self.contentView.infoView.cancelOrderBtn.isHidden = false
            self.contentView.infoView.cancelOrderLab.isHidden = false
            self.contentView.infoView.cancelOrderBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.cancelOrder()
            }
            
        }else {
            
            if fosterModel.OrderState == .delivered {
                self.contentView.infoView.cancelOrderBtn.setTitle("确认收货", for: .normal)
                self.contentView.infoView.cancelOrderBtn.isHidden = false
                self.contentView.infoView.cancelOrderBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                    self.sureOrder()
                }
            }
            
            
            self.contentView.infoView.payTimeLab.text = "付款时间: \(fosterModel.PayTime)\n支付方式: \(fosterModel.PaySystemName)"
            
        }
        
    }
    
    /// 确认收货
    func sureOrder() {
        XQSystemAlert.alert(withTitle: "确定已经收到商品了吗?", message: nil, contentArr: ["确定"], cancelText: "再看看", vc: self, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            let reqModel = XQSMNTSureReceiveProductReqModel.init(orderId: self.orderBaseInfoModel?.Oid ?? 0)
            XQSMOrderNetwork.sureReceiveProduct(reqModel).subscribe(onNext: { (resModel) in
                
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                self.orderBaseInfoModel?.OrderState = .receivedGoods
                self.orderBaseInfoModel?.OrderStateStr = "已完成"
                self.reloadUI()
                self.refreshCallback?()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
    }
    
    /// 取消订单
    func cancelOrder() {
        
        XQSystemAlert.alert(withTitle: "确定取消该订单吗?", message: nil, contentArr: ["确定"], cancelText: "再看看", vc: self, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            let reqModel = XQSMNTCancleToOrderReqModel.init(oId: self.orderBaseInfoModel?.Oid ?? 0)
            XQSMOrderNetwork.cancelOrder(reqModel).subscribe(onNext: { (resModel) in
                
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "取消成功")
                self.orderBaseInfoModel?.OrderState = .cancel
                self.orderBaseInfoModel?.OrderStateStr = "已取消"
                self.reloadUI()
                self.refreshCallback?()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
}
