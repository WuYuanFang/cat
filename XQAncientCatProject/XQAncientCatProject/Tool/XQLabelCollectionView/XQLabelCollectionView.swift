//
//  XQLabelCollectionView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/5.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

enum XQLabelCollectionViewType {
    
    /// 等间距
    case equalSpacing
    /// 往右靠齐
    case left
    
}

protocol XQLabelCollectionViewDelegate: NSObjectProtocol {
    
    /// 点击了cell
    func labelCollectionView(_ labelCollectionView: XQLabelCollectionView, didSelectItemAt indexPath: IndexPath)
    
}

class XQLabelCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let titleLab = UILabel()
    
    var collectionView: UICollectionView!
    var dataArr = [String]()
    
    /// 当前选中
    var selectIndexPath: IndexPath?
    
    weak var delegate: XQLabelCollectionViewDelegate?
    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var cellBorderColor = UIColor.orange
    private var cellBorderWidth: CGFloat = 1
    private var cellCornerRadius: CGFloat = 4
    
    private var cellSelectBackColor = UIColor.orange
    private var cellNormalBackColor = UIColor.clear
    
    private var cellSelectTitleColor = UIColor.white
    private var cellNormalTitleColor = UIColor.orange
    
    private var cellFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    /// 初始化 view
    /// - Parameters:
    ///   - dataArr: 数据
    ///   - showTitle: 是否显示头部标题
    ///   - cellBorderWidth: cell border 宽度
    ///   - cellBorderColor: cell border 颜色
    ///   - cellCornerRadius: cell 弯角
    ///   - cellSelectBackColor: cell 选中背景颜色
    ///   - cellNormalBackColor: cell 默认背景颜色
    ///   - cellSelectTitleColor: cell 选中文字颜色
    ///   - cellNormalTitleColor: cell 默认文字颜色
    ///   - defaultSelectIndexPath: 默认选中下标
    init(frame: CGRect,
         type: XQLabelCollectionViewType = .equalSpacing,
         dataArr: [String],
         showTitle: Bool = true,
         cellBorderWidth: CGFloat = 1,
         cellBorderColor: UIColor = UIColor.orange,
         cellCornerRadius: CGFloat = 4,
         cellSelectBackColor: UIColor = UIColor.orange,
         cellNormalBackColor: UIColor = UIColor.clear,
         cellSelectTitleColor: UIColor = UIColor.white,
         cellNormalTitleColor: UIColor = UIColor.orange,
         cellFont: UIFont = UIFont.systemFont(ofSize: 15),
         defaultSelectIndexPath: IndexPath? = nil) {
        
        super.init(frame: frame)
        
        self.dataArr = dataArr
        self.cellBorderWidth = cellBorderWidth
        self.cellBorderColor = cellBorderColor
        self.cellCornerRadius = cellCornerRadius
        self.cellSelectBackColor = cellSelectBackColor
        self.cellNormalBackColor = cellNormalBackColor
        self.cellSelectTitleColor = cellSelectTitleColor
        self.cellNormalTitleColor = cellNormalTitleColor
        self.cellFont = cellFont
        self.selectIndexPath = defaultSelectIndexPath
        
        self.addSubview(self.titleLab)
        
        
        var flowLayout = UICollectionViewFlowLayout()
        if type == .equalSpacing {
            flowLayout = XQCollectionViewEqualSpacingFlowLayout()
        }else if type == .left {
            flowLayout = XQEqualSpaceFlowLayout.init(wthType: .left);
            
        }
        
        flowLayout.estimatedItemSize = CGSize.init(width: 80, height: 30)
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        
        // 布局
        
        if showTitle {
            
            self.titleLab.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview()
            }
            
            self.collectionView.snp.makeConstraints { (make) in
                make.top.equalTo(self.titleLab.snp.bottom).offset(16)
                make.right.left.bottom.equalToSuperview()
            }
            
        }else {
            
            self.titleLab.isHidden = true
            
            self.collectionView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
        }
        
        
        // 设置属性
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(XQLabelCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQLabelCollectionViewCell
        
        cell.titleLab.text = self.dataArr[indexPath.row]
        cell.titleLab.font = self.cellFont
        
        cell.contentView.layer.cornerRadius = self.cellCornerRadius
        cell.contentView.layer.borderWidth = self.cellBorderWidth
        cell.contentView.layer.borderColor = self.cellBorderColor.cgColor
        
        if indexPath == self.selectIndexPath {
            self.selectCell(cell, select: true)
        }else {
            self.selectCell(cell, select: false)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.delegate?.labelCollectionView(self, didSelectItemAt: indexPath)
        
        // 第一次
        guard let ip = self.selectIndexPath, let cell = self.collectionView.cellForItem(at: indexPath) as? XQLabelCollectionViewCell else {
            
            if let cell = self.collectionView.cellForItem(at: indexPath) as? XQLabelCollectionViewCell {
                self.selectCell(cell, select: true)
            }
            
            self.selectIndexPath = indexPath
            
            return
        }
        
        // 相同
        if indexPath == ip {
            return
        }
        
        // 上一个
        if let cell = self.collectionView.cellForItem(at: ip) as? XQLabelCollectionViewCell {
            self.selectCell(cell, select: false)
        }
        
        // 当前
        self.selectCell(cell, select: true)
        
        // 改变选中
        self.selectIndexPath = indexPath
    }
    
    func selectCell(_ cell: XQLabelCollectionViewCell, select: Bool) {
        
        if select {
            cell.contentView.backgroundColor = self.cellSelectBackColor
            cell.titleLab.textColor = self.cellSelectTitleColor
        }else {
            cell.contentView.backgroundColor = self.cellNormalBackColor
            cell.titleLab.textColor = self.cellNormalTitleColor
        }
        
    }
    
    
}





