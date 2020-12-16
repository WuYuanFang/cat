//
//  AC_XQEditAddressView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import XQUITextField_Navigation

class AC_XQEditAddressView: UIView {
    
    let scrollView = UIScrollView()
    
    let nameView = AC_XQEditAddressViewRowView()
    let phoneView = AC_XQEditAddressViewRowView()
    let addressView = AC_XQEditAddressViewRowView()
    let detailAddressView = AC_XQEditAddressViewRowView()
    
    let normalTitleLab = UILabel()
    let xq_switch = UISwitch()
    let deleteBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.scrollView)
        self.scrollView.xq_addSubviews(self.nameView, self.phoneView, self.addressView, self.detailAddressView, self.normalTitleLab, self.xq_switch, self.deleteBtn)
        
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
        
        self.nameView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.phoneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.addressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.detailAddressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressView.snp.bottom).offset(12)
            make.left.equalTo(self.nameView)
            make.right.equalTo(self.nameView)
        }
        
        self.normalTitleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailAddressView.snp.bottom).offset(20)
            make.left.equalTo(self.nameView)
        }
        
        self.xq_switch.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.normalTitleLab)
            make.right.equalTo(self.nameView)
        }
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(46)
            make.top.greaterThanOrEqualTo(self.normalTitleLab.snp.bottom).offset(170)
            make.bottom.equalToSuperview().offset(-60)
        }
        
        // 设置属性
        self.nameView.titleLab.text = "收件人:"
        self.nameView.tf.placeholder = "请输入收件人姓名"
        
        self.phoneView.titleLab.text = "手机号:"
        self.phoneView.tf.placeholder = "请输入收件人手机号"
        self.phoneView.tf.keyboardType = .numberPad
        
        self.addressView.titleLab.text = "所在地区:"
        self.addressView.tf.placeholder = "请选择所在地区"
        self.addressView.arrowUI()
        
        self.detailAddressView.titleLab.text = "详细地址:"
        self.detailAddressView.tv.placeholder = "如道路、小区、门牌号、楼栋号、单元室等"
        self.detailAddressView.tvUI()
        
        self.normalTitleLab.text = "设置为默认地址"
        
        
        self.deleteBtn.setTitle("删除收件地址", for: .normal)
        self.deleteBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        
        self.xq_showTextField_Navigation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}







