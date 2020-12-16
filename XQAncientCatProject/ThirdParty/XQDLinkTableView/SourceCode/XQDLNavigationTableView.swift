//
//  XQDLNavigationTableView.swift
//  XQTableView
//
//  Created by wxq on 2019/8/1.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit
import Masonry

@objc public protocol XQDLNavigationTableViewDelegate: NSObjectProtocol {
    /// 有多少个cell
    func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    /// 返回 cell
    func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    /// cell 高度
    @objc optional func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    /// 点击了cell
    @objc optional func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    /// 已滚动
    @objc optional func navigationTableView(scrollViewDidScroll contentTableView: XQDLNavigationTableView, tableView: UITableView)
    
}

/// 内部协议
protocol XQDLNavigationTableViewInsideDelegate: NSObjectProtocol {
    /// 点击了cell
    func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    /// 已滚动
    func navigationTableView(scrollViewDidScroll contentTableView: XQDLNavigationTableView, tableView: UITableView)
}

public class XQDLNavigationTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    /// 不要去设置 tableView 的 delegate 和 dataSouce 这些, 要从我这边自定义的协议来搞
    public var tableView: UITableView!
    let cellIdentifier = "XQDLNavigationTableView_cellIdentifier"
    
    public weak var delegate: XQDLNavigationTableViewDelegate?
    weak var insideDelegate: XQDLNavigationTableViewInsideDelegate?
    
    var xq_section = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView = UITableView.init()
        self.addSubview(self.tableView)
//        self.tableView.mas_makeConstraints { (make) in
//            make?.edges.equalTo()(self)
//        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = self.delegate?.navigationTableView(self, tableView: tableView, numberOfRowsInSection: section) {
            self.xq_section = result
            return result
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.delegate?.navigationTableView(self, tableView: tableView, cellForRowAt: indexPath) {
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.insideDelegate?.navigationTableView(self, tableView: tableView, didSelectRowAt: indexPath)
        self.delegate?.navigationTableView?(self, tableView: tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.delegate?.navigationTableView?(self, tableView: tableView, heightForRowAt: indexPath) {
            return height
        }
        
        return 44
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.insideDelegate?.navigationTableView(scrollViewDidScroll: self, tableView: self.tableView)
        self.delegate?.navigationTableView?(scrollViewDidScroll: self, tableView: self.tableView)
    }
    
}
