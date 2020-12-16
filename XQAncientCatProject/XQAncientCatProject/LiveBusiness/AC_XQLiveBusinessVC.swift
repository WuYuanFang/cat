//
//  AC_XQLiveBusinessVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLiveBusinessVC: XQACBaseVC, AC_XQLiveBusinessViewDelegate, AC_XQLiveBusinessViewHeaderViewDelegate {
    
    let contentView = AC_XQLiveBusinessView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(image: UIImage.init(named: "shopCar"), style: .plain, target: self, action: #selector(respondsToShopCar)))
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.delegate = self
        self.contentView.headerView.delegate = self
        
        weak var weakSelf = self
        self.contentView.headerView.businessHistoryBtn.xq_addEvent(.touchUpInside) { (sender) in
            weakSelf?.navigationController?.pushViewController(AC_XQBusinessHistoryVC(), animated: true)
        }
        
        self.contentView.headerView.sideView.xq_addTap { (gesture) in
            weakSelf?.navigationController?.pushViewController(AC_XQPublishLiveVC(), animated: true)
        }
        
    }
    
    // MARK: - responds
    
    @objc func respondsToShopCar() {
        self.navigationController?.pushViewController(AC_XQShopCarVC(), animated: true)
    }
    
    // MARK: - AC_XQLiveBusinessViewDelegate
    func liveBusinessView(_ liveBusinessView: AC_XQLiveBusinessView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(AC_XQLiveBusinessDetailVC(), animated: true)
    }
    
    // MARK: - AC_XQLiveBusinessViewHeaderViewDelegate
    func liveBusinessViewHeaderView(_ liveBusinessViewHeaderView: AC_XQLiveBusinessViewHeaderView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(AC_XQLiveBusinessDetailVC(), animated: true)
    }
    
}
