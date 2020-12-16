//
//  AC_XQCouponViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

class AC_XQCouponViewCell: AC_XQShadowCell {
    
    /// 左边表示状态的背景按钮
    let leftBtn = UIButton()
    let typeView = AC_XQCouponTypeView()
    /// 钱或打折
    let moneyView = AC_XQMoneyView.init(frame: .zero, direction: .right)
    let statusLab = UILabel()
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    let dateLab = UILabel()
    let useBtn = UIButton()
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.xq_contentView.xq_addSubviews(self.leftBtn, self.typeView, self.titleLab, self.messageLab, self.dateLab, self.useBtn)
        self.leftBtn.xq_addSubviews(self.moneyView, self.statusLab)
        
        /// 布局
        self.leftBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(self.leftBtn.snp.height)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(self.leftBtn.snp.right).offset(12)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(8)
            make.left.equalTo(self.titleLab)
        }
        
        self.dateLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.left.equalTo(self.titleLab)
            make.right.equalToSuperview()
        }
        
        let useBtnHeight: CGFloat = 25
        self.useBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.centerY)
            make.right.equalTo(-12)
            make.size.equalTo(CGSize.init(width: 76, height: useBtnHeight))
        }
        
        self.typeView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(5)
        }
        
        self.moneyView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.statusLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.centerX.equalToSuperview()
        }
        
        /// 设置属性
        
        self.xq_contentView.layer.cornerRadius = 0
        self.xq_contentView.layer.masksToBounds = false
        
//        self.leftBtn.backgroundColor = UIColor.init(hex: "#86A6A8")
        self.leftBtn.isUserInteractionEnabled = false
        
        self.useBtn.setTitle("立即使用", for: .normal)
        self.useBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.useBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.useBtn.layer.cornerRadius = useBtnHeight/2
        self.useBtn.layer.borderWidth = 1
        self.useBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        self.useBtn.isUserInteractionEnabled = false
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.moneyView.moneyLab.textColor = UIColor.white
        self.moneyView.symbolLab.textColor = UIColor.white
        
        self.statusLab.textColor = UIColor.white
        self.statusLab.font = UIFont.systemFont(ofSize: 11)
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 12)
        
        self.dateLab.textColor = UIColor.init(hex: "#999999")
        self.dateLab.font = UIFont.systemFont(ofSize: 11)
//        self.dateLab.numberOfLines = 2
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

extension AC_XQCouponViewCell {
    
    func reloadUI(with model: XQSMNTCouponListModel) {
        if model.StateInt == 1 {
            self.statusLab.text = "未使用"
//            self.leftBtn.backgroundColor = UIColor.init(hex: "#86A6A8")
            self.leftBtn.setBackgroundImage(UIImage.init(named: "coupon_leftImg")?.xq_image(withTintColor: UIColor.init(hex: "#86A6A8")), for: .normal)
        }else {
            self.statusLab.text = "已过期"
//            self.leftBtn.backgroundColor = UIColor.init(hex: "#999999")
            self.leftBtn.setBackgroundImage(UIImage.init(named: "coupon_leftImg")?.xq_image(withTintColor: UIColor.init(hex: "#999999")), for: .normal)
        }
        
        
        self.titleLab.text = model.Name
        if model.OrderAmountLower == 0 {
            self.messageLab.text = "无门槛"
        }else {
            self.messageLab.text = "满\(model.OrderAmountLower)元使用"
        }
        
        self.dateLab.text = "有效期限：\(model.CreateTime) ~ \(model.ExpireTime)"
        
        self.typeView.vType = model.CouponType
        
        if model.Discount == 0 {
            self.moneyView.direction = .left
            self.moneyView.symbolLab.text = "¥"
            self.moneyView.moneyLab.text = "\(model.Money)"
        }else {
            self.moneyView.direction = .right
            self.moneyView.symbolLab.text = "折"
            let result = Float(model.Discount)/10
            self.moneyView.moneyLab.text = "\(result)"
        }
    }
    
}

class AC_XQCouponTypeView: UIView {
    
    private var _vType: XQSMNTCouponListModel.ModelType = .commodity
    var vType: XQSMNTCouponListModel.ModelType {
        set {
            _vType = newValue
            switch _vType {
            case .commodity:
                self.backView.backgroundColor = UIColor.init(hex: "#F8B024")
                self.typeLab.text = "商\n品"
            case .service:
                self.backView.backgroundColor = UIColor.init(hex: "#6CAED8")
                self.typeLab.text = "服\n务"
            case .otherService:
                self.backView.backgroundColor = UIColor.init(hex: "#65b9bf")
                self.typeLab.text = "服\n务"
            }
        }
        get {
            return _vType
        }
    }
    
    private let backView = UIView()
    private let typeLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.backView, self.typeLab)
        
        // 布局
        
        self.typeLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
            make.bottom.equalToSuperview().offset(-6)
        }
        
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        self.layer.shadowOffset = CGSize.init(width: 2, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.typeLab.textColor = UIColor.white
        self.typeLab.font = UIFont.systemFont(ofSize: 11)
        self.typeLab.numberOfLines = 0
        self.typeLab.textAlignment = .center
        
        self.vType = .commodity
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backView.xq_corners_addRoundedCorners([.bottomLeft, .bottomRight], withRadii: CGSize.init(width: self.backView.frame.width/2, height: self.backView.frame.width/2))
    }
    
}

