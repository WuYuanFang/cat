//
//  AC_XQAddressListAlert.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import XQProjectTool_iPhoneUI

class AC_XQAddressListAlertView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private static var addressListAlertView_: AC_XQAddressListAlertView?
    
    /// 显示弹框
    /// - Parameters:
    ///   - title: 标题
    ///   - name: 名称
    ///   - phone: 手机
    ///   - address: 地址
    static func show(with title: String, name: String = "", phone: String = "", address: String = "") {
        
        if let _ = addressListAlertView_ {
            print("已存在弹框")
            return
        }
        
        addressListAlertView_ = AC_XQAddressListAlertView()
        addressListAlertView_?.titleLab.text = title
        addressListAlertView_?.dataArr = [
            name,
            phone,
            address
        ]
        
        if let addressListAlertView = addressListAlertView_ {
            UIApplication.shared.xq_getWindow()?.addSubview(addressListAlertView)
            addressListAlertView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            addressListAlertView.show()
        }
        
    }
    
    static func hide() {
        AC_XQAddressListAlertView.addressListAlertView_?.hide()
    }
    
    
    private func show() {
        self.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
    
    private func hide() {
        self.alpha = 1
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (result) in
            self.removeFromSuperview()
            AC_XQAddressListAlertView.addressListAlertView_ = nil
        }
    }
    
    deinit {
        print(self.classForCoder, #function)
    }
    
    let backBtn = UIButton()
    let contentView = UIView()
    
    let cancelBtn = UIButton()
    let confirmBtn = UIButton()
    let titleLab = UILabel()
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        
        self.addSubview(self.backBtn)
        self.addSubview(self.contentView)
        self.contentView.xq_addSubviews(self.tableView, self.cancelBtn, self.confirmBtn, self.titleLab)
        
        
        // 布局
        self.backBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().multipliedBy(0.7).priority(.high)
            make.top.greaterThanOrEqualTo(30)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        self.cancelBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.left.equalToSuperview().offset(25)
        }
        
        self.confirmBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalToSuperview().offset(-25)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(16)
            make.height.equalTo(180)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
        // 设置属性
        
        self.backBtn.backgroundColor = UIColor.init(xq_rgbWithR: 222, g: 222, b: 222, alpha: 0.6)
        weak var weakSelf = self
        self.backBtn.xq_addEvent(.touchUpInside) { (sender) in
            weakSelf?.hide()
        }
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.cancelBtn.setTitle("取消", for: .normal)
        self.cancelBtn.setTitleColor(UIColor.black, for: .normal)
        self.cancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.cancelBtn.xq_addEvent(.touchUpInside) { (sender) in
            weakSelf?.hide()
        }
        
        self.confirmBtn.setTitle("确定", for: .normal)
        self.confirmBtn.setTitleColor(UIColor.black, for: .normal)
        self.confirmBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.confirmBtn.xq_addEvent(.touchUpInside) { (sender) in
            weakSelf?.hide()
        }
        
        self.tableView.register(AC_XQAddressListAlertViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 60
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQAddressListAlertViewCell
        
        cell.tf.text = self.dataArr[indexPath.row]
        
        switch indexPath.row {
        case 0:
            cell.tf.placeholder = "姓名"
        case 1:
            cell.tf.placeholder = "手机号"
        case 2:
            cell.tf.placeholder = "地址"
            
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
