//
//  AC_XQFosterViewOptionView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQFosterViewOptionView: UIView {

    /// 加食投喂
    let fSwitchView = AC_XQFosterViewOptionViewSwitchRowView()
    /// 接送
    let sSwitchView = AC_XQFosterViewOptionViewSwitchRowView()
    /// 监控
    let tSwitchView = AC_XQFosterViewOptionViewSwitchRowView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.fSwitchView, self.sSwitchView, self.tSwitchView)
        
        // 布局
        self.fSwitchView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        self.sSwitchView.snp.makeConstraints { (make) in
            make.top.equalTo(self.fSwitchView.snp.bottom).offset(10)
            make.left.right.equalTo(self.fSwitchView)
        }
        
        self.tSwitchView.snp.makeConstraints { (make) in
            make.top.equalTo(self.sSwitchView.snp.bottom).offset(10)
            make.left.right.equalTo(self.fSwitchView)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize.init(width: 8, height: 8)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowColor = UIColor.black.cgColor
        
        
        self.configSwitch(self.fSwitchView, title: "加食投喂", message: "冻干、罐头等多种选择", img: "foster_petFood")
        self.configSwitch(self.sSwitchView, title: "接送服务", message: "贴心、安全节省您的时间", img: "foster_pickUp")
        self.configSwitch(self.tSwitchView, title: "开启实时监控", message: "限时免费", img: "foster_camera")
        
        
        
        
        // 暂时不要接送 和 监控
        self.sSwitchView.removeFromSuperview()
        self.tSwitchView.removeFromSuperview()
//        self.tSwitchView.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.fSwitchView.snp.bottom).offset(10)
//            make.left.right.equalTo(self.fSwitchView)
//            make.bottom.equalToSuperview().offset(-12)
//        }
        self.fSwitchView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview().offset(-12)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSwitch(_ sRowView: AC_XQFosterViewOptionViewSwitchRowView, title: String, message: String, img: String) {
        sRowView.titleLab.moneyLab.font = UIFont.systemFont(ofSize: 13)
        sRowView.titleLab.moneyLab.text = title
        
        sRowView.titleLab.symbolLab.textColor = UIColor.init(hex: "#999999")
        sRowView.titleLab.symbolLab.text = message
        sRowView.titleLab.setSymbolFont(UIFont.systemFont(ofSize: 12))
        
        
//        sRowView.imgView.backgroundColor = UIColor.ac_mainColor
        sRowView.imgView.image = UIImage.init(named: img)
    }

}


class AC_XQFosterViewOptionViewSwitchRowView: UIView {
    
    let imgView = UIImageView()
    let titleLab = AC_XQMoneyView.init(direction: .right)
    let xq_switch = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        self.addSubview(self.xq_switch)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        self.xq_switch.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
        }
        
        // 设置属性
//        self.titleLab.font = UIFont.systemFont(ofSize: 16)
//
//        self.messageLab.font = UIFont.systemFont(ofSize: 14)
//        self.messageLab.textColor = UIColor.lightText
        
        self.xq_switch.onTintColor = UIColor.ac_mainColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
