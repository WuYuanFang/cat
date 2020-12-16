//
//  AC_XQWashProtectViewServiceViewContentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQWashProtectViewServiceViewContentViewDelegate: NSObjectProtocol {
    
    /// 点击了某个 cell
    func washProtectViewServiceViewContentView(_ washProtectViewServiceViewContentView: AC_XQWashProtectViewServiceViewContentView, didSelectItemAt indexPath: IndexPath)
    
    /// 点击了cell的跳转
    func washProtectViewServiceViewContentView(tapPush washProtectViewServiceViewContentView: AC_XQWashProtectViewServiceViewContentView, didSelectItemAt indexPath: IndexPath)
    
}

/// 套餐服务
class AC_XQWashProtectViewServiceViewContentView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQSMNTToShopPdPackageModel]()
    
    var selectIndex = 0
    
    weak var delegate: AC_XQWashProtectViewServiceViewContentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let cellHeight: CGFloat = 145
        flowLayout.itemSize = CGSize.init(width: 105, height: cellHeight)
        flowLayout.minimumLineSpacing = 20
        //        flowLayout.minimumInteritemSpacing = 25
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(cellHeight + 10)
        }
        
        // 设置属性
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQWashProtectViewServiceViewContentViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundView?.backgroundColor = UIColor.clear
        self.collectionView.backgroundColor = UIColor.clear
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ modelArr: [XQSMNTToShopPdPackageModel]) {
        self.dataArr = modelArr
        self.selectIndex = 0
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQWashProtectViewServiceViewContentViewCell
        
        let model = self.dataArr[indexPath.row]
        
        // 说跟后台同步
        cell.imgView.sd_setImage(with: model.PhotoStr.sm_getImgUrl())
        
        cell.titleLab.text = model.PackageName
        cell.messageLab.text = model.Descs
        cell.priceLab.text = "¥\(model.NowPrice)"
        
        cell.xq_isSelected = self.selectIndex == indexPath.row
        
        cell.pushBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.washProtectViewServiceViewContentView(tapPush: self, didSelectItemAt: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.selectIndex {
            return
        }
        
        let ip = IndexPath.init(row: self.selectIndex, section: 0)
        self.selectIndex = indexPath.row
        // 移除刷新动画
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [ip, indexPath])
        }
        
        self.delegate?.washProtectViewServiceViewContentView(self, didSelectItemAt: indexPath)
    }
    
}






