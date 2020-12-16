//
//  AC_XQMessageListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMessageListVC: XQACBaseVC, AC_XQSegmentViewDelegate {
    
    let headerView = AC_XQSegmentView.init(titleArr: ["在线消息", "系统公告"])
    
    let contentView = AC_XQMessageListView()
    
    let onlineView = AC_XQMessageListViewOnlineView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.delegate = self
        self.xq_navigationBar.contentView.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        
        self.xq_view.addSubview(self.onlineView)
        self.onlineView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.isHidden = true
        
    }
    
    // MARK: - AC_XQSegmentViewDelegate
    
    func segmentView(_ segmentView: AC_XQSegmentView, didSelectAtIndex index: Int) {
        
        if index == 0 {
            self.onlineView.isHidden = false
            self.contentView.isHidden = true
        }else {
            self.onlineView.isHidden = true
            self.contentView.isHidden = false
        }
        
    }
    
}
