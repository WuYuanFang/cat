//
//  AC_XQEditPasswordVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/20.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 修改密码
class AC_XQEditPasswordVC: XQACBaseVC {
    
    let contentView = AC_XQEditPasswordView()
    
    private var _phone: String?
    /// 电话号码
    /// 如外部传进来, 那么这里就不给用户去改手机号码
    var phone: String? {
        set {
            _phone = newValue
            if let phone = _phone {
                self.contentView.phoneView.tf.text = phone
                self.contentView.phoneView.tf.isUserInteractionEnabled = false
                self.contentView.phoneView.tf.nextNavigationField = nil
                self.contentView.xq_showTextField_Navigation()
            }
        }
        get {
            return _phone
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.saveBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.editPassword()
        }
        
        self.contentView.codeView.btn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.getCode()
        }
    }
    
    /// 获取验证码
    func getCode() {
        self.view.endEditing(true)
        
        if self.contentView.phoneView.tf.text?.count != 11 {
            SVProgressHUD.showInfo(withStatus: "请输入正确手机号码")
            return
        }
        
        let reqModel = XQSMNTSendMsgReqModel.init(self.contentView.phoneView.tf.text ?? "")
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.sendMsg(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "短信已发出")
            self.contentView.codeView.btn.xq_sendCode()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 修改密码
    func editPassword() {
        self.view.endEditing(true)
        
        if self.contentView.phoneView.tf.text?.count != 11 {
            SVProgressHUD.showInfo(withStatus: "请输入正确手机号码")
            return
        }
        
        if self.contentView.passwordView.tf.text?.count ?? 0 < 6 {
            SVProgressHUD.showInfo(withStatus: "请输入不小于6位数密码")
            return
        }
        
        if self.contentView.codeView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入验证码")
            return
        }
        
        if self.contentView.passwordView.tf.text != self.contentView.againPasswordView.tf.text {
            SVProgressHUD.showInfo(withStatus: "两次密码不一致")
            return
        }
        
        
        let reqModel = XQSMNTUserResetPasswordRecModel.init(Code: self.contentView.codeView.tf.text ?? "",
                                                            Phone: self.contentView.phoneView.tf.text ?? "",
                                                            Password: self.contentView.passwordView.tf.text ?? "",
                                                            RePassword: self.contentView.againPasswordView.tf.text ?? "")
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.resetPassword(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "修改成功")
            self.navigationController?.popViewController(animated: true)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    

}
