//
//  XQSMBaseVC.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/6.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD
import SnapKit
import XQProjectTool_iPhoneUI
import QMUIKit

class XQACBaseVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    /// 自定义导航栏
    let xq_navigationBar = XQACNavigationBar()
    /// 内容view, 一般其他 vc 都写view内容到这个上
    let xq_view = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.forceEnableInteractivePopGestureRecognizer()
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.xq_view)
        self.view.addSubview(self.xq_navigationBar)
        
        
        self.xq_navigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
//            make.height.equalTo(XQIOSDevice.getNavigationHeight())
        }
        
        self.xq_view.snp.makeConstraints { (make) in
            make.top.equalTo(self.xq_navigationBar.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func forceEnableInteractivePopGestureRecognizer() -> Bool {
        return true
    }
    
    #if DEBUG
    deinit {
        print(#function, NSStringFromClass(self.classForCoder))
    }
    #endif
    
    
}


extension XQACBaseVC {
    
    
    /// 在最左边加一层 view
    /// 因为加了 CMPageTitleView, 就不能左滑返回了. 非常难触发
    /// 所以在左边加一层透明的 view, 就能让系统认为那边没有滑动手势
    func xq_addLeftMaskView(_ leftWith: CGFloat = 20) {
        let v = UIView()
        self.xq_view.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(leftWith)
        }
    }
    
}

enum AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType {
    /// 透明
    case transparent
    /// 半透明
    case translucent
    /// 不透明
    case opaque
}

/// 滚动导航栏, 会渐变
protocol AC_XQBaseVCSrollNavigationBarGradientsProtocol: NSObjectProtocol {
    /// 当前状态
    var xq_ngbCurrentType: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType {set get}
    
    /// 导航栏变化回调
    func xq_nbgChange(_ type: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType)
    
    /// 滚动视图已滚动
    /// - Parameters:
    ///   - scrollY: 当前滚动视图的y
    ///   - transparentY: 透明的y最大值
    ///   - translucentY: 半透明的y最大值
    func xq_nbgDidScroll(with scrollY: Float, transparentY: Float, translucentY: Float, translucentColor: UIColor, opaqueColor: UIColor)
    
}

extension AC_XQBaseVCSrollNavigationBarGradientsProtocol where Self:XQACBaseVC {
    
    /// 滚动视图已滚动
    func xq_nbgDidScroll(with scrollY: Float, transparentY: Float = 1, translucentY: Float = 100, translucentColor: UIColor = UIColor.init(white: 1, alpha: 0.3), opaqueColor: UIColor = UIColor.white) {
        
        if scrollY <= transparentY {
            if self.xq_ngbCurrentType != .transparent {
                self.xq_navigationBar.backgroundColor = UIColor.clear
                self.xq_ngbCurrentType = .transparent
                self.xq_nbgChange(.transparent)
            }
            
        }else if scrollY <= translucentY {
            
            if self.xq_ngbCurrentType != .translucent {
                self.xq_navigationBar.backgroundColor = translucentColor
                self.xq_ngbCurrentType = .translucent
                self.xq_nbgChange(.translucent)
            }
            
        }else {
            if self.xq_ngbCurrentType != .opaque {
                self.xq_navigationBar.backgroundColor = opaqueColor
                self.xq_ngbCurrentType = .opaque
                self.xq_nbgChange(.opaque)
            }
        }
        
    }
    
}


