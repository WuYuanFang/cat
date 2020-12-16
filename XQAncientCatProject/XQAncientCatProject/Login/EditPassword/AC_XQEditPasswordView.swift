//
//  AC_XQEditPasswordView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/20.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQUITextField_Navigation

class AC_XQEditPasswordView: UIView {

    let scrollView = UIScrollView()
    
    let phoneView = AC_XQEditAddressViewRowView()
    let codeView = AC_XQEditPasswordViewCodeView()
    let passwordView = AC_XQEditAddressViewRowView()
    let againPasswordView = AC_XQEditAddressViewRowView()
    
    let saveBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.scrollView)
        self.scrollView.xq_addSubviews(self.phoneView, self.codeView, self.passwordView, self.againPasswordView, self.saveBtn)
        
        // 布局
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.left.right.equalToSuperview()
        }
        
        self.phoneView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.codeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneView.snp.bottom).offset(12)
            make.left.equalTo(self.phoneView)
            make.right.equalTo(self.phoneView)
        }
        
        self.passwordView.snp.makeConstraints { (make) in
            make.top.equalTo(self.codeView.snp.bottom).offset(12)
            make.left.equalTo(self.phoneView)
            make.right.equalTo(self.phoneView)
        }
        
        self.againPasswordView.snp.makeConstraints { (make) in
            make.top.equalTo(self.passwordView.snp.bottom).offset(12)
            make.left.equalTo(self.phoneView)
            make.right.equalTo(self.phoneView)
        }
        
        self.saveBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(220)
            make.height.equalTo(46)
            make.top.equalTo(self.againPasswordView.snp.bottom).offset(50)
            make.bottom.equalToSuperview().offset(-34)
        }
        
        // 设置属性
        self.phoneView.titleLab.text = "手机号:"
        self.phoneView.tf.placeholder = "请输入收件人姓名"
        self.phoneView.tf.keyboardType = .numberPad
        
        self.passwordView.titleLab.text = "新密码:"
        self.passwordView.tf.placeholder = "请输入新密码"
        AC_XQLoginViewHeaderView.xq_configPwdEye(self.passwordView.tf, tfHeight: 50)
        
        self.againPasswordView.titleLab.text = "确认密码:"
        self.againPasswordView.tf.placeholder = "请再次输入新密码"
        AC_XQLoginViewHeaderView.xq_configPwdEye(self.againPasswordView.tf, tfHeight: 50)
        
        self.saveBtn.setTitle("确认", for: .normal)
        self.saveBtn.setTitleColor(UIColor.white, for: .normal)
        self.saveBtn.backgroundColor = UIColor.ac_mainColor
        self.saveBtn.layer.cornerRadius = 4
        
        self.xq_showTextField_Navigation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


class AC_XQEditPasswordViewCodeView: UIView {
    
    let tf = UITextField()
    
    let btn = AC_XQRegisterCodeBtn()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tf)
        self.addSubview(self.btn)
        
        // 布局
        self.tf.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.left.equalTo(12)
            make.right.equalTo(self.btn.snp.left).offset(-12)
        }
        
        self.btn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(110)
        }
        
        // 设置属性
        self.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        self.btn.setTitle("获取验证码", for: .normal)
        self.btn.setTitleColor(UIColor.white, for: .normal)
        self.btn.backgroundColor = UIColor.ac_mainColor
        self.btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        self.tf.keyboardType = .numberPad
        self.tf.font = UIFont.systemFont(ofSize: 15)
        self.tf.placeholder = "请输入验证码"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

