//
//  AC_XQScoreHotView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQScoreHotViewDelegate: NSObjectProtocol {
    
    /// 点击某个cell
    func scoreHotView(_ scoreHotView: AC_XQScoreHotView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQScoreHotView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titleLab = UILabel()
    
    let moreBtn = UIButton()
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQSMNTIntegralIntegralProductInfoModel]()
    
    weak var delegate: AC_XQScoreHotViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize.init(width: 95, height: 113)
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.minimumLineSpacing = 12
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        self.addSubview(self.moreBtn)
        self.addSubview(self.titleLab)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
        }
        
        self.moreBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView)
            make.right.bottom.equalToSuperview()
            make.width.equalTo(25)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(20)
            make.bottom.left.equalToSuperview()
            make.right.equalTo(self.moreBtn.snp.left)
            make.height.equalTo(113)
        }
        
        // 设置属性
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQMoreViewContentViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        self.moreBtn.titleLabel?.numberOfLines = 0
        self.moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.moreBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.moreBtn.setTitle("查看更多".xq_toSingleVertical(), for: .normal)
        self.moreBtn.layer.cornerRadius = 12.5
        self.moreBtn.backgroundColor = UIColor.init(hex: "#F6F6F6")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noMoreBtnUI() {
        self.moreBtn.isHidden = true
        
        self.collectionView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(20)
            make.bottom.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(113)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQMoreViewContentViewCell
        
        let model = self.dataArr[indexPath.row]
        cell.titleLab.text = "\(model.ShopPrice.xq_removeDecimalPointZero())积分"
        cell.imgView.sd_setImage(with: model.ShowImgWithAddress.sm_getImgUrl())
        
        cell.showExchangeUI()
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.scoreHotView(self, didSelectItemAt: indexPath)
    }
    
    
}
