//
//  XQDLinkTableConfigModel.swift
//  XQTableView
//
//  Created by wxq on 2019/8/1.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit

/// 配置
public class XQDLinkTableConfigModel: NSObject {
    
    /// 头部视图高度, <= 0 就相当于隐藏, 默认 200
    public var heightViewHeight = CGFloat(200)
    
    /// 导航视图的宽, 默认 84, 剩下宽度, 所有归为内容视图
    public var navigationViewWidth = CFloat(84)
    
    /// 当滚动内容视图, 导航视图选中 cell, 滚动的位置, 默认是 .top
    public var navigationScrollPosition: UITableView.ScrollPosition = .top
    
    /// 当点击导航视图, 内容视图滚动的位置, 默认是 .top
    public var contentScrollPosition: UITableView.ScrollPosition = .top
    
    /// 当点击导航视图, 内容视图滚动是否要动画, 默认 false
    public var contentScrollAnimated: Bool = false

}
