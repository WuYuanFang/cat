//
//  XQAlertSelectAppointmentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/2.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import XQPaddingLabel
import SVProgressHUD

/// 洗护选择预约时间
class XQAlertSelectAppointmentView: UIView, AC_XQAlertBottomOtherViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    static func show(_ dayArr: [XQSMNTToShopTempModel], callback: XQAlertSelectAppointmentViewCallback? = nil) {
        
        if let _ = _selectAddressView {
            return
        }
        
        _selectAddressView = XQAlertSelectAppointmentView()
        
        // 添加到 window 上
        if let addressAlertView = _selectAddressView?.addressAlertView {
            UIApplication.shared.keyWindow?.addSubview(addressAlertView)
            addressAlertView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            addressAlertView.show()
        }
        
        _selectAddressView?.callback = callback
        
        _selectAddressView?.headerView.dataArr = dayArr
        _selectAddressView?.headerView.collectionView.reloadData()
        
        _selectAddressView?.refreshSelect()
//        _selectAddressView?.collectionView.reloadData()
    }
    
    static func hide() {
        if let selectAddressView = _selectAddressView {
            selectAddressView.addressAlertView.hide()
        }
        _selectAddressView = nil
    }
    
    
    typealias XQAlertSelectAppointmentViewCallback = (_ date: Date) -> ()
    private var callback: XQAlertSelectAppointmentViewCallback?
    
    
    private static var _selectAddressView: XQAlertSelectAppointmentView?
    
    private let addressAlertView = AC_XQAlertBottomOtherView.init(frame: UIScreen.main.bounds, contentHeight: 470)
    
    private var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private let headerReuseIdentifier = "headerReuseIdentifier"
    
    private var dataArr = [XQAlertSelectAppointmentViewSectionModel]()
    
    /// 上一次选择的
    private var lastSelectIndexPath: IndexPath?
    
    private let headerView = XQAlertSelectAppointmentViewHeaderView()
    
    
    var startHour: Int = 9
    var endHour: Int = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        // 少一个像素, 以防误差导致到第二行
        let width = (system_screenWidth - (16 * 2)) / 4 - 1
        let height: CGFloat = 40
        flowLayout.itemSize = CGSize.init(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        
        self.addressAlertView.contentView.contentView.addSubview(self.headerView)
        self.addressAlertView.contentView.contentView.addSubview(self.collectionView)
        
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.right.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.addressAlertView.delegate = self
        self.addressAlertView.contentView.titleLab.text = "选择预约时间"
//        self.addressAlertView.contentView.bottomLab.text = "3月8日 10:15"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.register(XQAlertSelectAppointmentViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
//        self.collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: self.headerReuseIdentifier)
        self.collectionView.register(XQAlertSelectAppointmentViewFooterView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: self.headerReuseIdentifier)
        
        self.lastSelectIndexPath = IndexPath.init(row: 0, section: 0)
        
        // 点击头部，选择日期
        self.headerView.callback = { [unowned self] (hView) in
            self.refreshSelect()
        }
        
        self.addressAlertView.contentView.sureBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//            let d = self.headerView.dataArr[self.headerView.selectIndex]
            
            guard let lastSelectIndexPath = self.lastSelectIndexPath else {
                return
            }
            
            if let date = self.xq_getDate(with: lastSelectIndexPath) {
//                print("wxq: ", self.cDate.timeIntervalSince1970 - date.timeIntervalSince1970,
//                      self.cDate.xq_toString(), date.xq_toString())
                
                if date.timeIntervalSince1970 < Date().timeIntervalSince1970 {
                    SVProgressHUD.showInfo(withStatus: "请选择正确时间点")
                    return
                }
                
                self.callback?(date)
                XQAlertSelectAppointmentView.hide()
            }
        }
        
    }
    
    private func xq_getDate(with indexPath: IndexPath) -> Date? {
        var hmStr = ""
        if let footerView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath.init(row: 0, section: indexPath.section)) as? XQAlertSelectAppointmentViewFooterView {
            hmStr = footerView.dataArr[footerView.selectIndex].TimeTitle
        }
        
        let model = self.headerView.dataArr[self.headerView.selectIndex]
        let ymdStr = "\(model.TheYear)-\(model.TheMonth)-\(model.TheDay)"
//        let ymdStr = self.headerView.dataArr[self.headerView.selectIndex].xq_toStringYMD()
        
        let dateStr = ymdStr + " " + hmStr
        return dateStr.xq_toDate("yyyy-MM-dd HH:mm")
    }
    
    /// 获取时间
    /// - Parameter mdhm: 月日时分
    private func xq_getDate(with mdhm: String) -> Date? {
        // 这里会有个问题，跨年的时候...
        let year = Date().xq_toStringY()
        let dateStr = year + "年" + mdhm
        if let date = dateStr.xq_toDate("yyyy年MM月dd日 HH:mm") {
            return date
        }
        
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 根据下标获取 cell 相对屏幕的 midX
    func getCellMidX(with row: Int) -> CGFloat {
        let cellWidth = (system_screenWidth - (16 * 2)) / 4 - 1
        let x = 16 + cellWidth * CGFloat(row) + cellWidth/2
        return x
    }
    
    /// 刷新恢复默认
    func refreshSelect() {
        
        var arr = [XQAlertSelectAppointmentViewSectionModel]()
        
        var tempModel = XQAlertSelectAppointmentViewSectionModel()
        let timeList = self.headerView.dataArr[self.headerView.selectIndex].TimeList ?? []
        for (index, item) in timeList.enumerated() {
            if index == 0 {
                tempModel.dataArr.append(item)
            }else if index % 4 == 0 {
                arr.append(tempModel)
                
                tempModel = XQAlertSelectAppointmentViewSectionModel()
                tempModel.dataArr.append(item)
            }else {
                tempModel.dataArr.append(item)
            }
        }
        arr.append(tempModel)
        
        self.dataArr = arr
        
        let result = self.getNormalSelectIndexPath()
        self.lastSelectIndexPath = IndexPath.init(row: result.row, section: result.section)
        
        self.dataArr[result.section].isShow = true
        
        self.collectionView.reloadData()
        self.reloadBottomText()
    }
    
    /// 获取默认的选择
    func getNormalSelectIndexPath() -> (section: Int, row: Int, dRow: Int) {
        
        var result = (0, 0, 0)
        
        for (section, item) in self.dataArr.enumerated() {
            // 4个一行的分区
            
            for (row, rItem) in item.dataArr.enumerated() {
                // 每个小时
                if !rItem.IsVisibled {
                    continue
                }
                
                let smallTimes = rItem.SmallTimes ?? []
                for (dRow, dItem) in smallTimes.enumerated() {
                    // 具体多少点
                    if !dItem.IsVisibled {
                        continue
                    }
                    
                    result.0 = section
                    result.1 = row
                    result.2 = dRow
                    return result
                }
                
            }
            
        }
        
        return result
    }
    
    /// 改变当前选中
    func changeCellSelect(with indexPath: IndexPath) {
        guard let lastSelectIndexPath = lastSelectIndexPath else {
            self.lastSelectIndexPath = indexPath
            self.reloadBottomText()
            return
        }
        
        let lastCell = self.collectionView.cellForItem(at: lastSelectIndexPath) as? XQAlertSelectAppointmentViewCell
        let cell = self.collectionView.cellForItem(at: indexPath) as? XQAlertSelectAppointmentViewCell
        
        lastCell?.xq_select = false
        cell?.xq_select = true
        
        self.lastSelectIndexPath = indexPath
        
        if let footerView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath.init(row: 0, section: indexPath.section)) as? XQAlertSelectAppointmentViewFooterView {
            footerView.dataArr = self.dataArr[indexPath.section].dataArr[indexPath.row].SmallTimes ?? []
            footerView.collectionView.reloadData()
        }
        
        self.reloadBottomText()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr[section].dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQAlertSelectAppointmentViewCell
        
        let model = self.dataArr[indexPath.section].dataArr[indexPath.row]
        
        if self.lastSelectIndexPath?.section == indexPath.section, self.lastSelectIndexPath?.row == indexPath.row {
            cell.xq_select = true
        }else {
            cell.xq_select = false
            cell.paddingLab.label.textColor = model.IsVisibled ? UIColor.ac_mainColor : UIColor.init(hex: "#999999")
        }
        
        
        cell.paddingLab.label.text = model.TimeTitle
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = self.dataArr[indexPath.section]
        if !model.dataArr[indexPath.row].IsVisibled {
            return
        }
        
        if let lastSelectIndexPath = self.lastSelectIndexPath {
            
            if lastSelectIndexPath.section == indexPath.section {
                // 已选中了.
                
                if let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath.init(row: 0, section: indexPath.section)) as? XQAlertSelectAppointmentViewFooterView {
                    // 同区不同行, view 改变
                    let midX = self.getCellMidX(with: indexPath.row)
                    footerView.contentView.arrowX = midX - 16
                }
                
                self.changeCellSelect(with: indexPath)
                
                return
            }
            
            model.isShow.toggle()
            
            let lastModel = self.dataArr[lastSelectIndexPath.section]
            lastModel.isShow.toggle()
            
            self.changeCellSelect(with: indexPath)
            collectionView.reloadSections(IndexSet.init([indexPath.section, lastSelectIndexPath.section]))
            
            return
        }
        
        model.isShow.toggle()
        self.changeCellSelect(with: indexPath)
        collectionView.reloadSections(IndexSet.init(integer: indexPath.section))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerReuseIdentifier, for: indexPath) as! XQAlertSelectAppointmentViewFooterView
        
        let midX = self.getCellMidX(with: self.lastSelectIndexPath?.row ?? 0)
        footerView.contentView.arrowX = midX - 16
        
        if let lastSelectIndexPath = self.lastSelectIndexPath {
//            footerView.hourStr = self.dataArr[lastSelectIndexPath.section].dataArr[lastSelectIndexPath.row].TimeTitle
            
            footerView.dataArr = self.dataArr[lastSelectIndexPath.section].dataArr[lastSelectIndexPath.row].SmallTimes ?? []
            footerView.collectionView.reloadData()
            
            self.reloadBottomText(footerView)
        }
        
        footerView.selectCallback = { [unowned self] (fView) in
            self.reloadBottomText()
        }
        
        return footerView
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let model = self.dataArr[section]
        
        if model.isShow {
            return CGSize.init(width: collectionView.frame.width, height: 80)
        }
        
        return CGSize.init(width: collectionView.frame.width, height: 0)
    }
    
    
    // MARK: - AC_XQAlertBottomOtherViewDelegate
    
    func alertBottomOtherView(hide alertBottomOtherView: AC_XQAlertBottomOtherView) {
        XQAlertSelectAppointmentView._selectAddressView = nil
    }
    
    func reloadBottomText(_ fView: XQAlertSelectAppointmentViewFooterView? = nil) {
        
        var ftView = fView
        
        if fView == nil {
            if let indexPath = self.lastSelectIndexPath,
                let footerView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath.init(row: 0, section: indexPath.section)) as? XQAlertSelectAppointmentViewFooterView {
                ftView = footerView
            }
        }
        
        let dateStr = self.headerView.dataArr[self.headerView.selectIndex].TheDate
        let hmStr = ftView?.dataArr[ftView?.selectIndex ?? 0].TimeTitle ?? ""
        self.addressAlertView.contentView.bottomLab.text = "\(dateStr) \(hmStr)"
    }
    
}


class XQAlertSelectAppointmentViewSectionModel: NSObject {
    
    var isShow = false
    
    var dataArr = [XQSMNTToShopTempTimeModel]()
    
}










