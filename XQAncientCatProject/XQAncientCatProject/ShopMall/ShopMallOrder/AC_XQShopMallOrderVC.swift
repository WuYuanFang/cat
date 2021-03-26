//
//  AC_XQShopMallOrderVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 下单
class AC_XQShopMallOrderVC: XQACBaseVC, XQNumberViewDelegate, AC_XQRealNameProtocol, AC_XQUserInfoProtocol {

    let contentView = AC_XQShopMallOrderView()
    
    var cartModel: XQSMNTCartModel?
    
    var couponModel: XQSMNTCouponListModel?
    
    /// 是否购物车结账
    var isShopCar = false
    
    typealias AC_XQShopMallOrderVCCallback = () -> ()
    /// 已经下单了
    var callback: AC_XQShopMallOrderVCCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.xq_navigationBar.setCenterTitle("确认订单")
        self.xq_navigationBar.titleLab.textColor = .white
        self.xq_navigationBar.backView.setBackImg(with: UIImage.init(named: "back_arrow")?.xq_image(withTintColor: .white))
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.getAddressData()
        self.contentView.headerView.xq_addTap { [unowned self] (gesture) in
            self.presentAddressList()
        }
        
        self.contentView.couponView.xq_addTap { [unowned self] (sender) in
            self.presentSelectCoupon()
        }
        
        self.contentView.payView.payBtn.xq_addTap { [unowned self] (gesture) in
            self.submitOrder()
        }
        
        
        
        // 默认不能选 vip
        self.contentView.vipView.reloadUI(.commodity)
        self.contentView.vipView.callback = { [unowned self] in
            self.confirmOrder()
        }
        
        self.contentView.rnDiscountView.toRealNameCallback = { [unowned self] in
            self.realNameAuthentication { [unowned self] in
                self.refreshUserInfo { [unowned self] (resModel) in
                    self.contentView.rnDiscountView.reloadUI()
                }
            }
        }
        
        self.contentView.rnDiscountView.changeSelectCallback = { [unowned self] in
            self.confirmOrder()
        }
        
        self.contentView.infoView.isShopCar = self.isShopCar
        self.contentView.infoView.numberView.numberView.delegate = self
        
        self.contentView.infoView.reloadUI(self.getSelectCartProductList())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.rnDiscountView.reloadUI()
    }
    
    func reloadUI() {
        self.contentView.infoView.reloadUI(self.getSelectCartProductList())
        self.confirmOrder()
    }
    
    /// 获取选中的商品
    func getSelectCartProductList() -> [XQSMNTCartProductInfoModel] {
        var arr = [XQSMNTCartProductInfoModel]()
        for item in self.cartModel?.CartInfo?.CartProductList ?? [] {
            if item.IsSelected {
                arr.append(item)
            }
        }

        return arr
    }
    
    /// 获取地址, 并且选择默认地址
    func getAddressData() {
        
        let reqModel = XQSMNTBaseReqModel.init()
        XQSMAddressNetwork.getMyAllAddress(reqModel).subscribe(onNext: { (resModel) in
            
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            var addressModel: XQSMNTShopAddressDtoModel?
            for item in resModel.Lss ?? [] {
                
                if item.IsDefault {
                    addressModel = item
                    break
                }
                
            }
            
            if addressModel == nil {
                addressModel = resModel.Lss?.first
            }
            
            self.contentView.headerView.addressModel = addressModel
            self.reloadUI()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            
        }).disposed(by: self.disposeBag)
        
    }
    
    /// 获取快递
    func getShipPluginInfo() {
//        XQSMNTOrderPluginInfoReqModel.init(OId: <#T##Int#>)
//        XQSMOrderNetwork.getShipPluginInfo(XQSMNTOrderPluginInfoReqModel)
    }
    
    /// 跳转去选择地址
    func presentAddressList() {
        let vc = AC_XQAddressListVC()
        vc.oSelectModel = self.contentView.headerView.addressModel
        vc.callback = { [unowned self] (model) in
            self.contentView.headerView.addressModel = model
            if let _ = model {
                self.reloadUI()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 选择优惠券
    func presentSelectCoupon() {
        print("选择优惠券")
        let vc = AC_XQShopMallOrderCouponVC()
        
        let cartPdList = self.getCartOrderProduInfoModelArr()
        vc.cartPdList = cartPdList
        
        vc.callback = { [unowned self] (cModel) in
            self.couponModel = cModel
            self.confirmOrder()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getCartOrderProduInfoModelArr() -> [XQSMNTCartOrderProduInfoModel] {
        let productArr = self.getSelectCartProductList()
        var produInfos = [XQSMNTCartOrderProduInfoModel]()
        for item in productArr {
            if let model = item.OrderProductInfo {
                let orderProduInfoModel = XQSMNTCartOrderProduInfoModel.init(pId: model.Pid, buyCount: model.BuyCount)
                produInfos.append(orderProduInfoModel)
            }
        }
        
        return produInfos
    }
    
    /// 计算订单价格
    func confirmOrder(_ callback: ( (_ model: XQSMNTCanceOrSelectReqModel) -> () )? = nil ) {
        
        let productArr = self.getSelectCartProductList()
        if productArr.count == 0 {
            SVProgressHUD.showError(withStatus: "获取商品信息失败")
            return
        }
        
        
        guard let addressModel = self.contentView.headerView.addressModel else {
            SVProgressHUD.showInfo(withStatus: "请先前去选择地址")
            return
        }
        
        var produInfos = self.getCartOrderProduInfoModelArr()
        
        // 不是购物车的话, 根据 UI 的 number 来
        if !self.isShopCar {
            produInfos[0].buyCount = Int(self.contentView.infoView.numberView.numberView.currentNumber)
        }
        
        var couponId = 0
        if let couponModel = self.couponModel {
            couponId = couponModel.CouponId
        }
        
        let reqModel = XQSMNTCanceOrSelectReqModel.init(ProduInfos: produInfos,
                                                        SaId: Int(addressModel.SaId) ?? 0,
                                                        ShipName: "",
                                                        CouponId: couponId,
                                                        xq_type: 0,
                                                        ChoseTrueMan: self.contentView.rnDiscountView.rightBtn.isSelected,
                                                        ChoseRank: self.contentView.vipView.rightBtn.isSelected)
        if let callback = callback {
            callback(reqModel)
            return
        }
        XQSMCartNetwork.confirmOrder(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.payView.moneyLab.text = "合计 ¥\(resModel.OrderModel?.OrderAmount ?? 0)"
            
            if let shipFee = resModel.OrderModel?.ShipFee, shipFee != 0 {
                self.contentView.infoView.freightView.contentLab.text = "¥\(shipFee)"
            }else {
                self.contentView.infoView.freightView.contentLab.text = "包邮"
            }
            
            if let couponPrice = resModel.OrderModel?.CouponPrice, couponPrice != 0 {
                self.contentView.couponView.couponPriceLab.text = "-¥\(resModel.OrderModel?.CouponPrice ?? 0)"
            }else {
                self.contentView.couponView.couponPriceLab.text = ""
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 下单
    func submitOrder() {
        
        self.confirmOrder { [unowned self] (model) in
            
            let reqModel = XQSMNTOrderReqModel.init(ProduInfos: model.ProduInfos,
                                                    SaId: model.SaId,
                                                    ShipName: "",
                                                    CouponId: model.CouponId,
                                                    FullCut: 0,
                                                    BuyerRemark: self.contentView.remarkTV.text ?? "",
                                                    xq_type: model.xq_type,
                                                    ChoseTrueMan: model.ChoseTrueMan,
                                                    ChoseRank: model.ChoseRank)
            SVProgressHUD.show(withStatus: nil)
            XQSMOrderNetwork.submitOrder(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                SVProgressHUD.dismiss()
                
                
                weak var nc = self.navigationController
                AC_XQAlertSelectPayView.show(String(resModel.OrderInfo?.Oid ?? 0), money: resModel.OrderInfo?.OrderAmount ?? 0, payType: .shopMall, callback: { (payId, payType) in
                    print("点击了支付: ", payType)
                    
                    self.callback?()
//                    if let id = Int(payId) {
//                        SVProgressHUD.show(withStatus: nil)
//                        XQSMOrderNetwork.getOrderById(id).subscribe(onNext: { (resModel) in
//
//                            if resModel.ErrCode != .succeed {
//                                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
//                                return
//                            }
//
//                            SVProgressHUD.dismiss()
//                            let vc = AC_XQShopMallOrderDetailVC()
//                            vc.orderBaseInfoModel = resModel.OrderList
//
//                            nc?.popViewController(animated: false)
//                            nc?.pushViewController(vc, animated: true)
//
//                        }, onError: { (error) in
//                            SVProgressHUD.showError(withStatus: error.localizedDescription)
//                        }).disposed(by: self.disposeBag)
//                    }
                    SVProgressHUD.showSuccess(withStatus: "支付成功")
                    
                    nc?.popViewController(animated: false)
                    nc?.pushViewController(AC_XQOrderListVC(), animated: true)
//                    nc?.qmui_popViewController(animated: false, completion: {
//                        nc?.pushViewController(AC_XQOrderListVC(), animated: true)
//                    })
                    
                }) {
                    print("隐藏了")
                    SVProgressHUD.showSuccess(withStatus: "已取消支付")
                    nc?.popViewController(animated: true)
                    // 弹框
//                    self.getDetail(id: resModel.OrderInfo?.Oid ?? 0)
                }
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
        }
        
    }
    
    
    // 获取订单详情
    func getDetail(id:Int) {
        weak var nc = self.navigationController
        SVProgressHUD.show(withStatus: nil)
        XQSMOrderNetwork.getOrderById(id).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            
            
            nc?.popViewController(animated: false)
            nc?.qmui_pushViewController(AC_XQOrderListVC(), animated: true, completion: {
                let vc = AC_XQShopMallOrderDetailVC()
                vc.orderBaseInfoModel = resModel.OrderList
                nc?.pushViewController(vc, animated: true)
            })
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - XQNumberViewDelegate
    
    func numberView(_ numberView: XQNumberView, number: Float, increaseStatus: Bool) {
        
//        self.confirmOrder()
        
        // 这里得让后台改...不应该还要调用购物车的数量
        guard let productInfo = self.getSelectCartProductList().first else {
            return
        }
        
        let pid = productInfo.OrderProductInfo?.Pid ?? 0
        let reqModel = XQSMNTChangeProductCountReqModel.init(pid: pid, buyCount: Int(number) , Selectpids: [pid])
        XQSMCartNetwork.changeProductCount(reqModel).subscribe(onNext: { (resModel) in

            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }

            self.cartModel = resModel.CartInfo
//            self.reloadUI()
            self.confirmOrder()

        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
        
    }
    
    
}


