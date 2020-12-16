//
//  XQPinyinSortTableViewController.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import XQProjectTool

class XQPinyinSortTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func initTableView() {
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath)
        cell.textLabel?.text = self.dataArr[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
