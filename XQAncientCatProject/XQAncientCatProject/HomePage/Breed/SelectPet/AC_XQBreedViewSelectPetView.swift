//
//  AC_XQBreedViewSelectPetView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

class AC_XQBreedViewSelectPetView: AC_XQHomePageViewTableViewHeaderView {
    
    let petListView = AC_XQBreedViewSelectPetViewPetListView()
    let optionView = AC_XQBreedViewSelectPetViewContentView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.petListView, self.optionView)
        
        // 布局
        self.petListView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        self.optionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.petListView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        
        // 设置属性
        
        self.titleLab.text = "选择宠物"
        self.subtitleLab.text = ""
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - AC_XQBreedViewSelectPetViewPetListView

protocol AC_XQBreedViewSelectPetViewPetListViewDelegate: NSObjectProtocol {
    
    /// 点击某个猫
    func petListView(_ petListView: AC_XQBreedViewSelectPetViewPetListView, didSelectItemAt indexPath: IndexPath)
    
    /// 点击添加
    func petListView(tapAdd petListView: AC_XQBreedViewSelectPetViewPetListView)
    
}

/// 选择宠物列表 view
class AC_XQBreedViewSelectPetViewPetListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()
    
    /// 当前选中的 cell
    var selectIndex = 0
    
    weak var delegate: AC_XQBreedViewSelectPetViewPetListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize.init(width: 70, height: 70)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
//        flowLayout.minimumInteritemSpacing = 100
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(70)
            make.bottom.equalToSuperview()
        }
        
        
        // 设置属性
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQBreedViewSelectPetViewPetListViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        self.dataArr = [
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
        return self.dataArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQBreedViewSelectPetViewPetListViewCell
        
        if indexPath.row >= self.dataArr.count {
            cell.reloadUI(false)
            cell.imgView.image = UIImage.init(named: "pet_add")
            return cell
        }
        
        cell.reloadUI(self.selectIndex == indexPath.row)
        cell.imgView.image = UIImage.init(named: "AppIcon")
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row >= self.dataArr.count {
            self.delegate?.petListView(tapAdd: self)
            return
        }
        
        if self.selectIndex == indexPath.row {
            return
        }
        
        let lastIndex = self.selectIndex
        self.selectIndex = indexPath.row
        
        collectionView.reloadItems(at: [indexPath, IndexPath.init(row: lastIndex, section: 0)])
        self.delegate?.petListView(self, didSelectItemAt: indexPath)
    }
    
    
}


class AC_XQBreedViewSelectPetViewPetListViewCell: UICollectionViewCell {
    
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.imgView)
        
        // 布局
        self.reloadUI(false)
        
        // 设置属性
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ select: Bool) {
        
        var size: CGFloat = 63
        
        if select {
//            self.imgView.snp.remakeConstraints { (make) in
////                make.edges.equalToSuperview()
//                make.center.equalToSuperview()
//                make.size.equalTo(63)
//            }
            
        }else {
//            self.imgView.snp.remakeConstraints { (make) in
////                make.top.equalTo(7)
////                make.bottom.equalTo(-7)
////                make.left.equalTo(7)
////                make.right.equalTo(-7)
//                make.center.equalToSuperview()
//                make.size.equalTo(48)
//            }
            size = 48
        }
        
        self.imgView.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(size)
        }
        
        self.imgView.layer.cornerRadius = size/2
        self.imgView.layer.masksToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}













