//
//  XQalertSelectLevelView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/26.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import CMPageTitleView

protocol XQAlertSelectLevelViewDataSource: NSObjectProtocol {
    
    /// 多少个分区
//    func alertSelectLevelView(numberOfSectionsIn alertSelectLevelView: XQalertSelectLevelView) -> Int
    
    /// 某个分区, 多少行
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, numberOfRowsInSection section: Int) -> Int
    
    /// 某行标题
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, titleForRowAt indexPath: IndexPath) -> String
    
    /// 某个分区标题
//    func alertSelectLevelView(_ alertSelectLevelView: XQalertSelectLevelView, titleForHeaderInSection section: Int) -> String
}

@objc protocol XQAlertSelectLevelViewDelegate: NSObjectProtocol {
    
    /// 点击取消或者点击背景
    @objc optional func alertSelectLevelView(hide alertSelectLevelView: XQAlertSelectLevelView)
    
    /// 点击选择了某个分区
    @objc optional func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, didSelectSectionAt section: Int)
    
    /// 点击选择了某一行
    @objc optional func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, didSelectRowAt indexPath: IndexPath)
    
    /// 选到了最后一个
    @objc optional func alertSelectLevelView(didEnd alertSelectLevelView: XQAlertSelectLevelView)
    
}

class XQAlertSelectLevelView: AC_XQBottomAlert, UITableViewDelegate, UITableViewDataSource, CMPageTitleViewDelegate {
    
    /// 默认标题
    var notSelectSectionTitle = "请选择"
    
    /// 未选中颜色
    var notSelectColor = UIColor.black
    
    /// 选中颜色
    var selectColor = UIColor.black
    
    /// 选中显示的图片
    var selectImg = UIImage.init(named: "tick")
    
    private var _selectIndexArr = [Int]()
    /// 选中的那个行
    /// 内容是 row, 下标是 section
    var selectIndexArr: [Int] {
        get {
            return _selectIndexArr
        }
    }
    
    private var _currentSection = 0
    /// 当前选中第几个 section
    var currentSection: Int {
        get {
            return _currentSection
        }
    }
    
    /// 可选择最大 section. 如 -1，就表示能一直选下去
    /// 默认是 -1
    var selectSectionMax = -1
    
    weak var dataSource: XQAlertSelectLevelViewDataSource?
    
    weak var delegate: XQAlertSelectLevelViewDelegate?
    
    private let titleLab = UILabel()
    private let cancelBtn = UIButton()
    
    private let titleView = CMPageTitleView()
    
    private var tableView: UITableView!
    private let result = "cell"
    
    /// 上一次刷新的时间, 防止 numberOfRowsInSection 连续回调
    private var lastDate: Date?
    /// 上一次的数量, 防止 numberOfRowsInSection 连续回调
    private var lastCount = 0
    
    required init(frame: CGRect, contentHeight: CGFloat = 246) {
//        super.init(frame: frame, contentHeight: contentHeight)
        super.init(frame: UIScreen.main.bounds, contentHeight: contentHeight)
        
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        
        self.titleView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: 44)
        
        self.contentView.xq_addSubviews(self.titleLab, self.cancelBtn, self.titleView, self.tableView)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        self.cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(self.titleLab)
        }
        
        self.titleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        
        // 设置属性
        self.titleLab.text = "请选择收件地址"
        
        self.cancelBtn.setTitleColor(UIColor.gray, for: .normal)
        self.cancelBtn.setTitle("取消", for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(respondsToCancel), for: .touchUpInside)
        
        self.tableView.register(XQAlertSelectLevelViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        self.normalTitleConfig()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 刷新当前 tableview
    func reloadCurrentSection() {
        self.lastDate = nil
        self.tableView.reloadData()
    }
    
    /// 隐藏
    override func hide() {
        self.delegate?.alertSelectLevelView?(hide: self)
        super.hide()
    }
    
    /// 直接默认添加到 window 上, 并且做动画
    override func show() {
        
        // 刷新数据
        _currentSection = 0
        _selectIndexArr.removeAll()
        self.normalTitleConfig()
        self.titleView.cm_reloadConfig()
        self.tableView.reloadData()
        
        // 添加到 window 上
        self.removeFromSuperview()
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        super.show()
        
    }
    
    private func normalTitleConfig() {
        let config = CMPageTitleConfig.default()

        config.cm_selectedColor = UIColor.black
        config.cm_normalColor = UIColor.black
        
        config.cm_underlineColor = UIColor.black
        config.cm_underlineHeight = 4
        
        config.cm_backgroundColor = UIColor.white
        
        config.cm_switchMode = [.underline, .scale]
        
        config.cm_selectedFont = UIFont.boldSystemFont(ofSize: 16)
        config.cm_font = UIFont.systemFont(ofSize: 16)
        
        config.cm_minTitleMargin = 25
        
        config.cm_contentMode = .left
        config.cm_titles = [
            self.notSelectSectionTitle,
        ]
        
        self.titleView.cm_config = config
        self.titleView.delegate = self
    }
    
    // MARK: - responds
    @objc func respondsToCancel() {
        self.hide()
    }
    
    // MARK: - UITableViewDataSource
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lDate = self.lastDate else {
            self.lastDate = Date.init()
            self.lastCount = self.dataSource?.alertSelectLevelView(self, numberOfRowsInSection: self.currentSection) ?? 0
            return self.lastCount
        }
        
        if (Date.init().timeIntervalSince1970 - lDate.timeIntervalSince1970) < 0.2 {
            return self.lastCount
        }
        
        self.lastDate = Date.init()
        self.lastCount = self.dataSource?.alertSelectLevelView(self, numberOfRowsInSection: self.currentSection) ?? 0
        return self.lastCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! XQAlertSelectLevelViewCell
        
        let title = self.dataSource?.alertSelectLevelView(self, titleForRowAt: IndexPath.init(row: indexPath.row, section: self.currentSection)) ?? ""
        
        cell.titleLab.text = title
        
        cell.imgView.image = self.selectImg
        
        if self.currentSection >= self.selectIndexArr.count {
            cell.imgView.isHidden = true
        }else {
            cell.imgView.isHidden = self.selectIndexArr[self.currentSection] != indexPath.row
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? XQAlertSelectLevelViewCell else {
            return
        }
        
        
        /// 删除多余标题
        self.removeTitle()
        
        _selectIndexArr.append(indexPath.row)
        
        if self.selectSectionMax != -1 && self.selectSectionMax <= self.selectIndexArr.count - 1 {
            // 选择到最后一个了
            self.delegate?.alertSelectLevelView?(didEnd: self)
            self.hide()
            
        }else {
            // 还没到最后一个, 刷新这些标题的
            var titles = self.titleView.cm_config.cm_titles
            
            // 当前选中
            titles[self.titleView.cm_config.cm_titles.count - 1] = cell.titleLab.text ?? ""
            
            // 添加默认标题
            titles.append(self.notSelectSectionTitle)
            
            self.titleView.cm_config.cm_titles = titles
            // 选中最后一个
            self.titleView.cm_config.cm_defaultIndex = self.titleView.cm_config.cm_titles.count - 1
            self.titleView.cm_config.cm_contentMode = .left
            self.titleView.cm_reloadConfig()
        }
        
        self.delegate?.alertSelectLevelView?(self, didSelectRowAt: IndexPath.init(row: indexPath.row, section: self.currentSection))
    }
    
    // MARK: - CMPageTitleViewDelegate
    func cm_pageTitleViewClick(with index: Int, repeat xq_repeat: Bool) {
        
        if xq_repeat {
            return
        }
        
        if self.currentSection == index {
            return
        }
        
        _currentSection = index
        
//        self.removeTitle()
        
        
        self.delegate?.alertSelectLevelView?(self, didSelectSectionAt: index)
        self.tableView.reloadData()
        // 切换分区，回到顶部, 或者回到上一次选中的地方
        if self.lastCount != 0 {
            print("wxq: ", self.currentSection, self.selectIndexArr)
            if self.currentSection < self.selectIndexArr.count {
                let indexPath = IndexPath.init(row: self.selectIndexArr[self.currentSection], section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }else {
                let indexPath = IndexPath.init(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            
        }
        
    }
    
    /// 删除当前选中(self.currentSection), 及后面所有标题
    /// 并且默认填在最后加上一个 请选中 (self.notSelectSectionTitle)
    private func removeTitle() {
        var titles = self.titleView.cm_config.cm_titles
        titles.removeSubrange(self.currentSection..<self.titleView.cm_config.cm_titles.count)
        titles.append(self.notSelectSectionTitle)
        
        _selectIndexArr.removeSubrange(self.currentSection..<self.titleView.cm_config.cm_titles.count - 1)
        
        self.titleView.cm_config.cm_titles = titles
        self.titleView.cm_config.cm_defaultIndex = self.currentSection
        self.titleView.cm_config.cm_contentMode = .left
        self.titleView.cm_reloadConfig()
    }
    
    
}
