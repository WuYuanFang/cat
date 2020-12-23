//
//  AC_XQOrderListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView

/// 订单列表
class AC_XQOrderListVC: XQACBaseVC, CMPageTitleViewDelegate, AC_XQSegmentViewDelegate {
    
//    let headerView = AC_XQSegmentView.init(titleArr: ["商品订单", "服务订单", "活体订单"])
    let headerView = AC_XQSegmentView.init(titleArr: ["商品订单", "服务订单"])
    
    /// 商品订单
    let titleView = CMPageTitleView()
    
    /// 服务订单
    let serverOrderTitleView = CMPageTitleView()
    
    /// 活体订单
    let liveOrderTitleView = CMPageTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.title = "福利订单"
        
        self.headerView.delegate = self
        self.xq_navigationBar.contentView.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.xq_view.addSubview(self.titleView)
        self.xq_view.addSubview(self.serverOrderTitleView)
        self.xq_view.addSubview(self.liveOrderTitleView)
        
        self.xq_addLeftMaskView()
        
        // 布局
        self.titleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.serverOrderTitleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.liveOrderTitleView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.configTitleView(self.titleView, titleArr: [
            "全部",
            "待付款",
            "待发货",
            "待收货",
            "待评价",
            "退款/售后",
            
//            "全部",
//            "待付款",
//            "待确认",
//            "已确认",
//            "备货中",
//            "待收货",
//            "已收货",
//            "锁定",
//            "取消",
//            "退款中",
//            "退款完成",
            
        ], cl: AC_XQOrderListChildrenVC.self)
        
        
        var vcArr = [UIViewController]()
        for (index, item) in self.titleView.cm_config.cm_titles.enumerated() {
            let vc = AC_XQOrderListChildrenVC()
            
            vc.title = item
            
            switch index {
            case 0:
                vc.state = .all
                
            case 1:
                vc.state = .waitPay
                
            case 2:
                vc.state = .toBeDelivered
                
            case 3:
                vc.state = .delivered
                
            case 4:
                vc.state = .receivedGoods
                
            case 5:
                vc.state = .refundAndAfterSale
                
            default:
                vc.state = .all
                break
            }
            
            vcArr.append(vc)
        }
        
        self.titleView.cm_config.cm_childControllers = vcArr
        self.titleView.cm_reloadConfig()
        
        
        let arr = [AC_XQWashProtectOrderListVC.self, AC_XQServerOrderVC.self]
        self.configTitleView(self.serverOrderTitleView, titleArr: [
            //            "全部", // 暂时没有全部
            "洗护订单",
            "寄养订单",
            //            "繁育订单", // 暂时没有繁育
        ], clArr: arr)
        
        
        self.configTitleView(self.liveOrderTitleView, titleArr: [
            "没有UI1",
            "没有UI2",
        ], cl: AC_XQLiveOrderVC.self)
        
        
        
        
        self.serverOrderTitleView.isHidden = true
        self.liveOrderTitleView.isHidden = true
        
    }
    
    func configTitleView<T: XQACBaseVC>(_ pageTitleView: CMPageTitleView, titleArr: [String], cl: T.Type) {
        
        var vcArr = [UIViewController]()
        for (_, item) in titleArr.enumerated() {
//            let vc = AC_XQOrderListChildrenVC()
            let vc = cl.init()
            
            vc.title = item

            vcArr.append(vc)
            self.addChild(vc)
        }

        let config = CMPageTitleConfig.default()
        
        config.sm_config()
        config.cm_childControllers = vcArr
        
        pageTitleView.delegate = self
        pageTitleView.cm_config = config
    }
    
    func configTitleView<T: XQACBaseVC>(_ pageTitleView: CMPageTitleView, titleArr: [String], clArr: [T.Type]) {
            
        var vcArr = [UIViewController]()
        for (index, item) in titleArr.enumerated() {
            //            let vc = AC_XQOrderListChildrenVC()
            let vc = clArr[index].init()
            
            vc.title = item
            
            vcArr.append(vc)
            self.addChild(vc)
        }
        
        let config = CMPageTitleConfig.default()
        
        config.sm_config()
        config.cm_childControllers = vcArr
        
        pageTitleView.delegate = self
        pageTitleView.cm_config = config
    }
    
    // MARK: - CMPageTitleViewDelegate
    
    func cm_pageTitleViewSelected(with index: Int, repeat: Bool) {
        
    }
    
    // MARK: - AC_XQSegmentViewDelegate
    func segmentView(_ segmentView: AC_XQSegmentView, didSelectAtIndex index: Int) {
        
        if index == 0 {
            self.titleView.isHidden = false
            self.serverOrderTitleView.isHidden = true
            self.liveOrderTitleView.isHidden = true
        }else if index == 1 {
            self.titleView.isHidden = true
            self.serverOrderTitleView.isHidden = false
            self.liveOrderTitleView.isHidden = true
        }else {
            self.titleView.isHidden = true
            self.serverOrderTitleView.isHidden = true
            self.liveOrderTitleView.isHidden = false
        }
        
    }
    
    
}
