//
//  AC_XQMyPublishView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMyPublishView: UIView, UITableViewDelegate, UITableViewDataSource {

    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(AC_XQBusinessHistoryViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        
        self.dataArr = [
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
        ]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQBusinessHistoryViewCell
        
        if indexPath.row == 1 || indexPath.row == 3 {
            cell.btn.isHidden = true
            cell.statusLab.isHidden = true
            cell.editBtn.isHidden = false
        }else {
            cell.btn.isHidden = false
            cell.statusLab.isHidden = false
            cell.editBtn.isHidden = true
        }
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
