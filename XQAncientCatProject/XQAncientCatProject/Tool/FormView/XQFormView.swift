//
//  XQFormView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

protocol XQFormViewDataSource: NSObjectProtocol {
    
    /// 多少列
    func formView(columnNumber formView: XQFormView) -> Int
    
    /// 多少行
    func formView(rowNumber formView: XQFormView) -> Int
    
    /// 列头部 cell
    /// indexPath.row 就是第几列
    func formView(_ formView: XQFormView, columnTitleCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    /// 行最左边 cell
    /// indexPath.row 就是第几行
    func formView(_ formView: XQFormView, rowTitleCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
    /// 内容 cell
    /// - Parameters:
    ///   - indexPath: collectionview 原本的 indexPath
    ///   - formIndexPath: 按照列和行来分的 indexPath
    func formView(_ formView: XQFormView, contentCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath, formIndexPath: XQFormIndexPath) -> UICollectionViewCell
    
    
    
}

@objc protocol XQFormViewDelegate: NSObjectProtocol {
    
    /// 点击了内容 cell
    /// - Parameters:
    ///   - indexPath: collectionview 原本的 indexPath
    ///   - formIndexPath: 按照列和行来分的 indexPath
    @objc optional func formView(_ formView: XQFormView, didSelectContentItemAt indexPath: IndexPath, formIndexPath: XQFormIndexPath)
    
    /// 点击了列 cell
    /// - Parameters:
    ///   - indexPath: row 第几列
    @objc optional func formView(_ formView: XQFormView, didSelectColumnItemAt indexPath: IndexPath)
    
    /// 点击了行 cell
    /// - Parameters:
    ///   - indexPath: row 第几行
    @objc optional func formView(_ formView: XQFormView, didSelectRowAt indexPath: IndexPath)
    
    
    /// 获取列宽度
    /// - Parameters:
    ///   - column: 第几列
    @objc optional func formView(_ formView: XQFormView, columnWdithForItemAt column: Int) -> CGFloat
    
    
    /// 获取行高度
    /// - Parameters:
    ///   - row: 第几行
    @objc optional func formView(_ formView: XQFormView, rowHeightForItemAt row: Int) -> CGFloat
    
}

class XQFormView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    weak var dataSource: XQFormViewDataSource?
    
    weak var delegate: XQFormViewDelegate?
    
    /// 左上角的描述view
    let descView = XQFormDescView()
    
    /// 列, 宽度, 如已实现代理, 则忽略这个
    var columnWidth: CGFloat = 44
    
    /// 行, 高度, 如已实现代理, 则忽略这个
    var rowHeight: CGFloat = 44
    
    /// 列标题高度
    private var columnTitleHeight: CGFloat = 30
    
    /// 行标题宽度
    private var rowTitleWidth: CGFloat = 25
    
    /// 列间距
    private var columnSpacing: CGFloat = 1.5
    
    /// 行间距
    private var rowSpacing: CGFloat = 2.5
    
    /// 列, 头部
    private var columnCount = 0
    
    /// 行, 左边
    private var rowCount = 0
    
    /// 内容 view 滚动方向
    private var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    private let scrollView = UIScrollView()
    
    private var contentCollectionView: UICollectionView!
    private let contentCollectionFlowLayout = UICollectionViewFlowLayout()
    
    private var rowTitleCollectionView: UICollectionView!
    private let rowTitleCollectionFlowLayout = UICollectionViewFlowLayout()
    
    private var columnTitleCollectionView: UICollectionView!
    private let columnTitleCollectionFlowLayout = UICollectionViewFlowLayout()
    
    private let cellReuseIdentifier = "XQFormView_cellReuseIdentifier"
    
    private var dataArr = [String]()
    
    /// 初始化
    /// - Parameters:
    ///   - scrollDirection: 内容滚动方向 ( 主要影响 cell 刷新问题, 列多情况下, 用 horizontal. 行多情况下, 用 vertical )
    ///   - columnTitleHeight: 列标题高度, 默认 30
    ///   - rowTitleWidth: 行标题宽度, 默认 25
    ///   - columnSpacing: 列间距, 默认 1.5
    ///   - rowSpacing: 行间距, 默认 2.5
    init(frame: CGRect,
         scrollDirection: UICollectionView.ScrollDirection = .horizontal,
         columnTitleHeight: CGFloat = 30,
         rowTitleWidth: CGFloat = 25,
         columnSpacing: CGFloat = 2,
         rowSpacing: CGFloat = 3) {
        
        super.init(frame: frame)
        
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
        
        self.columnTitleHeight = columnTitleHeight
        self.rowTitleWidth = rowTitleWidth
        
        self.scrollDirection = scrollDirection
        
        self.contentCollectionFlowLayout.minimumLineSpacing = rowSpacing
        self.contentCollectionFlowLayout.minimumInteritemSpacing = columnSpacing
        self.contentCollectionFlowLayout.scrollDirection = scrollDirection
        self.contentCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.contentCollectionFlowLayout)
        
        
        self.rowTitleCollectionFlowLayout.minimumLineSpacing = rowSpacing
        self.rowTitleCollectionFlowLayout.minimumInteritemSpacing = columnSpacing
        self.rowTitleCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.rowTitleCollectionFlowLayout)
        
        
        
        self.columnTitleCollectionFlowLayout.minimumLineSpacing = columnSpacing
        self.columnTitleCollectionFlowLayout.minimumInteritemSpacing = rowSpacing
        self.columnTitleCollectionFlowLayout.scrollDirection = .horizontal
        self.columnTitleCollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.columnTitleCollectionFlowLayout)
        
        
//        scrollView
        self.addSubview(self.scrollView)
        self.addSubview(self.descView)
        
        // 布局
        
        self.descView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.size.equalTo(CGSize.init(width: rowTitleWidth, height: columnTitleHeight))
        }
        
        self.columnTitleCollectionFlowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: columnSpacing, bottom: 0, right: 0)
        self.rowTitleCollectionFlowLayout.sectionInset = UIEdgeInsets.init(top: rowSpacing, left: 0, bottom: 0, right: 0)
        self.contentCollectionFlowLayout.sectionInset = UIEdgeInsets.init(top: rowSpacing, left: columnSpacing, bottom: 0, right: 0)
        
        if scrollDirection == .horizontal {
            self.scrollView.addSubview(self.contentCollectionView)
            self.scrollView.addSubview(self.rowTitleCollectionView)
            self.addSubview(self.columnTitleCollectionView)
            
            self.columnTitleCollectionView.snp.makeConstraints { (make) in
                make.left.equalTo(self.descView.snp.right)
                make.top.equalTo(self.descView)
                make.height.equalTo(columnTitleHeight)
                make.right.equalToSuperview()
            }
            
            self.scrollView.snp.makeConstraints { (make) in
                make.top.equalTo(self.columnTitleCollectionView.snp.bottom)
                make.left.bottom.right.equalToSuperview()
            }
            
            let v = UIView()
            self.scrollView.addSubview(v)
            v.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.width.equalToSuperview()
            }
            
            self.rowTitleCollectionView.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.width.equalTo(rowTitleWidth)
                make.bottom.equalToSuperview()
            }
            
            self.contentCollectionView.snp.makeConstraints { (make) in
                make.left.equalTo(self.rowTitleCollectionView.snp.right)
                make.top.bottom.right.equalToSuperview()
            }
            
        }else {
            self.scrollView.addSubview(self.contentCollectionView)
            self.addSubview(self.rowTitleCollectionView)
            self.scrollView.addSubview(self.columnTitleCollectionView)
            
            
            
            self.rowTitleCollectionView.snp.makeConstraints { (make) in
                make.left.equalTo(self.descView)
                make.top.equalTo(self.descView.snp.bottom).offset(self.rowSpacing)
                make.width.equalTo(self.rowTitleWidth)
                make.bottom.equalToSuperview()
            }
            
            self.scrollView.snp.makeConstraints { (make) in
                make.top.equalTo(self.descView)
                make.left.equalTo(self.descView.snp.right)
                make.right.bottom.equalToSuperview()
            }
            
            let v = UIView()
            self.scrollView.addSubview(v)
            v.snp.makeConstraints { (make) in
                make.right.top.bottom.equalToSuperview()
                make.height.equalToSuperview()
            }
            
            self.columnTitleCollectionView.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.height.equalTo(columnTitleHeight)
            }
            
            self.contentCollectionView.snp.makeConstraints { (make) in
                make.top.equalTo(self.columnTitleCollectionView.snp.bottom).offset(self.rowSpacing)
                make.left.bottom.right.equalToSuperview()
            }
            
        }
        
        
        // 设置属性
        
        self.configCollecctionView(self.contentCollectionView)
        self.configCollecctionView(self.rowTitleCollectionView)
        self.configCollecctionView(self.columnTitleCollectionView)
        
        self.columnTitleCollectionView.isScrollEnabled = false
        self.rowTitleCollectionView.isScrollEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.reloadUI()
    }
    
    private var isFirstLayout = true
    /// 列宽数组
    private var columnWidths = [CGFloat]()
    /// 行高数组
    private var rowHeights = [CGFloat]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isFirstLayout {
            self.isFirstLayout = false
            self.reloadUI()
        }
        
    }
    
    private func reloadUI() {
        if self.columnCount == 0, let number = self.dataSource?.formView(columnNumber: self) {
            self.columnCount = number
        }
        
        if self.rowCount == 0, let number = self.dataSource?.formView(rowNumber: self) {
            self.rowCount = number
        }
        
        for item in 0..<self.columnCount {
            if let width = self.delegate?.formView?(self, columnWdithForItemAt: item) {
                self.columnWidths.append(width)
            }else {
                self.columnWidths.append(self.columnWidth)
            }
        }
        
        for item in 0..<self.rowCount {
            if let height = self.delegate?.formView?(self, rowHeightForItemAt: item) {
                self.rowHeights.append(height)
            }else {
                self.rowHeights.append(self.rowHeight)
            }
        }
        
        if self.scrollDirection == .horizontal {
            
            if self.rowCount != 0 {
                var height = self.rowHeights.xq_formTotal()
                height += CGFloat((self.rowHeights.count - 1)) * self.rowSpacing + self.rowTitleCollectionFlowLayout.sectionInset.top
                
                self.rowTitleCollectionView.snp.makeConstraints { (make) in
                    make.left.equalTo(self.descView)
                    make.top.equalToSuperview()
                    make.width.equalTo(self.rowTitleWidth)
                    make.bottom.equalToSuperview()
                    
                    make.height.equalTo(height)
                }
            }
            
        }else {
            
            if self.columnCount != 0 {
                
                var width = self.columnWidths.xq_formTotal()
                width += CGFloat((self.rowHeights.count - 1)) * self.columnSpacing  + self.columnTitleCollectionFlowLayout.sectionInset.left
                
                self.columnTitleCollectionView.snp.remakeConstraints { (make) in
                    make.left.right.top.equalToSuperview()
                    make.height.equalTo(self.columnTitleHeight)
                    
                    make.width.equalTo(width)
                }
                
            }
            
            
        }
        
        
        self.columnTitleCollectionView.reloadData()
        self.rowTitleCollectionView.reloadData()
        self.contentCollectionView.reloadData()
    }
    
    /// 注册左边行的cell
    func registerRowCell(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.rowTitleCollectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    /// 注册头部列的cell
    func registerColumnCell(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.columnTitleCollectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    /// 注册内容cell
    func registerContentCell(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        self.contentCollectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

//    open func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
//
//    }
    
    private func configCollecctionView(_ cView: UICollectionView) {
        cView.dataSource = self
        cView.delegate = self
        cView.backgroundColor = UIColor.clear
        
        cView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isEqual(self.contentCollectionView) {
            
            return self.columnCount * self.rowCount
            
        }else if collectionView.isEqual(self.columnTitleCollectionView) {
            
            if self.columnCount == 0, let number = self.dataSource?.formView(columnNumber: self) {
                self.columnCount = number
                self.contentCollectionView.reloadData()
            }
            
            return self.columnCount
            
        }else if collectionView.isEqual(self.rowTitleCollectionView) {
            
            if self.rowCount == 0, let number = self.dataSource?.formView(rowNumber: self) {
                self.rowCount = number
                self.contentCollectionView.reloadData()
            }
            
            return self.rowCount
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.isEqual(self.contentCollectionView) {
            
            let fIndexPath = indexPath.toFormIndexPath(self.scrollDirection, column: self.columnCount)
            
            if let cell = self.dataSource?.formView(self, contentCollectionView: collectionView, cellForItemAt: indexPath, formIndexPath: fIndexPath) {
                return cell
            }
            
        }else if collectionView.isEqual(self.columnTitleCollectionView) {
            if let cell = self.dataSource?.formView(self, columnTitleCollectionView: collectionView, cellForItemAt: indexPath) {
                return cell
            }
        }else if collectionView.isEqual(self.rowTitleCollectionView) {
            if let cell = self.dataSource?.formView(self, rowTitleCollectionView: collectionView, cellForItemAt: indexPath) {
                return cell
            }
        }
        
        // 默认 cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isEqual(self.contentCollectionView) {
            let fip = indexPath.toFormIndexPath(self.scrollDirection, column: self.columnCount)
            self.delegate?.formView?(self, didSelectContentItemAt: indexPath, formIndexPath: fip)
        }else if collectionView.isEqual(self.columnTitleCollectionView) {
            self.delegate?.formView?(self, didSelectColumnItemAt: indexPath)
        }else if collectionView.isEqual(self.rowTitleCollectionView) {
            self.delegate?.formView?(self, didSelectRowAt: indexPath)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.isEqual(self.contentCollectionView) {
            
            let fIndexPath = indexPath.toFormIndexPath(self.scrollDirection, column: self.columnCount)
            
            var width: CGFloat = self.columnWidth
            if fIndexPath.column < self.columnWidths.count {
                width = self.columnWidths[fIndexPath.column]
            }
            
            var height: CGFloat = self.rowHeight
            if fIndexPath.row < self.rowHeights.count {
                height = self.rowHeights[fIndexPath.row]
            }
            
            return CGSize.init(width: width, height: height)
            
        }else if collectionView.isEqual(self.columnTitleCollectionView) {
            
            var width: CGFloat = self.columnWidth
            if indexPath.row < self.columnWidths.count {
                width = self.columnWidths[indexPath.row]
            }
            return CGSize.init(width: width, height: collectionView.frame.height)
            
        }else if collectionView.isEqual(self.rowTitleCollectionView) {
            
            var height: CGFloat = self.rowHeight
            if indexPath.row < self.rowHeights.count {
                height = self.rowHeights[indexPath.row]
            }
            return CGSize.init(width: collectionView.frame.width, height: height)
        }
        
        return CGSize.init(width: 0, height: 0)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(self.contentCollectionView) {
            
            if self.scrollDirection == .horizontal {
                let x = self.contentCollectionView.contentOffset.x
                let y = self.columnTitleCollectionView.contentOffset.y
                self.columnTitleCollectionView.setContentOffset(CGPoint.init(x: x, y: y), animated: false)
            }else {
                let y = self.contentCollectionView.contentOffset.y
                let x = self.rowTitleCollectionView.contentOffset.x
                self.rowTitleCollectionView.setContentOffset(CGPoint.init(x: x, y: y), animated: false)
            }
            
            
        }
        
    }
    
}


class XQFormIndexPath: NSObject {
    
    /// 列
    var column: Int = 0
    
    /// 行
    var row: Int = 0
    
    /// 转为 IndexPath
    /// - Parameters:
    ///   - scrollDirection: 内容视图的滚动方向
    ///   - column: 当前多少列
    func toIndexPath(_ scrollDirection: UICollectionView.ScrollDirection, column: Int) -> IndexPath {
        IndexPath.init(row: self.row, section: self.column)
    }
    
    /// 便捷初始化
    init(_ row: Int, column: Int) {
        super.init()
        
        self.row = row
        self.column = column
        
    }
}

extension IndexPath {
    
    /// 转为 XQFormIndexPath
    /// - Parameters:
    ///   - scrollDirection: 内容视图的滚动方向
    ///   - column: 当前多少列
    func toFormIndexPath(_ scrollDirection: UICollectionView.ScrollDirection, column: Int) -> XQFormIndexPath {
        
        /// 第几列
        let rColumn = self.row % column
        /// 第几行
        let rRow = Int(Float(self.row)/Float(column))
        
        if scrollDirection == .horizontal {
            let fip = XQFormIndexPath.init(rColumn, column: rRow)
            return fip
        }
        let fip = XQFormIndexPath.init(rRow, column: rColumn)
        return fip
    }
    
    
    
}

extension Array where Element == CGFloat {
    
    func xq_formTotal() -> Element {
        var total: Element = 0
        for item in self {
            total += item
        }
        return total
    }
    
}

