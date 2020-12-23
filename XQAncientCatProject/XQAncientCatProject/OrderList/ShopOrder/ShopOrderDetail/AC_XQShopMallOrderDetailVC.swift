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
import SwiftRichString

// 商品订单详情
class AC_XQShopMallOrderDetailVC: XQACBaseVC {
    
    /// 外部传入的列表订单model
    var orderBaseInfoModel: XQSMNTOrderBaseInfoDtoModel?

    let contentView = AC_XQShopMallOrderDetailView()
    
    typealias AC_XQShopMallOrderDetailVCCallback = () -> ()
    var refreshCallback: AC_XQShopMallOrderDetailVCCallback?
    
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
        
        self.reloadUI()
        
        self.contentView.bottomView.mapBtn.xq_addEvent(.touchUpInside) {  (sender) in
            
        }
        
        self.contentView.bottomView.phoneBtn.xq_addEvent(.touchUpInside) {  (sender) in
//            if let phone = self.fosterModel?.phone, let url = URL.init(string: "tel://\(phone)") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
        }
        
        
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
        
        self.contentView.infoView.couponView.contentLab.text = "¥\(fosterModel.RankDiscountPrice)"
        self.contentView.infoView.moneyView.contentLab.text = "¥\(fosterModel.SurplusMoney)"
        
        self.contentView.infoView.remarkView.contentLab.text = fosterModel.BuyerRemark
        
        self.contentView.infoView.orderLab.text = "订单编号 \(fosterModel.OSN)"
        self.contentView.statusLabel.text = fosterModel.OrderStateStr
        self.contentView.infoView.refundBtn.isHidden = true
        self.contentView.infoView.cancelOrderBtn.isHidden = true
        self.contentView.infoView.cancelOrderLab.isHidden = true
        self.contentView.animalImg.isHidden = true
        self.contentView.signBtn.isHidden = true
        self.contentView.infoView.cancelOrderBtn.xq_addEvent(.touchUpInside) { (sender) in
            
        }
        
        if fosterModel.OrderState == .waitPay {
            self.contentView.infoView.payTimeLab.text = ""
            self.contentView.infoView.refundBtn.isHidden = false
            self.contentView.infoView.cancelOrderBtn.isHidden = false
            self.contentView.infoView.cancelOrderLab.isHidden = false
            self.contentView.animalImg.isHidden = false
            self.contentView.infoView.refundBtn.setTitle("去付款", for: .normal)
            self.contentView.infoView.cancelOrderBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.cancelOrder()
            }
            self.contentView.infoView.refundBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.payOrder()
            }
            
        }else if fosterModel.OrderState == .inInspection {
            self.contentView.infoView.refundBtn.setTitle("申请退款", for: .normal)
            self.contentView.infoView.refundBtn.isHidden = false
            self.contentView.animalImg.isHidden = false
            self.contentView.infoView.refundBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.refundAction()
            }
            self.contentView.infoView.payTimeLab.attributedText = "付款时间: \(fosterModel.PayTime)\n支付方式: \(fosterModel.PaySystemName)".set(style: lineSpace6)
        }else {
            
            if fosterModel.OrderState == .delivered {
                self.contentView.signBtn.isHidden = false
                self.contentView.infoView.refundBtn.setTitle("确认收货", for: .normal)
                self.contentView.infoView.refundBtn.isHidden = false
                self.contentView.infoView.refundBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                    self.sureOrder()
                }
            }
            if fosterModel.OrderState == .refund || fosterModel.OrderState == .inStock  {
                self.contentView.animalImg.isHidden = false
            }
            
            self.contentView.infoView.payTimeLab.attributedText = "付款时间: \(fosterModel.PayTime)\n支付方式: \(fosterModel.PaySystemName)".set(style: lineSpace6)
            
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
    
    /// 去付款
    func payOrder() {
        guard let model = self.orderBaseInfoModel else {
            SVProgressHUD.showError(withStatus: "订单有误，无法支付")
            return
        }
        
        AC_XQAlertSelectPayView.show(String(model.Oid), money: model.SurplusMoney, payType: .shopMall, callback: { (payId, payType) in
            print("支付成功: ", payType)
            SVProgressHUD.showSuccess(withStatus: "支付成功")
            self.getDetail()
        }) {
            print("隐藏了")
        }
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
    
    /// 退款
    func refundAction() {
        let vc = AC_XQShopRefundOrderVC()
        vc.orderBaseInfoModel = self.orderBaseInfoModel
        vc.refreshCallback = { [unowned self] in
            self.getDetail()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 获取订单详情
    func getDetail() {
        SVProgressHUD.show(withStatus: nil)
        XQSMOrderNetwork.getOrderById(orderBaseInfoModel?.Oid ?? 0).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            self.orderBaseInfoModel = resModel.OrderList
            self.reloadUI()
            self.refreshCallback?()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
}
