//
//  AC_XQAlertBottomOtherView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/2.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

@objc protocol AC_XQAlertBottomOtherViewDelegate: NSObjectProtocol {

    /// 点击取消或者点击背景
    @objc optional func alertBottomOtherView(hide alertBottomOtherView: AC_XQAlertBottomOtherView)
    
}

class AC_XQAlertBottomOtherView: UIView {
    
    let contentView = AC_XQAlertBottomOtherViewContentView()
    
    weak var delegate: AC_XQAlertBottomOtherViewDelegate?
    
    static func show(_ contentHeight: CGFloat = 317.5) {
        
        if let _ = _bottomAlert {
            return
        }
        
        _bottomAlert = self.init(frame: UIScreen.main.bounds, contentHeight: contentHeight)
        UIApplication.shared.keyWindow?.addSubview(_bottomAlert!)
        _bottomAlert?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        _bottomAlert?.show()
        
    }
    
    static func hide() {
        if let bottomAlert = _bottomAlert {
            bottomAlert.hide()
        }
    }
    
    private static var _bottomAlert: AC_XQAlertBottomOtherView?
    
    private let backView = UIView()
    private let alertView = UIView()
    
    /// 圆角
    private let lc: CGFloat = 20
    /// 内容高度
    private var contentHeight: CGFloat = 317.5 + 20
    
    required init(frame: CGRect, contentHeight: CGFloat = 317.5) {
        super.init(frame: frame)
        
        self.contentHeight = contentHeight
        
        // 初始化时, 要设置基础 frame, 不然无法实现动画
        self.backView.frame = self.bounds
        self.alertView.frame = CGRect.init(x: 0, y: self.bounds.height, width: self.bounds.width, height: self.contentHeight)
        self.contentView.frame = CGRect.init(x: 0, y: 0, width: self.alertView.bounds.width, height: self.alertView.frame.height - self.lc)
        
        self.xq_addSubviews(self.backView, self.alertView)
        self.alertView.addSubview(self.contentView)
        
        // 布局
        
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.alertView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.contentHeight)
            make.height.equalTo(self.contentHeight)
        }
        
        // 设置属性
        self.backView.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        
        self.alertView.backgroundColor = UIColor.white
        self.alertView.layer.cornerRadius = self.lc
        
        
        weak var weakSelf = self
        self.backView.xq_addTap { (_) in
            weakSelf?.hide()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        
        self.backView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.backView.alpha = 1
            
            self.alertView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.lc)
            }
            
            self.layoutIfNeeded()
        }
        
    }
    
    func hide() {
        self.backView.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.backView.alpha = 0
            self.alertView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.contentHeight)
            }
            
            self.layoutIfNeeded()
            
        }) { (_) in
            self.removeFromSuperview()
            self.delegate?.alertBottomOtherView?(hide: self)
            AC_XQAlertBottomOtherView._bottomAlert = nil
        }
    }
    
}


class AC_XQAlertBottomOtherViewContentView: UIView {
    
    private let xq_contentView = UIView()
    let contentView = UIView()
    private let lineView = UIView()
    let titleLab = UILabel()
    let sureBtn = UIButton()
    
    private let bottomView = UIView()
    let bottomLab = UILabel()
    
    private var _xq_cornerRadius: CGFloat = 30
    var xq_cornerRadius: CGFloat {
        set {
            _xq_cornerRadius = newValue
        }
        get {
            return _xq_cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.bottomView, self.xq_contentView)
        
        self.xq_contentView.xq_addSubviews(self.lineView, self.titleLab, self.sureBtn, self.contentView)
        self.bottomView.addSubview(self.bottomLab)
        
        // 布局
        
        self.xq_contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.xq_contentView.snp.bottom).offset(-self.xq_cornerRadius)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
            make.width.equalTo(32)
            make.height.equalTo(4)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(35)
        }
        
        self.sureBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(-16)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.bottomLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.xq_cornerRadius)
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(83)
        }
        
        
        // 设置属性
        self.xq_contentView.backgroundColor = UIColor.white
        self.xq_contentView.layer.cornerRadius = self.xq_cornerRadius
        self.xq_contentView.layer.masksToBounds = true
        
        self.bottomView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        self.lineView.backgroundColor = UIColor.init(hex: "#EEEEEE")
        self.lineView.layer.cornerRadius = 2
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.sureBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.sureBtn.setTitle("确定", for: .normal)
        self.sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        self.bottomLab.textColor = UIColor.ac_mainColor
        self.bottomLab.font = UIFont.systemFont(ofSize: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


