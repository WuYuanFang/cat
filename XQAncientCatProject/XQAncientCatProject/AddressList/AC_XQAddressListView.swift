//
//  AC_XQAddressListView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQAddressListViewDelegate: NSObjectProtocol {
    
    /// 点击编辑
    func addressListView(_ addressListView: AC_XQAddressListView, didSelectEditAt indexPath: IndexPath)
    
    /// 点击 cell
    func addressListView(_ addressListView: AC_XQAddressListView, didSelectRowAt indexPath: IndexPath)
    
}

class AC_XQAddressListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTShopAddressDtoModel]()
    
    let addView = AC_XQPetListChildrenViewFooterView()
    
    weak var delegate: AC_XQAddressListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(AC_XQAddressListViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        self.addView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 60 + 12 * 2)
        self.tableView.tableFooterView = self.addView
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQAddressListViewCell
        
        let model = self.dataArr[indexPath.row]
        cell.titleLab.text = model.Consignee
        cell.phoneLab.text = model.Mobile
        
        if model.IsDefault {
            cell.normalLab.isHidden = false
            cell.addressLab.text = "            " + model.Address
        }else {
            cell.normalLab.isHidden = true
            cell.addressLab.text = model.Address
        }
        
//        self.titleLab.text = "娜娜"
//        self.addressLab.text = "            " + "河北省东城区上海路华安大厦A区1号门5单元1040室"
//        self.phoneLab.text = "13907145333"
        
        
        cell.editBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.addressListView(self, didSelectEditAt: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.addressListView(self, didSelectRowAt: indexPath)
    }
}
