//
//  AC_XQShopRefundOrderVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool
import SVProgressHUD
import SwiftRichString

class AC_XQShopRefundOrderVC: XQACBaseVC {
    
    typealias AC_XQShopRefundOrderVCCallback = () -> ()
    var refreshCallback: AC_XQShopRefundOrderVCCallback?
    
    /// 外部传入的列表订单model
    var orderBaseInfoModel: XQSMNTOrderBaseInfoDtoModel?

    let contentView = AC_XQShopRefundOrderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setCenterTitle("申请退款")
        self.xq_navigationBar.titleLab.textColor = .white
        self.xq_navigationBar.backView.setBackImg(with: UIImage.init(named: "back_arrow")?.xq_image(withTintColor: .white))
        
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.init(hex: "#A9C0C2")
        self.xq_navigationBar.contentView.backgroundColor = UIColor.init(hex: "#A9C0C2")
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.commitBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
            
            if let model = self.orderBaseInfoModel {
                
                switch model.OrderState {
                case .confirmed, .inInspection, .inStock:
                    self.refundToOrder()
                    
                case .delivered, .receivedGoods:
                    self.aroundShopRefundOrder()
                    
                default:
                    break
                }
                
            }
            
        }
        
        if let model = self.orderBaseInfoModel?.ProductList?.first {
            self.contentView.headerView.imgView.sd_setImage(with: model.ShowImg.sm_getImgUrl())
            self.contentView.headerView.nameLab.text = model.Name
            self.contentView.headerView.messageLab.text = model.Specs
            self.contentView.headerView.priceLab.text = "¥ \(self.orderBaseInfoModel?.SurplusMoney.xq_removeDecimalPointZero() ?? "")"
            self.contentView.headerView.haveNumberUILayout()
            self.contentView.headerView.numberLab.text = "x\(model.BuyCount)"
        }
        
        
        self.contentView.payTimeView.messageLab.text = self.orderBaseInfoModel?.PayTime
        self.contentView.orderView.messageLab.text = self.orderBaseInfoModel?.OSN
        self.contentView.moneyView.messageLab.text = "¥\(self.orderBaseInfoModel?.SurplusMoney.xq_removeDecimalPointZero() ?? "")"
    }
    
    
    
    func refundToOrder() {
        
        let reqModel = XQSMNTOrderRequestRefundReqModel.init(OId: self.orderBaseInfoModel?.Oid ?? 0, Reson: self.contentView.reasonView.tv.text)
        SVProgressHUD.show(withStatus: nil)
        XQSMOrderNetwork.requestRefund(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            self.refreshCallback?()
            self.navigationController?.popViewController(animated: true)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    func aroundShopRefundOrder() {
        let reqModel = XQSMNTOrderRequestRefundReqModel.init(OId: self.orderBaseInfoModel?.Oid ?? 0, Reson: self.contentView.reasonView.tv.text)
        SVProgressHUD.show(withStatus: nil)
        XQSMOrderNetwork.aroundShopRefundOrder(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "提交成功")
            self.refreshCallback?()
            self.navigationController?.popViewController(animated: true)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    
}
