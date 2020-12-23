//
//  AC_XQFosterOrderVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/2.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 寄养确认订单
class AC_XQFosterOrderVC: XQACBaseVC, AC_XQRealNameProtocol, AC_XQUserInfoProtocol {
    
    var reqModel: XQACNTAddFosterReqModel?
    
    /// 附近商店信息
    var ShopInfo: XQSMNTToShopIndexModel?
    
    /// 猫舍
    var catdormitoryModel: XQACNTGM_CatdormitoryModel?
    
    /// 猫
    var petModel: XQSMNTGetMyPetListUserPetInfoModel?
    
    /// 选中的食物列表
    var foodList: [XQACNTGM_FosterShopModel]?
    
    /// 计算价格model
    var calculationResModel: XQACNTFosterCalculationResModel?
    
    /// 优惠券
    var couponModel: XQSMNTCouponListModel?

    let contentView = AC_XQFosterOrderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setCenterTitle("确认订单")
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.headerView.imgView.sd_setImage(with: self.petModel?.PhotoWithAddress.sm_getImgUrl())
        self.contentView.headerView.titleLab.text = self.ShopInfo?.Name ?? ""
        self.contentView.headerView.addressLab.text = "\(self.ShopInfo?.Address ?? "")(距您\(self.ShopInfo?.TheDistance ?? 0)km)"
        
        
        if let reqModel = self.reqModel {
            
            self.contentView.infoView.serverView.desLab.text = "寄养(\(self.catdormitoryModel?.DormitoryName ?? ""))"
            self.contentView.infoView.serverView.contentLab.text = "¥\(self.catdormitoryModel?.dayMoney ?? 0)/天"
            
            if reqModel.IsFeed, let foodList = self.foodList, foodList.count != 0 {
                
                var foodStr = ""
                var foodMoney: Float = 0
                for item in foodList {
                    if foodStr.count == 0 {
                        foodStr += item.Name
                    }else {
                        foodStr += "\n\(item.Name)"
                    }
                    
                    foodMoney += item.Money
                }
                
                self.contentView.infoView.foodView.desLab.text = foodStr
                self.contentView.infoView.foodView.contentLab.text = "¥\(foodMoney)"
                
            }else {
                self.contentView.infoView.noFood()
            }
            
            if let date = reqModel.StartTime.xq_toDateYMD() {
                self.contentView.infoView.timeView.contentLab.text = date.xq_toString("yyyy年MM月dd日")
            }
            
            self.contentView.infoView.dayView.contentLab.text = "\(reqModel.Day)天"
        }
        
        self.contentView.payView.payBtn.xq_addTap { [unowned self] (sender) in
            self.payOrder()
        }
        
        self.contentView.couponView.xq_addTap { [unowned self] (sender) in
            self.presentSelectCoupon()
        }
        
        // 默认隐藏 vip
        self.contentView.vipView.reloadUI(.otherService)
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
        
        self.calculation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentView.rnDiscountView.reloadUI()
    }
    
    /// 选择优惠券
    func presentSelectCoupon() {
        print("选择优惠券")
        guard let calculationResModel = self.calculationResModel else {
            SVProgressHUD.showInfo(withStatus: "获取订单信息失败")
            self.calculation()
            return
        }
        
        let vc = AC_XQFosterCouponVC()
        vc.orderMoney = calculationResModel.Totalamount
        
        vc.callback = { [unowned self] (cModel) in
            self.couponModel = cModel
            self.contentView.couponView.reloadUI(cModel)
            if let cModel = cModel {
                self.reqModel?.CouponId = String(cModel.CouponId)
            }else {
                self.reqModel?.CouponId = ""
            }
            
            self.calculation()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 计算订单价格
    func calculation() {
        
        self.reqModel?.ChoseTrueMan = self.contentView.rnDiscountView.rightBtn.isSelected
        self.reqModel?.Discount = self.contentView.vipView.rightBtn.isSelected
        
        guard let reqModel = self.reqModel else {
            return
        }
        
        XQACFosterNetwork.fosterCalculation(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.calculationResModel = resModel
            self.contentView.payView.moneyLab.text = "合计 ¥\(resModel.Totalamount)"
            
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 下单
    func payOrder() {
        
        if self.contentView.nameView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请填写姓名")
            return
        }
        
        if self.contentView.phoneView.tf.text?.count ?? 0 != 11 {
            SVProgressHUD.showInfo(withStatus: "请填写正确手机号码")
            return
        }
        
        self.reqModel?.Name = self.contentView.nameView.tf.text ?? ""
        self.reqModel?.Mobile = self.contentView.phoneView.tf.text ?? ""
        self.reqModel?.Remarks = self.contentView.remarkTV.text
        
        self.reqModel?.ChoseTrueMan = self.contentView.rnDiscountView.rightBtn.isSelected
        self.reqModel?.Discount = self.contentView.vipView.rightBtn.isSelected
        
        guard let reqModel = self.reqModel else {
            return
        }
        
        self.view.endEditing(true)
        
        SVProgressHUD.show(withStatus: nil)
        XQACFosterNetwork.AddFoster(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            
            // 这里应该先弹框, 去支付
            AC_XQAlertSelectPayView.show(String(resModel.oid), money: 0, payType: .foster, callback: { (payId, payType) in
                
                if let id = Int(payId) {
                    self.presentOrderDetail(id)
                }
                
            }) {
                self.presentOrderDetail(resModel.oid)
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    func presentOrderDetail(_ id: Int) {
        weak var nc = self.navigationController
        SVProgressHUD.show(withStatus: nil)
        XQACFosterNetwork.fosterDetails(id).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            
            nc?.popViewController(animated: false)
            nc?.qmui_pushViewController(AC_XQOrderListVC(), animated: true, completion: {
                let vc = AC_XQFosterOrderDetailVC()
                vc.fosterModel = resModel.model
                nc?.pushViewController(vc, animated: true)
            })
            
            
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }

}
