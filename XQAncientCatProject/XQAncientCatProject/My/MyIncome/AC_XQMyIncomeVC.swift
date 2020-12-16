//
//  AC_XQMyIncomeVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 我的收入
class AC_XQMyIncomeVC: XQACBaseVC {

    let contentView = AC_XQMyIncomeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.detailBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.navigationController?.pushViewController(AC_XQMyIncomeDetailVC(), animated: true)
        }
    }

}
