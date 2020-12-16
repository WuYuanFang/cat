//
//  XQAlertSelectFoodViewDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

protocol XQAlertSelectFoodViewDetailViewDelegate: NSObjectProtocol {
    
    /// 选中
    func selectFoodViewDetailView(_ selectFoodViewDetailView: XQAlertSelectFoodViewDetailView, didSelectItemAt indexPath: IndexPath)
    
    /// 取消选中
    func selectFoodViewDetailView(_ selectFoodViewDetailView: XQAlertSelectFoodViewDetailView, didDeselectItemAt indexPath: IndexPath)
    
}

class XQAlertSelectFoodViewDetailView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// 当前选中第几个
    /// -1 不选任何
//    var selectIndex = -1
    /// 当前选中第几个
    var selectIndexs = [Int]()
    
    let contentView = XQBubbleView()
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()
    
    weak var delegate: XQAlertSelectFoodViewDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.estimatedItemSize = CGSize.init(width: 60, height: 30)
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets.init(top: 12, left: 16, bottom: 0, right: -16)
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.contentView.addSubview(self.collectionView)
        
        // 布局
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-12)
            //            make.left.right.bottom.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(XQAlertSelectFoodViewDetailViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQAlertSelectFoodViewDetailViewCell
        
        cell.paddingView.label.text = self.dataArr[indexPath.row]
        
        cell.xq_select = self.selectIndexs.contains(indexPath.row)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectIndexs.contains(indexPath.row) {
            // 取消
            if let cell = collectionView.cellForItem(at: indexPath) as? XQAlertSelectFoodViewDetailViewCell {
                cell.xq_select = false
            }
            self.selectIndexs.removeAll { (index) -> Bool in
                return index == indexPath.row
            }
            self.delegate?.selectFoodViewDetailView(self, didDeselectItemAt: indexPath)
            
        }else {
            // 选择
            self.selectIndexs.append(indexPath.row)
            if let cell = collectionView.cellForItem(at: indexPath) as? XQAlertSelectFoodViewDetailViewCell {
                cell.xq_select = true
            }
            
            self.delegate?.selectFoodViewDetailView(self, didSelectItemAt: indexPath)
        }
        
        
    }
    
    
}






