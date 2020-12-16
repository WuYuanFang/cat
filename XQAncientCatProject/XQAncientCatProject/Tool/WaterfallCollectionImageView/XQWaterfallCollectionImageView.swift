//
//  XQWaterfallCollectionImageView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SDWebImage

/// 瀑布流, 纯图片
class XQWaterfallCollectionImageView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQWaterfallCollectionImageViewCellModel]()
    
    var columnWidth: CGFloat = 0
    var columnCount = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = XQWaterfallCollectionViewFlowLayout()
//        flowLayout.delegate = self
        
        flowLayout.minimumLineSpacing = 30
        flowLayout.minimumInteritemSpacing = 16
        
        flowLayout.columnCount = self.columnCount
        self.columnWidth = (system_screenWidth - flowLayout.minimumInteritemSpacing)/CGFloat(flowLayout.columnCount)
        
//        flowLayout.estimatedItemSize = CGSize.init(width: flowLayout.columnWidth, height: 200)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(XQWaterfallCollectionImageViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downLoadImg(_ cell: XQWaterfallCollectionImageViewCell, indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row]
        
        cell.imgView.sd_setImage(with: URL.init(string: model.url), placeholderImage: UIImage.init(named: "my_pet")) { [unowned self] (img, error, cacheType, url) in
            
            if let error = error {
                print("wxq error: ", error)
                return
            }
            
            if let img = img {
                let model = self.dataArr[indexPath.row]
                
                // 不存在才去刷新
                if model.imgSize == nil {
                    let scale = img.size.width / img.size.height
                    model.imgSize = CGSize.init(width: self.columnWidth, height: self.columnWidth / scale)
                    // 不要刷新动画, 不然会很奇怪
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQWaterfallCollectionImageViewCell
        
        let model = self.dataArr[indexPath.row]
        
        self.downLoadImg(cell, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let model = self.dataArr[indexPath.row]

        if let size = model.imgSize {
            return size
        }
        
        return CGSize.init(width: self.columnWidth, height: 200)
    }
    
    // MARK: - XQWaterfallCollectionViewFlowLayoutDelegate
    func waterfallCollectionViewFlowLayout(_ waterfallCollectionViewFlowLayout: XQWaterfallCollectionViewFlowLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let model = self.dataArr[indexPath.row]
        
        if let size = model.imgSize {
            return size.height
        }
        
        return 200
    }
    
}


class XQWaterfallCollectionImageViewCellModel: NSObject {
    
    var imgSize: CGSize?
    
    var url: String = ""
    
    
}



