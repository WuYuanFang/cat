//
//  AC_XQShopCarListView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQAlert
import SnapKit


class AC_XQShopCarListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTableView() {
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(AC_XQShopCarListCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 110
        self.tableView.separatorStyle = .none
        
        
        
        self.dataArr = [
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
        ]
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQShopCarListCell
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteContextualAction = UIContextualAction.init(style: .normal, title: "") { (contextualAction, view, callback) in
            callback(true)
            print("点击了删除")
            XQAlertView.show("删除商品", message: "商品将被删除，是否删除?", btnTitle: "确定")
        }
        deleteContextualAction.backgroundColor = UIColor.init(hex: "#282626")
        deleteContextualAction.image = UIImage.init(named: "delete")
        let swipeActionsConfiguration = UISwipeActionsConfiguration.init(actions: [deleteContextualAction])
        return swipeActionsConfiguration
    }
    
}
