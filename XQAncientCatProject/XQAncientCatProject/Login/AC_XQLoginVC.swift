//
//  AC_XQLoginVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import AuthenticationServices
import SVProgressHUD
import XQTencent
import XQWechat

/// 账号密码登录
class AC_XQLoginVC: XQACBaseVC, XQThirdPartyLoginProtocol {
    
    var contentView = AC_XQLoginView()
    
    var firstVC = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.isHidden = true
        self.xq_view.isHidden = true
        
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        // 手机号码登录
        weak var weakSelf = self
        
        // 老板说要改的
        self.contentView.headerView.titleLab.text = "Meow！"
        
        if self.firstVC {
            
        }else {
            self.contentView.headerView.otherBtn.isHidden = true
            self.contentView.headerView.visitorBtn.isHidden = true
        }
        
        self.contentView.headerView.otherBtn.xq_addEvent(.touchUpInside) { (sender) in
            weakSelf?.present(AC_XQPhoneLoginVC(), animated: true, completion: nil)
        }
        
        self.contentView.bottomView.btn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.login()
        }
        
        // 游客登录
        self.contentView.headerView.visitorBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            AC_XQPhoneLoginVC.xq_loginDismiss(self)
        }
        
        self.thirdPartyLogin_addTap()
        
        
        var acc = UserDefaults.standard.string(forKey: "xq_AC_XQLoginVC_acc")
        
//        #if DEBUG
//        if acc == nil {
//            acc = "15007893212"
//        }
//
//        // 正式版本不存储密码
//        var pwd = UserDefaults.standard.string(forKey: "xq_AC_XQLoginVC_pwd")
//        if pwd == nil {
//            pwd = "123456"
//        }
//        self.contentView.headerView.pwdTF.text = pwd
//        #endif
        
        self.contentView.headerView.accTF.text = acc
        
        
    }
    
    private func login() {
        self.view.endEditing(true)
        
        if self.contentView.headerView.accTF.text?.count != 11 {
            SVProgressHUD.showInfo(withStatus: "请输入正确手机号码")
            return
        }
        
        if self.contentView.headerView.pwdTF.text?.count ?? 0 < 6 {
            SVProgressHUD.showInfo(withStatus: "请输入不小于6位数密码")
            return
        }
        
        let reqModel = XQSMNTUserLoginReqModel.init(Phone: self.contentView.headerView.accTF.text ?? "", Password: self.contentView.headerView.pwdTF.text ?? "", Uid: 0)
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.login(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            UserDefaults.standard.setValue(reqModel.Phone, forKey: "xq_AC_XQLoginVC_acc")
            UserDefaults.standard.setValue(reqModel.Password, forKey: "xq_AC_XQLoginVC_pwd")
            
            SVProgressHUD.dismiss()
            XQSMBaseNetwork.default.token = resModel.Token
            AC_XQPhoneLoginVC.xq_loginDismiss(self)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - XQThirdPartyLoginProtocol
    
    /// 登录成功
    func thirdPartyLoginSucceed(_ token: String) {
        AC_XQPhoneLoginVC.xq_loginDismiss(self)
    }
    
//    private func getUserInfo() {
//
//    }
    
    static func presentLogin(_ vc: UIViewController, animated flag: Bool = true) {
//        let loginVC = AC_XQLoginVC()
        let loginVC = AC_XQPhoneLoginVC()
        loginVC.firstVC = true
        loginVC.modalPresentationStyle = .fullScreen
        vc.present(loginVC, animated: flag, completion: nil)
    }
    
    
    
    
}


protocol XQThirdPartyLoginProtocol {
    
    var contentView: AC_XQLoginView {set get}
    
    /// 登录成功
    func thirdPartyLoginSucceed(_ token: String)
}

extension XQThirdPartyLoginProtocol where Self:XQACBaseVC {
    
    /// 添加点击事件
    func thirdPartyLogin_addTap() {
        self.contentView.bottomView.wechatBtn.xq_addTap { [unowned self] (sender) in
//            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
            
            XQWechat.manager().sendAutInfo { [unowned self] (code, errCode) in
                if errCode == WXSuccess.rawValue {
                    self.wechatLogin(withCode: code)
                }else if errCode != WXErrCodeUserCancel.rawValue {
                    SVProgressHUD.showError(withStatus: "授权失败")
                }
            }
            
        }
        
        self.contentView.bottomView.qqBtn.xq_addTap { [unowned self] (sender) in
//            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
            XQTencentOpenApi.manager().sendAutInfo(withPermissionsArr: [kOPEN_PERMISSION_GET_USER_INFO], callback: { [unowned self] (openId, errcode) in
                if errcode == .succeed {
                    self.xq_tpLogin(withOpenId: openId, loginType: .qq)
                }else if errcode != .cancel {
                    SVProgressHUD.showError(withStatus: "授权失败")
                }
            })
        }
    }
    
    private func wechatLogin(withCode code: String) {
        SVProgressHUD.show(withStatus: nil)
        XQWechat.manager().getTokenWithCode(code, succeed: { (respondsData) in
            
            if let respondsData = respondsData as? Dictionary<String, Any>, let openId = respondsData["openid"] as? String {
                
                self.xq_tpLogin(withOpenId: openId, loginType: .wechat)
                
            }else {
                SVProgressHUD.showError(withStatus: "获取微信信息失败")
            }
            
            //            {
            //                "access_token" = "";
            //                "expires_in" = 7200;
            //                openid = "xxx";
            //                "refresh_token" = "";
            //                scope = "snsapi_userinfo";
            //                unionid = "";
            //            }
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    /// 第三方登录
    func xq_tpLogin(withOpenId openId: String, loginType: XQSMNTUserAliPayLoginReqModel.LoginType) {
        SVProgressHUD.show(withStatus: nil)
        let reqModel = XQSMNTUserAliPayLoginReqModel.init(openId: openId, type: loginType)
        XQSMUserNetwork.aliPayLogin(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode == .tokenOverdue {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                let vc = AC_XQPhoneLoginVC()
                vc.loginType = loginType
                vc.openId = openId
                self.present(vc, animated: true, completion: nil)
                return
            }else if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            UserDefaults.standard.setValue("", forKey: "xq_AC_XQLoginVC_pwd")
            
            XQSMBaseNetwork.default.token = resModel.Token
            
            SVProgressHUD.dismiss()
            self.thirdPartyLoginSucceed(resModel.Token)
            
            
            
        }, onError: { (error) in
            
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            
        }).disposed(by: self.disposeBag)
    }
    
    
}

