//
//  AC_XQMallView.swift
//  XQAncientCatProject
//
//  Created by sinking on 2020/1/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQDLinkTableView
import SnapKit



class AC_XQMallView: UIView, XQDLNavigationTableViewDelegate, XQDLContentTableViewDelegate {
    
    var contentView: XQDLinkTableView!
    let navigationCellIdentifier = "XQDLNavigationTableView_cellIdentifier"
    let contentCellIdentifier = "XQDLNavigationTableView_cellIdentifier"
    let contentHfIdentifier = "XQDLNavigationTableView_forHeaderFooterViewReuseIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let model = XQDLinkTableConfigModel.init()
        model.contentScrollAnimated = true
        model.heightViewHeight = 0
        self.contentView = XQDLinkTableView.init(model)
        self.addSubview(self.contentView)
        
        self.contentView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.contentView.navigationView.delegate = self
        self.contentView.navigationView.tableView.register(AC_XQMallNaviCell.self, forCellReuseIdentifier: self.navigationCellIdentifier)
        self.contentView.navigationView.tableView.showsVerticalScrollIndicator = false
        self.contentView.navigationView.tableView.separatorStyle = .none
        self.contentView.navigationView.tableView.backgroundView?.backgroundColor = UIColor.init(hex: "#F7F7F7")
        self.contentView.navigationView.tableView.backgroundColor = UIColor.init(hex: "#F7F7F7")
        
        self.contentView.contentView.delegate = self
        self.contentView.contentView.tableView.register(AC_XQMallContentCell.self, forCellReuseIdentifier: self.contentCellIdentifier)
        self.contentView.contentView.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: self.contentHfIdentifier)
        self.contentView.contentView.tableView.separatorStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - XQDLNavigationTableViewDelegate
    
    func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.navigationCellIdentifier, for: indexPath) as! AC_XQMallNaviCell
        
        cell.titleLab.text = "零食"
        
        return cell
    }
    
    // MARK: - XQDLContentTableViewDelegate
    
    func contentTableView(numberOfSections contentTableView: XQDLContentTableView, tableView: UITableView) -> Int {
        return 6
    }
    
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.contentCellIdentifier, for: indexPath) as! AC_XQMallContentCell
        
        return cell
    }
    
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.contentHfIdentifier)
        hView?.contentView.backgroundColor = UIColor.init(xq_rgbWithR: Float(arc4random() % 255), g: Float(arc4random() % 255), b: Float(arc4random() % 255))
        return hView
    }
    
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}
