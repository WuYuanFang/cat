//
//  AC_XQLiveBusinessDetailViewDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 商城的特色view.  活体的详情
class AC_XQLiveBusinessDetailViewDetailView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let titleLab = UILabel()
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize.init(width: 125, height: 175)
        flowLayout.minimumLineSpacing = 25
//        flowLayout.minimumInteritemSpacing = 25
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 30, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(175 + 10)
        }
        
        // 设置属性
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQLiveBusinessDetailViewDetailViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundView?.backgroundColor = UIColor.clear
        self.collectionView.backgroundColor = UIColor.clear
        
        self.dataArr = [
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
            "测试",
        ]
        
        self.titleLab.text = "详情"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQLiveBusinessDetailViewDetailViewCell
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}
