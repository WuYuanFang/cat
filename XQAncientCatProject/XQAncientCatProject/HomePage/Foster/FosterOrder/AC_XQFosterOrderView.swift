//
//  AC_XQFosterOrderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/2.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI
import XQUITextField_Navigation
import QMUIKit
import RxSwift
import SVProgressHUD

class AC_XQFosterOrderView: AC_XQFosterOrderViewBaseView {
    
    let headerView = AC_XQFosterOrderViewHeaderView()
    
    /// 支付
    let payView = AC_XQShopMallOrderViewPayView()
    
    let infoView = AC_XQFosterOrderViewInfoView()
    
    /// 积分
    let scoreView = XQSelectRowView()
    
    /// 会员专享
    let vipView = AC_XQFosterOrderViewVIPSelectRowView()
    
    /// 实名认证专享
    let rnDiscountView = AC_XQFosterOrderViewRealNameDiscountSelectRowView()
    
    /// 优惠券
    let couponView = AC_XQFosterOrderViewCouponView()
    
    /// 手机号
    let nameView = AC_XQFosterOrderViewTFView()
    
    /// 手机号
    let phoneView = AC_XQFosterOrderViewTFView()
    
    /// 备注
    let remarkLab = UILabel()
    let remarkTV = UITextView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.contentView.xq_addSubviews(self.payView, self.headerView, self.infoView, self.scoreView, self.vipView, self.rnDiscountView, self.couponView, self.nameView, self.phoneView, self.remarkLab, self.remarkTV)
        
        
        
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
        
        self.scoreView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(30)
        }
        
        self.vipView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scoreView.snp.bottom).offset(6)
            make.left.equalTo(self.scoreView)
            make.right.equalTo(self.scoreView)
            make.height.equalTo(30)
        }
        
        self.rnDiscountView.snp.makeConstraints { (make) in
            make.top.equalTo(self.vipView.snp.bottom).offset(6)
            make.left.equalTo(self.vipView)
            make.right.equalTo(self.vipView)
            make.height.equalTo(30)
        }
        
        self.couponView.snp.makeConstraints { (make) in
            make.top.equalTo(self.rnDiscountView.snp.bottom).offset(6)
            make.left.equalTo(self.vipView)
            make.right.equalTo(self.vipView)
            make.height.equalTo(30)
        }
        
        self.nameView.snp.makeConstraints { (make) in
            make.top.equalTo(self.couponView.snp.bottom).offset(25)
            make.left.equalTo(self.vipView)
            make.right.equalTo(self.vipView)
            make.height.equalTo(30)
        }
        
        self.phoneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameView.snp.bottom).offset(12)
            make.left.equalTo(self.vipView)
            make.right.equalTo(self.vipView)
            make.height.equalTo(30)
        }
        
        self.remarkLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneView.snp.bottom).offset(12)
            make.left.equalTo(self.vipView)
        }
        
        self.remarkTV.snp.makeConstraints { (make) in
            make.top.equalTo(self.remarkLab)
            make.left.equalTo(self.remarkLab.snp.right).offset(16)
            make.right.equalTo(self.vipView)
            make.height.equalTo(80)
        }
        
        self.payView.snp.makeConstraints { (make) in
            make.top.equalTo(self.remarkTV.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-25)
        }
        
        
        
        // 设置属性
        
        self.scoreView.titleLab.text = "积分抵扣(可抵扣¥3.01)"
        self.scoreView.leftBtn.isHidden = true
        self.scoreView.rightBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.scoreView.rightBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        
        self.phoneView.titleLab.text = "手机号："
        self.phoneView.tf.placeholder = "请填写联系人手机号"
        self.phoneView.tf.keyboardType = .numberPad
        
        self.nameView.titleLab.text = "姓名："
        self.nameView.tf.placeholder = "请填写联系人姓名"
        
        self.remarkLab.text = "备注："
        self.remarkLab.font = UIFont.systemFont(ofSize: 14)
        self.remarkTV.placeholder = "亲亲可以在这里备注哦"
        self.remarkTV.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.remarkTV.layer.cornerRadius = 4
        
        
        self.payView.payBtn.titleLab.text = "确认下单"
        self.payView.moneyLab.textColor = UIColor.black
        
        self.xq_showTextField_Navigation()
        
        
        // 不要积分折扣
        
        self.scoreView.removeFromSuperview()
        
        self.vipView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
}


class AC_XQFosterOrderViewBaseView: UIView {
    
    private let xq_contentView = UIView()
    /// 底部缩小的view
    private let backView = UIView()
    
    
    let scrollView = UIScrollView()
    /// 中间的白色 view, 把内容添加到这个 view 上就行了
    let contentView = UIView()
    
    let cornerRadius: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.xq_contentView)
        self.xq_contentView.xq_addSubviews(self.backView, self.scrollView)
        
        self.scrollView.addSubview(self.contentView)
        
        // 布局
        
        self.xq_contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.backView.snp.makeConstraints { (make) in
            make.top.equalTo(XQIOSDevice.getNavigationHeight() + 20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.bottom.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.backView).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(cornerRadius)
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
//        let vView = UIView()
//        self.scrollView.addSubview(vView)
//        vView.snp.makeConstraints { (make) in
//            make.left.top.bottom.equalToSuperview()
//            make.height.equalToSuperview()
//        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(-cornerRadius)
        }
        
        // 设置属性
        
        self.xq_contentView.backgroundColor = UIColor.init(hex: "#A9C0C2")
        
        self.backView.backgroundColor = UIColor.init(hex: "#D1DEE0")
        self.backView.layer.cornerRadius = cornerRadius
        
        self.scrollView.backgroundColor = UIColor.white
        self.scrollView.layer.cornerRadius = cornerRadius
        
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(notification_willShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(notification_willHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - notification
    @objc func notification_willShowNotification(_ notification: Notification) {
        
        if let keyFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let rect = keyFrame.cgRectValue
            print("wxq: ", rect)
            
            self.scrollView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.backView).offset(20)
                make.left.right.equalToSuperview()
                // 键盘的高度
                make.bottom.equalTo(-(rect.height - self.cornerRadius))
            }
            
        }
    }
    
    @objc func notification_willHideNotification(_ notification: Notification) {
        self.scrollView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.backView).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.cornerRadius)
        }
    }
    
}


class AC_XQFosterOrderViewTFView: UIView {
    
    /// 手机号
    let titleLab = UILabel()
    let tf = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.tf)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(60)
        }
        
        self.tf.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.left.equalTo(self.titleLab.snp.right)
            make.right.equalToSuperview()
        }
        
        // 设置属性
        
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        self.tf.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class AC_XQFosterOrderViewVIPSelectRowView: UIView {
    
    typealias AC_XQFosterOrderViewVIPSelectRowViewCallback = () -> ()
    var callback: AC_XQFosterOrderViewVIPSelectRowViewCallback?
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    /// 打多少折
    let dicountLab = UILabel()
    let rightBtn = QMUIButton()
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.dicountLab)
        self.addSubview(self.rightBtn)
        self.addSubview(self.imgView)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imgView.snp.right).offset(8)
        }
        
        self.dicountLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLab.snp.right).offset(3)
        }
        
        self.rightBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        self.titleLab.text = "会员专享"
        
        self.dicountLab.font = UIFont.systemFont(ofSize: 15)
        self.dicountLab.textColor = UIColor.init(hex: "#F7A32B")
        
        self.rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.rightBtn.imagePosition = .right
        self.rightBtn.imageView?.contentMode = .scaleAspectFit
        self.rightBtn.spacingBetweenImageAndTitle = 8
        self.rightBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.rightBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        self.rightBtn.isUserInteractionEnabled = false
        
        self.imgView.image = UIImage.init(named: "order_vip")
        
        self.rightBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ type: XQSMNTCouponListModel.ModelType) {
        
        if !ac_isShowV() {
            self.isHidden = true
            return
        }
        
        let reqModel = XQSMNTBaseReqModel()
        XQSMUserNetwork.getUserRankDiscount(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            var dicount: Float = 0
            
            switch type {
                
            case .commodity:
                dicount = resModel.AroundDicount
                
            case .otherService:
                dicount = resModel.FosterDicount
                
            case .service:
                dicount = resModel.BatheDicount
                
            }
            
            if dicount < 10, dicount > 0 {
                // 有折扣
                self.rightBtn.isHidden = false
                //                self.contentView.vipView.dicountLab.text = "会员专享\(resModel.AroundDicount.xq_removeDecimalPointZero())折"
                self.dicountLab.text = "\(dicount.xq_removeDecimalPointZero())折"
                
                self.xq_addTap { [unowned self] (gesture) in
                    self.rightBtn.isSelected.toggle()
                    self.callback?()
                }
                
            }else {
                self.rightBtn.isHidden = true
                self.dicountLab.text = "无"
                
                self.xq_removeTap()
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
}


class AC_XQFosterOrderViewCouponView: UIView {
    
    let arrowImgView = UIImageView()
    let titleLab = UILabel()
    
    /// 优惠券减多少
    let couponPriceLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.arrowImgView)
        self.addSubview(self.couponPriceLab)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        
        self.arrowImgView.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        self.couponPriceLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.arrowImgView.snp.left).offset(-10)
        }
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        self.titleLab.text = "优惠券"
        
        self.couponPriceLab.font = self.titleLab.font
        self.couponPriceLab.textColor = UIColor.init(hex: "#999999")
        
        self.arrowImgView.image = UIImage.init(named: "arrow_right")
        
    }
    
    func reloadUI(_ cModel: XQSMNTCouponListModel?) {
        if let cModel = cModel {
            if cModel.Discount == 0 {
                if cModel.Money != 0 {
                    self.couponPriceLab.text = "-¥\(cModel.Money)"
                }else {
                    self.couponPriceLab.text = ""
                }
            }else {
                let result = Float(cModel.Discount)/10
                self.couponPriceLab.text = "\(result)折"
            }
        }else {
            self.couponPriceLab.text = ""
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AC_XQFosterOrderViewRealNameDiscountSelectRowView: UIView {
    
    typealias AC_XQFosterOrderViewRealNameDiscountSelectRowViewCallback = () -> ()
    /// 去实名认证
    var toRealNameCallback: AC_XQFosterOrderViewRealNameDiscountSelectRowViewCallback?
    
    /// 改变选中状态
    var changeSelectCallback: AC_XQFosterOrderViewRealNameDiscountSelectRowViewCallback?
    
    let disposeBag = DisposeBag()
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    /// 满减多少
    let dicountLab = UILabel()
    let rightBtn = QMUIButton()
    
    let toRealNameBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.dicountLab)
        self.addSubview(self.rightBtn)
        self.addSubview(self.imgView)
        self.addSubview(self.toRealNameBtn)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imgView.snp.right).offset(8)
        }
        
        self.dicountLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.titleLab.snp.right).offset(3)
        }
        
        self.rightBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.toRealNameBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.toRealNameBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        self.titleLab.text = "认证专享"
        
        self.dicountLab.font = UIFont.systemFont(ofSize: 15)
        self.dicountLab.textColor = UIColor.ac_mainColor
//        self.dicountLab.text = "满50元减2元"
        
        self.rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.rightBtn.imagePosition = .right
        self.rightBtn.imageView?.contentMode = .scaleAspectFit
        self.rightBtn.spacingBetweenImageAndTitle = 8
        self.rightBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.rightBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        self.rightBtn.isUserInteractionEnabled = false
        
        self.toRealNameBtn.setTitle("去认证", for: .normal)
        self.toRealNameBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.toRealNameBtn.titleLabel?.font = self.titleLab.font
        self.toRealNameBtn.isUserInteractionEnabled = false
        
        self.imgView.image = UIImage.init(named: "security")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI() {
        let model = XQSMNTUserInfoModel.getUserInfoModel()
        let verifyMobile = model?.VerifyMobile ?? false
//        let verifyMobile = false
        
        self.rightBtn.isHidden = !verifyMobile
        self.toRealNameBtn.isHidden = verifyMobile
        
        if verifyMobile {
            self.xq_addTap { [unowned self] (gesture) in
                self.rightBtn.isSelected.toggle()
                self.changeSelectCallback?()
            }
        }else {
            self.xq_addTap { [unowned self] (gesture) in
                self.toRealNameCallback?()
            }
        }
        
        XQSMCommonNetwork.getSystemConfig().subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            
            self.dicountLab.text = "满\(resModel.TrueManMinPrice.xq_removeDecimalPointZero())元减\(resModel.TrueManPrice.xq_removeDecimalPointZero())元"
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    
}






