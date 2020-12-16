//
//  AC_XQWashProtectViewSelectPetView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQWashProtectViewSelectPetViewDelegate: NSObjectProtocol {
    
    /// 点击某个猫
    func selectPetView(_ selectPetView: AC_XQWashProtectViewSelectPetView, didSelectItemAt indexPath: IndexPath)
    
    /// 点击添加
    func selectPetView(tapAdd selectPetView: AC_XQWashProtectViewSelectPetView)
    
}

class AC_XQWashProtectViewSelectPetView: AC_XQHomePageViewTableViewHeaderView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "AC_XQWashProtectViewSelectPetView_cellReuseIdentifier"
    var dataArr = [XQSMNTGetMyPetListUserPetInfoModel]()
    
    /// 当前选中的 cell
    var selectIndex = 0
    
    weak var delegate: AC_XQWashProtectViewSelectPetViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let cellSize: CGFloat = 60
        flowLayout.estimatedItemSize = CGSize.init(width: cellSize, height: cellSize)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        //        flowLayout.minimumInteritemSpacing = 100
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.contentView.addSubview(self.collectionView)
        
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(cellSize + 12)
        }
        
        
        // 设置属性
        self.titleLab.text = "选择宠物"
        self.subtitleLab.text = ""
        self.imgView.image = UIImage.init(named: "foster_pet")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQWashProtectViewSelectPetViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataArr.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQWashProtectViewSelectPetViewCell
        
        if indexPath.row >= self.dataArr.count {
            cell.reloadUI(false)
            cell.imgView.image = UIImage.init(named: "pet_add")
            return cell
        }
        
        let model = self.dataArr[indexPath.row]
        
//        cell.imgView.image = UIImage.init(named: "AppIcon")
        cell.imgView.sd_setImage(with: model.PhotoWithAddress.sm_getImgUrl())
        
        cell.reloadUI(self.selectIndex == indexPath.row)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row >= self.dataArr.count {
            
            self.delegate?.selectPetView(tapAdd: self)
            return
        }
        
        if self.selectIndex == indexPath.row {
            return
        }
        
        let lastIndex = self.selectIndex
        self.selectIndex = indexPath.row
        
        collectionView.reloadItems(at: [indexPath, IndexPath.init(row: lastIndex, section: 0)])
        self.delegate?.selectPetView(self, didSelectItemAt: indexPath)
    }
    
    
}


class AC_XQWashProtectViewSelectPetViewCell: UICollectionViewCell {
    
    private let centerImgView = UIImageView()
    private let xq_maskView = UIView()
    
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.imgView)
        self.imgView.addSubview(self.xq_maskView)
        self.xq_maskView.addSubview(self.centerImgView)
        
        // 布局
        let cellSize: CGFloat = 60
        self.imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(cellSize)
        }
        
        self.xq_maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.centerImgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(22)
        }
        
        self.reloadUI(false)
        
        // 设置属性
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        self.xq_maskView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.centerImgView.image = UIImage.init(named: "yes")
        
        self.imgView.layer.cornerRadius = cellSize/2
        self.imgView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ select: Bool) {
        if select {
            self.xq_maskView.isHidden = false
        }else {
            self.xq_maskView.isHidden = true
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}
