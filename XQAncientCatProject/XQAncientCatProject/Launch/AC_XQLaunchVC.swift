//
//  AC_XQLaunchVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLaunchVC: UIViewController {
    
    let contentView = AC_XQLaunchView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.backgroundColor = UIColor.white
        
    }
    
}
