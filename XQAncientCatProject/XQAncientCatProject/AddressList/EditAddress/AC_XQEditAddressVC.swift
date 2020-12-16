//
//  AC_XQEditAddressVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import XQAlert

class AC_XQEditAddressVC: XQACBaseVC {

    
    let contentView = AC_XQEditAddressView()
    
    /// 如存在, 表示编辑
    var oModel: XQSMNTShopAddressDtoModel?
    
    private var provinceModel: XQAlertSelectAddressViewModel?
    private var cityModel: XQAlertSelectAddressViewModel?
    private var areaModel: XQAlertSelectAddressViewModel?
    
    typealias AC_XQEditAddressVCCallback = (_ isDelete: Bool) -> ()
    var refreshCallback: AC_XQEditAddressVCCallback?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(respondsToSave)))

        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.addressView.xq_addTap { [unowned self] (gesture) in
            self.view.endEditing(true)
            XQAlertSelectAddressView.show { [unowned self] (pModel, cityModel, areaModel) in
                self.provinceModel = pModel
                self.cityModel = cityModel
                self.areaModel = areaModel
                self.contentView.addressView.tf.text = "\(pModel.name) \(cityModel.name) \(areaModel.name)";
            }
        }
        
        
        self.contentView.deleteBtn.isHidden = true
        self.contentView.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.respondsToDelete()
        }
        
        if let oModel = self.oModel {
            self.contentView.deleteBtn.isHidden = false
            
            self.contentView.nameView.tf.text = oModel.Consignee
            self.contentView.phoneView.tf.text = oModel.Mobile
            self.contentView.addressView.tf.text = "\(oModel.ProvinceName) \(oModel.CityName) \(oModel.AreaName)"
            self.contentView.detailAddressView.tv.text = oModel.Address
            self.contentView.xq_switch.isOn = oModel.IsDefault
        }
        
        
    }
    
    // MARK: - responds
    
    func respondsToDelete() {
        
        XQSystemAlert.alert(withTitle: "确定要删除该地址吗？", message: nil, contentArr: ["删除"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            self.view.endEditing(true)
            let reqModel = XQSMNTDeleteShopAddressReqModel.init(SaId: self.oModel?.SaId ?? "")
            SVProgressHUD.show(withStatus: nil)
            XQSMAddressNetwork.deleteShopAddress(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                self.refreshCallback?(true)
                self.navigationController?.popViewController(animated: true)
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
    }
    
    @objc func respondsToSave() {
        self.view.endEditing(true)
        
        if self.contentView.nameView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请填写收件人")
            return
        }
        
        if self.contentView.phoneView.tf.text?.count ?? 0 != 11 {
            SVProgressHUD.showInfo(withStatus: "请填写正确手机号")
            return
        }
        
        if self.contentView.detailAddressView.tv.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请填写详细地址")
            return
        }
        
        let isDefault = self.contentView.xq_switch.isOn
        
        
        
        var reqModel = XQSMNTAddAddressDtoReqModel.init(Id: 0,
                                                        Uid: 0,
                                                        RegionId: Int(self.areaModel?.code ?? "0") ?? 0,
                                                        IsDefault: isDefault,
                                                        Alias: "",
                                                        Consignee: self.contentView.nameView.tf.text ?? "",
                                                        Mobile: self.contentView.phoneView.tf.text ?? "",
                                                        ZipCode: "",
                                                        Address: self.contentView.detailAddressView.tv.text ?? "",
                                                        X: "",
                                                        Y: "")
        
        if let oModel = self.oModel {
            
            if self.areaModel == nil {
                // 没有时, 用本身自带的 areaId
                reqModel.RegionId = Int(oModel.AreaId) ?? 0
            }
            
            reqModel.Id = Int(oModel.SaId) ?? 0
            
            SVProgressHUD.show(withStatus: nil)
            XQSMAddressNetwork.editAddress(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "保存成功")
                self.refreshCallback?(false)
                self.navigationController?.popViewController(animated: true)
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
            return
        }
        
        guard let provinceModel = self.provinceModel, let cityModel = self.cityModel, let areaModel = self.areaModel else {
            SVProgressHUD.showInfo(withStatus: "请选择所在地区")
            return
        }
        
        SVProgressHUD.show(withStatus: nil)
        XQSMAddressNetwork.addAddress(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "保存成功")
            self.refreshCallback?(false)
            self.navigationController?.popViewController(animated: true)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
}

//{
//  "Alias" : "",
//  "Id" : 0,
//  "Consignee" : "还有，我",
//  "X" : "",
//  "IsDefault" : false,
//  "ZipCode" : "",
//  "Address" : "，我，我",
//  "Y" : "",
//  "Mobile" : "15007893212",
//  "Uid" : 0,
//  "RegionId" : 130403
//}

//{
//  "Y" : "",
//  "Uid" : 0,
//  "Address" : "哈，www。",
//  "IsDefault" : false,
//  "Mobile" : "15007893212",
//  "X" : "",
//  "Id" : 0,
//  "ZipCode" : "",
//  "Consignee" : "111",
//  "Alias" : "",
//  "RegionId" : 110101
//}
