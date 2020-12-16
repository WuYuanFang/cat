//
//  XQDLContentTableView.swift
//  XQTableView
//
//  Created by wxq on 2019/8/1.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit

@objc public protocol XQDLContentTableViewDelegate: NSObjectProtocol {
    
    /// 有多少个 section, 这个要和导航视图的 row 一样
    func contentTableView(numberOfSections contentTableView: XQDLContentTableView, tableView: UITableView) -> Int
    
    /// 有多少个 cell
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    
    /// 返回 cell
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    /// cell 高度, 默认 44
    @objc optional func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    /// 返回头部 view, 默认 nil
    @objc optional func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    
    /// 头部view 高度, 默认 0
    @objc optional func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    
    
    /// 已选中 cell
    @objc optional func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    /// 在滑动
    @objc optional func contentTableView(scrollViewDidScroll contentTableView: XQDLContentTableView, tableView: UITableView)
    
}

/// 内部协议
protocol XQDLContentTableViewInsideDelegate: NSObjectProtocol {
    
    /// 即将显示某个头部 view
    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    /// 在滑动
    func contentTableView(scrollViewDidScroll contentTableView: XQDLContentTableView, tableView: UITableView)
    
    /// 用户手放上去了, 开始拖拽
    func contentTableView(scrollViewWillBeginDragging contentTableView: XQDLContentTableView, tableView: UITableView)
    
    /// 结束拖拽
    ///
    /// - Parameters:
    ///   - decelerate: YES 还有惯性滑动, NO 直接停止了
    func contentTableView(scrollViewDidEndDragging contentTableView: XQDLContentTableView, tableView: UITableView, willDecelerate decelerate: Bool)
    
    /// 结束惯性滑动
    func contentTableView(scrollViewDidEndDecelerating contentTableView: XQDLContentTableView, tableView: UITableView)
    
}


public class XQDLContentTableView: UIView, UITableViewDataSource, UITableViewDelegate {

    public var tableView: UITableView!
    
    let cellIdentifier = "XQDLNavigationTableView_cellIdentifier"
    
    public weak var delegate: XQDLContentTableViewDelegate?
    weak var insideDelegate: XQDLContentTableViewInsideDelegate?
    
    var xq_section = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tableView = UITableView.init()
        self.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make) in
            make?.edges.equalTo()(self)
        }
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 78
        
//        self.tableView.contentInset = UIEdgeInsets.init(top: 300, left: 0, bottom: 0, right: 0)
//        let hView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 300))
//        hView.backgroundColor = UIColor.red
//        self.tableView.tableHeaderView = hView
//        self.tableView.separatorInset = UIEdgeInsets.init(top: 200, left: 100, bottom: 0, right: 0)
        
//        self.tableView.register(XQSMOrderGoodsContentCell.self, forCellReuseIdentifier: self.cellIdentifier)
//        self.tableView.register(XQSMOrderGoodsTableHeaderView.self, forHeaderFooterViewReuseIdentifier: self.hfIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        if let number = self.delegate?.contentTableView(numberOfSections: self, tableView: tableView) {
            self.xq_section = number
            return number
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let row = self.delegate?.contentTableView(self, tableView: tableView, numberOfRowsInSection: section) {
            return row
        }
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.delegate?.contentTableView(self, tableView: tableView, cellForRowAt: indexPath) {
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.contentTableView?(self, tableView: tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.delegate?.contentTableView?(self, tableView: tableView, viewForHeaderInSection: section)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let height = self.delegate?.contentTableView?(self, tableView: tableView, heightForHeaderInSection: section) {
            return height
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = self.delegate?.contentTableView?(self, tableView: tableView, heightForRowAt: indexPath) {
            return height
        }
        return 44
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        self.insideDelegate?.contentTableView(self, tableView: tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.contentTableView?(scrollViewDidScroll: self, tableView: self.tableView)
        self.insideDelegate?.contentTableView(scrollViewDidScroll: self, tableView: self.tableView)
    }
    
    /// 开始滑动
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.insideDelegate?.contentTableView(scrollViewWillBeginDragging: self, tableView: self.tableView)
    }
    
    /// 手放开
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        /**
         停止点 targetContentOffset.pointee
         这里可以改变停止点
         关于停止点不会为负的情况
         是因为默认会弹回 0.0 , 但是你设置了 scrollView.contentInset 的话, top 是哪, 那么停止点就是哪
         */
        
//        print(#function, velocity, targetContentOffset.pointee)
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.insideDelegate?.contentTableView(scrollViewDidEndDragging: self, tableView: self.tableView, willDecelerate: decelerate)
//        if decelerate {
//            // 有减速
//
//        }else {
//            // 没减速, 直接停下
//            self.delegate?.contentTableView(scrollViewDidEndDecelerating: self, tableView: self.tableView)
//        }
        
    }
    
    /// 已经结束惯性滑动了
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.insideDelegate?.contentTableView(scrollViewDidEndDecelerating: self, tableView: self.tableView)
    }
    
    

}
