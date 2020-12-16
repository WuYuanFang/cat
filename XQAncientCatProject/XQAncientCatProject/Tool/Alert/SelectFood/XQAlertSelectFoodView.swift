//
//  XQAlertSelectFoodView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class XQAlertSelectFoodView: UIView, AC_XQAlertBottomOtherViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, XQAlertSelectFoodViewDetailViewDelegate {
    
    static func show(_ modelArr: [XQAlertSelectFoodViewModel]? = nil, callback: XQAlertSelectFoodViewCallback? = nil) {
        
        if let _ = _selectAddressView {
            return
        }
        
        _selectAddressView = XQAlertSelectFoodView()
        
        // 添加到 window 上
        if let addressAlertView = _selectAddressView?.addressAlertView {
            UIApplication.shared.keyWindow?.addSubview(_selectAddressView!)
            UIApplication.shared.keyWindow?.addSubview(addressAlertView)
            addressAlertView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            addressAlertView.show()
        }
        
        _selectAddressView?.callback = callback
        
        _selectAddressView?.dataArr = modelArr ?? []
        _selectAddressView?.collectionView.reloadData()
        
        _selectAddressView?.foodView.dataArr = modelArr?.first?.foods ?? []
        _selectAddressView?.foodView.collectionView.reloadData()
    }
    
    static func hide() {
        if let selectAddressView = _selectAddressView {
            selectAddressView.addressAlertView.hide()
        }
        _selectAddressView?.removeFromSuperview()
        _selectAddressView = nil
    }
    
    private static var _selectAddressView: XQAlertSelectFoodView?
    
    typealias XQAlertSelectFoodViewCallback = (_ selectIndexPaths: [IndexPath]) -> ()
    private var callback: XQAlertSelectFoodViewCallback?
    
    private let addressAlertView = AC_XQAlertBottomOtherView.init(frame: UIScreen.main.bounds, contentHeight: 330)
    
    
    /// 具体选择的食物
    private let foodView = XQAlertSelectFoodViewDetailView()
    
    /// 当前选中的分类
    private var currentSelectCategoryIndex = 0
    
    /// 所有选中的食物
    private var selectIndexPaths = [IndexPath]()
    
    private var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private var dataArr = [XQAlertSelectFoodViewModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addressAlertView.contentView.contentView.addSubview(self.foodView)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = (system_screenWidth - 16 * 2)/5
        flowLayout.itemSize = CGSize.init(width: width, height: 40)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addressAlertView.contentView.contentView.addSubview(self.collectionView)
        
        
        // 布局
        
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        
        self.foodView.snp.makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        // 设置属性
        self.addressAlertView.delegate = self
        self.addressAlertView.contentView.titleLab.text = "选择食物(可多选)"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(XQAlertSelectFoodViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        self.foodView.delegate = self
        
        self.addressAlertView.contentView.sureBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if self.selectIndexPaths.count == 0 {
                SVProgressHUD.showInfo(withStatus: "请选择食物")
                return
            }
            
            self.callback?(self.selectIndexPaths)
            XQAlertSelectFoodView.hide()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if DEBUG
    deinit {
        print(self.classForCoder, #function)
    }
    #endif
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.reloadArrowX()
    }
    
    /// 刷新箭头位置
    func reloadArrowX() {
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: self.currentSelectCategoryIndex, section: 0)) as? XQAlertSelectFoodViewCell {
            let x = cell.frame.midX
            self.foodView.contentView.arrowX = x
        }
        
    }
    
    // MARK: - AC_XQAlertBottomOtherViewDelegate
    
    func alertBottomOtherView(hide alertBottomOtherView: AC_XQAlertBottomOtherView) {
        XQAlertSelectFoodView._selectAddressView?.removeFromSuperview()
        XQAlertSelectFoodView._selectAddressView = nil
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQAlertSelectFoodViewCell
        
        let model = self.dataArr[indexPath.row]
        cell.btn.setTitle(model.name, for: .normal)
        cell.btn.isSelected = self.currentSelectCategoryIndex == indexPath.row
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.currentSelectCategoryIndex == indexPath.row {
            return
        }
        
        if let cell = collectionView.cellForItem(at: IndexPath.init(row: self.currentSelectCategoryIndex, section: 0)) as? XQAlertSelectFoodViewCell {
            cell.btn.isSelected = false
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? XQAlertSelectFoodViewCell {
            cell.btn.isSelected = true
        }
        
        self.currentSelectCategoryIndex = indexPath.row
        self.reloadArrowX()
        
        
        
        let model = self.dataArr[indexPath.row]
        self.foodView.dataArr = model.foods
        
        // 刷新底部view
        self.foodView.selectIndexs.removeAll()
        for item in self.selectIndexPaths {
            if item.section == self.currentSelectCategoryIndex {
                self.foodView.selectIndexs.append(item.row)
            }
        }
        
        self.foodView.collectionView.reloadData()
        
    }
    
    // MARK: - XQAlertSelectFoodViewDetailViewDelegate
    
    func selectFoodViewDetailView(_ selectFoodViewDetailView: XQAlertSelectFoodViewDetailView, didSelectItemAt indexPath: IndexPath) {
        
//        for (index, item) in self.selectIndexPaths.enumerated() {
//            if item.section == self.currentSelectCategoryIndex {
//                self.selectIndexPaths.remove(at: index)
//            }
//        }
        
        self.selectIndexPaths.append(IndexPath.init(row: indexPath.row, section: self.currentSelectCategoryIndex))
        self.reloadBottomLab()
    }
    
    /// 取消选中
    func selectFoodViewDetailView(_ selectFoodViewDetailView: XQAlertSelectFoodViewDetailView, didDeselectItemAt indexPath: IndexPath) {
        let cIp = IndexPath.init(row: indexPath.row, section: self.currentSelectCategoryIndex)
        self.selectIndexPaths.removeAll { (ip) -> Bool in
            return ip == cIp
        }
        self.reloadBottomLab()
    }
    
    
    func reloadBottomLab() {
        
        var bottomStr = ""
        for item in self.selectIndexPaths {
            let str = self.dataArr[item.section].foods[item.row]
            bottomStr += " \(str)"
        }
        
        self.addressAlertView.contentView.bottomLab.text = bottomStr
    }
    
}


struct XQAlertSelectFoodViewModel {
    var name = "罐头"
    var foods = [String]()
}







