//
//  AC_XQAlert.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQBottomAlertDelegate: NSObjectProtocol {
    
    /// 点击取消或者点击背景
    func bottomAlert(hide bottomAlert: AC_XQBottomAlert)
    
}

class AC_XQBottomAlert: UIView {
     
    weak var baseDelegate: AC_XQBottomAlertDelegate?
    
    private static var _bottomAlert: AC_XQBottomAlert?
    
    private let backView = UIView()
    let alertView = UIView()
    
    let contentView = UIView()
    
    var hideCallback: ( () -> () )?
    
    static func show(_ contentHeight: CGFloat = 246) {
        
        if let _ = _bottomAlert {
            return
        }
        
        
//        _bottomAlert = AC_XQBottomAlert.init(frame: UIScreen.main.bounds, contentHeight: contentHeight)
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
    
    /// 圆角
    let lc: CGFloat = 20
    /// 内容高度
    private var contentHeight: CGFloat = 226 + 20
    
    required init(frame: CGRect, contentHeight: CGFloat = 246) {
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
        self.backView.xq_addTap { [unowned self] (_) in
            
            if self.baseDelegate != nil {
                self.baseDelegate?.bottomAlert(hide: self)
            }else {
                weakSelf?.hide()
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 显示在 window 上
    func showWindow() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        self.show()
        
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
            AC_XQBottomAlert._bottomAlert = nil
            self.hideCallback?()
        }
    }
    
}
