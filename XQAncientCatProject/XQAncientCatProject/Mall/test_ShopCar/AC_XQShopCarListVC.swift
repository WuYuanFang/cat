//
//  AC_XQShopCarListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopCarListVC: XQACBaseVC {
    
    let contentView = AC_XQShopCarListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setTitle("购物车")
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        let barButtonItem = UIBarButtonItem.init(title: "全部订单", style: .plain, target: self, action: #selector(respondsToAllOrder))
        self.xq_navigationBar.addRightBtn(with: barButtonItem)
        
    }
    
    // MARK: - responds
    
    @objc func respondsToAllOrder() {
        let vc = AC_XQMallOrderListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
