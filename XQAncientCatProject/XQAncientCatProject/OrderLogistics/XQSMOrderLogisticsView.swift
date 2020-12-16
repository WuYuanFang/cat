//
//  XQSMOrderLogisticsView.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/6.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit

class XQSMOrderLogisticsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTOrderThePlugingModel]()
    
    /// 测试, 已完成
    var xq_test: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initTableView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initTableView() {
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        self.tableView.register(XQSMOrderLogisticsCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 80
        
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! XQSMOrderLogisticsCell
        
        let model = self.dataArr[indexPath.row]
        
        let done = self.xq_test && indexPath.row == 0 ? true : false
        
        if self.dataArr.count == 1 {
            cell.setViewType(done, lineType: 3)
        }else if indexPath.row == 0 {
            cell.setViewType(done, lineType: 1)
        }else if indexPath.row == self.dataArr.count - 1 {
            cell.setViewType(done, lineType: 2)
        }else {
            cell.setViewType(done, lineType: 0)
        }
        
        cell.titleLab.text = model.AcceptStation
        cell.timeLab.text = model.AcceptTime
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
