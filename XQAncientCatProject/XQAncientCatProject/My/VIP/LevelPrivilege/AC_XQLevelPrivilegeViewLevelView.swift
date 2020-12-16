//
//  AC_XQLevelPrivilegeViewLevelView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

class AC_XQLevelPrivilegeViewLevelView: UIView, XQFormViewDataSource, XQFormViewDelegate {
    
    let formView = XQFormView.init(frame: .zero)
    
    private let rowCellReuseIdentifier = "rowCellReuseIdentifier"
    private let columnCellReuseIdentifier = "columnCellReuseIdentifier"
    private let contentCellReuseIdentifier = "contentCellReuseIdentifier"
    
    let rowDataArr = [
        "商品折扣".xq_toSingleVertical(),
        "会员尊享价".xq_toSingleVertical(),
        "合作医疗机构折扣".xq_toSingleVertical(),
        "消费积分".xq_toSingleVertical(),
        "寄养折扣".xq_toSingleVertical(),
        "洗护折扣".xq_toSingleVertical(),
    ]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.formView)
        
        
        // 布局
        self.formView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        // 设置属性
        
        self.formView.dataSource = self
        self.formView.delegate = self
        
        self.formView.registerRowCell(AC_XQLevelPrivilegeViewRowCell.classForCoder(), forCellWithReuseIdentifier: self.rowCellReuseIdentifier)
        self.formView.registerColumnCell(AC_XQLevelPrivilegeViewColumnCell.classForCoder(), forCellWithReuseIdentifier: self.columnCellReuseIdentifier)
        self.formView.registerContentCell(AC_XQLevelPrivilegeViewContentCell.classForCoder(), forCellWithReuseIdentifier: self.contentCellReuseIdentifier)
        
        
        self.formView.descView.rowDesLab.text = "等级"
        self.formView.descView.rowDesLab.font = UIFont.systemFont(ofSize: 12)
        self.formView.descView.rowDesLab.textColor = UIColor.white
        self.formView.descView.backgroundColor = UIColor.init(hex: "#7E9B9D")
        
        self.formView.descView.singleTitleUI()
        
        self.formView.columnWidth = 55
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - XQFormViewDataSource
    
    /// 多少列
    func formView(columnNumber formView: XQFormView) -> Int {
        return 6
    }
    
    /// 多少行
    func formView(rowNumber formView: XQFormView) -> Int {
        return self.rowDataArr.count
    }
    
    /// 列头部 cell
    /// indexPath.row 就是第几列
    func formView(_ formView: XQFormView, columnTitleCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = columnTitleCollectionView.dequeueReusableCell(withReuseIdentifier: self.columnCellReuseIdentifier, for: indexPath) as! AC_XQLevelPrivilegeViewColumnCell
        
        cell.titleLab.text = "\(indexPath.row)"
        
        return cell
    }
    
    /// 行最左边 cell
    /// indexPath.row 就是第几行
    func formView(_ formView: XQFormView, rowTitleCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = rowTitleCollectionView.dequeueReusableCell(withReuseIdentifier: self.rowCellReuseIdentifier, for: indexPath)  as! AC_XQLevelPrivilegeViewRowCell
        
        cell.titleLab.text = self.rowDataArr[indexPath.row]
        
        return cell
    }
    
    /// 内容 cell
    /// - Parameters:
    ///   - indexPath: collectionview 原本的 indexPath
    ///   - formIndexPath: 按照列和行来分的 indexPath
    func formView(_ formView: XQFormView, contentCollectionView: UICollectionView, cellForItemAt indexPath: IndexPath, formIndexPath: XQFormIndexPath) -> UICollectionViewCell {
        let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: self.contentCellReuseIdentifier, for: indexPath)  as! AC_XQLevelPrivilegeViewContentCell
        
        cell.titleLab.text = "\(formIndexPath.column)列/\(formIndexPath.row)行"
        
        return cell
    }
    
    // MARK: - XQFormViewDelegate
    
    func formView(_ formView: XQFormView, rowHeightForItemAt row: Int) -> CGFloat {
        return 12 + XQDirectionButton.getStringHeight(withText: self.rowDataArr[row], font: UIFont.systemFont(ofSize: 13), viewWidth: 25) + 12
    }
    
    
}


extension String {
    
    /// 单字垂直排列
    /// 就是在每个字后面加上\n换行
    func xq_toSingleVertical() -> String {
        
        var str = ""
        for (index, item) in self.enumerated() {
            
            if index == self.count - 1 {
                // 最后一个
                str.append(item)
            }else {
                str.append("\(item)\n")
            }
            
        }
        
        return str
    }
    
}
