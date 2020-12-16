//
//  AC_XQMallOrderListView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

import SnapKit

protocol AC_XQMallOrderListViewDelegate: NSObjectProtocol {
    
    /// 点击cell
    func mallOrderListView(_ mallOrderListView: AC_XQMallOrderListView, didSelectRowAt indexPath: IndexPath)
    
}

class AC_XQMallOrderListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    weak var delegate: AC_XQMallOrderListViewDelegate?
    
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
        
        self.tableView.register(AC_XQMallOrderListCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 133.5 + 16 * 2
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
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQMallOrderListCell
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.mallOrderListView(self, didSelectRowAt: indexPath)
    }
    
    
}


