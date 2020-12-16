//
//  AC_YCMyInfoHeaderView.swift
//  XQAncientCatProject
//
//  Created by YCMacMini on 2020/5/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import XQProjectTool_iPhoneUI


protocol AC_YCMyInfoHeaderViewDelegate: NSObjectProtocol {
    
    /// 点击设置
    func myInfoHeaderView(didTapSet myInfoHeaderView: AC_YCMyInfoHeaderView)
    
    /// 点击客服
    func myInfoHeaderView(didTapCustomServer myInfoHeaderView: AC_YCMyInfoHeaderView)
    
    /// 点击摄像头
    func myInfoHeaderView(didTapCamera myInfoHeaderView: AC_YCMyInfoHeaderView)
    
    /// 点击头像
    func myInfoHeaderView(didTapHeadImg myInfoHeaderView: AC_YCMyInfoHeaderView)
    
    /// 点击名称
    func myInfoHeaderView(didTapName myInfoHeaderView: AC_YCMyInfoHeaderView)
    
}

class AC_YCMyInfoHeaderView: UIView {
    
    weak var delegate: AC_YCMyInfoHeaderViewDelegate?
    
    private let backView = UIView()
    
    // Lazy
    
    /// 设置按钮
    lazy var settingButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage.init(named: "my_setting"), for: .normal)
        return bt
    }()
    
    /// 客服按钮
    lazy var serviceButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage.init(named: "my_service"), for: .normal)
        return bt
    }()
    
    /// 摄像头按钮
    lazy var monitoringButton: QMUIButton = {
        let bt = QMUIButton()
        bt.backgroundColor = UIColor.ac_mainColor
        bt.imagePosition = .left
        bt.setImage(UIImage(named: "my_monitoring"), for: .normal)
        bt.setTitle("摄像头", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt.contentHorizontalAlignment = .center
        return bt
    }()
    
    /// 头像
    lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.ac_mainColor
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    /// vip标识
    lazy var vipImageView: UIImageView = {
//        let iv = UIImageView(image: UIImage.init(named: "my_vipImage"))
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    /// 用户名称
    lazy var userNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.white
//        lb.text = "小明"
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    /// 认证标识
    lazy var approveImageView: UIImageView = {
        let iv = UIImageView(image: UIImage.init(named: "my_approve"))
        return iv
    }()
    
    /// 用户电话号码
    lazy var phoneNumberLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = UIColor.white
        lb.text = "15278956795".phoneDesensitization()
        return lb
    }()
    
    
    
    // Life Cycle (生命周期)
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
        addElement()
        layoutElement()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImageView.layer.cornerRadius = self.iconImageView.qmui_height/2
        self.monitoringButton.xq_corners_addRoundedCorners([.topLeft, .bottomLeft], withRadii: CGSize.init(width: self.monitoringButton.qmui_height/2, height: self.monitoringButton.qmui_height/2))
        self.backView.xq_corners_addRoundedCorners([.bottomLeft, .bottomRight], withRadii: CGSize.init(width: 25, height: 25))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Config (配置)
    func config() {
        self.backView.backgroundColor = UIColor.init(hex: "#B9CDCE")
        
        self.settingButton.xq_addEvent(.touchUpInside) { [unowned self] (semder) in
            self.delegate?.myInfoHeaderView(didTapSet: self)
        }
        
        self.serviceButton.xq_addEvent(.touchUpInside) { [unowned self] (semder) in
            self.delegate?.myInfoHeaderView(didTapCustomServer: self)
        }
        
        self.monitoringButton.xq_addEvent(.touchUpInside) { [unowned self] (semder) in
            self.delegate?.myInfoHeaderView(didTapCamera: self)
        }
        
        self.iconImageView.isUserInteractionEnabled = true
        self.iconImageView.xq_addTap(callback: { [unowned self] (gesture) in
            self.delegate?.myInfoHeaderView(didTapHeadImg: self)
        })
        
        self.userNameLabel.isUserInteractionEnabled = true
        self.userNameLabel.xq_addTap(callback: { [unowned self] (gesture) in
            self.delegate?.myInfoHeaderView(didTapName: self)
        })
        
        
        // 第一期不显示
        self.monitoringButton.isHidden = true
    }
    
    // Structure （构造）
    func addElement() {
        self.xq_addSubviews(self.backView, settingButton, serviceButton, monitoringButton, iconImageView, vipImageView, userNameLabel, approveImageView, phoneNumberLabel)
        
    }
    
    func layoutElement() {
        
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.settingButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(XQIOSDevice.getStatusHeight() + 10)
            make.left.equalToSuperview().offset(24)
            make.height.width.equalTo(30)
        }
        
        self.serviceButton.snp.makeConstraints { (make) in
            make.top.width.height.equalTo(self.settingButton)
            make.left.equalTo(self.settingButton.snp.right).offset(12)
        }
        
        self.monitoringButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.serviceButton)
            make.right.equalToSuperview()
            make.width.equalTo(95)
            make.height.equalTo(40)
        }
        
        self.iconImageView.snp.makeConstraints { (make) in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(self.settingButton.snp.bottom).offset(8)
            make.center.equalToSuperview()
            make.width.height.equalTo(96)
        }
        
        self.vipImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.iconImageView.snp.bottom).offset(-10)
            make.left.equalTo(self.iconImageView).offset(5)
            make.width.height.equalTo(30)
        }
        
        self.userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.vipImageView.snp.bottom)
            make.centerX.equalToSuperview()
//            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        self.approveImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.userNameLabel)
            make.left.equalTo(self.userNameLabel.snp.right).offset(6)
            make.height.width.equalTo(13)
        }
        
        self.phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.userNameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-25)
        }
        
        
        
    }
    
}
