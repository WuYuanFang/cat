//
//  AC_XQOrderLogisticsView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/7.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class AC_XQOrderLogisticsView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let headerView = AC_XQOrderLogisticsViewHeaderView()

    let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTOrderThePlugingModel]()
    
    /// 测试, 已完成
    var xq_test: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.xq_addSubviews(self.tableView, self.headerView)
        
        // 布局
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(16)
            make.left.right.equalTo(self.headerView)
            make.bottom.equalTo(-30)
        }
        
        // 设置顺序
        self.tableView.register(AC_XQOrderLogisticsViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 80
        self.tableView.backgroundColor = UIColor.white
        self.tableView.layer.cornerRadius = 15
        self.tableView.layer.masksToBounds = true
        
        self.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQOrderLogisticsViewCell
        
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

class AC_XQOrderLogisticsViewHeaderView: UIView {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    
    let orderLab = UILabel()
    let copyBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.titleLab, self.orderLab, self.copyBtn)
        
        // 布局
        let imgViewSize = 40
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(12)
            make.size.equalTo(imgViewSize)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(20)
//            make.top.equalTo(self.imgView)
            make.centerY.equalTo(self.imgView)
            make.right.equalTo(-12)
        }
        
        self.orderLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView)
            make.top.equalTo(self.imgView.snp.bottom).offset(20)
        }
        
        self.copyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.orderLab.snp.right).offset(8)
            make.centerY.equalTo(self.orderLab)
            make.size.equalTo(30)
            make.bottom.equalTo(-16)
        }
        
        // 设置属性
        
        self.imgView.layer.cornerRadius = CGFloat(imgViewSize)/2
        self.imgView.layer.masksToBounds = true
        self.imgView.backgroundColor = UIColor.init(hex: "#55A6CB")
        
        self.orderLab.font = UIFont.systemFont(ofSize: 14)
        
        self.backgroundColor = UIColor.white
        
        self.copyBtn.setBackgroundImage(UIImage.init(named: "logistics_copy"), for: .normal)
        
        self.layer.cornerRadius = 15
        
        self.copyBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            let strArr = self.orderLab.text?.components(separatedBy: " ")
            if strArr?.count ?? 0 != 2 {
                return
            }
            
            UIPasteboard.general.string = strArr?.last
            SVProgressHUD.showSuccess(withStatus: "已复制")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

