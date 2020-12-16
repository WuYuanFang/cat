//
//  XQAlertSelectAppointmentViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import Masonry
import XQPaddingLabel

class XQAlertSelectAppointmentViewHeaderView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    typealias XQAlertSelectAppointmentViewHeaderViewCallback = (_ headerView: XQAlertSelectAppointmentViewHeaderView) -> ()
    var callback: XQAlertSelectAppointmentViewHeaderViewCallback?
    
    var selectIndex = 0
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    
//    var dataArr = [Date]()
    
    /// Lss (Array[TempDt], optional): 时间点列表 ,
    var dataArr = [XQSMNTToShopTempModel]()
    
    /// 灰色线
    private let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.lineView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize.init(width: 70, height: 88)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
//        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(88)
        }
        
        self.lineView.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.weekViewArr.first!)
            make.bottom.equalTo(-15)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(22)
        }
        
        
        // 设置属性
        self.lineView.backgroundColor = UIColor.init(hex: "#F6F6F6")
        self.lineView.layer.cornerRadius = 4
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(XQAlertSelectAppointmentViewHeaderViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        
//        for item in 0..<7 {
//            let date = Date.init(timeIntervalSinceNow: TimeInterval(item * (24 * 60 * 60)))
//            self.dataArr.append(date)
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQAlertSelectAppointmentViewHeaderViewCell
        
        let date = self.dataArr[indexPath.row]
        
//        cell.dateLab.text = date.xq_toString("MM月dd日")
//        cell.paddingView.label.text = date.xq_weekdayStr()
        cell.dateLab.text = date.TheDate
        cell.paddingView.label.text = date.DateDesc
        
        cell.xq_select = indexPath.row == self.selectIndex
        
        cell.paddingView.xq_addTap { [unowned self] (gesture) in
            self.selectIndex = indexPath.row
            self.collectionView.reloadData()
            self.callback?(self)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    
}


class XQAlertSelectAppointmentViewHeaderViewCell: UICollectionViewCell {
    
    let dateLab = UILabel()
    
    let paddingView = XQPaddingLabel.init(frame: .zero, padding: .init(top: 10, left: 3, bottom: -10, right: -3), rounded: false)
    
    private var _xq_select: Bool = false
    var xq_select: Bool {
        set {
            _xq_select = newValue
            
            if _xq_select {
                self.paddingView.backgroundColor = UIColor.ac_mainColor
                self.paddingView.label.textColor = UIColor.white
                self.paddingView.layer.shadowOpacity = 0.15
            }else {
                self.paddingView.backgroundColor = UIColor.clear
                self.paddingView.label.textColor = UIColor.init(hex: "#999999")
                self.paddingView.layer.shadowOpacity = 0
            }
            
        }
        get {
            return _xq_select
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.dateLab)
        self.contentView.addSubview(self.paddingView)
        
        // 布局
        
        self.dateLab.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.paddingView.snp.makeConstraints { (make) in
            make.top.equalTo(self.dateLab.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        // 设置属性
        
        self.paddingView.layer.cornerRadius = 4
        self.paddingView.label.font = UIFont.systemFont(ofSize: 13)
        
        self.paddingView.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        self.paddingView.layer.shadowOpacity = 0
        self.paddingView.layer.shadowColor = UIColor.black.cgColor
        
        
        self.dateLab.textColor = UIColor.init(hex: "#999999")
        self.dateLab.textAlignment = .center
        self.dateLab.font = UIFont.systemFont(ofSize: 13)
        
        
        self.paddingView.label.text = "今天"
        self.dateLab.text = "3月5日"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

