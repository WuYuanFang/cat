//
//  DKAutoContentView.swift
//  XQAncientCatProject
//
//  Created by wuyuanfang on 2021/1/13.
//  Copyright © 2021 WXQ. All rights reserved.
//

import UIKit

class DKAutoContentView: UIView {
    
    let detailLabel = UILabel()
    
//    var webView: WKWebView!
    
    typealias XQAutoHeightWebViewCallback = (_ height: Float) -> ()
    /// 高度变化回调
    var heightRefreshCallback: XQAutoHeightWebViewCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
        self.monitorWebViewContentSize()
    }
    
    private var lastHeight: Float = 0
    private func monitorWebViewContentSize() {
        
//        weak var weakSelf = self
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
//            if Float(weakSelf?.webView.scrollView.contentSize.height ?? 0) != weakSelf?.lastHeight {
//                weakSelf?.lastHeight = Float(weakSelf?.webView.scrollView.contentSize.height ?? 0)
//                weakSelf?.xq_layout(weakSelf?.lastHeight ?? 0)
//            }
//            weakSelf?.monitorWebViewContentSize()
//        }
    }
    
    func initUI() {
        self.addSubview(detailLabel)
        detailLabel.font = UIFont.systemFont(ofSize: 16)
        detailLabel.textColor = UIColor.qmui_color(withHexString: "333333")
        detailLabel.numberOfLines = 0
        detailLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
//        let config = WKWebViewConfiguration.init()
//        let userContentCtl =  WKUserContentController.init()
//
//        config.userContentController = userContentCtl
//        self.webView = WKWebView.init(frame: CGRect.zero, configuration: config)
//        self.addSubview(self.webView)
//
//        // 布局
//        self.webView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//            make.height.equalTo(0)
//        }
//
//        // 设置属性
//        self.webView.xq_ImgSelfAdaption_js()
//        self.webView.uiDelegate = self
//        self.webView.navigationDelegate = self
//        self.webView.scrollView.bounces = false
//        print("scrollView: ", self.webView.scrollView.frame, self.webView.scrollView.contentSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func xq_layout(_ height: Float) {
//        self.webView.snp.updateConstraints { (make) in
//            make.height.equalTo(height)
//        }
//
//        self.heightRefreshCallback?(height)
    }
    
    
    #if DEBUG
    deinit {
        print(self.classForCoder, #function)
    }
    #endif
    
}



