//
//  AC_XQScoreOrderVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 积分下订单
class AC_XQScoreOrderVC: XQACBaseVC, XQNumberViewDelegate {

    let contentView = AC_XQScoreOrderView()
    
    var productInfoModel: XQSMNTIntegralIntegralProductInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.headerView.xq_addTap { [unowned self] (gesture) in
            self.presentAddressList()
        }
        
        self.contentView.payView.payBtn.xq_addTap { [unowned self] (gesture) in
            self.submitOrder()
        }
        
        self.contentView.infoView.numberView.numberView.delegate = self
        
        self.reloadUI()
        self.getAddressData()
    }
    
    func reloadUI() {
        if let model = self.productInfoModel {
            self.contentView.infoView.reloadUI([model])
        }
        self.confirmOrder()
    }
    
    /// 跳转去选择地址
    func presentAddressList() {
        let vc = AC_XQAddressListVC()
        vc.callback = { [unowned self] (model) in
            self.contentView.headerView.addressModel = model
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    /// 计算订单价格
    func confirmOrder() {
        guard let productInfoModel = self.productInfoModel else {
            return
        }
        
        let result = self.contentView.infoView.numberView.numberView.currentNumber * productInfoModel.ShopPrice
        self.contentView.payView.moneyLab.text = "合计 \(result.xq_removeDecimalPointZero())积分"
    }
    
    /// 下单
    func submitOrder() {
        
        guard let addressModel = self.contentView.headerView.addressModel else {
            SVProgressHUD.showInfo(withStatus: "请选择收货地址")
            return
        }
        
        guard let productInfoModel = self.productInfoModel else {
            SVProgressHUD.showInfo(withStatus: "获取商品信息失败")
            return
        }
        
        let reqModel = XQSMNTIntegralDuihuanApiReqModel.init(PId: productInfoModel.PId,
                                                             ShopAddressId: Int(addressModel.SaId) ?? 0,
                                                             Number: Int(self.contentView.infoView.numberView.numberView.currentNumber),
                                                             Remark: self.contentView.remarkTV.text ?? "")
        
        SVProgressHUD.show(withStatus: nil)
        XQSMIntegralNetwork.addIntegralProductOrder(reqModel).subscribe(onNext: { (resModel) in
            
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "兑换成功")
            self.navigationController?.popViewController(animated: true)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: - XQNumberViewDelegate
        
    func numberView(_ numberView: XQNumberView, number: Float, increaseStatus: Bool) {
        self.confirmOrder()
    }
    
}
