//
//  AC_XQLoginView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool
import XQProjectTool_iPhoneUI
import XQUITextField_Navigation
import XQTimer
import XQTencent
import XQWechat

class AC_XQLoginView: UIView {
    
    let headerView = AC_XQLoginViewHeaderView()
    
    let bottomView = AC_XQLoginViewBottomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.headerView, self.bottomView)
        
        // 布局
        self.headerView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.left.right.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        // 配置属性
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AC_XQLoginViewHeaderView: UIView {
    
    let titleLab = UILabel()
    let titleView = UIView()
    let accTF = UITextField()
    let pwdTF = UITextField()
    
    let codeTF = UITextField()
    
    /// 验证码登录啥的
    let otherBtn = UIButton()
    
    /// 获取验证码
    var codeBtn: AC_XQRegisterCodeBtn?
    
    /// 游客登录
    let visitorBtn = UIButton()
    
    
    
    let tfHeight: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleView, self.accTF, self.pwdTF, self.codeTF, self.otherBtn, self.visitorBtn)
        self.titleView.addSubview(self.titleLab)
        
        // 布局
        self.otherBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-12)
            make.left.equalToSuperview().offset(74)
            make.height.greaterThanOrEqualTo(30)
        }
        
        self.pwdTF.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.otherBtn.snp.top).offset(-25)
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(self.tfHeight)
        }
        
        self.accTF.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.pwdTF.snp.top).offset(-18.5)
            make.left.right.height.equalTo(self.pwdTF)
        }
        
        self.titleView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.accTF.snp.top)
            make.top.left.right.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.visitorBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.top.equalTo(XQIOSDevice.getStatusHeight())
            make.height.equalTo(30)
        }
        
        // 设置属性
        self.backgroundColor = UIColor.white
        
        self.titleLab.text = "Hello world！"
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.configTF(self.accTF, placeholder: "请输入手机号")
        self.accTF.keyboardType = .numberPad
        
        self.configTF(self.pwdTF, placeholder: "请输入密码")
        self.pwdTF.isSecureTextEntry = true
        
        self.configTF(self.codeTF, placeholder: "请输入验证码")
        self.codeTF.keyboardType = .numberPad
        
        // 眼睛 btn
        AC_XQLoginViewHeaderView.xq_configPwdEye(self.pwdTF, tfHeight: self.tfHeight)
        
        self.otherBtn.setTitle("验证码登录", for: .normal)
        self.otherBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.otherBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        
        self.visitorBtn.setTitle("游客登录 >", for: .normal)
        self.visitorBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.visitorBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        
        // 验证密码
        let codeV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 40))
        let codeBtn = AC_XQRegisterCodeBtn.init(frame: CGRect.init(x: 10, y: 0, width: 110, height: 40))
        codeV.addSubview(codeBtn)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.codeBtn = codeBtn
        self.codeTF.rightView = codeV
        self.codeTF.rightViewMode = .always
        self.codeTF.isHidden = true
        
        self.xq_showTextField_Navigation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configTF(_ tf: UITextField, placeholder: String) {
        tf.backgroundColor = UIColor.init(hex: "#F4F4F4")
        tf.placeholder = placeholder
        tf.layer.cornerRadius = self.tfHeight/2
        tf.layer.masksToBounds = true
        
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 0))
        tf.leftView = leftView
        tf.leftViewMode = .always
    }
    
    /// 手机验证码登录
    func phoneLoginMode() {
//        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 40))
//        let pwdBtn = UIButton.init(frame: CGRect.init(x: 10, y: 0, width: 110, height: 40))
//        v.addSubview(pwdBtn)
//        pwdBtn.setTitle("获取验证码", for: .normal)
//        pwdBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
//        pwdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        self.codeBtn = pwdBtn
//
//        self.pwdTF.rightView = v
        
        self.pwdTF.isHidden = true
        
        self.codeTF.isHidden = false
        self.codeTF.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.otherBtn.snp.top).offset(-25)
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(self.tfHeight)
        }
        
        self.accTF.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.codeTF.snp.top).offset(-18.5)
            make.left.right.height.equalTo(self.codeTF)
        }
        
        self.xq_showTextField_Navigation()
    }
    
    /// 注册
    func registerMode() {
        self.otherBtn.isHidden = true
        self.visitorBtn.isHidden = true
        
        self.codeTF.isHidden = false
        
        self.pwdTF.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.otherBtn.snp.top).offset(-25)
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-44)
            make.height.equalTo(self.tfHeight)
        }
        
        self.codeTF.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.pwdTF.snp.top).offset(-18.5)
            make.left.right.height.equalTo(self.pwdTF)
        }
        
        self.accTF.snp.remakeConstraints { (make) in
            make.bottom.equalTo(self.codeTF.snp.top).offset(-18.5)
            make.left.right.height.equalTo(self.pwdTF)
        }
        
        self.xq_showTextField_Navigation()
    }
    
    /// 配置一个眼睛
    /// - Parameters:
    ///   - tfHeight: tf 高度
    static func xq_configPwdEye(_ tf: UITextField, tfHeight: CGFloat) {
        let vWidth: CGFloat = 50
        let pwdBtnSize: CGFloat = 25
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: vWidth, height: tfHeight))
        let pwdBtn = UIButton.init(frame: CGRect.init(x: (vWidth - pwdBtnSize) / 2, y: (tfHeight - pwdBtnSize) / 2, width: pwdBtnSize, height: pwdBtnSize))
        v.addSubview(pwdBtn)
        pwdBtn.setImage(UIImage.init(named: "eye_0"), for: .normal)
        pwdBtn.setImage(UIImage.init(named: "eye_1"), for: .selected)
        tf.rightView = v
        tf.rightViewMode = .always
        tf.isSecureTextEntry = true
        
        weak var weakTF = tf
        pwdBtn.xq_addEvent(.touchUpInside) { (sender) in
            sender?.isSelected = !(sender?.isSelected ?? false)
            weakTF?.isSecureTextEntry = !(sender?.isSelected ?? false)
        }
    }
    
}

class AC_XQLoginViewBottomView: UIView {
    
    let roundView = UIView()
    let btn = UIButton()
    
    let desView = UIView()
    let desLab = UILabel()
    
    let wechatBtn = AC_XQLoginViewBottomViewOtherBtnView()
    let qqBtn = AC_XQLoginViewBottomViewOtherBtnView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        self.xq_addSubviews(self.roundView, self.btn, self.wechatBtn, self.qqBtn, self.desView)
        
        self.desView.addSubview(self.desLab)
        
        // 布局
        self.btn.snp.makeConstraints { (make) in
//            make.size.equalTo(CGSize.init(width: 52, height: 52))
            make.size.equalTo(CGSize.init(width: 80, height: 80))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let otherLoginBtnSize: CGFloat = 50
        
        self.wechatBtn.snp.makeConstraints { (make) in
            make.size.equalTo(otherLoginBtnSize)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(0.75)
        }
        
        self.qqBtn.snp.makeConstraints { (make) in
            make.size.equalTo(otherLoginBtnSize)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.25)
        }
        
        self.roundView.snp.makeConstraints { (make) in
            make.top.equalTo(self.btn.snp.centerY)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.2)
        }
        
        self.desView.snp.makeConstraints { (make) in
            make.top.equalTo(self.btn.snp.bottom)
            make.bottom.equalTo(self.wechatBtn.snp.top)
            make.left.right.equalToSuperview()
        }
        
        self.desLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // 设置属性
        self.backgroundColor = UIColor.white
        
        self.btn.setBackgroundImage(UIImage.init(named: "loginBtn"), for: .normal)
        
//        self.roundView.backgroundColor = UIColor.ac_mainColor
        self.roundView.backgroundColor = UIColor.init(xq_rgbWithR: 223, g: 223, b: 223)
        
        self.wechatBtn.btn.setBackgroundImage(UIImage.init(named: "wechat"), for: .normal)
        
        self.qqBtn.btn.setBackgroundImage(UIImage.init(named: "qq"), for: .normal)
        
        self.desLab.text = "or"
        self.desLab.textColor = UIColor.ac_mainColor
        self.desLab.font = UIFont.systemFont(ofSize: 14)
        
        
        if XQWechat.isInstalled(), XQTencentOpenApi.isInstalled() {
            // 正常, 都能打开
            
        }else if !XQTencentOpenApi.isInstalled() {
            // 不能打开qq
            self.wechatBtn.snp.remakeConstraints { (make) in
                make.size.equalTo(otherLoginBtnSize)
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            self.qqBtn.isHidden = true
        }else if !XQWechat.isInstalled() {
            // 不能打开微信
            self.qqBtn.snp.remakeConstraints { (make) in
                make.size.equalTo(otherLoginBtnSize)
                make.centerY.equalToSuperview()
                make.centerX.equalToSuperview()
            }
            self.wechatBtn.isHidden = true
        }else {
            // 都不能打开
            self.desLab.isHidden = true
            self.wechatBtn.isHidden = true
            self.qqBtn.isHidden = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundView.xq_corners_addRoundedCorners([.topLeft, .topRight], withRadii: CGSize.init(width: self.roundView.bounds.width/3, height: 0))
    }
    
}

class AC_XQLoginViewBottomViewOtherBtnView: UIView {
    
    let btn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.btn)
        
        // 布局
        
//        let otherLoginBtnSize: CGFloat = 44
        
        self.btn.snp.makeConstraints { (make) in
            make.size.equalToSuperview().multipliedBy(0.7)
            make.center.equalToSuperview()
        }
        
        // 设置属性
        
        self.btn.isUserInteractionEnabled = false
        self.btn.setBackgroundImage(UIImage.init(named: "wechat"), for: .normal)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hex: "#BCBCBC").cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width/2
    }
    
}


class AC_XQRegisterCodeBtn: UIButton {
    
    var xq_second = 0
    var orginTitle = "获取验证码"
    
    /// 发送了验证码
    func xq_sendCode(_ second: Int = 60) {
        
        self.orginTitle = self.titleLabel?.text ?? ""
        
        self.isUserInteractionEnabled = false
        self.xq_second = second
        self.xq_cancelTimer()
        self.xq_createTimer(withTime: 1, walltime: 0)
    }
    
    override func operationTimer() {
        // xx秒后重新发送
        self.setTitle("\(self.xq_second)秒后重新发送", for: .normal)
        self.xq_second -= 1
        if self.xq_second <= 0 {
            self.xq_cancelTimer()
            self.isUserInteractionEnabled = true
            self.setTitle(self.orginTitle, for: .normal)
        }
        
    }
    
    
}




