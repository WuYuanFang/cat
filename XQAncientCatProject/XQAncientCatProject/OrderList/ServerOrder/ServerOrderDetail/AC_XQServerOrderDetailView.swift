//
//  AC_XQServerOrderDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/24.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQServerOrderDetailView: UIView {
    
    let bottomView = UIView()
    
    let lineView = UIView()
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    /// 剩余多少天
    let dayLab = UILabel()
    
    let videoImgView = UIImageView()
    let videoLab = UILabel()
    
    /// 订单详情
    let detailBtn = UIButton()
    /// 结束寄养
    let cancelBtn = UIButton()
    /// 增加天数
    let dayBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.bottomView)
        self.bottomView.xq_addSubviews(self.lineView, self.imgView, self.titleLab, self.dayLab, self.videoLab, self.videoImgView, self.detailBtn, self.dayBtn)
        
        // 布局
        self.bottomView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 60, height: 3))
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom).offset(25)
            make.centerX.equalToSuperview().multipliedBy(0.4)
            make.size.equalTo(30)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView).offset(-5)
            make.left.equalTo(self.imgView.snp.right).offset(10)
            make.right.equalTo(-12)
        }
        
        self.dayLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(5)
            make.left.equalTo(self.titleLab)
            make.right.equalTo(-12)
        }
        
        self.videoImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(25)
            make.size.centerX.equalTo(self.imgView)
        }
        
        self.videoLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.videoImgView)
            make.left.equalTo(self.titleLab)
            make.right.equalTo(-12)
        }
        
        self.detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.videoImgView.snp.bottom).offset(30)
            make.size.equalTo(CGSize.init(width: 80, height: 40))
            make.centerX.equalToSuperview().multipliedBy(0.65)
            make.bottom.equalTo(-49)
        }
        
        self.dayBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailBtn)
            make.centerX.equalToSuperview().multipliedBy(1.35)
            make.size.equalTo(self.detailBtn)
        }
        
        
        // 设置属性
        self.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
        self.bottomView.backgroundColor = UIColor.white
        self.lineView.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
        self.titleLab.textColor = UIColor.ac_mainColor
        
        self.dayLab.textColor = UIColor.init(hex: "#9A9A9A")
        self.dayLab.font = UIFont.systemFont(ofSize: 15)
        
        self.videoLab.textColor = UIColor.ac_mainColor
        
        self.imgView.image = UIImage.init(named: "fosterOrder_phone")
        self.videoImgView.image = UIImage.init(named: "fosterOrder_camera")
        
        self.configBtn(self.detailBtn, title: "查看订单")
        self.configBtn(self.dayBtn, title: "增加天数")
        
        self.titleLab.text = "宠物寄养中，请安心等待"
//        self.dayLab.text = "寄养还剩0天"
        self.dayLab.text = ""
        self.videoLab.text = "实时监控"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bottomView.xq_corners_addRoundedCorners([.topLeft, .topRight], withRadii: .init(width: 25, height: 25))
    }
    
    private func configBtn(_ btn: UIButton, title: String) {
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.ac_mainColor.cgColor
        btn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
}
