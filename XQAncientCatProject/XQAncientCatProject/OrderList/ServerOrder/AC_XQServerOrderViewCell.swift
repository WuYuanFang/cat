//
//  AC_XQServerOrderViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQServerOrderViewCell: AC_XQThreeContentCell {
    
    var serverModel:XQACNTFosterGM_FosterModel?
    var washModel:XQSMNTTinnyToOrderInfoModel?

    let orderCodeImgView = UIImageView()
    let orderCodeLab = UILabel()
    let statusLab = UILabel()
    
    let iconImgView = UIImageView()
    let titleLab = UILabel()
    let messageLab = UILabel()
    let priceLab = UILabel()
    let numberLab = UILabel()
    let originPriceLab = UILabel()
    let dateLab = UILabel()
    
    let deleteBtn = UIButton()
    let statusBtn = UIButton()
    let funcBtn = UIButton()
    let downStatusLab = UILabel()
    
    @objc func updateTime() {
        if let m = serverModel, m.State == .orderPlaced, m.PayType == 2 {
            if DK_TimerManager.getLastTime(m.PayTime).count > 0 {
                statusBtn.setTitle(DK_TimerManager.getLastTime(m.PayTime), for: .normal)
            }else{
                statusBtn.isHidden = true
                funcBtn.isHidden = true
                NotificationCenter.default.removeObserver(self, name: timeNoti, object: nil)
            }
        }
        if let m = washModel, m.CanRefund {
            if DK_TimerManager.getLastTime(m.PayTime).count > 0 {
                statusBtn.setTitle(DK_TimerManager.getLastTime(m.PayTime), for: .normal)
            }else{
                statusBtn.isHidden = true
                funcBtn.isHidden = true
                NotificationCenter.default.removeObserver(self, name: timeNoti, object: nil)
            }
        }
    }
    
    deinit {
        print("cell已经销毁")
        NotificationCenter.default.removeObserver(self, name: timeNoti, object: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTime), name: timeNoti, object: nil)
        
        self.topContentView.xq_addSubviews(self.orderCodeImgView, self.orderCodeLab, self.statusLab)
        
        self.centerContentView.xq_addSubviews(self.iconImgView, self.titleLab, self.messageLab, self.dateLab, self.priceLab, self.numberLab, self.originPriceLab)
        
        self.bottomContentView.xq_addSubviews(self.deleteBtn, self.funcBtn, self.statusBtn, self.downStatusLab)
        
        
        // 布局
        
        self.orderCodeImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.left.equalTo(20)
        }
        
        self.orderCodeLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.orderCodeImgView.snp.right).offset(8)
        }
        
        self.statusLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
        }
        
        let iconImgViewSize: CGFloat = 60
        self.iconImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.size.equalTo(iconImgViewSize)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.messageLab.snp.top).offset(-7)
            make.left.equalTo(self.iconImgView.snp.right).offset(16)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
//            make.top.equalTo(self.titleLab.snp.bottom).offset(7)
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLab)
        }
        
        self.originPriceLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(-12)
        }
        
        self.numberLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.originPriceLab.snp.bottom).offset(3)
            make.right.equalTo(self.originPriceLab)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.originPriceLab)
            make.right.equalTo(self.originPriceLab)
        }
        
        self.dateLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.messageLab.snp.bottom).offset(7)
            make.left.equalTo(self.titleLab)
        }
        
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(20)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        let funcBtnHeight: CGFloat = 26
        self.downStatusLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize.init(width: 83, height: funcBtnHeight))
        }
        self.funcBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize.init(width: 83, height: funcBtnHeight))
        }
        self.statusBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.funcBtn.snp.left).offset(-10)
            make.height.equalTo(30)
        }
        
        
        // 设置属性
        
        self.orderCodeImgView.image = UIImage.init(named: "petFosterCare")
        
        self.orderCodeLab.textColor = UIColor.init(hex: "#666666")
        self.orderCodeLab.font = UIFont.systemFont(ofSize: 14)
        
        self.statusLab.textColor = UIColor.ac_mainColor
        self.statusLab.font = UIFont.systemFont(ofSize: 14)
        
        self.downStatusLab.textColor = UIColor.systemYellow
        self.downStatusLab.font = UIFont.systemFont(ofSize: 14)
        
        
        self.originPriceLab.textColor = UIColor.init(hex: "#999999")
        self.originPriceLab.font = UIFont.systemFont(ofSize: 14)
        self.numberLab.textColor = UIColor.init(hex: "#999999")
        self.numberLab.font = UIFont.systemFont(ofSize: 14)
        
        self.priceLab.font = UIFont.systemFont(ofSize: 15)
        
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 14)
        
        
        self.iconImgView.layer.cornerRadius = iconImgViewSize/2
        self.iconImgView.layer.masksToBounds = true
        
        self.deleteBtn.setBackgroundImage(UIImage.init(named: "review_delete_list"), for: .normal)
        
        self.dateLab.textColor = UIColor.init(hex: "#999999")
        self.dateLab.font = UIFont.systemFont(ofSize: 14)
        
        self.statusBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.statusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.funcBtn.layer.borderWidth = 1;
        self.funcBtn.layer.borderColor = UIColor.ac_mainColor.cgColor;
        self.funcBtn.layer.cornerRadius = funcBtnHeight/2;
        self.funcBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.funcBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.funcBtn.setTitle("评价", for: .normal)
        
        self.originPriceLab.isHidden = true
        self.numberLab.isHidden = true
        self.downStatusLab.isHidden = true
        
//        self.titleLab.text = "小古猫宠物店"
//        self.messageLab.text = "寄养 5天"
        
//        self.dateLab.text = "预约时间：2019-3-14 22:00"
        
//        self.statusBtn.setTitle("查看物流", for: .normal)
        
//        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        
//        self.originPriceLab.text = "¥14589"
//        self.numberLab.text = "x3"
        
//        self.priceLab.text = "¥13589"
        
//        self.orderCodeLab.text = "繁育服务"
//        self.statusLab.text = "已预约"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
