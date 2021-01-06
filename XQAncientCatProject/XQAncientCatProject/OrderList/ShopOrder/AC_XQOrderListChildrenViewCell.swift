//
//  AC_XQOrderListChildrenViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQOrderListChildrenViewCell: AC_XQThreeContentCell {
    
    var model:XQSMNTOrderBaseInfoDtoModel?
    
    
    let orderCodeLab = UILabel()
    let statusLab = UILabel()
    
    let iconImgView = UIImageView()
    let titleLab = UILabel()
    let messageLab = UILabel()
    let priceLab = UILabel()
    let numberLab = UILabel()
    let originPriceLab = UILabel()
    
    let deleteBtn = UIButton()
    let dateLab = UILabel()
    let statusBtn = UIButton()
    let funcBtn = UIButton()
    
    @objc func updateTime() {
        if let m = model, (m.OrderState == .inInspection || m.OrderState == .confirmed || m.OrderState == .inStock) {
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
        
        self.topContentView.xq_addSubviews(self.orderCodeLab, self.statusLab)
        
        self.centerContentView.xq_addSubviews(self.iconImgView, self.titleLab, self.messageLab, self.priceLab, self.numberLab, self.originPriceLab)
        
        self.bottomContentView.xq_addSubviews(self.deleteBtn, self.dateLab, self.funcBtn, self.statusBtn)
        
        
        // 布局
        
        self.orderCodeLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(12)
            make.right.equalTo(self.statusLab.snp.left).offset(-5)
        }
        
        self.statusLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-12)
            make.width.greaterThanOrEqualTo(72)
        }
        
        self.iconImgView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(12)
            make.width.equalTo(self.iconImgView.snp.height)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView)
            make.left.equalTo(self.iconImgView.snp.right).offset(12)
            make.right.equalTo(self.originPriceLab.snp.left).offset(-5)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
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
            make.bottom.equalTo(self.iconImgView)
            make.right.equalTo(self.originPriceLab)
        }
        
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.dateLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.deleteBtn.snp.right).offset(10)
            make.right.equalTo(self.statusBtn.snp.left).offset(-5)
        }
        
        let funcBtnHeight: CGFloat = 26
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
        
        self.orderCodeLab.numberOfLines = 2
        self.orderCodeLab.textColor = UIColor.init(hex: "#666666")
        self.orderCodeLab.font = UIFont.systemFont(ofSize: 13)
        
        self.statusLab.textColor = UIColor.ac_mainColor
        self.statusLab.font = UIFont.systemFont(ofSize: 14)
        self.statusLab.textAlignment = .right
        
        self.originPriceLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.originPriceLab.textColor = UIColor.init(hex: "#999999")
        self.originPriceLab.font = UIFont.systemFont(ofSize: 14)
        self.numberLab.textColor = UIColor.init(hex: "#999999")
        self.numberLab.font = UIFont.systemFont(ofSize: 14)
        
        self.priceLab.font = UIFont.systemFont(ofSize: 15)
        
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 14)
        
        
        self.iconImgView.layer.cornerRadius = 4
        self.iconImgView.layer.masksToBounds = true
        self.iconImgView.contentMode = .scaleAspectFill
        
        self.deleteBtn.setBackgroundImage(UIImage.init(named: "review_delete_list"), for: .normal)
        
        self.dateLab.textColor = UIColor.init(hex: "#999999")
        self.dateLab.font = UIFont.systemFont(ofSize: 13)
        
        self.statusBtn.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.statusBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.statusBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        self.funcBtn.layer.borderWidth = 1;
        self.funcBtn.layer.borderColor = UIColor.ac_mainColor.cgColor;
        self.funcBtn.layer.cornerRadius = funcBtnHeight/2;
        self.funcBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.funcBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.statusBtn.setTitle("查看物流", for: .normal)
        
        self.funcBtn.setTitle("评价", for: .normal)
        
        
//        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        
//        self.titleLab.text = "好之味全价狗粮"
//        self.messageLab.text = "10kg | 牛肉味"
        
//        self.dateLab.text = "2019 -02-03 22:00"
        
//        self.originPriceLab.text = "¥14589"
//        self.numberLab.text = "x3"
        
//        self.priceLab.text = "¥13589"
        
//        self.orderCodeLab.text = "订单号：76567876590"
//        self.statusLab.text = "交易成功"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
