//
//  AC_XQCommodityDetailViewContentViewParamView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit



class AC_XQCommodityDetailViewContentViewParamView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let titleLab = UILabel()
    
    private let result = "cell"
    let tableView = UITableView.init(frame: .zero, style: .plain)
    var dataArr = [String]()
    
    private let rowHeight: CGFloat = 30

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab)
        self.addSubview(self.tableView)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(135)
        }
        
        // 设置属性
        
        self.titleLab.text = "参数"
        
        self.tableView.register(AC_XQCommodityDetailViewContentViewParamViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = self.rowHeight
        self.tableView.isScrollEnabled = false
        
        
        self.reloadUI(with: [
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func reloadUI(with dataArr: [String]) {
        
        self.tableView.snp.updateConstraints { (make) in
            make.height.equalTo(CGFloat(dataArr.count) * self.rowHeight)
        }
        
        self.dataArr = dataArr
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
