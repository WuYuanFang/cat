//
//  AC_XQMallOrderListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMallOrderListVC: XQACBaseVC, AC_XQMallOrderListViewDelegate {
    
    let contentView = AC_XQMallOrderListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setTitle("全部订单")
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.delegate = self
    }
    
    // MARK: - AC_XQMallOrderListViewDelegate
    func mallOrderListView(_ mallOrderListView: AC_XQMallOrderListView, didSelectRowAt indexPath: IndexPath) {
        let vc = AC_XQMallOrderDetailVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

