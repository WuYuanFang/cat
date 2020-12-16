//
//  AC_XQScoreMallView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQScoreMallView: UIView {
    
    let welfareView = AC_XQScoreHotView()
    
    let allView = AC_XQScoreMallViewAllView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.welfareView, self.allView)
        
        // 布局
        self.welfareView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.right.equalToSuperview()
        }
        
        self.allView.snp.makeConstraints { (make) in
            make.top.equalTo(self.welfareView.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.welfareView.noMoreBtnUI()
        self.welfareView.titleLab.text = "热门兑换"
        
        self.allView.titleLab.text = "全部"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol AC_XQScoreMallViewAllViewDelegate: NSObjectProtocol {
    
    /// 点击某个cell
    func scoreMallViewAllView(_ scoreMallViewAllView: AC_XQScoreMallViewAllView, didSelectItemAt indexPath: IndexPath)
    
}

class AC_XQScoreMallViewAllView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titleLab = UILabel()
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQSMNTIntegralIntegralProductInfoModel]()
    
    weak var delegate: AC_XQScoreMallViewAllViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize.init(width: 160, height: 190)
        flowLayout.minimumInteritemSpacing = 18
//        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        self.addSubview(self.titleLab)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(20)
            make.bottom.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        // 设置属性
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 17)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQScoreMallViewAllViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQScoreMallViewAllViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.titleLab.text = "\(model.ShopPrice.xq_removeDecimalPointZero())积分"
        
        cell.imgView.sd_setImage(with: model.ShowImgWithAddress.sm_getImgUrl())
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.scoreMallViewAllView(self, didSelectItemAt: indexPath)
    }
    
}


class AC_XQScoreMallViewAllViewCell: UICollectionViewCell {
    
    let headerView = UIView()
    let imgView = UIImageView()
    
    let footerView = UIView()
    let titleLab = UILabel()
    
    let messageLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.footerView)
        
        self.headerView.addSubview(self.imgView)
        self.footerView.xq_addSubviews(self.titleLab, self.messageLab)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(84.0/113.0)
        }
        
        let footerCornerRadius: CGFloat = 10
        self.footerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
//            make.bottom.equalTo(-20)
            make.left.equalTo(-footerCornerRadius)
            make.right.lessThanOrEqualToSuperview().offset(-6)
            make.height.equalTo(35)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview().multipliedBy(0.8)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(12 + footerCornerRadius)
            make.right.equalTo(self.messageLab.snp.left).offset(-16)
            make.centerY.equalToSuperview()
        }
        
        self.messageLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.messageLab.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.init(hex: "#F6F6F6")
        
        self.imgView.contentMode = .scaleAspectFill
        
        self.titleLab.font = UIFont.systemFont(ofSize: 11)
        self.titleLab.textColor = UIColor.white
        
        self.footerView.backgroundColor = UIColor.init(xq_rgbWithR: 192, g: 203, b: 202)
        self.footerView.layer.cornerRadius = 10
        self.footerView.layer.masksToBounds = true
        
        self.messageLab.text = "兑换"
        self.messageLab.font = self.titleLab.font
        self.messageLab.textColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



