//
//  AC_XQHomePageViewAppointmentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQHomePageViewAppointmentViewDelegate: NSObjectProtocol {
    
    /// 点击洗护
    func homePageViewAppointmentView(tapWashProtext homePageViewAppointmentView: AC_XQHomePageViewAppointmentView)
    
    /// 点击寄养
    func homePageViewAppointmentView(tapFoster homePageViewAppointmentView: AC_XQHomePageViewAppointmentView)
    
    /// 点击繁育
    func homePageViewAppointmentView(tapBreed homePageViewAppointmentView: AC_XQHomePageViewAppointmentView)
    
}

class AC_XQHomePageViewAppointmentView: AC_XQHomePageViewTableViewHeaderView {
    
    weak var delegate: AC_XQHomePageViewAppointmentViewDelegate?
    
    let washProtectView = AC_XQHomePageViewAppointmentViewContentView()
    let fosterView = AC_XQHomePageViewAppointmentViewContentView()
    let breedView = AC_XQHomePageViewAppointmentViewContentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.washProtectView, self.fosterView, self.breedView)
        
        // 布局
        let vArr = NSArray.init(array: [self.washProtectView, self.fosterView, self.breedView])
        vArr.mas_makeConstraints { (make) in
            make?.top.bottom()?.equalTo()(self.contentView)
        }
        vArr.mas_distributeViews(along: .horizontal, withFixedSpacing: 16, leadSpacing: 16, tailSpacing: 16)
        
        
        // 设置属性
        
        self.imgView.image = UIImage.init(named: "homePage_appointment")
        self.titleLab.text = "预约服务"
        self.subtitleLab.text = "Reservation Service"
        
        self.washProtectView.titleLab.text = "洗护"
        self.washProtectView.messageLab.text = "细心呵护"
        self.washProtectView.fImgView.image = UIImage.init(named: "homePage_washProtect_back")
        self.washProtectView.imgView.image = UIImage.init(named: "homePage_washProtect")?.xq_image(withTintColor: UIColor.white)
        self.washProtectView.tImgView.image = UIImage.init(named: "homePage_rectangle_mainColor")
        
        
        self.fosterView.titleLab.text = "寄养"
        self.fosterView.messageLab.text = "家庭式寄养"
        self.fosterView.fImgView.image = UIImage.init(named: "homePage_foster_back")
        self.fosterView.imgView.image = UIImage.init(named: "homePage_foster")?.xq_image(withTintColor: UIColor.white)
        self.fosterView.tImgView.image = UIImage.init(named: "homePage_rectangle_foster")
        
        self.breedView.titleLab.text = "繁育"
        self.breedView.messageLab.text = "安心繁育"
        self.breedView.fImgView.image = UIImage.init(named: "homePage_breed_back")
        self.breedView.imgView.image = UIImage.init(named: "homePage_breed")?.xq_image(withTintColor: UIColor.white)
        self.breedView.tImgView.image = UIImage.init(named: "homePage_rectangle_breed")
        
        
        self.washProtectView.xq_addTap { [unowned self] (gesture)  in
            self.delegate?.homePageViewAppointmentView(tapWashProtext: self)
        }
        
        self.fosterView.xq_addTap { [unowned self] (gesture)  in
            self.delegate?.homePageViewAppointmentView(tapFoster: self)
        }
        
        self.breedView.xq_addTap { [unowned self] (gesture)  in
            self.delegate?.homePageViewAppointmentView(tapBreed: self)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AC_XQHomePageViewAppointmentViewContentView: UIView {
    
    let contentView = UIView()
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    /// 第一层六边形
    let fImgView = UIImageView()
    /// 第二层六边形
    let tImgView = UIImageView()
    /// 最中间图片
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.contentView, self.fImgView)
        self.contentView.xq_addSubviews(self.titleLab, self.messageLab)
        
        self.fImgView.addSubview(self.tImgView)
        self.tImgView.addSubview(self.imgView)
        
        // 布局
        self.contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.contentView.snp.width)
        }
        
        self.fImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.contentView.snp.bottom).multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            
//            make.size.equalTo(55)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(self.fImgView.snp.width)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.centerX.equalToSuperview()
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        self.tImgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.7)
//            make.top.left.equalTo(6)
//            make.right.bottom.equalTo(-6)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.4)
        }
        
        // 设置属性
        
        self.contentView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.contentView.layer.cornerRadius = 10
        
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        
        self.messageLab.font = UIFont.systemFont(ofSize: 13)
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        
        self.fImgView.image = UIImage.init(named: "homePage_rectangle")
        self.fImgView.contentMode = .scaleAspectFit
//        self.fImgView.backgroundColor = UIColor.white
        
        self.tImgView.image = UIImage.init(named: "homePage_rectangle_mainColor")
        
        self.imgView.image = UIImage.init(named: "wechat")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



