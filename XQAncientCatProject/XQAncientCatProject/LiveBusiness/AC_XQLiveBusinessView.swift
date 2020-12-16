//
//  AC_XQLiveBusinessView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

protocol AC_XQLiveBusinessViewDelegate: NSObjectProtocol {
    
    func liveBusinessView(_ liveBusinessView: AC_XQLiveBusinessView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQLiveBusinessView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let headerView = AC_XQLiveBusinessViewHeaderView()
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()
    
    weak var delegate: AC_XQLiveBusinessViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = AC_XQLiveBusinessViewCell.xq_cellSize();
        
        flowLayout.minimumLineSpacing = 18
//        flowLayout.minimumInteritemSpacing = 6
        flowLayout.sectionInset = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQLiveBusinessViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.white
        
        self.addSubview(self.collectionView)
        self.addSubview(self.headerView)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(XQIOSDevice.getStatusHeight() + 30)
            make.left.right.equalToSuperview()
            make.height.equalTo(AC_XQLiveBusinessViewHeaderView.xq_headerSize().height)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
//            make.bottom.left.right.equalToSuperview()
//            make.top.equalTo(self.headerView.snp.bottom)
            
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        self.headerView.backgroundColor = UIColor.white
        
        self.dataArr = [
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
            "asd",
        ]
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQLiveBusinessViewCell
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.liveBusinessView(self, didSelectItemAt: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 0, height: AC_XQLiveBusinessViewHeaderView.xq_headerSize().height)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
        
    }
}
