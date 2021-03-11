//
//  AppDelegate.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

#if DEBUG
import CocoaDebug
#endif

import XQTencent
import XQWechat
import IQKeyboardManager


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TencentLoginDelegate, XQWebchatDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 防止重签名
        if let bundleIdentifier = Bundle.main.bundleIdentifier, bundleIdentifier != "com.miacid.catwxq" {
            exit(0)
        }
        let iqManager = IQKeyboardManager.shared()
        iqManager.isEnabled = true
        
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMaximumDismissTimeInterval(1.5)
        
        XQSMLocation.register()
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        DK_TimerManager.shared.startTimer()
//        #if DEBUG
//        UserDefaults.standard.setValue(false, forKey: "ac_xq_launch")
//        #endif
        
        if UserDefaults.standard.bool(forKey: "ac_xq_launch") {
            self.normalRootVC()
        }else {
            self.launchRootVC()
        }
        
        // 这里判断一下，如果已经不是第一次打开就 normal
//        self.normalRootVC()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification_TokenOverdue(_:)), name: XQSM_Notification_TokenOverdue, object: nil)
        
        #if DEBUG
        CocoaDebug.enable()
        self.pgy()
        #endif
        
        self.registerQQ()
        self.registerWechat()
        
        
        return true
    }
    
    func launchRootVC() {
        let vc = AC_XQLaunchVC()
        vc.contentView.hideCallback = { [unowned self] in
            self.normalRootVC()
            UserDefaults.standard.set(true, forKey: "ac_xq_launch")
        }
        self.window?.rootViewController = vc
    }
    
    func normalRootVC() {
        
        self.window?.rootViewController = XQACTBC()
        
        if XQSMBaseNetwork.default.token.count == 0, let rootViewController = self.window?.rootViewController {
            AC_XQLoginVC.presentLogin(rootViewController)
        }
    }
    
    #if DEBUG
    func pgy() {
        
        PgyUpdateManager.sharedPgy()?.start(withAppId: "8c2582a7a2834bbff5cb46544193e27b")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            PgyUpdateManager.sharedPgy()?.checkUpdate()
        }
    }
    #endif
    
    /// 注册微信
    private let qqAppId = "1110706972"
    private func registerQQ() {
        /// QQ
        /// APP ID:1110706972
        /// APP KEY: rcDDby80zpPTATWJ
        
        XQTencentOpenApi.register(withAppId: qqAppId)
        XQTencentOpenApi.manager().loginDelegate = self
        print("qq初始化")
    }
    
    /// 注册微信
    private let wechatAppId = "wxb26025bf2ce5c88b"
    private func registerWechat() {
        
        /// 微信
        /// AppID：wxb26025bf2ce5c88b
        /// AppSecret： cfb8aa59cafee014bb08652ae88163dc
        
        #if DEBUG
        WXApi.startLog(by: .detail) { (log) in
            print("微信log: ", log)
        }
        #endif
        
        
        if XQWechat.register(withAppId: self.wechatAppId, universalLink: "https://cx.gdmiacid.com/", appSecret: "cfb8aa59cafee014bb08652ae88163dc") {
            //        if WXApi.registerApp("gh_d23b944c26ec", universalLink: "https://app.beeplustea.com") {
            print("初始化微信成功")
            XQWechat.manager().delegate = self
        }else {
            print("初始化微信失败")
        }
        
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        #if DEBUG
        print(self.classForCoder, #function, url)
        #endif
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        #if DEBUG
        print(self.classForCoder, #function, url, options)
        #endif
        
        if url.host ?? "" == "pay" || url.absoluteString.hasPrefix(self.wechatAppId) {
            
            //            WXApi.handleOpen(url, delegate: self)
            XQWechat.handleOpenURL(with: url, options: options)
            
        }else if url.absoluteString.hasPrefix("tencent\(self.qqAppId)") {
            
            XQTencentOpenApi.handleOpenURL(with: url, options: options)
            
        }else if url.host ?? "" == "safepay" {
            
            // 跳转支付宝钱包进行支付，处理支付结果
            AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                
                let res = resultDic as? Dictionary<String, Any>
                
                let resultModel = XQSMAlipayAppPayResultModel.deserialize(from: res)
                print(res ?? "没有数据")
                
                if var resultModel = resultModel {
                    
                    if resultModel.resultStatus == 9000 {
                        let appPayResultDataModel = XQSMAlipayAppPayResultDataModel.deserialize(from: resultModel.result)
                        resultModel.resultModel = appPayResultDataModel
                        
                        if appPayResultDataModel?.alipay_trade_app_pay_response?.code == "10000" {
                            print("支付成功结果: ", appPayResultDataModel?.toJSON() ?? "没有json")
                            NotificationCenter.default.post(name: sm_alipay_succeed_notificationName, object: resultModel)
                        }else {
                            NotificationCenter.default.post(name: sm_alipay_failure_notificationName, object: resultModel)
                        }
                    }else if resultModel.resultStatus == 6001 {
                        // 用户点击取消了
                    }else {
                        NotificationCenter.default.post(name: sm_alipay_failure_notificationName, object: resultModel)
                    }
                    
                }else {
                    NotificationCenter.default.post(name: sm_alipay_failure_notificationName, object: resultModel)
                }
                
                print("支付宝处理结果: ", resultDic ?? "没有", res ?? "没有", resultModel?.result ?? "没有")
                
            })
            
        }
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        #if DEBUG
        print(self.classForCoder, #function, userActivity)
        
        if #available(iOS 13.0, *) {
            print("wxq: ",
                  userActivity.activityType,
                  userActivity.title ?? "userinfo 没有",
                  userActivity.userInfo ?? "userinfo 没有数据",
                  userActivity.requiredUserInfoKeys ?? "requiredUserInfoKeys 没有",
                  userActivity.needsSave,
                  userActivity.webpageURL ?? "webpageURL 没有数据",
                  userActivity.referrerURL ?? "referrerURL 没有数据",
                  userActivity.expirationDate ?? "expirationDate 没有数据",
                  userActivity.keywords,
                  userActivity.supportsContinuationStreams,
                  userActivity.targetContentIdentifier ?? "targetContentIdentifier 没有",
                  userActivity.isEligibleForHandoff,
                  userActivity.isEligibleForSearch,
                  userActivity.isEligibleForPublicIndexing,
                  userActivity.isEligibleForPrediction,
                  userActivity.persistentIdentifier ?? "persistentIdentifier 没有")
            
            /// NSUserActivityTypeBrowsingWeb
            ///  nil
            ///  [:]
            ///  requiredUserInfoKeys 没有
            ///  true
            ///  https://cx.gdmiacid.com/wxappid/oauth?code=xaa&state=xq_wf_wechatAut
            ///  referrerURL 没有数据
            ///  expirationDate 没有数据
            ///  expirationDate ??
            ///  []
            ///  false
            ///  targetContentIdentifier 没有
            ///  true
            ///  false
            ///  false
            ///  false
            ///  targetContentIdentifier 没有
        }
        
        #endif
        // 微信跳转回来, webpageURL 里面会带有 微信的appid
        // https://申请填的域名/微信的appid/oauth?code=授权code&state=回执码(就是你传过去的码)
        if let urlStr = userActivity.webpageURL?.absoluteString,
            urlStr.contains(self.wechatAppId),
            let m = XQWechat.manager() as? WXApiDelegate {
            return WXApi.handleOpenUniversalLink(userActivity, delegate: m)
        }
        
        
        return true
    }
    
    // MARK: - notification
    
    @objc func notification_TokenOverdue(_ notification: Notification) {
        if let _ = self.window?.rootViewController?.presentedViewController as? AC_XQLoginVC {
            // 已经在login界面了
            return
        }
        
        if let vc = self.window?.rootViewController {
            AC_XQLoginVC.presentLogin(vc)
        }
        
    }
    
    
    // MARK: - TencentLoginDelegate
    func tencentDidLogin() {
        print("wxq: ", XQTencentOpenApi.manager().tAuth.openId ?? "没有")
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        // 取消登录
        //        SVProgressHUD.showError(withStatus: "网络错误")
    }
    
    func tencentDidNotNetWork() {
        SVProgressHUD.showError(withStatus: "网络错误")
    }
    
    // MARK: - XQWebchatDelegate
    
    func wechatReceivePay(with resp: PayResp) {
        if resp.errCode == WXSuccess.rawValue {
            NotificationCenter.default.post(name: sm_wechat_succeed_notificationName, object: resp)
        }else if resp.errCode == WXErrCodeUserCancel.rawValue {
            // 点击取消
        }else {
            NotificationCenter.default.post(name: sm_wechat_failure_notificationName, object: resp)
        }
    }
    
    func wechatReceiveAut(withCode code: String, errCode: Int32) {
        print(#function, code, errCode)
    }
    
    
}

