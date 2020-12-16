//
//  XQTestViewController.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool

class XQTestViewController: XQACBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UIButton()

        label.setTitle("哈哈哈\nasd啊呵呵", for: .normal)
        label.setTitleColor(UIColor.orange, for: .normal)

        label.titleLabel?.xqAtt_setUnderlineStyle(.single, range: NSRange.init(location: 0, length: 3))

        self.xq_view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        UIButton().xq_addEvent(.touchUpInside) { (sender) in
            print("点击了按钮 ")
        }
        
    }
    
    
    
}
