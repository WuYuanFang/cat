//
//  AC_XQWashProtectOrderVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SwiftDate
import SVProgressHUD

/// 预约洗护下单
class AC_XQWashProtectOrderVC: XQACBaseVC, AC_XQRealNameProtocol, AC_XQUserInfoProtocol {
    
    /// 附近商店信息
    var ShopInfo: XQSMNTToShopIndexModel?
    
    /// 预约时间
    var appointmentDate: Date?
    
    /// 猫
    var petModel: XQSMNTGetMyPetListUserPetInfoModel?
    
    /// 选中的单品
    var singleProductArr = [XQSMNTToProductTinnyV2Model]()
    
    /// 选中的套餐
    var packageProductModel: XQSMNTToShopPdPackageModel?
    
    /// 优惠券
    var couponModel: XQSMNTCouponListModel?

    let contentView = AC_XQWashProtectOrderView()
    
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
        
        self.reloadHeaderUI()
        self.reloadInfoUI()
        
        self.calculation()
        
        // 默认隐藏 vip
        self.contentView.vipView.reloadUI(.service)
        self.contentView.vipView.callback = { [unowned self] in
            self.calculation()
        }
        
        self.contentView.rnDiscountView.toRealNameCallback = { [unowned self] in
            self.realNameAuthentication { [unowned self] in
                self.refreshUserInfo { [unowned self] (resModel) in
                    self.contentView.rnDiscountView.reloadUI()
                }
            }
        }
        
        self.contentView.rnDiscountView.changeSelectCallback = { [unowned self] in
            self.calculation()
        }
        
        self.contentView.couponView.xq_addTap { [unowned self] (sender) in
            self.presentSelectCoupon()
        }
        
        self.contentView.payView.payBtn.xq_addTap { [unowned self] (sender) in
            self.payOrderBefore()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.rnDiscountView.reloadUI()
        
        
    }
    
    func reloadHeaderUI() {
        self.contentView.headerView.imgView.sd_setImage(with: self.petModel?.PhotoWithAddress.sm_getImgUrl())
        
        self.contentView.headerView.titleLab.text = self.ShopInfo?.Name ?? ""
        self.contentView.headerView.addressLab.text = "\(self.ShopInfo?.Address ?? "")(距您\(self.ShopInfo?.TheDistance ?? 0)km)"
    }
    
    func reloadInfoUI() {
        
        var serverMoney: Float = 0
        self.contentView.infoView.serverView.desLab.text = self.packageProductModel?.PackageName ?? ""
        serverMoney += self.packageProductModel?.NowPrice ?? 0
        
        var desDetailStr = ""
        for item in self.singleProductArr {
            if desDetailStr.count == 0 {
               desDetailStr = item.Name
            }else {
                desDetailStr += "\n\(item.Name)"
            }
            serverMoney += item.NowPrice
        }
        self.contentView.infoView.serverView.desDetailLab.text = desDetailStr
        
//        self.contentView.infoView.serverView.contentLab.text = "¥\(serverMoney)"
        
        self.contentView.infoView.timeView.contentLab.text = self.appointmentDate?.xq_toString("MM月dd日 HH:mm")
        var endTime = self.appointmentDate
        if let tmpMData = self.appointmentDate {
            endTime = tmpMData + 1.hours + 30.minutes
        }
        self.contentView.infoView.endTimeView.contentLab.text = endTime?.xq_toString("MM月dd日 HH:mm")
        
    }
    
    func getPdList() -> [XQSMNTTinnyOrderProductInfoModel] {
        var productInfoModelArr = [XQSMNTTinnyOrderProductInfoModel]()
        for item in self.singleProductArr {
            let pModel = XQSMNTTinnyOrderProductInfoModel.init(Id: item.Id)
            productInfoModelArr.append(pModel)
        }
        return productInfoModelArr
    }
    
    
    /// 计算价格
    @discardableResult
    func calculation(_ isPay:Bool = false) -> XQSMNTBeginOrderReqModel? {
        
        if XQSMBaseNetwork.default.token.count == 0 {
            return nil
        }
        
        guard let petModel = self.petModel else {
            return nil
        }
        
        // 商店 id
        let shopId = self.ShopInfo?.Id ?? 0
        
        // 预约时间
        let startTime = self.appointmentDate?.xq_toString("yyyy-MM-dd HH:mm:ss")
        
        if startTime?.count ?? 0 == 0 {
            return nil
        }
        
        let productInfoModelArr = self.getPdList()
        
        var reqModel = XQSMNTBeginOrderReqModel.init(ShopId: shopId,
                                                     PetId: petModel.Id,
                                                     SubscribeTime: startTime ?? "",
                                                     Phone: "",
                                                     Remark: "",
                                                     PdList: productInfoModelArr,
                                                     SendAddress: "",
                                                     SendX: "",
                                                     SendY: "",
                                                     SendBackAddress: "",
                                                     SendBackX: "",
                                                     SendBackY: "",
                                                     ManName: "",
                                                     PackageId: String(packageProductModel?.Id ?? 0),
                                                     NeedSend: false,
                                                     NeedSendBack: false,
                                                     ChoseUserRank: self.contentView.vipView.rightBtn.isSelected,
                                                     CouponId: self.couponModel?.CouponId ?? 0,
                                                     ChoseTrueMan: self.contentView.rnDiscountView.rightBtn.isSelected)
        
        XQSMToShopNetwork.preOrder(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            if isPay {
                self.payOrder(reqModel: &reqModel)
            }
            self.contentView.payView.moneyLab.text = "合计 ¥\(resModel.TotalPrice.xq_removeDecimalPointZero())"
            self.contentView.infoView.serverView.contentLab.text = "¥\(resModel.TotalPrice.xq_removeDecimalPointZero())"
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
        return reqModel
    }
    
    /// 选择优惠券
    func presentSelectCoupon() {
        print("选择优惠券")
        guard let packageProductModel = self.packageProductModel else {
            SVProgressHUD.showInfo(withStatus: "获取套餐信息失败")
            return
        }
        let vc = AC_XQFosterCouponVC()
        
        let pdList = self.getPdList()
        
        vc.couponInputReqModel = XQSMNTShowToOrderCanUseCouponInputReqModel.init(PdList: pdList, PackageId: packageProductModel.Id)
        
        vc.callback = { [unowned self] (cModel) in
            
            self.couponModel = cModel
            self.contentView.couponView.reloadUI(cModel)
            self.calculation()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getCartOrderProduInfoModelArr() -> [XQSMNTCartOrderProduInfoModel] {
        
        var produInfos = [XQSMNTCartOrderProduInfoModel]()
        for item in self.singleProductArr {
            let orderProduInfoModel = XQSMNTCartOrderProduInfoModel.init(pId: item.Id, buyCount: 1)
            produInfos.append(orderProduInfoModel)
        }
        
        if let packageProductModel = self.packageProductModel {
            let orderProduInfoModel = XQSMNTCartOrderProduInfoModel.init(pId: packageProductModel.Id, buyCount: 1)
            produInfos.append(orderProduInfoModel)
        }
        
        return produInfos
    }
    
    /// 下单
    func payOrderBefore() {
        
        if self.contentView.nameView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请填写姓名")
            return
        }
        
        if self.contentView.phoneView.tf.text?.count ?? 0 != 11 {
            SVProgressHUD.showInfo(withStatus: "请填写正确电话号码")
            return
        }
        self.calculation(true)
//        guard var reqModel = self.calculation() else {
//            return
//        }
    }
    func payOrder(reqModel:inout XQSMNTBeginOrderReqModel) {
        
        self.view.endEditing(true)
        
        reqModel.ManName = self.contentView.nameView.tf.text ?? ""
        reqModel.Phone = self.contentView.phoneView.tf.text ?? ""
        reqModel.Remark = self.contentView.remarkTV.text
        
        SVProgressHUD.show(withStatus: nil)
        XQSMToShopNetwork.beginOrder(reqModel).subscribe(onNext: { (resModel) in

            SVProgressHUD.dismiss()
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }

            
            AC_XQAlertSelectPayView.show(String(resModel.OId), money: resModel.TotalPrice, payType: .appointment, callback: { (payId, payType) in
                print("点击了支付: ", payType)
                
                self.presentOrderDetail(0)
//                if let id = Int(payId) {
//                    self.presentOrderDetail(id)
//                }
                
            }) {
                print("隐藏了")
                self.presentOrderDetail(resModel.OId)
//                self.navigationController?.popViewController(animated: true)
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    func presentOrderDetail(_ id: Int) {
        
        weak var nc = self.navigationController
        nc?.qmui_popToRootViewController(animated: false, completion: {
            let vc = AC_XQOrderListVC()
            vc.selIndex = 1
            vc.selServerIndex = 0
            nc?.pushViewController(vc, animated: true)
        })
//        SVProgressHUD.show(withStatus: nil)
//        XQSMToShopOrderNetwork.getToOrderById(id).subscribe(onNext: { (resModel) in
//
//            if resModel.ErrCode != .succeed {
//                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
//                return
//            }
//
//            SVProgressHUD.dismiss()
//
//            nc?.popViewController(animated: false)
//
//            nc?.qmui_pushViewController(AC_XQOrderListVC(), animated: true, completion: {
//                let vc = AC_XQWashProtectOrderDetailVC()
//                vc.fosterModel = resModel.ToOrderItem
//                nc?.pushViewController(vc, animated: true)
//            })
//
//        }, onError: { (error) in
//            SVProgressHUD.showError(withStatus: error.localizedDescription)
//        }).disposed(by: self.disposeBag)
    }
    
}
