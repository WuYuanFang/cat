//
//  XQTestCollectionVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQTestCollectionVC: XQACBaseVC, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let flowLayout = UICollectionViewFlowLayout()
        let flowLayout = XQSpringCollectionViewFlowLayout()
        //        let flowLayout = VVSpringCollectionViewFlowLayout()
        
        print(AC_XQShopMallViewCell.xq_cellSize())
//        flowLayout.itemSize = CGSize.init(width: 80, height: 40)
        flowLayout.itemSize = CGSize.init(width: 166, height: AC_XQShopMallViewCell.xq_cellSize().height)
//        flowLayout.itemSize = AC_XQShopMallViewCell.xq_cellSize()
        
        flowLayout.minimumLineSpacing = 18
//        flowLayout.minimumInteritemSpacing = 30
        flowLayout.sectionInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.xq_view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        for _ in 0..<300 {
            self.dataArr.append("")
        }
    }
    
    
    
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath)
        cell.contentView.backgroundColor = UIColor.orange
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

}
