//
//  AC_XQRegisterVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/7.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQRegisterVC: XQACBaseVC {

    let contentView = AC_XQLoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.isHidden = true
        self.xq_view.isHidden = true
        
        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.headerView.titleLab.text = "Hello!"
        
        weak var weakSelf = self
        self.contentView.headerView.codeBtn?.xq_addEvent(.touchUpInside, callback: { (sender) in
            print("获取验证码")
        })
        
        
        
    }
    
    // MARK: - responds
    
    @objc func respondsToSearch() {
        
    }
}
