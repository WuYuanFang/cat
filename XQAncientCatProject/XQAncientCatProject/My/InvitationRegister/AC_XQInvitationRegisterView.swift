//
//  AC_XQInvitationRegisterView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/5.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQInvitationRegisterView: UIView {
    
    let imgView = UIImageView()
    
    let titleLab = UILabel()
    let copyBtn = UIButton()
    
    let saveBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.titleLab, self.copyBtn, self.saveBtn)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(self.imgView.snp.width)
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(16)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.copyBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        let saveBtnHeight: CGFloat = 40
        self.saveBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.copyBtn.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 80, height: saveBtnHeight))
        }
        
        // 设置属性
        
        self.titleLab.textAlignment = .center
        
        self.copyBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.copyBtn.setTitle("复制", for: .normal)
        
        self.saveBtn.layer.cornerRadius = saveBtnHeight/2
        self.saveBtn.backgroundColor = UIColor.ac_mainColor
        self.saveBtn.setTitle("保存", for: .normal)
        self.saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
