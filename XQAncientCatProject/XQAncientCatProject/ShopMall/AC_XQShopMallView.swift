//
//  AC_XQShopMallView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

protocol AC_XQShopMallViewDelegate: NSObjectProtocol {
    
    /// 点击cell
    func shopMallView(_ shopMallView: AC_XQShopMallView, didSelectItemAt indexPath: IndexPath)
    
    /// 点击加入购物车
    func shopMallView(addShopCar shopMallView: AC_XQShopMallView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQShopMallView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {

    let headerView = AC_XQShopMallViewHeaderView()
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQSMNTProductModel]()
    
    weak var delegate: AC_XQShopMallViewDelegate?
    
    let shopCarBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
//        let flowLayout = XQSpringCollectionViewFlowLayout()
        
//        flowLayout.itemSize = AC_XQShopMallViewCell.xq_cellSize()
        let itemSize = AC_XQShopMallViewCell.xq_cellSize()
        flowLayout.itemSize = CGSize.init(width: Int(itemSize.width), height: Int(itemSize.height))
        
        flowLayout.minimumLineSpacing = 18
        //        flowLayout.minimumInteritemSpacing = 6
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        self.addSubview(self.headerView)
        
        self.addSubview(self.shopCarBtn)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(AC_XQShopMallViewHeaderView.xq_headerSize().height)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
//            make.edges.equalToSuperview()
        }
        
        self.shopCarBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.bottom.equalTo(-40)
            make.size.equalTo(60)
        }
        
        // 设置属性
        self.headerView.backgroundColor = UIColor.white
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQShopMallViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.white
        
//        self.collectionView.contentInset = UIEdgeInsets.init(top: AC_XQShopMallViewHeaderView.xq_headerSize().height - 68, left: 0, bottom: 0, right: 0)
//        self.collectionView.contentInset = UIEdgeInsets.init(top: AC_XQShopMallViewHeaderView.xq_headerSize().height, left: 0, bottom: 0, right: 0)
        
        self.collectionView.contentInsetAdjustmentBehavior = .never
        
        self.shopCarBtn.setBackgroundImage(UIImage.init(named: "mall_suspensionShopCar"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQShopMallViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.imgView.sd_setImage(with: model.ShowImgWithAddress.sm_getImgUrl())
        cell.nameLab.text = model.Name
        cell.priceLab.text = "¥ \(model.ShopPrice)"
        cell.shopCarBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.shopMallView(addShopCar: self, didSelectItemAt: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.shopMallView(self, didSelectItemAt: indexPath)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        return
//    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize.init(width: 0, height: AC_XQShopMallViewHeaderView.xq_headerSize().height)
//    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 不用动头部
        return
        
        var y = scrollView.contentOffset.y
        
//        #if DEBUG
//        print(y, self.headerView.frame.height)
//        #endif
        
        if y > self.headerView.frame.height {
            y = -self.headerView.frame.height
        }else {
            y = -y
        }
        
        self.headerView.frame.origin.y = y
        
        
//        if y > 0 {
//            self.headerView.frame.origin.y = -self.headerView.frame.height
//            return
//        }else if y < -self.headerView.frame.height {
//            self.headerView.frame.origin.y = 0
//            return
//        }
//
//        self.headerView.frame.origin.y = -(y + self.headerView.frame.height)
        
    }

}
