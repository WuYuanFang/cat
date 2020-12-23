//
//  XQACNC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

// QMUIKit 影响
//class XQACNC: UINavigationController, UIGestureRecognizerDelegate {
//class XQACNC: QMUINavigationController {
class XQACNC: UINavigationController {
    
//    override init(rootViewController: UIViewController) {
//        super.init(rootViewController: rootViewController)
//        self.setNavigationBarHidden(true, animated: false)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 自定义导航栏右滑返回失效问题
        // 不过这样设置, 也会出现第一层(就是 .viewControllers 只有一个的时候)直接搞手势的时候, 会出现 bug
        // 所以需要实现 UIGestureRecognizerDelegate 的 func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool 方法
        
        
        // QMUIKit 影响
        // 判断一下, 如果当前只有一个, 那么就 false, 这次 pop 手势不要处理
//        self.interactivePopGestureRecognizer?.delegate = self
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0 {
            // 自动隐藏tabbar
            viewController.hidesBottomBarWhenPushed = true
            
            // 显示返回图片
            if let vc = viewController as? XQACBaseVC {
                // 显示返回图片
                vc.xq_navigationBar.showBackImg()
                // 响应点击返回
                weak var weakSelf = self
                vc.xq_navigationBar.backCallback = {
                    weakSelf?.popViewController(animated: true)
                }
            }
            
        }
        
            // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
        super.pushViewController(viewController, animated: animated)
    }
    
    // QMUIKit 影响
    // MARK: - UIGestureRecognizerDelegate
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        print(#function)
//        return super.gestureRecognizerShouldBegin(gestureRecognizer)
//        if self.viewControllers.count > 1 {
//            return true
//        }
//        return false
//    }

}
