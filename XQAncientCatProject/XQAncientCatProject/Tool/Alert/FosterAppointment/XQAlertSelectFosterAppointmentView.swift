//
//  XQAlertSelectFosterAppointmentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/20.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import XQPaddingLabel
import SVProgressHUD

/// 寄养预约时间
class XQAlertSelectFosterAppointmentView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static func show(_ startHour: Int, endHour: Int, callback: XQAlertSelectFosterAppointmentViewCallback? = nil) {
        
        if let _ = _selectAddressView {
            return
        }
        
        _selectAddressView = XQAlertSelectFosterAppointmentView()
        
        // 添加到 window 上
        if let addressAlertView = _selectAddressView?.addressAlertView {
            UIApplication.shared.keyWindow?.addSubview(addressAlertView)
            addressAlertView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            addressAlertView.show()
        }
        
        _selectAddressView?.callback = callback
        //        _selectAddressView?.collectionView.reloadData()
    }
    
    static func hide() {
        if let selectAddressView = _selectAddressView {
            selectAddressView.addressAlertView.hide()
        }
        _selectAddressView = nil
    }
    
    
    typealias XQAlertSelectFosterAppointmentViewCallback = (_ date: Date) -> ()
    private var callback: XQAlertSelectFosterAppointmentViewCallback?
    
    
    private static var _selectAddressView: XQAlertSelectFosterAppointmentView?
    
    private let addressAlertView = AC_XQAlertBottomOtherView.init(frame: UIScreen.main.bounds, contentHeight: 350)
    
    private var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private let headerReuseIdentifier = "headerReuseIdentifier"
    
    private var dataArr = [Date]()
    
    /// 选中的下标
    private var selectIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        // 少一个像素, 以防误差导致到第二行
        let width = (system_screenWidth - (16 * 2)) / 3 - 1
        let height: CGFloat = 50
        flowLayout.itemSize = CGSize.init(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 16, left: 16, bottom: 0, right: 16)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addressAlertView.contentView.contentView.addSubview(self.collectionView)
        
        
        // 布局
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        
//        self.addressAlertView.delegate = self
        self.addressAlertView.contentView.titleLab.text = "选择预约时间"
        //        self.addressAlertView.contentView.bottomLab.text = "3月8日 10:15"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(XQAlertSelectAppointmentViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        self.addressAlertView.contentView.sureBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            // 点击确定
            self.callback?(self.dataArr[self.selectIndex])
            XQAlertSelectFosterAppointmentView.hide()
        }
        
        for item in 0..<9 {
            let date = Date.init(timeIntervalSinceNow: TimeInterval(item * (24 * 60 * 60)))
            self.dataArr.append(date)
        }
        
        self.addressAlertView.contentView.bottomLab.text = self.dataArr[self.selectIndex].xq_toStringYMD()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 改变当前选中
    func changeCellSelect(with indexPath: IndexPath) {
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQAlertSelectAppointmentViewCell
        
        let date = self.dataArr[indexPath.row]
        
        cell.xq_select = indexPath.row == self.selectIndex
//        cell.paddingLab.label.textColor = model.IsVisibled ? UIColor.ac_mainColor : UIColor.init(hex: "#999999")
        cell.paddingLab.label.text = date.xq_toStringYMD()
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.selectIndex {
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? XQAlertSelectAppointmentViewCell {
            cell.xq_select = true
        }
        
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: self.selectIndex, section: 0)) as? XQAlertSelectAppointmentViewCell {
            cell.xq_select = false
        }
        
        self.selectIndex = indexPath.row
        self.addressAlertView.contentView.bottomLab.text = self.dataArr[self.selectIndex].xq_toStringYMD()
        
    }
    
    
}
