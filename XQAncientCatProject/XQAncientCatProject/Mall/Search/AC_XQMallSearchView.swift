//
//  AC_XQMallSearchView.swift
//  XQAncientCatProject
//
//  Created by sinking on 2020/1/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit


/// 弃用
class AC_XQMallSearchView: UIView, UITableViewDelegate, UITableViewDataSource {
    
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
        
        self.tableView.register(AC_XQMallContentCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 100
        
        
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
        ]
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQMallContentCell
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
