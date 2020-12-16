//
//  XQAutoHeightWebView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class XQAutoHeightWebView: UIView, WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate {
    
    var webView: WKWebView!
    
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
        
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if Float(weakSelf?.webView.scrollView.contentSize.height ?? 0) != weakSelf?.lastHeight {
                weakSelf?.lastHeight = Float(weakSelf?.webView.scrollView.contentSize.height ?? 0)
                weakSelf?.xq_layout(weakSelf?.lastHeight ?? 0)
            }
            weakSelf?.monitorWebViewContentSize()
        }
    }
    
    func initUI() {
        let config = WKWebViewConfiguration.init()
        let userContentCtl =  WKUserContentController.init()
        
        config.userContentController = userContentCtl
        self.webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        self.addSubview(self.webView)
        
        // 布局
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
        
        // 设置属性
        
        self.webView.uiDelegate = self
        self.webView.navigationDelegate = self
        self.webView.scrollView.bounces = false
        print("scrollView: ", self.webView.scrollView.frame, self.webView.scrollView.contentSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func xq_layout(_ height: Float) {
        self.webView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        
        self.heightRefreshCallback?(height)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.xq_prohibitZoom_js()
    }
    
    #if DEBUG
    deinit {
        print(self.classForCoder, #function)
    }
    #endif
    
}


extension WKWebView {
    
    /// 注入js, 禁止缩放
    /// 在代理 WKNavigationDelegate,  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) 中调用
    func xq_prohibitZoom_js(_ completionHandler: ((Any?, Error?) -> Void)? = nil) {
        let injectionJSString = """
        var script = document.createElement('meta');
        script.name = 'viewport';
        script.setAttribute('content', 'width=device-width, user-scalable=no');
        document.getElementsByTagName('head')[0].appendChild(script);
        """
        
        self.evaluateJavaScript(injectionJSString) { (data, error) in
            completionHandler?(data, error)
        }
    }
    
    /// 注入js, 图片自适应宽度
    func xq_ImgSelfAdaption_js() {
        self.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'", completionHandler: nil)
    
        // maxwidth WebView中显示的图片宽度
        let str = """
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.text = \"function ResizeImages() {
        var myimg,oldwidth;
        var maxwidth = 375.0;
        for(i=1;i <document.images.length;i++){
        myimg = document.images[i];
        oldwidth = myimg.width;
        myimg.width = maxwidth;
        }
        }\";
        document.getElementsByTagName('head')[0].appendChild(script);
        ResizeImages();
        """
        self.evaluateJavaScript(str, completionHandler: nil)
    }
    
}


