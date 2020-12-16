//
//  AC_XQMallSearchVC.swift
//  XQAncientCatProject
//
//  Created by sinking on 2020/1/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMallSearchVC: XQACBaseVC {
    
    let contentView = AC_XQMallSearchOtherView()
    let resultContentView = AC_XQMallSearchResultView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let t0 = UIBarButtonItem.init(title: "垂直", style: .plain, target: self, action: #selector(respondsToVertical))
        let t1 = UIBarButtonItem.init(title: "横向", style: .plain, target: self, action: #selector(respondsToHorizontal))
        
        
        self.xq_navigationBar.addRightBtns(with: t0, t1)
        
        
        self.respondsToVertical()
        
    }
    
    @objc func respondsToVertical() {
        
        self.contentView.removeFromSuperview()
        
        self.xq_view.addSubview(self.resultContentView)
        self.resultContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    @objc func respondsToHorizontal() {
        
        self.resultContentView.removeFromSuperview()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}
