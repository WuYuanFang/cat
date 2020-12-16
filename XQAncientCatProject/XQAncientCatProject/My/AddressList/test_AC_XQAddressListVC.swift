//
//  AC_XQAddressListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class test_AC_XQAddressListVC: XQACBaseVC {
    
    let contentView = test_AC_XQAddressListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setTitle("地址管理")
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let item = UIBarButtonItem.init(title: "添加", style: .plain, target: self, action: #selector(respondsToAdd))
        self.xq_navigationBar.addRightBtn(with: item)
        
    }
    
    @objc func respondsToAdd() {
        AC_XQAddressListAlertView.show(with: "编辑地址")
    }
    
    
}
