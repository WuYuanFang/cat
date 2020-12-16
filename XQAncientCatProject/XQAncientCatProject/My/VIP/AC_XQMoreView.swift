//
//  AC_XQMoreView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQMoreViewDelegate: NSObjectProtocol {
    
    /// 点击某个cell
    func moreView(_ moreView: AC_XQMoreView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQMoreView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titleLab = UILabel()
    
    let moreBtn = UIButton()
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()
    
    weak var delegate: AC_XQMoreViewDelegate?
    
    var showExchange = false
    
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
        
        self.dataArr = [
            "",
            "",
            "",
            "",
        ]
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
        
        cell.titleLab.text = "会员价¥500"
        cell.imgView.backgroundColor = UIColor.ac_mainColor
        
        if self.showExchange {
            cell.showExchangeUI()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.moreView(self, didSelectItemAt: indexPath)
    }
    
    
}


class AC_XQMoreViewContentViewCell: UICollectionViewCell {
    
    let headerView = UIView()
    let imgView = UIImageView()
    
    let footerView = UIView()
    let titleLab = UILabel()
    
    let exchangeLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.footerView)
        
        self.headerView.addSubview(self.imgView)
        self.footerView.xq_addSubviews(self.titleLab, self.exchangeLab)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(84.0/113.0)
        }
        
        self.footerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.8)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(6)
            make.right.equalTo(-6)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        
        self.imgView.contentMode = .scaleAspectFill
        
        self.headerView.backgroundColor = UIColor.init(hex: "#F6F6F6")
        
//        self.footerView.backgroundColor = UIColor.ac_mainColor
        self.footerView.backgroundColor = UIColor.init(xq_rgbWithR: 192, g: 203, b: 202)
        
        
        self.titleLab.font = UIFont.systemFont(ofSize: 11)
        self.titleLab.textAlignment = .center
        self.titleLab.textColor = UIColor.white
        
        self.exchangeLab.font = self.titleLab.font
        self.exchangeLab.textColor = UIColor.white
        self.exchangeLab.text = "兑换"
        self.exchangeLab.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showExchangeUI() {
        
        if !self.exchangeLab.isHidden {
            return
        }
        
        self.titleLab.textAlignment = .left
        self.exchangeLab.isHidden = false
        
        self.titleLab.snp.remakeConstraints { (make) in
            make.left.equalTo(6)
            make.right.lessThanOrEqualTo(self.exchangeLab.snp.left).offset(-6)
            make.centerY.equalToSuperview()
        }
        
        self.exchangeLab.snp.remakeConstraints { (make) in
            make.right.equalTo(-6)
            make.centerY.equalToSuperview()
        }
        
    }
    
    
}


