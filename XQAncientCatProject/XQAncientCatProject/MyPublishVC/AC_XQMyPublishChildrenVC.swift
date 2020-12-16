//
//  AC_XQMyPublishChildrenVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMyPublishChildrenVC: XQACBaseVC {

    let contentView = AC_XQMyPublishView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.isHidden = true
        self.xq_view.isHidden = true

        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}
