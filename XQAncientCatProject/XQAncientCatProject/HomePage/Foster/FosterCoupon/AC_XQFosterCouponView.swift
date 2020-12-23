//
//  AC_XQFosterCouponView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQFosterCouponViewDelegate: NSObjectProtocol {
    
    func couponView(_ couponView: AC_XQFosterCouponView, didSelectRowAt indexPath: IndexPath)
    
}

class AC_XQFosterCouponView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTCouponListModel]()
    
    weak var delegate: AC_XQFosterCouponViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        // 布局
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        
        self.tableView.register(AC_XQCouponViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 103 + 12
        
        self.tableView.separatorStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQCouponViewCell
        
        let model = self.dataArr[indexPath.row]
        cell.reloadUI(with: model)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.couponView(self, didSelectRowAt: indexPath)
    }

}