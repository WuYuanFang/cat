//
//  AC_XQStatusVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQStatusVC: XQACBaseVC {
    
    let contentView = AC_XQStatusView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    


}
