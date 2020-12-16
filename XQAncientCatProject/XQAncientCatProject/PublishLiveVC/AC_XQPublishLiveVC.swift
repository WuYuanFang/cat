//
//  AC_XQPublishLiveVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 我要发布
class AC_XQPublishLiveVC: XQACBaseVC {
    
    let contentView = AC_XQPublishLiveView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(respondsToPublish)))
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }
    
    
    @objc func respondsToPublish() {
        
    }
    

}
