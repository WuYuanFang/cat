//
//  AC_XQShopMallOrderDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/21.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class AC_XQShopMallOrderDetailView: AC_XQFosterOrderViewBaseView {

    let headerView = AC_XQShopMallOrderViewHeaderView()
    
    let infoView = AC_XQShopMallOrderDetailViewInfoView()
    
    let bottomView = AC_XQWashProtectOrderDetailViewBottomView()
    
    let signBtn = UIButton()
    let statusLabel = UILabel()
    let animalImg = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.infoView, self.bottomView, statusLabel, animalImg, signBtn)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.infoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalTo(-12)
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-FootSafeHeight-70)
        }
        let json = UserDefaults.standard.string(forKey: "XQSMNTCommonGetSystemConfigResModel")
        let days = XQSMNTCommonGetSystemConfigResModel.deserialize(from: json)?.ReceiveExpire ?? 3
        let str = days / 24
        
        signBtn.setImage(UIImage(named: "icon_sign_order"), for: .normal)
        signBtn.setTitleColor(UIColor.init(fromHexString: "#8a8a8a"), for: .normal)
        signBtn.setTitle("\(str)天后系统自动收货", for: .normal)
        signBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        signBtn.isEnabled = false
        signBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        signBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(18)
            make.top.equalTo(bottomView.snp.bottom)
        }
        
        statusLabel.font = UIFont.systemFont(ofSize: 20)
        statusLabel.textColor = .ac_mainColor
        statusLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.bottom.equalTo(-FootSafeHeight-10)
            make.height.equalTo(30)
        }
        animalImg.image = UIImage(named: "icon_waiting")
        animalImg.contentMode = .scaleAspectFit
        animalImg.snp.makeConstraints { (make) in
            make.right.equalTo(statusLabel.snp.left).offset(-12)
            make.height.width.equalTo(30)
            make.centerY.equalTo(statusLabel)
        }
        
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        // 设置动画属性
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        anim.isRemovedOnCompletion = false
        // 将动画添加到图层上
        animalImg.layer.add(anim, forKey: nil)
        
        // 设置属性
        self.headerView.arrowImgView.isHidden = true
        self.bottomView.isHidden = true
        animalImg.isHidden = true
        signBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class AC_XQShopMallOrderDetailViewInfoView: AC_XQFosterOrderViewInfoViewBaseView {
    
    
    let productView = AC_XQShopMallOrderViewInfoViewCellContentView()
    
    /// 购买数量
    let buyNumberView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 运费
    let freightView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 会员抵扣
    let vipZKView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 优惠卷
    let couponView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 支付金额
    let moneyView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 取消订单
    let cancelOrderBtn = UIButton()
    /// 申请退款
    let refundBtn = UIButton()
    /// 功能按钮
    let funBtn = UIButton()
    /// 取消订单
    let cancelOrderLab = UILabel()
    
    /// 备注
    let remarkView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 订单号
    let orderLab = UILabel()
    /// 复制
    let copyBtn = UIButton()
    /// 支付时间
    let payTimeLab = UILabel()
    
    
    let spacing: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.productView, self.buyNumberView, self.freightView, self.vipZKView, self.couponView, self.moneyView, self.refundBtn, self.cancelOrderBtn, self.cancelOrderLab, self.remarkView, self.orderLab, self.copyBtn, self.payTimeLab, self.funBtn)
        
        
        // 布局
        self.productView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(80)
        }
        
        self.buyNumberView.snp.makeConstraints { (make) in
            make.top.equalTo(self.productView.snp.bottom).offset(spacing)
            make.left.equalTo(self.productView)
            make.right.equalTo(self.productView)
        }
        
        self.freightView.snp.makeConstraints { (make) in
            make.top.equalTo(self.buyNumberView.snp.bottom).offset(spacing)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
        self.vipZKView.snp.makeConstraints { (make) in
            make.top.equalTo(self.freightView.snp.bottom).offset(40)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
        self.couponView.snp.makeConstraints { (make) in
            make.top.equalTo(self.vipZKView.snp.bottom).offset(spacing)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
        self.moneyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.couponView.snp.bottom).offset(spacing)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
        self.refundBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyView.snp.bottom).offset(6)
            make.right.equalTo(self.buyNumberView)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        
        self.funBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyView.snp.bottom).offset(6)
            make.right.equalTo(self.refundBtn.snp.left).offset(-12)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        
        self.cancelOrderBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyView.snp.bottom).offset(6)
            make.right.equalTo(self.refundBtn.snp.left).offset(-12)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        
        self.cancelOrderLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.cancelOrderBtn)
            make.right.equalTo(self.cancelOrderBtn.snp.left).offset(-5)
        }
        
        self.remarkView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancelOrderBtn.snp.bottom).offset(40)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
//        self.orderLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.orderLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.remarkView.snp.bottom).offset(40)
            make.left.equalTo(self.buyNumberView)
            make.right.lessThanOrEqualToSuperview().offset(-50)
        }
        
        self.copyBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.orderLab)
            make.left.equalTo(self.orderLab.snp.right).offset(10)
        }
        
        self.payTimeLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.orderLab.snp.bottom).offset(5)
            make.left.equalTo(self.orderLab)
            make.bottom.equalTo(-30)
        }
        
        
        // 设置属性
        self.orderLab.numberOfLines = 0
        self.orderLab.font = UIFont.systemFont(ofSize: 13)
        self.orderLab.textColor = UIColor.init(hex: "#999999")
        
        self.payTimeLab.font = UIFont.systemFont(ofSize: 13)
        self.payTimeLab.textColor = UIColor.init(hex: "#999999")
        self.payTimeLab.numberOfLines = 0
        
        
        self.refundBtn.setTitle("申请退款", for: .normal)
        self.refundBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.refundBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.refundBtn.layer.cornerRadius = 15
        self.refundBtn.layer.borderWidth = 1
        self.refundBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.funBtn.setTitle("确认收货", for: .normal)
        self.funBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.funBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.funBtn.layer.cornerRadius = 15
        self.funBtn.layer.borderWidth = 1
        self.funBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.cancelOrderBtn.setTitle("取消订单", for: .normal)
        self.cancelOrderBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.cancelOrderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.cancelOrderBtn.layer.cornerRadius = 15
        self.cancelOrderBtn.layer.borderWidth = 1
        self.cancelOrderBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.cancelOrderLab.font = UIFont.systemFont(ofSize: 13)
        self.cancelOrderLab.textColor = UIColor.ac_mainColor
        
        self.copyBtn.setTitle("复制", for: .normal)
        self.copyBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        self.copyBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if let str = self.orderLab.text?.components(separatedBy: " ").last {
                UIPasteboard.general.string = str
                SVProgressHUD.showSuccess(withStatus: "已复制")
            }
        }
        
        self.buyNumberView.titleLab.text = "购买数量"
        
        self.freightView.titleLab.text = "运费"
        self.freightView.contentLab.text = "包邮"
        
        
        self.vipZKView.titleLab.text = "会员折扣"
        
        self.couponView.titleLab.text = "优惠券"
        
        self.moneyView.titleLab.text = "支付金额"
        
        self.remarkView.titleLab.text = "备注："
        
        self.buyNumberView.contentLab.text = "2"
        
//        self.cancelOrderLab.text = "21小时45分03秒"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}




