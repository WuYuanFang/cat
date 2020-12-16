//
//  AC_XQMallVC.swift
//  XQAncientCatProject
//
//  Created by sinking on 2020/1/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 已遗弃
class AC_XQMallVC: XQACBaseVC {
    
    let contentView = AC_XQMallView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let item = UIBarButtonItem.init(title: "搜索", style: .plain, target: self, action: #selector(respondsToSearch))
        self.xq_navigationBar.addRightBtn(with: item)
        
    }
    
    // MARK: - responds
    
    @objc func respondsToSearch() {
        let vc = AC_XQMallSearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
