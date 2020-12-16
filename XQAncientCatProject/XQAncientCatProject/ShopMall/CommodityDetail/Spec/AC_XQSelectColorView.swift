//
//  AC_XQSelectColorView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

protocol AC_XQSelectColorViewDelegate: NSObjectProtocol {
    
    /// 选择了参数
    func selectColorView(_ selectColorView: AC_XQSelectColorView, didSelectItemAt indexPath: IndexPath, attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel)
}


class AC_XQSelectColorView: AC_XQHomePageViewTableViewHeaderView, UICollectionViewDelegate, UICollectionViewDataSource, AC_XQSelectSpecViewProtocol {

    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var _attListModel: XQSMNTAttListModel?
    var attListModel: XQSMNTAttListModel? {
        set {
            _attListModel = newValue
            
            self.titleLab.text = _attListModel?.Name
            self.collectionView.reloadData()
            
        }
        get {
            return _attListModel
        }
    }
    
    weak var delegate: AC_XQSelectColorViewDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = XQEqualSpaceFlowLayout.init(wthType: .center)
        flowLayout.betweenOfCell = 20
        let cellSize: CGFloat = 33
        flowLayout.estimatedItemSize = CGSize.init(width: cellSize, height: cellSize)
        flowLayout.scrollDirection = .horizontal
        //        flowLayout.minimumLineSpacing = 6
        //        flowLayout.minimumInteritemSpacing = 6
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.contentView.xq_addSubviews(self.collectionView)
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(cellSize + 12)
        }
        
        self.plainTextLayout()
        
        // 设置属性
        
        self.titleLab.text = "颜色选择"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQSelectColorViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
        
//        self.dataArr = [
//            "S",
//            "M",
//            "L",
//            "XL",
//            "XXL",
//        ]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attListModel?.AttValues?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQSelectColorViewCell
        
        let model = self.attListModel?.AttValues?[indexPath.row]
        
        cell.colorView.backgroundColor = UIColor.init(hex: model?.AttrValue ?? "")
//        cell.colorView.backgroundColor = UIColor.qmui_random()
        
        cell.xq_select = model?.CurrentPdSelected ?? false
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let model = self.setSelect(indexPath.row) else {
            return
        }
        
        // 移除刷新动画
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [model.previousIndexPath, model.currentIndexPath])
        }
        
        if let attListModel = self.attListModel, let attValue = attListModel.AttValues?[indexPath.row] {
            self.delegate?.selectColorView(self, didSelectItemAt: indexPath, attListModel: attListModel, attValueModel: attValue)
        }
    }

}


class AC_XQSelectColorViewCell: UICollectionViewCell {
    
    /// 选中旁边的线
    private let borderView = UIView()
    /// 中间圆点
    let colorView = UIView()
    
    private var _xq_select: Bool = false
    /// 是否选中
    var xq_select: Bool {
        set {
            _xq_select = newValue
            
            if _xq_select {
                self.borderView.layer.borderWidth = 1
            }else {
                self.borderView.layer.borderWidth = 0
            }
            
        }
        get {
            return _xq_select
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.borderView)
        self.borderView.addSubview(self.colorView)
        
        // 布局
        let cellSize: CGFloat = 33
        self.borderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.equalTo(cellSize)
        }
        
        let spacing: CGFloat = 4
        self.colorView.snp.makeConstraints { (make) in
            make.top.equalTo(spacing)
            make.right.equalTo(-spacing)
            make.bottom.equalTo(-spacing)
            make.left.equalTo(spacing)
        }
        
        // 设置属性
        self.xq_select = false
        
        self.colorView.layer.cornerRadius = (cellSize - spacing * 2)/2
        
        self.borderView.layer.borderColor = UIColor.ac_mainColor.cgColor
        self.borderView.layer.cornerRadius = cellSize/2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





//class AC_XQSelectColorView: AC_XQHomePageViewTableViewHeaderView, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    var collectionView: UICollectionView!
//    private let cellReuseIdentifier = "cellReuseIdentifier"
//
//    private var _attListModel: XQSMNTAttListModel?
//    var attListModel: XQSMNTAttListModel? {
//        set {
//            _attListModel = newValue
//
//            self.titleLab.text = _attListModel?.Name
//            self.collectionView.reloadData()
//
//        }
//        get {
//            return _attListModel
//        }
//    }
//
//    var selectIndex = 0
//
//    weak var delegate: AC_XQSelectColorViewDelegate?
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        let flowLayout = XQEqualSpaceFlowLayout.init(wthType: .center)
//        flowLayout.betweenOfCell = 20
//        let cellSize: CGFloat = 33
//        flowLayout.estimatedItemSize = CGSize.init(width: cellSize, height: cellSize)
//        flowLayout.scrollDirection = .horizontal
//        //        flowLayout.minimumLineSpacing = 6
//        //        flowLayout.minimumInteritemSpacing = 6
//
//        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
//
//        self.contentView.xq_addSubviews(self.collectionView)
//
//        // 布局
//        self.collectionView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//            make.height.equalTo(cellSize + 12)
//        }
//
//        self.plainTextLayout()
//
//        // 设置属性
//
//        self.titleLab.text = "颜色选择"
//
//        self.collectionView.dataSource = self
//        self.collectionView.delegate = self
//        self.collectionView.register(AC_XQSelectColorViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
//        self.collectionView.isScrollEnabled = false
//        self.collectionView.backgroundColor = UIColor.clear
//
////        self.dataArr = [
////            "S",
////            "M",
////            "L",
////            "XL",
////            "XXL",
////        ]
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - UICollectionViewDataSource
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.attListModel?.AttValues?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQSelectColorViewCell
//
//        let model = self.attListModel?.AttValues?[indexPath.row]
//
//        cell.colorView.backgroundColor = UIColor.init(hex: model?.AttrValue ?? "")
////        cell.colorView.backgroundColor = UIColor.qmui_random()
//
//        cell.xq_select = self.selectIndex == indexPath.row
//        cell.xq_select = model?.CurrentPdSelected ?? false
//
//        return cell
//    }
//
//    // MARK: - UICollectionViewDelegate
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if indexPath.row == self.selectIndex {
//            return
//        }
//
//        let ip = IndexPath.init(row: self.selectIndex, section: 0)
//        self.selectIndex = indexPath.row
//        // 移除刷新动画
//        UIView.performWithoutAnimation {
//            collectionView.reloadItems(at: [ip, indexPath])
//        }
//
//        if let attListModel = self.attListModel, let attValue = attListModel.AttValues?[indexPath.row] {
//            self.delegate?.selectColorView(self, didSelectItemAt: indexPath, attListModel: attListModel, attValueModel: attValue)
//        }
//    }
//
//}
