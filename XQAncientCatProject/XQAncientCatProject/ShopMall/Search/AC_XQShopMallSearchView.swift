//
//  AC_XQShopMallSearchView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQShopMallSearchViewDelegate: NSObjectProtocol {
    
    /// 点击cell
    func shopMallView(_ shopMallView: AC_XQShopMallSearchView, didSelectItemAt indexPath: IndexPath)
    
    /// 点击加入购物车
    func shopMallView(addShopCar shopMallView: AC_XQShopMallSearchView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQShopMallSearchView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let searchView = AC_XQShopMallViewHeaderViewSearchView()
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQSMNTProductModel]()
    
    weak var delegate: AC_XQShopMallSearchViewDelegate?
    
    let shopCarBtn = UIButton()
    
    var columnWidth: CGFloat = 160
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let flowLayout = UICollectionViewFlowLayout()
        
        let flowLayout = XQWaterfallCollectionViewFlowLayout()
        flowLayout.columnCount = 2
        
        self.columnWidth = (system_screenWidth - 16 * 3)/2
        flowLayout.estimatedItemSize = CGSize.init(width: self.columnWidth, height: 200)
        
        flowLayout.minimumLineSpacing = 16
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.searchView)
        self.addSubview(self.collectionView)
        self.addSubview(self.shopCarBtn)
        
        // 布局
        
        self.searchView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalToSuperview()
            make.height.equalTo(35)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.searchView.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.shopCarBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(-40)
            make.size.equalTo(60)
        }
        
        // 设置属性
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQShopMallSearchViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.white
        
        //        self.collectionView.contentInsetAdjustmentBehavior = .never
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQShopMallSearchViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.nameLab.text = model.Name
        cell.priceLab.text = "¥ \(model.ShopPrice)"
        cell.shopCarBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.shopMallView(addShopCar: self, didSelectItemAt: indexPath)
        }
        
//        if let size = model.xq_imgSize {
//            cell.xq_contentView.snp.remakeConstraints { (make) in
//                make.top.left.right.equalToSuperview()
//                make.height.equalTo(size.height)
//            }
//        }else {
//            cell.xq_contentView.snp.remakeConstraints { (make) in
//                make.top.left.right.equalToSuperview()
//                make.height.equalTo(0)
//            }
//        }
        cell.imgView.sd_setImage(with: model.ShowImgWithAddress.sm_getImgUrl(), placeholderImage: nil) { [unowned self] (img, error, cacheType, url) in
            
            if let _ = error {
                return
            }
            
            if let img = img {
                
                if self.dataArr[indexPath.row].xq_imgSize == nil {
                    let scale = img.size.width / img.size.height
                    self.dataArr[indexPath.row].xq_imgSize = CGSize.init(width: self.columnWidth,
                                                                         height: self.columnWidth / scale)
                    print("size: ", self.dataArr[indexPath.row].xq_imgSize, indexPath)
                    // 移除刷新动画
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                    
                }
                
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.shopMallView(self, didSelectItemAt: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let model = self.dataArr[indexPath.row]

        if let size = model.xq_imgSize {
            return CGSize.init(width: size.width, height: size.height + 70)
        }
        
        return CGSize.init(width: self.columnWidth, height: 70)
    }
    
    
}
