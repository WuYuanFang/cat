//
//  AC_XQBusinessHistoryView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import XQProjectTool
import QMUIKit

class AC_XQBusinessHistoryView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    let footerView = AC_XQBusinessHistoryViewBottomView()
    
    private var _xq_isEditing = false
    var xq_isEditing: Bool {
        set {
            _xq_isEditing = newValue
            self.tableView.reloadData()
            
            if self.xq_isEditing {
                self.footerView.isHidden = false
                self.footerView.snp.remakeConstraints { (make) in
                    make.left.right.bottom.equalToSuperview()
                    make.height.equalTo(90)
                }
                
                self.tableView.snp.remakeConstraints { (make) in
                    make.top.left.right.equalToSuperview()
                    make.bottom.equalTo(self.footerView.snp.top)
                }
            }else {
                self.footerView.isHidden = true
                self.tableView.snp.remakeConstraints { (make) in
                    make.edges.equalToSuperview()
                }
            }
        }
        get {
            return _xq_isEditing
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.footerView.isHidden = true
        self.addSubview(self.footerView)
        
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
        ]
        
        self.tableView.allowsMultipleSelection = true
        
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
        
        cell.xq_isEditing = self.xq_isEditing
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}



class AC_XQBusinessHistoryViewBottomView: UIView {
    
    /// 全选
    let selectBtn = QMUIButton()
    /// 删除
    let deleteBtn = UIButton()
    
    /// 价格
    let priceLab = UILabel()
    private let priceDesLab = UILabel()
    
    /// 购买按钮
    let settlementBtn = AC_XQSideButtonView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.selectBtn, self.deleteBtn, self.priceLab, self.priceDesLab, self.settlementBtn)
        
        // 布局
        self.selectBtn.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        
        self.settlementBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.settlementBtn.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
        
        self.priceDesLab.snp.makeConstraints { (make) in
            make.right.equalTo(self.priceLab.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.backgroundColor = UIColor.white
        
        self.selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.selectBtn.setTitle("全选", for: .normal)
        self.selectBtn.setTitleColor(UIColor.black, for: .normal)
        self.selectBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.selectBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        self.selectBtn.spacingBetweenImageAndTitle = 10
        
        self.deleteBtn.setBackgroundImage(UIImage.init(named: "delete_mainColor"), for: .normal)
        
        self.priceLab.font = UIFont.systemFont(ofSize: 17)
        self.priceLab.textColor = UIColor.ac_mainColor
        
        self.priceDesLab.text = "合计"
        self.priceDesLab.font = UIFont.systemFont(ofSize: 15)
        
        self.settlementBtn.titleLab.text = "结算"
        self.settlementBtn.titleLab.font = UIFont.systemFont(ofSize: 20)
        
        self.managerUILayout(false)
        
//        self.priceLab.text = "¥1888"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    /// 变换UI
    /// - Parameter isManager: true 管理模式. 默认 false
    func managerUILayout(_ isManager: Bool) {
        
        self.priceDesLab.isHidden = isManager
        self.priceLab.isHidden = isManager
        self.settlementBtn.isHidden = isManager
        
        self.deleteBtn.isHidden = !isManager
        
    }
    
}

