//
//  AC_XQPhoneLoginVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 手机号码登录
/// 手机号登录, 也是注册
class AC_XQPhoneLoginVC: XQACBaseVC, XQThirdPartyLoginProtocol {

    var contentView = AC_XQLoginView()
    
    /// 如果有类型, 代表是某个第三方授权没有绑定账号，跳到这里绑定
    var loginType: XQSMNTUserAliPayLoginReqModel.LoginType = .unkonw
    
    /// 第三方平台的唯一id
    var openId = ""
    
    
    var firstVC = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.isHidden = true
        self.xq_view.isHidden = true
        
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.headerView.titleLab.text = "Meow！"
        self.contentView.headerView.phoneLoginMode()
        
        if self.firstVC {
            if self.openId.count == 0 {
                let acc = UserDefaults.standard.string(forKey: "xq_AC_XQLoginVC_acc")
                self.contentView.headerView.accTF.text = acc
            }
        }else {
            self.contentView.headerView.otherBtn.isHidden = true
            self.contentView.headerView.visitorBtn.isHidden = true
        }
        
        // 游客登录
        self.contentView.headerView.visitorBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            AC_XQPhoneLoginVC.xq_loginDismiss(self)
        }
        
        // 密码登录
        self.contentView.headerView.otherBtn.setTitle("密码登录", for: .normal)
        self.contentView.headerView.otherBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            let vc = AC_XQLoginVC()
            vc.firstVC = false
            self.present(vc, animated: true, completion: nil)
        }
        
        self.contentView.headerView.codeBtn?.xq_addEvent(.touchUpInside, callback: { [unowned self] (sender) in
            print("获取验证码")
            self.getCode()
        })
        
        self.contentView.bottomView.btn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.registerPhone()
        }
        
        self.thirdPartyLogin_addTap()
        
        if self.loginType != .unkonw {
            self.contentView.bottomView.qqBtn.isHidden = true
            self.contentView.bottomView.wechatBtn.isHidden = true
            self.contentView.bottomView.desView.isHidden = true
            self.contentView.headerView.titleLab.text = "绑定第三方平台"
            
            if self.openId.count == 0 {
                SVProgressHUD.showInfo(withStatus: "未获取到第三方平台的ID")
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.contentView.headerView.codeBtn?.xq_cancelTimer()
    }
    
    /// 获取验证码
    private func getCode() {
        self.view.endEditing(true)
        
        if self.contentView.headerView.accTF.text?.count != 11 {
            SVProgressHUD.showInfo(withStatus: "请输入正确手机号码")
            return
        }
        
        let reqModel = XQSMNTSendMsgReqModel.init(self.contentView.headerView.accTF.text ?? "")
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.sendMsg(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "短信已发出")
            self.contentView.headerView.codeBtn?.xq_sendCode()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    private func registerPhone() {
        
        self.view.endEditing(true)
        
        if self.contentView.headerView.accTF.text?.count != 11 {
            SVProgressHUD.showInfo(withStatus: "请输入正确手机号码")
            return
        }
        
        if self.contentView.headerView.codeTF.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请输入不小于6位数密码")
            return
        }
        
        /// WechatOpenId (string, optional): 微信OpenId ,
        var WechatOpenId = ""
        
        /// QQOpenId (string, optional): QQOpenId ,
        var QQOpenId = ""
        
        /// AliPayOpenId (string, optional): 支付宝Id ,
        var AliPayOpenId = ""
        
        /// AppleOpenId (string, optional): Apple Id ,
        var AppleOpenId = ""
        
        switch self.loginType {
            
        case .unkonw:
            break
            
        case .qq:
            QQOpenId = self.openId
            
        case .alipay:
            AliPayOpenId = self.openId
            
        case .wechat:
            WechatOpenId = self.openId
            
        case .apple:
            AppleOpenId = self.openId
            
        default:
            break
        }
        
        
        let reqModel = XQSMNTUserRegistReqModel.init(CheckCode: self.contentView.headerView.codeTF.text ?? "",
                                                     Phone: self.contentView.headerView.accTF.text ?? "",
                                                     Password: "111111",
                                                     Uid: 0,
                                                     WechatOpenId: WechatOpenId,
                                                     QQOpenId: QQOpenId,
                                                     AliPayOpenId: AliPayOpenId,
                                                     AppleOpenId: AppleOpenId)
            
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.regist(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            UserDefaults.standard.setValue(reqModel.Phone, forKey: "xq_AC_XQLoginVC_acc")
            UserDefaults.standard.setValue(reqModel.Password, forKey: "")
            
            SVProgressHUD.dismiss()
            XQSMBaseNetwork.default.token = resModel.Token
            
            AC_XQPhoneLoginVC.xq_loginDismiss(self)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    static func xq_loginDismiss(_ viewController: UIViewController) {
        
        DK_TimerManager.shared.startTimer()
        if let vc = viewController.presentingViewController?.presentingViewController,
            let _ = viewController.presentingViewController?.presentingViewController?.presentingViewController {
            weak var weakVC = vc
            vc.dismiss(animated: false) {
                weakVC?.dismiss(animated: true, completion: nil)
            }
        }else if let presentingViewController = viewController.presentingViewController,
            let _ = viewController.presentingViewController?.presentingViewController {
            weak var vc = presentingViewController
            viewController.dismiss(animated: false) {
                vc?.dismiss(animated: true, completion: nil)
            }
        }else {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - XQThirdPartyLoginProtocol
    
    /// 登录成功
    func thirdPartyLoginSucceed(_ token: String) {
        AC_XQPhoneLoginVC.xq_loginDismiss(self)
    }
    
}





