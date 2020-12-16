//
//  XQAlertSelectAppointmentViewFooterView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class XQAlertSelectAppointmentViewFooterView: UICollectionReusableView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    typealias XQAlertSelectAppointmentViewFooterViewCallback = (_ footerView: XQAlertSelectAppointmentViewFooterView) -> ()
    var selectCallback: XQAlertSelectAppointmentViewFooterViewCallback?
    
    /// 当前选中第几个
    var selectIndex = 0
    
    let contentView = XQBubbleView()
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var _dataArr = [XQSMNTToShopTempDetailTimeModel]()
    var dataArr: [XQSMNTToShopTempDetailTimeModel] {
        set {
            _dataArr = newValue
            
            self.selectIndex = 0
            for (index, item) in _dataArr.enumerated() {
                if item.IsVisibled {
                    self.selectIndex = index
                    break
                }
            }
        }
        get {
            return _dataArr
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        let width = 80
        let height = 30
        flowLayout.estimatedItemSize = CGSize.init(width: width, height: height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
//        flowLayout.minimumInteritemSpacing = 80
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.contentView)
        self.contentView.contentView.addSubview(self.collectionView)
        
        // 布局
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-12)
//            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(XQAlertSelectAppointmentViewFooterViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQAlertSelectAppointmentViewFooterViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.paddingLabel.label.text = model.TimeTitle
        
        if self.selectIndex == indexPath.row {
            cell.paddingLabel.layer.borderWidth = 1
        }else {
            cell.paddingLabel.layer.borderWidth = 0
        }
        
        
        cell.paddingLabel.label.textColor = model.IsVisibled ? UIColor.ac_mainColor : UIColor.init(hex: "#999999")
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectIndex == indexPath.row {
            return
        }
        
        if !self.dataArr[indexPath.row].IsVisibled {
            return
        }
        
        self.selectIndex = indexPath.row
        self.collectionView.reloadData()
        self.selectCallback?(self)
    }
    
        
}





