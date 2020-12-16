//
//  XQDLinkTableView.swift
//  XQTableView
//
//  Created by wxq on 2019/8/1.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Masonry
import MJRefresh
import UIKit

/// 联动滚动视图
public class XQDLinkTableView: UIView, XQDLContentTableViewInsideDelegate, XQDLNavigationTableViewInsideDelegate {
    public var navigationView: XQDLNavigationTableView!
    public var contentView: XQDLContentTableView!
    public var headerView: UIView!

    var backView: UIView!

    var configModel: XQDLinkTableConfigModel!

    /// 默认初始化
    public init(_ configModel: XQDLinkTableConfigModel) {
        super.init(frame: CGRect.zero)

        self.configModel = configModel

        backView = UIView()
        addSubview(backView)

        navigationView = XQDLNavigationTableView()
        navigationView.insideDelegate = self
        backView.addSubview(navigationView)

        contentView = XQDLContentTableView()
        contentView.insideDelegate = self
        backView.addSubview(contentView)

        headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        backView.addSubview(headerView)

        // 布局
        backView.mas_makeConstraints { make in
            make?.edges.equalTo()(self)
        }

        headerView.mas_makeConstraints { make in
            make?.top.left()?.right().equalTo()(self.backView)
            make?.height.mas_equalTo()(self.configModel.heightViewHeight)
        }

        // 84 / 375
        navigationView.mas_makeConstraints { make in
            make?.top.equalTo()(self.headerView.mas_bottom)
            make?.left.equalTo()(self.backView)
            make?.bottom.equalTo()(self.backView)

            make?.width.mas_equalTo()(configModel.navigationViewWidth)
        }

        contentView.mas_makeConstraints { make in
            make?.top.height()?.right().equalTo()(self.backView)
            make?.left.equalTo()(self.navigationView.mas_right)
        }

        //        self.contentView.tableView.bounces = false
        //        self.navigationView.tableView.bounces = false

        let hView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.configModel.heightViewHeight))
        contentView.tableView.tableHeaderView = hView

        backView.backgroundColor = UIColor.white

        // 导航视图, 不能触发滚动到顶端, 这样点击状态栏, 就只触发内容视图 ( 反正内容视图到了顶端, 这个也会到, 所以这个没必要去触发 )
        navigationView.tableView.scrollsToTop = false
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 滚动之后， 应该要做的事情
    func xq_scrollViewDidScroll(_ tableView: UITableView) {
        // 不追求什么两边都搞了, 直接最简单的搞上
//        print("已滚动: ", tableView.contentOffset)
        let contentOffset = tableView.contentOffset

        
        if #available(iOS 13.0, *) {
            // 13.0 后面, 直接设置高度是不会改变的...
            var y = contentOffset.y
            
            if y > self.configModel.heightViewHeight {
                y = self.configModel.heightViewHeight
            }
            
            self.headerView.mas_remakeConstraints { make in
                make?.top.equalTo()(self.backView)?.offset()(-y)
                make?.left.right()?.equalTo()(self.backView)
                make?.height.mas_equalTo()(self.configModel.heightViewHeight)
            }
            
        } else {
            headerView.mj_y = -contentOffset.y
            
            var navigationViewY = -contentOffset.y + headerView.mj_h
            // 最小Y
            if navigationViewY < 0 {
                navigationViewY = 0
            }

            var height = backView.mj_h - navigationViewY
            let minHeight = backView.mj_h - headerView.mj_h
            // 最小高
            if height < minHeight {
                height = minHeight
            }

            navigationView.mj_h = height
            navigationView.mj_y = navigationViewY
            
        }

        
    }
    
    /// 是否内容tableView 滚动时, 会联动导航 tableView
    private var judgeScroll = true

    // MARK: - XQDLNavigationTableViewInsideDelegate

    func navigationTableView(_ navigationTableView: XQDLNavigationTableView, tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ip = IndexPath(row: 0, section: indexPath.row)
        
        // 防止超出界限
        if ip.section < self.contentView.xq_section {
            let row = self.contentView.tableView.numberOfRows(inSection: ip.section)
            
            // 点击之后, 0.25 不联动滚动, 不然会出现导航这边跳来跳去, 并且最终结果不准问题
            self.judgeScroll = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
                self.judgeScroll = true
            }
            
            // 当数据为, row 数据为 0 时, 选中会直接崩溃
            if row == 0 {
                let rect = contentView.tableView.rect(forSection: ip.section)
                contentView.tableView.scrollRectToVisible(rect, animated: configModel.contentScrollAnimated)
            } else {
                contentView.tableView.scrollToRow(at: ip, at: configModel.contentScrollPosition, animated: configModel.contentScrollAnimated)
                //            self.contentView.tableView.selectRow(at: ip, animated: false, scrollPosition: self.configModel.contentScrollPosition)
                
            }
            
        }
        
    }

    func navigationTableView(scrollViewDidScroll contentTableView: XQDLNavigationTableView, tableView: UITableView) {
        // 目前不用判断这个滚动, 先尽量简单点
//        self.xq_scrollViewDidScroll(tableView)
    }

    // MARK: - XQDLContentTableViewInsideDelegate

    func contentTableView(_ contentTableView: XQDLContentTableView, tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if !self.judgeScroll {
            return
        }
        
        let indexPath = IndexPath(row: section, section: 0)
        
        // 不能超出界限
        if section < self.navigationView.xq_section {
            self.navigationView.tableView.selectRow(at: indexPath, animated: true, scrollPosition: configModel.navigationScrollPosition)
//            self.xq_setNavigationIndexPath(tableView)
        }
        
    }

    func contentTableView(scrollViewDidScroll contentTableView: XQDLContentTableView, tableView: UITableView) {
        xq_scrollViewDidScroll(tableView)
    }

    func contentTableView(scrollViewWillBeginDragging contentTableView: XQDLContentTableView, tableView: UITableView) {
//        print(#function)
//        self.xq_setNavigationIndexPath(tableView)
    }

    func contentTableView(scrollViewDidEndDragging contentTableView: XQDLContentTableView, tableView: UITableView, willDecelerate decelerate: Bool) {
//        print(#function)
    }

    func contentTableView(scrollViewDidEndDecelerating contentTableView: XQDLContentTableView, tableView: UITableView) {
//        print(#function)
    }

    func xq_setNavigationIndexPath(_ tableView: UITableView) {
        let indexPath = tableView.indexPathForRow(at: tableView.contentOffset)
//        print(#function, indexPath ?? "没有")
        if let indexPath = indexPath {
            let ip = IndexPath(row: indexPath.section, section: 0)
            navigationView.tableView.selectRow(at: ip, animated: true, scrollPosition: configModel.navigationScrollPosition)
        }
    }
}

/**
 这里说一下内嵌tableView(其实这个换成scrollView也是一样的), 系统判定滚动逻辑

 以下出现这些字眼, 就代表这些
 外层scrollView: XQDLinkTableView.scrollView
 内嵌tableView: XQDLNavigationTableView.tableView 和 XQDLContentTableView.tableView

 刚开始滚动, 系统的判定
 1. 手指在 XQDLinkTableView.headerView 上, 开始滚动, 那么这个时候, 系统判定响应是给 外层scrollView 的
 2. 手指在 内嵌tableView 上, 开始滚动, 这里分两种情况， 如下
    2.1 如当前内嵌 tableView 已经在最顶部, 或者最底部, 就是 contentOffset.y == || or contentOffset.y == Max. 这时, 系统判定响应是给 外层scrollView 的
    2.2 如当前内嵌 tableView 不是在最顶部, 或者最底部, 就是 contentOffset.y > 0 && contentOffset.y < Max. 这时, 系统判定响应是给 内嵌tableView 的

 这里再补充一下
 如当 2.2 时, 虽然已经给响应 内嵌tableView 了, 但是我直接滑动 内嵌tableView 滚到最顶端或者最低端的时候会怎样 ?
 当然, 响应并不会转接到 外层scrollView, 而是还在 内嵌tableView 上

 */
