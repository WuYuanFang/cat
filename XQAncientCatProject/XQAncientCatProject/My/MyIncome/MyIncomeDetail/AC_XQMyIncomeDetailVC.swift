//
//  AC_XQMyIncomeDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMyIncomeDetailVC: XQACBaseVC {
    
    let contentView = AC_XQMyIncomeDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setTitle("余额明细")
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}
