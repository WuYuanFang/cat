//
//  AC_XQAlertSelectPayView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/20.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import SVProgressHUD
import RxSwift

let sm_alipay_succeed_notificationName = NSNotification.Name.init("sm_pay_succeed_notification")
let sm_alipay_failure_notificationName = NSNotification.Name.init("sm_pay_failure_notification")
let sm_wechat_succeed_notificationName = NSNotification.Name.init("sm_wechat_succeed_notificationName")
let sm_wechat_failure_notificationName = NSNotification.Name.init("sm_wechat_failure_notificationName")

class AC_XQAlertSelectPayView: UIView {
    
    /// 显示支付弹框
    /// - Parameters:
    ///   - payId: 支付id(订单id)
    ///   - money: 支付的钱
    ///   - payType: 支付那种类型(商城，寄养这些)
    ///   - callback: 支付成功
    ///   - hideCallback: 点击背景隐藏
    static func show(_ payId: String, money: Float, payType: XQSMNTUnifiedorderReqModelPayType, callback: AC_XQAlertSelectPayViewCallback? = nil, hideCallback: AC_XQAlertSelectPayViewHideCallback? = nil) {
        
        if let _ = _selectAddressView {
            return
        }
        
        _selectAddressView = AC_XQAlertSelectPayView()
        
        // 添加到 window 上
        if let addressAlertView = _selectAddressView?.bottomAlert {
            UIApplication.shared.keyWindow?.addSubview(_selectAddressView!)
            UIApplication.shared.keyWindow?.addSubview(addressAlertView)
            addressAlertView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            addressAlertView.show()
        }
        
        _selectAddressView?.payId = payId
        _selectAddressView?.money = money
        _selectAddressView?.payType = payType
        _selectAddressView?.callback = callback
        _selectAddressView?.hideCallback = hideCallback
    }
    
    static func hide() {
        if let selectAddressView = _selectAddressView {
            selectAddressView.bottomAlert.hide()
        }
        _selectAddressView?.removeFromSuperview()
        _selectAddressView = nil
    }
    
    enum PayType {
        /// 微信
        case wechat
        /// 支付宝
        case alipay
    }
    
    typealias AC_XQAlertSelectPayViewCallback = (_ payId: String, _ payType: AC_XQAlertSelectPayView.PayType) -> ()
    private var callback: AC_XQAlertSelectPayViewCallback?
    
    typealias AC_XQAlertSelectPayViewHideCallback = () -> ()
    private var hideCallback: AC_XQAlertSelectPayViewHideCallback?
    
    private static var _selectAddressView: AC_XQAlertSelectPayView?
    
    private let bottomAlert = AC_XQBottomAlert.init(frame: UIScreen.main.bounds, contentHeight: 180)
    private let alipayBtn = QMUIButton()
    private let wechatBtn = QMUIButton()
    
    private let disposeBag = DisposeBag()
    
    private var payId = ""
    private var money: Float = 0
    private var payType: XQSMNTUnifiedorderReqModelPayType = .shopMall
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bottomAlert.contentView.addSubview(self.alipayBtn)
        self.bottomAlert.contentView.addSubview(self.wechatBtn)
        
        // 布局
        self.alipayBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(0.65)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        
        self.wechatBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(1.35)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        
        // 设置属性
        
        self.wechatBtn.imagePosition = .top
        self.wechatBtn.spacingBetweenImageAndTitle = 12
        self.wechatBtn.setTitle("微信支付", for: .normal)
        self.wechatBtn.setTitleColor(UIColor.init(hex: "#333333"), for: .normal)
        self.wechatBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.wechatBtn.setImage(UIImage.init(named: "pay_wechat"), for: .normal)
        self.wechatBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
            self.pay(1)
        }
        
        self.alipayBtn.imagePosition = .top
        self.alipayBtn.spacingBetweenImageAndTitle = 12
        self.alipayBtn.setTitle("支付宝支付", for: .normal)
        self.alipayBtn.setTitleColor(UIColor.init(hex: "#333333"), for: .normal)
        self.alipayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.alipayBtn.setImage(UIImage.init(named: "pay_alipay"), for: .normal)
        self.alipayBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.pay(0)
//            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
        }
        
        weak var weakSelf = self
        self.bottomAlert.hideCallback = { [unowned self] in
            weakSelf?.hideCallback?()
            AC_XQAlertSelectPayView._selectAddressView?.removeFromSuperview()
            AC_XQAlertSelectPayView._selectAddressView = nil
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification_pay_succeed), name: sm_alipay_succeed_notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notification_pay_failure), name: sm_alipay_failure_notificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notification_wechat_pay_succeed), name: sm_wechat_succeed_notificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notification_wechat_pay_failure), name: sm_wechat_failure_notificationName, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if DEBUG
    deinit {
        print(self.classForCoder, #function)
    }
    #endif
    
    /// 支付
    /// - Parameters:
    ///   - id: 订单id
    ///   - money: 钱
    ///   - payType: 给后台的类型
    ///   - payMethodType: 支付类型. 0 支付宝, 1 微信
    private func pay(_ payMethodType: Int) {
        
        let reqModel = XQSMNTUnifiedorderReqModel(id: self.payId, PayType: self.payType)
        
        if payMethodType == 0 {
            // 支付宝
            SVProgressHUD.show(withStatus: nil)
            XQSMAlipayNetwork.aliPayOrder(reqModel).subscribe(onNext: { resModel in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                //                SVProgressHUD.showSuccess(withStatus: "付款成功")
                if let msg = resModel.ErrMsg {
                    SVProgressHUD.dismiss()
                    // 跳转支付宝
                    AlipaySDK.defaultService()?.payOrder(msg, fromScheme: "miacidCatAlipay", callback: { (dic) in
                        print("支付宝返回结果: ", dic ?? "没有")
                    })
                    
                }else {
                    SVProgressHUD.showError(withStatus: "未获取到支付信息")
                }
                
            }, onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: disposeBag)
            
        } else if payMethodType == 1 {
            // 微信
            //            SVProgressHUD.showInfo(withStatus: "还未支持微信支付")
            SVProgressHUD.show(withStatus: nil)
            XQSMWechatNetwork.unifiedorder(reqModel).subscribe(onNext: { resModel in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                let payReqModel = resModel.getPayModel()
                
                WXApi.send(payReqModel) { (result) in
                    if result {
                        SVProgressHUD.dismiss()
                    }else {
                        SVProgressHUD.showError(withStatus: "打开微信失败")
                    }
                }
                
            }, onError: { error in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: disposeBag)
            
        } else {
            
            SVProgressHUD.showInfo(withStatus: "请选择支付方式")
        }
        
    }
    
    // MARK: - Notification
    
    @objc func notification_pay_succeed(_ notification: Notification) {
        SVProgressHUD.showSuccess(withStatus: "支付成功")
        self.callback?(self.payId, .alipay)
        AC_XQAlertSelectPayView.hide()
    }
    
    @objc func notification_pay_failure(_ notification: Notification) {
        SVProgressHUD.showError(withStatus: "支付失败")
    }
    
    @objc func notification_wechat_pay_succeed(_ notification: Notification) {
        SVProgressHUD.showSuccess(withStatus: "支付成功")
        self.callback?(self.payId, .wechat)
        AC_XQAlertSelectPayView.hide()
    }
    
    @objc func notification_wechat_pay_failure(_ notification: Notification) {
        SVProgressHUD.showError(withStatus: "支付失败")
    }
    
    
}
