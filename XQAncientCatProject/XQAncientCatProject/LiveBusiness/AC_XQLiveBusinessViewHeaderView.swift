//
//  AC_XQLiveBusinessViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView
import QMUIKit

protocol AC_XQLiveBusinessViewHeaderViewDelegate: NSObjectProtocol {
    
    func liveBusinessViewHeaderView(_ liveBusinessViewHeaderView: AC_XQLiveBusinessViewHeaderView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQLiveBusinessViewHeaderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let titleLineView = UIView()
    let titleLab = UILabel()
    let sideView = AC_XQSideButtonView()
    let titleView = CMPageTitleView()
    
    let businessHistoryBtn = QMUIButton()
    
    let filterBtn = UIButton()
    let sortBtn = UIButton()
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()
    
    weak var delegate: AC_XQLiveBusinessViewHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        
        let flowLayout = UICollectionViewFlowLayout()
        
//        let itemWHScale: CGFloat = 127 / 163
//        let width = (system_screenWidth - 12 * 2 - 12 * 2 - 6 * 2) * 0.4
//        let height = width/itemWHScale;
        
        let size = AC_XQLiveBusinessViewHeaderView.getImgSize()
        
        flowLayout.itemSize = size
        flowLayout.minimumLineSpacing = 20
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        self.xq_addSubviews(self.titleLineView, self.titleLab, self.titleView, self.sideView, self.businessHistoryBtn, self.sortBtn, self.filterBtn)
        
        // 布局
        
        self.titleLineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(18)
            make.height.equalTo(2)
            make.width.equalTo(12)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLineView.snp.bottom).offset(8)
            make.left.equalTo(16)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(size.height + 12)
        }
        
        self.sideView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.equalTo(self.collectionView.snp.bottom).offset(12)
            make.width.equalTo(164)
        }
        
        self.businessHistoryBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.sideView)
            make.left.equalTo(self.titleLab)
            make.width.equalTo(125)
            make.height.equalTo(40)
        }
        
        self.titleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.sideView.snp.bottom).offset(12)
            //            make.left.equalTo(12)
            make.left.equalToSuperview()
            make.right.equalTo(-94)
            make.height.equalTo(44)
        }
        
//        self.sortBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(self.sideView.snp.bottom).offset(12)
//            //            make.left.equalTo(12)
//            make.left.equalToSuperview()
//            make.right.equalTo(-94)
//            make.height.equalTo(44)
//        }
//
//        self.filterBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(self.sideView.snp.bottom).offset(12)
//            //            make.left.equalTo(12)
//            make.left.equalToSuperview()
//            make.right.equalTo(-94)
//            make.height.equalTo(44)
//        }
        
        
        
        // 设置属性
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQLiveBusinessViewHeaderViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        self.collectionView.backgroundColor = UIColor.white
        
        self.titleLineView.backgroundColor = UIColor.ac_mainColor
        self.titleLab.text = "最新上架"
        
        self.sideView.titleLab.text = "我要发布"
        self.sideView.setImg(UIImage.init(named: "publish"))
        
        self.businessHistoryBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.businessHistoryBtn.setTitle("交易记录", for: .normal)
        self.businessHistoryBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.businessHistoryBtn.setImage(UIImage.init(named: "businessHistory"), for: .normal)
        self.businessHistoryBtn.imagePosition = .left
        self.businessHistoryBtn.spacingBetweenImageAndTitle = 12
        self.businessHistoryBtn.layer.cornerRadius = 4
        self.businessHistoryBtn.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        let config = CMPageTitleConfig.default()
        
        config.sm_config()
//        config.cm_contentMode = .left
        config.cm_minTitleMargin = 30
        config.cm_titles = [
            "全部",
            "领养专区❤️",
            "蓝猫",
            "英短",
            "111",
            "111",
            "111",
            "111",
            "111",
            "111",
        ]
        
        //        self.titleView.delegate = self
        self.titleView.cm_config = config
        
        self.dataArr = [
            "asdasd",
            "asdasd",
            "asdasd",
            "asdasd",
            "asdasd",
            "asdasd",
            "asdasd",
            "asdasd",
            "asdasd",
        ]
        
//        self.backgroundColor = UIColor.red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQLiveBusinessViewHeaderViewCell
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.liveBusinessViewHeaderView(self, didSelectItemAt: indexPath)
    }
    
    private static func getImgSize() -> CGSize {
        return CGSize.init(width: 127, height: 163)
    }
    
    /// cell size
    static func xq_headerSize() -> CGSize {
        let imgSize = self.getImgSize()
        let width = system_screenWidth
        let imgHeight = imgSize.height
        
        let height = CGFloat(2 + 8 + 20 + 16 + imgHeight + 16 + 60 + 16 + 44)
        
        return CGSize.init(width: width, height: height)
    }
    
}
