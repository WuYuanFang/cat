//
//  AC_XQVIPViewPrivilegeView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView

/// 特权 view
class AC_XQVIPViewPrivilegeView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, CMPageTitleViewDelegate {
    
    let titleView = CMPageTitleView()
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    
    
    struct AC_XQVIPViewPrivilegeViewCellModel {
        var title = ""
        var img = ""
    }
    
    var dataArr = [AC_XQVIPViewPrivilegeViewCellModel]()
    
    var userInfoModel: XQSMNTUserInfoResModel?
    var currentRankInfo: XQSMNTUserRankInfoDetailModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let height: CGFloat = 120
        flowLayout.itemSize = CGSize.init(width: 70, height: height)
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.xq_addSubviews(self.titleView, self.collectionView)
        
        // 布局
        
        self.titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            //            make.left.equalTo(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom).offset(20)
            make.right.leading.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
        
        // 设置属性
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQVIPViewPrivilegeViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        let config = CMPageTitleConfig.default()
        
        config.sm_config()
        config.cm_contentMode = .left
        config.cm_underlineWidth = 20
        config.cm_titles = [
            "我的M1特权",
            "升级M2可获更多特权",
        ]
                
        self.titleView.delegate = self
        self.titleView.cm_config = config
        
        self.dataArr = [
            AC_XQVIPViewPrivilegeViewCellModel.init(title: "寄养折扣", img: "score_foster"),
            AC_XQVIPViewPrivilegeViewCellModel.init(title: "洗护折扣", img: "score_washProtect"),
            AC_XQVIPViewPrivilegeViewCellModel.init(title: "医疗折扣", img: "score_medicalCare"),
            AC_XQVIPViewPrivilegeViewCellModel.init(title: "消费积分", img: "score_score"),
            AC_XQVIPViewPrivilegeViewCellModel.init(title: "商品折扣", img: "score_commodity"),
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ model: XQSMNTUserInfoResModel?) {
        var titles = [String]()
        if let CurrentRankInfo = model?.CurrentRankInfo {
            titles.append("我的\(CurrentRankInfo.Title)特权")
        }
        
        if let NextRankInfo = model?.NextRankInfo {
            titles.append("升级\(NextRankInfo.Title)可获更多特权")
        }
        
        self.userInfoModel = model
        self.currentRankInfo = model?.CurrentRankInfo
        
        self.titleView.cm_config.cm_titles = titles
        self.titleView.cm_reloadConfig()
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQVIPViewPrivilegeViewCell
        
        cell.titleLab.text = self.dataArr[indexPath.row].title
        cell.imgView.image = UIImage.init(named: self.dataArr[indexPath.row].img)
        
        cell.discountLab.text = ""
        if let currentRankInfo = self.currentRankInfo {
            cell.discountLab.text = "无"
            
            let magnification = 100
            let magnificationF: Float = 10
            switch indexPath.row {
            case 0:
                if currentRankInfo.DiscountOfFoster < magnification {
                    cell.discountLab.text = "\( (Float(currentRankInfo.DiscountOfFoster)/magnificationF).xq_removeDecimalPointZero() )折"
                }
                
            case 1:
                if currentRankInfo.DiscountOfBathe < magnification {
                    cell.discountLab.text = "\( (Float(currentRankInfo.DiscountOfBathe)/magnificationF).xq_removeDecimalPointZero() )折"
                }
                
            case 2:
                if currentRankInfo.DiscountOfMedical < magnification {
                    cell.discountLab.text = "\( (Float(currentRankInfo.DiscountOfMedical)/magnificationF).xq_removeDecimalPointZero() )折"
                }
                
            case 3:
                cell.discountLab.text = ""
                
            case 4:
                if currentRankInfo.DiscountOfAroundShop < magnification {
                    cell.discountLab.text = "\( (Float(currentRankInfo.DiscountOfAroundShop)/magnificationF).xq_removeDecimalPointZero() )折"
                }
            default:
                break
            }
            
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    // MARK: - CMPageTitleViewDelegate
    func cm_pageTitleViewClick(with index: Int, repeat xq_repeat: Bool) {
        if xq_repeat {
            return
        }
        
        if index == 0 {
            self.currentRankInfo = self.userInfoModel?.CurrentRankInfo
        }else {
            self.currentRankInfo = self.userInfoModel?.NextRankInfo
        }
        
        self.collectionView.reloadData()
    }
    
    
}
