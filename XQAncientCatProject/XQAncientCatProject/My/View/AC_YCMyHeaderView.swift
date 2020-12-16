//
//  AC_YCMyHeaderView.swift
//  XQAncientCatProject
//
//  Created by YCMacMini on 2020/5/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_YCMyHeaderViewDelegate: NSObjectProtocol {
    
    /// 点击我的收入这些
    func myHeaderView(_ myHeaderView: AC_YCMyHeaderView, didSelectItemAt cellType: AC_YCMyHeaderView.CellType)
    
}

class AC_YCMyHeaderView: UITableViewHeaderFooterView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    weak var delegate: AC_YCMyHeaderViewDelegate?
    
    var modelArr = [AC_YCMyHeaderView.CellModel]()
    struct CellModel {
        
        var type: AC_YCMyHeaderView.CellType = .income
        var title = ""
        var img = ""
        
    }
    
    enum CellType: Int {
        /// 收入
        case income = 0
        
        /// 积分
        case integral = 1
        
        /// 会员
        case member = 2
        
        /// 升级会员
        case upgradeMember = 5
        
        /// 优惠券
        case coupon = 3
        
        /// 签到
        case signIn = 4
        
    }
    
    /// 重用标识符
    private let myCollectionViewCellIdent = "myCollectionViewCell"
    
    // Lazy
    
    /// 头部集合view
    lazy var headerView: AC_YCMyInfoHeaderView = {
        let v = AC_YCMyInfoHeaderView()
        return v
    }()
    
    /// 底部collectionView
    lazy var collectionView: UICollectionView = { [unowned self] in
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
//        let width = (system_screenWidth - 3.0 * 13.5 - 2 * 25) / 3
//        let height = width / 0.9126
        let width = 95
        let height = 103
        flowLayout.itemSize = CGSize(width: width, height: height)
        
        flowLayout.minimumLineSpacing = 13.5
        
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(AC_YCMyCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: myCollectionViewCellIdent)
        cv.backgroundColor = UIColor.clear
        
        return cv
    }()
    
    // Life Cycle (生命周期)
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.config()
        self.addElement()
        self.layoutElement()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Config (配置)
    func config() {
        
        if ac_isShowV() {
            self.modelArr = [
                //            AC_YCMyHeaderView.CellModel.init(type: .income, title: "我的收入", img: "my_income"),
                AC_YCMyHeaderView.CellModel.init(type: .integral, title: "积分兑换", img: "my_integral"),
                AC_YCMyHeaderView.CellModel.init(type: .member, title: "会员详情", img: "my_vipDetail"),
                //            AC_YCMyHeaderView.CellModel.init(type: .upgradeMember, title: "升级会员", img: "my_vipDetail"),
                AC_YCMyHeaderView.CellModel.init(type: .coupon, title: "优惠券", img: "my_vipDetail"),
                AC_YCMyHeaderView.CellModel.init(type: .signIn, title: "签到", img: "my_vipDetail"),
            ]
        }else {
            self.modelArr = [
                AC_YCMyHeaderView.CellModel.init(type: .integral, title: "积分兑换", img: "my_integral"),
                AC_YCMyHeaderView.CellModel.init(type: .coupon, title: "优惠券", img: "my_vipDetail"),
                AC_YCMyHeaderView.CellModel.init(type: .signIn, title: "签到", img: "my_vipDetail"),
            ]
        }
        
    }
    
    // Structure （构造）
    func addElement() {
        self.contentView.xq_addSubviews(headerView, collectionView)
    }
    
    func layoutElement() {
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(160)
        }
        
    }
    
    var userInfoResModel: XQSMNTUserInfoResModel?
    func reloadUI(_ userInfoResModel: XQSMNTUserInfoResModel) {
        self.userInfoResModel = userInfoResModel
        self.collectionView.reloadData()
    }
    
}

// MARK:- UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension AC_YCMyHeaderView {
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: myCollectionViewCellIdent, for: indexPath) as! AC_YCMyCollectionViewCell
        
        let model = self.modelArr[indexPath.row]
        cell.titleLabel.text = model.title
        cell.imageView.image = UIImage.init(named: model.img)
        cell.detailLabel.text = ""
        
        switch model.type {
        case AC_YCMyHeaderView.CellType.income:
            break
            
        case AC_YCMyHeaderView.CellType.integral:
            cell.detailLabel.text = "积分: \(self.userInfoResModel?.UserInfo?.PayCredits ?? 0)"
            
        case AC_YCMyHeaderView.CellType.member:
            cell.detailLabel.text = "\(self.userInfoResModel?.CurrentRankInfo?.Title ?? "")会员"
            
            //        case 3:
            //            cell.titleLabel.text = "升级会员"
            //            cell.imageView.image = UIImage.init(named: "my_vipDetail")
            
        case AC_YCMyHeaderView.CellType.coupon:
            cell.detailLabel.text = "领券中心"
            
        case AC_YCMyHeaderView.CellType.signIn:
            cell.detailLabel.text = "签到送积分"
        default:
            break
        }
        
        return cell;
    }
    
    // UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.modelArr[indexPath.row]
        self.delegate?.myHeaderView(self, didSelectItemAt: model.type)
    }
    
}

