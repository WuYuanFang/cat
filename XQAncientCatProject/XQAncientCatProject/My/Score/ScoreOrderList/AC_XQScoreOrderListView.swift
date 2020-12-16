//
//  AC_XQScoreOrderListView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQScoreOrderListViewDelegate: NSObjectProtocol {
    
    /// 点击 cell
    func scoreOrderListView(_ scoreOrderListView: AC_XQScoreOrderListView, didSelectItemAt indexPath: IndexPath)
    
    /// 点击再次购买
    func scoreOrderListView(againBuy scoreOrderListView: AC_XQScoreOrderListView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQScoreOrderListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQSMNTIntegralProductsOrdersInfoModel]()
    
    weak var delegate: AC_XQScoreOrderListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize.init(width: 100, height: 130)
        flowLayout.minimumInteritemSpacing = 18
        //        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        // 布局
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQScoreOrderListViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQScoreOrderListViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.priceLab.text = "\(model.SumShopPrice)积分"
        
        cell.imgView.sd_setImage(with: model.ShowImg.sm_getImgUrl())
        
        cell.footerView.xq_addTap { [unowned self] (gesture) in
            self.delegate?.scoreOrderListView(againBuy: self, didSelectItemAt: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.scoreOrderListView(self, didSelectItemAt: indexPath)
    }
}
