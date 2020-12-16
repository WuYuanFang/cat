//
//  AC_XQPetListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView

/// 宠物列表
class AC_XQPetListVC: XQACBaseVC, CMPageTitleViewDelegate {
    
    let titleView = CMPageTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "福利订单"
        
        self.xq_view.addSubview(self.titleView)
        self.xq_addLeftMaskView()
        
        self.titleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let titleArr = [
            "全部",
            "洗护中",
            "寄养中",
        ]

        var vcArr = [UIViewController]()
        for (index, item) in titleArr.enumerated() {
            let vc = AC_XQPetListChildrenVC()
            
            switch index {
            case 0:
                vc.petStatus = .all
                
            case 1:
                vc.petStatus = .washProtect
                
            case 2:
                vc.petStatus = .foster
                
            default:
                vc.petStatus = .all
            }
            
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
