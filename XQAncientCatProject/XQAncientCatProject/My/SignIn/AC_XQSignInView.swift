//
//  AC_XQSignInVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/24.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class AC_XQSignInView: UIView {
    
    private static var signInView_: AC_XQSignInView?
    
    typealias AC_XQSignInViewCallback = (_ index: Int) -> ()
    
    /// 显示签到弹框
    /// - Parameters:
    ///   - callback: 0 点击积分, 1 点击兑换商品, 2 点击帮助
    ///   - hideCallback: 点击取消按钮
    static func show(_ callback: AC_XQSignInViewCallback? = nil, hideCallback: AC_XQSignInViewCallback? = nil) {
        
        if let _ = signInView_ {
            return
        }
        
        signInView_ = AC_XQSignInView()
        signInView_?.alpha = 0
        signInView_?.callback = callback
        signInView_?.hideCallback = hideCallback
        UIApplication.shared.keyWindow?.addSubview(signInView_!)
        
        UIView.animate(withDuration: 0.25, animations: {
            signInView_?.alpha = 1
        }) { (result) in
            
        }
        
    }
    
    static func hide() {
        
        if let _ = signInView_ {
            UIView.animate(withDuration: 0.25, animations: {
                signInView_?.alpha = 0
            }) { (result) in
                signInView_?.removeFromSuperview()
                signInView_ = nil
            }
        }
        
    }
    
    static func reloadUI(with signResModel: XQSMNTUserSignResModel?, addSignResModel: XQSMNTUserSignGetJFResModel? = nil) {
        
        guard let signInView = signInView_, let sModel = signResModel else {
            return
        }
        
        var Accumulative = sModel.Accumulative
        var Continuous = sModel.Continuous
        
        if let addSignResModel = addSignResModel, sModel.IsOk {
            signInView.headerView.succeedLab.text = "签到成功 积分+\(addSignResModel.integration)"
            Accumulative += 1
            Continuous += 1
        }else {
            signInView.headerView.alreadySignInLab.isHidden = false
            signInView.headerView.succeedLab.isHidden = true
            signInView.headerView.succeedImgView.isHidden = true
        }
        
        signInView.footerView.cumulativeSignInLab.text = "累计签到\(Accumulative)天"
        signInView.footerView.continueSignInLab.text = "已经连续签到\(Continuous)天"
        
    }
    
    var callback: AC_XQSignInViewCallback?
    var hideCallback: AC_XQSignInViewCallback?
    
    let backView = UIView()
    
    let contentView = UIView()
    let cancelBtn = UIButton()
    
    let xq_contentView = UIView()
    let headerView = AC_XQSignInViewHeaderView()
    let footerView = AC_XQSignInViewFooterView()
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        self.xq_addSubviews(self.backView, self.contentView)
        self.contentView.xq_addSubviews(self.xq_contentView, self.cancelBtn)
        self.xq_contentView.xq_addSubviews(self.headerView, self.footerView)
        
        // 布局
        self.backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.xq_contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 308, height: 364))
        }
        
        self.cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.xq_contentView.snp.bottom).offset(20)
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.headerView.snp.width).multipliedBy(135.0/308.0)
        }
        
        self.footerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        
        // 设置属性
        self.backView.backgroundColor = UIColor.init(white: 0, alpha: 0.7)
        
        self.xq_contentView.layer.cornerRadius = 10
        self.xq_contentView.layer.masksToBounds = true
        
        self.cancelBtn.setImage(UIImage.init(named: "my_signIn_cancel"), for: .normal)
        self.cancelBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.hideCallback?(0)
            AC_XQSignInView.hide()
        }
        
        self.headerView.helpBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.callback?(2)
            AC_XQSignInView.hide()
        }
        
        self.footerView.scoreBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.callback?(0)
            AC_XQSignInView.hide()
        }
        
        self.footerView.goodsBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.callback?(1)
            AC_XQSignInView.hide()
        }
        
        self.headerView.helpBtn.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(#function, self.classForCoder)
    }
    
}

class AC_XQSignInViewHeaderView: UIView {
    
    let helpBtn = UIButton()
    
    let succeedImgView = UIImageView()
    let succeedLab = UILabel()
    
    let alreadySignInLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.helpBtn, self.succeedImgView, self.succeedLab, self.alreadySignInLab)
        
        // 布局
        
        self.helpBtn.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.right.equalTo(-12)
            make.size.equalTo(20)
        }
        
        self.succeedImgView.snp.makeConstraints { (make) in
            make.size.equalTo(45)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        self.succeedLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.succeedImgView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        self.alreadySignInLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.init(hex: "#86A6A8")
        
        self.helpBtn.setImage(UIImage.init(named: "my_signIn_help"), for: .normal)
        
        self.succeedImgView.image = UIImage.init(named: "my_signIn")
        
        self.succeedLab.font = UIFont.systemFont(ofSize: 17)
        self.succeedLab.textColor = UIColor.white
        
        self.alreadySignInLab.font = UIFont.systemFont(ofSize: 17)
        self.alreadySignInLab.textColor = UIColor.white
        self.alreadySignInLab.isHidden = true
        self.alreadySignInLab.text = "您今日已经签到，请明日再来"
        
        
        self.succeedLab.text = "签到成功 积分+10"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class AC_XQSignInViewFooterView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// 累计
    let cumulativeSignInLab = UILabel()
    /// 持续
    let continueSignInLab = UILabel()
    
    let lineView = UIView()
    
    /// 积分
    let scoreBtn = UIButton()
    /// 商品
    let goodsBtn = UIButton()
    
    
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [Date]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let itemSize = CGSize.init(width: 28, height: 40)
        flowLayout.itemSize = itemSize
        flowLayout.minimumLineSpacing = 9
        flowLayout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.xq_addSubviews(self.cumulativeSignInLab, self.continueSignInLab, self.lineView, self.collectionView, self.scoreBtn, self.goodsBtn)
        
        
        // 布局
        self.cumulativeSignInLab.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(30)
        }
        
        self.continueSignInLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.cumulativeSignInLab)
            make.right.equalTo(-30)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cumulativeSignInLab.snp.bottom).offset(6)
            make.right.equalTo(self.continueSignInLab)
            make.left.equalTo(self.cumulativeSignInLab)
            make.height.equalTo(1)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom).offset(6)
            make.right.left.equalTo(self.lineView)
            make.height.equalTo(itemSize.height)
        }
        
        let btnHeigh: CGFloat = 33
        self.goodsBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 110, height: btnHeigh))
        }
        
        self.scoreBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.goodsBtn.snp.top).offset(-12)
            make.centerX.equalToSuperview()
            make.size.equalTo(self.goodsBtn)
        }
        
        
        // 设置属性
        
        self.backgroundColor = UIColor.white
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(AC_XQSignInViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        self.cumulativeSignInLab.textColor = UIColor.ac_mainColor
        self.cumulativeSignInLab.font = UIFont.systemFont(ofSize: 13)
        
        self.continueSignInLab.textColor = UIColor.ac_mainColor
        self.continueSignInLab.font = UIFont.systemFont(ofSize: 13)
        
        self.lineView.backgroundColor = UIColor.ac_mainColor
        
        
        self.scoreBtn.backgroundColor = UIColor.ac_mainColor
        self.scoreBtn.setTitle("查看积分", for: .normal)
        self.scoreBtn.setTitleColor(UIColor.white, for: .normal)
        self.scoreBtn.layer.cornerRadius = btnHeigh/2
        
        self.goodsBtn.backgroundColor = UIColor.white
        self.goodsBtn.setTitle("兑换商品", for: .normal)
        self.goodsBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.goodsBtn.layer.borderWidth = 1
        self.goodsBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        self.goodsBtn.layer.cornerRadius = btnHeigh/2
        
        
        self.cumulativeSignInLab.text = "累计签到10天"
        self.continueSignInLab.text = "已经连续签到3天"
        
        
        
        // 获取当前周的时间
        self.dataArr = Date.xq_getCurrentWeekDates()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQSignInViewCell
        
        let date = self.dataArr[indexPath.row]
        
        cell.topLab.text = String(date.xq_weekdayEnglishStr().prefix(3)).uppercased()
        
        cell.bottomLab.text = date.xq_toString("dd")
        
        cell.xq_select = Date().xq_toString("dd") == date.xq_toString("dd")
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}



