//
//  AC_XQMyPublishAnnouncementVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView

class AC_XQMyPublishVC: XQACBaseVC, CMPageTitleViewDelegate {

    let titleView = CMPageTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.titleView)
        self.xq_addLeftMaskView()
        
        self.titleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let titleArr = [
            "全部",
            "未卖出",
            "已卖出",
        ]

        var vcArr = [UIViewController]()
        for (index, item) in titleArr.enumerated() {
            let vc = AC_XQMyPublishChildrenVC()
            
            vc.title = item

            vcArr.append(vc)
            self.addChild(vc)
            
        }

        let config = CMPageTitleConfig.default()
        
        config.sm_config()
        
        config.cm_childControllers = vcArr
        
        
        self.titleView.delegate = self
        self.titleView.cm_config = config
        
    }
    
    // MARK: - CMPageTitleViewDelegate
    
    func cm_pageTitleViewSelected(with index: Int, repeat: Bool) {
        
    }

}
