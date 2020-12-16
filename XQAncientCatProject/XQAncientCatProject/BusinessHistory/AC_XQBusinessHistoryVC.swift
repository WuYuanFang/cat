//
//  AC_XQBusinessHistoryVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 交易记录
class AC_XQBusinessHistoryVC: XQACBaseVC {
    
    let contentView = AC_XQBusinessHistoryView()
    
    let headerView = AC_XQSegmentView.init(titleArr: ["我买到的", "我卖出的"])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.contentView.addSubview(self.headerView)
        self.headerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "管理", style: .plain, target: self, action: #selector(respondsToManager)))
        
    }

    
    // MARK: - responds
    
    @objc func respondsToManager() {
        self.contentView.xq_isEditing = !self.contentView.xq_isEditing
        
        if self.contentView.xq_isEditing {
            self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(respondsToManager)))
        }else {
            self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "管理", style: .plain, target: self, action: #selector(respondsToManager)))
        }
    }
    
}
