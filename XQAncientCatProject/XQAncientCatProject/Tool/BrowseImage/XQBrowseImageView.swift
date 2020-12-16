//
//  XQBrowseImageView.swift
//  XQShopMallProject
//
//  Created by WXQ on 2020/5/18.
//  Copyright © 2020 itchen.com. All rights reserved.
//

import UIKit
import SDCycleScrollView

class XQBrowseImageView: UIView, SDCycleScrollViewDelegate {
    
    private static var _browseImageView: XQBrowseImageView?
    
    static func show(_ imgArr: [Any], defaultSelectIndex: Int = 0) {
        if let _ = _browseImageView {
            return
        }
        
        print("wxq: ", imgArr)
        
        _browseImageView = XQBrowseImageView.init(frame: CGRect.zero, imgArr: imgArr, defaultSelectIndex: defaultSelectIndex)
        
        UIApplication.shared.keyWindow?.addSubview(_browseImageView!)
        _browseImageView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        _browseImageView?.show()
        
    }
    
    static func hide() {
        if let bottomAlert = _browseImageView {
            bottomAlert.hide()
        }
    }
    
    private var contentView: SDCycleScrollView!
    private let backView = UIView()
    private var defaultSelectIndex = 0
    
    init(frame: CGRect, imgArr: [Any], defaultSelectIndex: Int = 0) {
        super.init(frame: frame)
        
        
        // 初始化时, 要设置基础 frame, 不然无法实现动画
        self.backView.frame = self.bounds
        self.contentView = SDCycleScrollView.init(frame: self.bounds, imageNamesGroup: imgArr)
        self.contentView.delegate = self
        self.contentView.bannerImageViewContentMode = .scaleAspectFit
        self.contentView.infiniteLoop = false
        self.contentView.autoScroll = false
        // 这个不行的...
        self.contentView.makeScroll(to: defaultSelectIndex)
        self.defaultSelectIndex = defaultSelectIndex
        
        self.xq_addSubviews(self.backView, self.contentView)
        
        // 布局
        
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        self.backView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        self.contentView.backgroundColor = UIColor.clear
        
        weak var weakSelf = self
        self.backView.xq_addTap { (_) in
            weakSelf?.hide()
        }
        
        self.contentView.xq_addTap { (_) in
            weakSelf?.hide()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func show() {
        
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
        
        
        
    }
    
    private func hide() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            
        }) { (_) in
            self.removeFromSuperview()
            XQBrowseImageView._browseImageView = nil
        }
    }
    
    
//    private var setIndex = false
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if !self.setIndex {
//            print("wxq: ", self.defaultSelectIndex)
//            self.setIndex = true
//            self.contentView.makeScroll(to: self.defaultSelectIndex)
//        }
//        
//    }
    
    // MARK: - SDCycleScrollViewDelegate
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
    }
    
}
