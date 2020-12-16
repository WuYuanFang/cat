//
//  AC_XQEditPetInfoView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

class AC_XQEditPetInfoView: UIView {
    
    let scrollView = UIScrollView()
    
    /// 头像
    let imgView = AC_XQEditPetInfoViewPhotoView()
    /// 名称
    let nameView = AC_XQEditAddressViewRowView()
    /// 品种
    let varietiesView = AC_XQEditAddressViewRowView()
    /// 性别
    let genderView = AC_XQEditAddressViewRowView()
    /// 体重
    let weightView = AC_XQEditAddressViewRowView()
    /// 生日
    let birthdayView = AC_XQEditAddressViewRowView()
    /// 绝育
    let sterilizationView = AC_XQEditAddressViewRowView()
    /// 全身照
    let fullBodyView = AC_XQEditPetInfoViewCameraView()
    /// 鼻头照
    let noseView = AC_XQEditPetInfoViewCameraView()
    
    let saveBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.scrollView)
        self.scrollView.xq_addSubviews(self.imgView, self.nameView, self.varietiesView, self.genderView, self.weightView, self.birthdayView, self.sterilizationView, self.fullBodyView, self.noseView, self.saveBtn)
        
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
        
        let imgViewSize: CGFloat = 82
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(imgViewSize)
        }
        
        self.nameView.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(30)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.varietiesView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.genderView.snp.makeConstraints { (make) in
            make.top.equalTo(self.varietiesView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.weightView.snp.makeConstraints { (make) in
            make.top.equalTo(self.genderView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.birthdayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.weightView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.sterilizationView.snp.makeConstraints { (make) in
            make.top.equalTo(self.birthdayView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.fullBodyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.sterilizationView.snp.bottom).offset(16)
            make.left.equalTo(self.nameView).offset(20)
            make.width.equalTo(114)
        }
        
        self.noseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.fullBodyView)
            make.right.equalTo(self.nameView).offset(-20)
            make.width.equalTo(self.fullBodyView)
        }
        
        
        self.saveBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(46)
            make.top.greaterThanOrEqualTo(self.noseView.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        // 设置属性
//        self.imgView.backgroundColor = UIColor.ac_mainColor
//        self.imgView.layer.cornerRadius = imgViewSize/2
        
        self.nameView.titleLab.text = "宠物昵称:"
        self.nameView.tf.placeholder = "请输入宠物昵称"
        
        self.varietiesView.titleLab.text = "宠物品种:"
        self.varietiesView.tf.placeholder = "选择品种"
        self.varietiesView.arrowUI()
        
        self.genderView.titleLab.text = "宠物性别:"
        self.genderView.btnUI()
        self.genderView.leftBtn.setTitle("公", for: .normal)
        self.genderView.rightBtn.setTitle("母", for: .normal)
        
        self.weightView.titleLab.text = "宠物体重:"
        self.weightView.tf.placeholder = "请填写体重(单位kg)"
        self.weightView.tf.keyboardType = .decimalPad
        
        self.birthdayView.titleLab.text = "宠物生日:"
        self.birthdayView.tf.placeholder = "请选择生日"
        self.birthdayView.arrowUI()
        
        self.sterilizationView.titleLab.text = "是否绝育:"
        self.sterilizationView.btnUI()
        self.sterilizationView.leftBtn.setTitle("是", for: .normal)
        self.sterilizationView.rightBtn.setTitle("否", for: .normal)
        
        self.fullBodyView.bottomLab.text = "请上传宠物全身照"
        
        self.noseView.bottomLab.text = "请上传宠物鼻头照\n(能清晰看到鼻纹)"
        
        self.saveBtn.setTitle("保存", for: .normal)
        self.saveBtn.backgroundColor = UIColor.ac_mainColor
        self.saveBtn.layer.cornerRadius = 10
        self.saveBtn.layer.shadowColor = UIColor.ac_mainColor.cgColor
        self.saveBtn.layer.shadowOpacity = 0.2
        self.saveBtn.layer.shadowOffset = CGSize.init(width: 8, height: 8)
        
        self.xq_showTextField_Navigation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 选择封面照view
class AC_XQEditPetInfoViewPhotoView: UIView {
    
    
    let imgView = UIImageView()
    
    private let xq_maskView = UIView()
    private let cameraImgView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView)
        self.imgView.xq_addSubviews(self.xq_maskView, self.cameraImgView)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.xq_maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.cameraImgView.snp.makeConstraints { (make) in
            make.size.equalTo(40)
            make.center.equalToSuperview()
        }
        
        // 设置属性
        self.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.cameraImgView.image = UIImage.init(named: "camera")
        self.cameraImgView.contentMode = .scaleAspectFit
        
        self.xq_maskView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        
        self.imgView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgView.layer.cornerRadius = self.imgView.frame.width/2
    }
    
}

class AC_XQEditPetInfoViewCameraView: UIView {
    
    private let cameraImgView = UIImageView()
    private let cameraBackView = UIView()
    private let cameraLab = UILabel()
    private let cameraView = UIView()
    let bottomLab = UILabel()
    
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.cameraView, self.bottomLab)
        self.cameraView.xq_addSubviews(self.cameraBackView, self.cameraLab, self.imgView)
        self.cameraBackView.addSubview(self.cameraImgView)
        
        
        // 布局
        
        self.cameraView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.cameraView.snp.width)
        }
        
        self.bottomLab.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.cameraView.snp.bottom).offset(16)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.cameraBackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.65)
            make.size.equalTo(35)
        }
        
        self.cameraLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.cameraBackView.snp.bottom).offset(12)
        }
        
        self.cameraImgView.snp.makeConstraints { (make) in
            make.left.top.equalTo(6)
            make.right.bottom.equalTo(-6)
        }
        
        // 设置属性
        
        self.imgView.contentMode = .scaleAspectFill
        
        self.cameraImgView.image = UIImage.init(named: "camera")
        self.cameraImgView.contentMode = .scaleAspectFit
        
        self.cameraLab.text = "请上传照片"
        self.cameraLab.textColor = UIColor.init(hex: "#999999")
        self.cameraLab.font = UIFont.systemFont(ofSize: 13)
        
        self.cameraView.layer.cornerRadius = 10
        self.cameraView.layer.borderWidth = 1
        self.cameraView.layer.borderColor = UIColor.ac_mainColor.cgColor
        self.cameraView.layer.masksToBounds = true
        
        self.cameraBackView.layer.cornerRadius = 4
        self.cameraBackView.backgroundColor = UIColor.ac_mainColor
        
        self.bottomLab.font = UIFont.systemFont(ofSize: 13)
        self.bottomLab.numberOfLines = 0
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

