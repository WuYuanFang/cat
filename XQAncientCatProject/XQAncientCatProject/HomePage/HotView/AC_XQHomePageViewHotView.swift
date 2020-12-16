//
//  AC_XQHomePageViewHotView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SDWebImage

protocol AC_XQHomePageViewHotViewDelegate: NSObjectProtocol {
    
    func homePageViewHotView(_ homePageViewHotView: AC_XQHomePageViewHotView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQHomePageViewHotView: AC_XQHomePageViewTableViewHeaderView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    var dataArr = [XQSMNTHPGetTheHotsModel]()
    
    weak var delegate: AC_XQHomePageViewHotViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.collectionView)
        
        // 布局
        
        let height = 216 + 33
        
        self.collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(height + 12)
//            make.height.equalTo(30)
            make.edges.equalToSuperview()
//            make.top.left.equalToSuperview()
        }
        
        // 设置属性
        
        self.titleLab.text = "热门推荐"
        self.subtitleLab.text = "Popular Recommendation"
        self.imgView.image = UIImage.init(named: "homePage_hot")
        
        let flowLayout = XQCollectionViewScaleLayout()
        
//        flowLayout.minimumLineSpacing = 0
//        flowLayout.minimumInteritemSpacing = 50
        flowLayout.scaleOffset = 108
        flowLayout.minimumScale = 0.6
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
        flowLayout.itemSize = CGSize.init(width: 183, height: height)
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQHomePageViewHotViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQHomePageViewHotViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.imgView.sd_setImage(with: model.PathWithAddress.sm_getImgUrl())
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.homePageViewHotView(self, didSelectItemAt: indexPath)
    }
    

}
