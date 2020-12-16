//
//  XQACTBC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class XQACTBC: UITabBarController {
    
    let homeVC = AC_XQHomePageVC()
    var homeNC: XQACNC!
    
//    let mallVC = AC_XQMallVC()
    let mallVC = AC_XQShopMallVC()
    var mallNC: XQACNC!
    
//    let orderVC = ViewController()
    let orderVC = AC_XQLiveBusinessVC()
    var orderNC: XQACNC!
    
    let myVC = AC_YCMyViewController()
    var myNC: XQACNC!
    
    var xq_tabBar: XQACTabBar!
    
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        self.xq_tabBar = XQACTabBar.init(frame: self.tabBar.frame)
        self.xq_tabBar.backgroundColor = UIColor.white
        self.setValue(self.xq_tabBar, forKey: "tabBar")
        
        let item = XQACTabBarContentViewItem.init(title: "首页",
                                                  normalImg: UIImage.init(named: "tabbar_home_0"),
                                                  selectImg: UIImage.init(named: "tabbar_home_1"))
        self.xq_tabBar.contentView.items.append(item)
        
        let item1 = XQACTabBarContentViewItem.init(title: "商城",
                                                   normalImg: UIImage.init(named: "tabbar_mall_0"),
                                                   selectImg: UIImage.init(named: "tabbar_mall_1"))
        self.xq_tabBar.contentView.items.append(item1)
        
        let item2 = XQACTabBarContentViewItem.init(title: "活体",
                                                   normalImg: UIImage.init(named: "tabbar_live_0"),
                                                   selectImg: UIImage.init(named: "tabbar_live_1"))
        self.xq_tabBar.contentView.items.append(item2)
        
        let item3 = XQACTabBarContentViewItem.init(title: "我的",
                                                   normalImg: UIImage.init(named: "tabbar_my_0"),
                                                   selectImg: UIImage.init(named: "tabbar_my_1"))
        self.xq_tabBar.contentView.items.append(item3)
        
        self.xq_tabBar.contentView.refreshUI()
        
        self.xq_tabBar.contentView.selectCallback = { index in
            self.selectedIndex = index
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeNC = self.initNC(with: "首页", img: "tabbar_home_0", vc: self.homeVC)
        self.mallNC = self.initNC(with: "商城", img: "tabbar_mall_0", vc: self.mallVC)
        self.orderNC = self.initNC(with: "活体", img: "tabbar_live_0", vc: self.orderVC)
        self.myNC = self.initNC(with: "我的", img: "tabbar_my_0", vc: self.myVC)
        
        
        self.viewControllers = [self.homeNC, self.mallNC, self.orderNC, self.myNC]
//        self.viewControllers = [self.homeNC, self.mallNC, self.myNC]
        self.selectedIndex = 0
        
    }
    
    private func initNC(with title: String, img: String, vc: UIViewController) -> XQACNC {
        let nc = XQACNC.init(rootViewController: vc)
        nc.tabBarItem.title = title
        nc.tabBarItem.image = UIImage.init(named: img)
        
        return nc
    }
    
}
