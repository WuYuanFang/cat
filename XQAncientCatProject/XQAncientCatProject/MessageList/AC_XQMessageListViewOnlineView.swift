//
//  AC_XQMessageListViewOnlineView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMessageListViewOnlineView: UIView, UITableViewDelegate, UITableViewDataSource {

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
        
        self.tableView.register(AC_XQMessageListViewCell.classForCoder(), forCellReuseIdentifier: result)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQMessageListViewCell
        
        cell.headerImgView.isHidden = false
        cell.iconImgView.isHidden = true
        
        cell.headerImgView.backgroundColor = UIColor.ac_mainColor
        cell.titleLab.text = "小明"
        cell.messageLab.text = "请尽快确认收货哦"
        cell.dateLab.text = "今天 13:14"
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
