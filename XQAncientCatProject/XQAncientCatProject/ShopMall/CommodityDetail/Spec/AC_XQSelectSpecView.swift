//
//  AC_XQSelectSpecView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

protocol AC_XQSelectSpecViewDelegate: NSObjectProtocol {
    
    /// 选择了参数
    func selectSpecView(_ selectSpecView: AC_XQSelectSpecView, didSelectItemAt indexPath: IndexPath, attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel)
}

class AC_XQSelectSpecView: AC_XQHomePageViewTableViewHeaderView, UICollectionViewDelegate, UICollectionViewDataSource, AC_XQSelectSpecViewProtocol {
    
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
    
    weak var delegate: AC_XQSelectSpecViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let flowLayout = XQEqualSpaceFlowLayout.init(wthType: .left)
//        flowLayout.betweenOfCell = 10
        
        let flowLayout = XQEqualSpaceCollectionViewFlowLayout()
        flowLayout.layoutType = .left
        flowLayout.cellSpacing = 10
        
//        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumInteritemSpacing = 12
        
        let cellSize: CGFloat = 33
        flowLayout.estimatedItemSize = CGSize.init(width: 80, height: cellSize)
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.contentView.xq_addSubviews(self.collectionView)
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(cellSize + 12)
        }
        
        self.plainTextLayout()
        
        // 设置属性
        
        self.titleLab.text = "其他选择"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQSelectSpecViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
        
        self.collectionView.xq_observerContentSize()
        self.collectionView.xq_changeContentSizeCallback = { [unowned self] (scrollView) in
            self.collectionView.snp.updateConstraints { (make) in
                make.height.equalTo(scrollView.contentSize.height)
            }
        }
        
    }
    
    deinit {
        print(#function, self.classForCoder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attListModel?.AttValues?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQSelectSpecViewCell
        
        let model = self.attListModel?.AttValues?[indexPath.row]
        
        cell.paddingLab.label.text = model?.AttrValue
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
            self.delegate?.selectSpecView(self, didSelectItemAt: indexPath, attListModel: attListModel, attValueModel: attValue)
        }
        
    }
    
    

}

protocol AC_XQSelectSpecViewProtocol {
    
    var attListModel: XQSMNTAttListModel? { get set }
    
    /// 获取当前选中的  indePath
    func getCurrentSelectIndex() -> IndexPath?
    
    /// 选中某一行
    func setSelect(_ index: Int) -> (previousIndexPath: IndexPath, currentIndexPath: IndexPath, valueModel: XQSMNTAttValueModel)?
    
}

extension AC_XQSelectSpecViewProtocol {
    
    func getCurrentSelectIndex() -> IndexPath? {
        
        var ip = IndexPath.init(row: 0, section: 0)
        
        if let AttValues = self.attListModel?.AttValues {
            for (index, item) in AttValues.enumerated() {
                if item.CurrentPdSelected {
                    ip.row = index
                    break
                }
            }
        }
        
        return ip
    }
    
    /// 选中某一行
    func setSelect(_ index: Int) -> (previousIndexPath: IndexPath, currentIndexPath: IndexPath, valueModel: XQSMNTAttValueModel)? {
        
        guard let model = self.attListModel?.AttValues?[index] else {
            return nil
        }
        
        if model.CurrentPdSelected {
            return nil
        }
        
        // 获取上一个选中
        guard let ip = self.getCurrentSelectIndex() else {
            return nil
        }
        
        if let pModel = self.attListModel?.AttValues?[ip.row] {
            pModel.CurrentPdSelected = false
        }
        
        model.CurrentPdSelected = true
        
        return (ip, IndexPath.init(row: index, section: 0), model)
        
        // 移除刷新动画
//        UIView.performWithoutAnimation {
//            collectionView.reloadItems(at: [ip, indexPath])
//        }
        
//        if let attListModel = self.attListModel, let attValue = attListModel.AttValues?[indexPath.row] {
//            self.delegate?.selectSpecView(self, didSelectItemAt: indexPath, attListModel: attListModel, attValueModel: attValue)
//        }
        
    }
    
}


class AC_XQSelectSpecViewCell: XQAlertSelectAppointmentViewCell {
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        // 布局
        self.paddingLab.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        // 设置属性
        
        self.titleNormalColor = UIColor.init(hex: "#B1C1C2")
        self.backNormalColor = UIColor.init(hex: "#F4F4F4")
        
        self.paddingLab.rounded = false
        self.paddingLab.layer.cornerRadius = 4
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension UIScrollView {
    
    private struct XQUIScrollViewAssociatedKeys {
        static var kChangeContentSizeCallback = "UIScrollView_xq_changeContentSizeBlock_kChangeContentSizeCallback"
        static var kLastContentSize = "UIScrollView_lastContentSize"
    }
    
    public typealias XQUIScrollViewCallback = (_ scrollView: UIScrollView) -> ()
    public var xq_changeContentSizeCallback: XQUIScrollViewCallback? {
        get {
            return objc_getAssociatedObject(self, &XQUIScrollViewAssociatedKeys.kChangeContentSizeCallback) as? XQUIScrollViewCallback
        }
        set {
            objc_setAssociatedObject(self, &XQUIScrollViewAssociatedKeys.kChangeContentSizeCallback, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var xq_lastContentSize: CGSize {
        get {
            
            if let value = objc_getAssociatedObject(self, &XQUIScrollViewAssociatedKeys.kLastContentSize) as? NSValue {
                return value.cgSizeValue
            }
            
            return CGSize.init(width: 0, height: 0)
        }
        set {
            let value = NSValue.init(cgSize: newValue)
            objc_setAssociatedObject(self, &XQUIScrollViewAssociatedKeys.kLastContentSize, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
//    /// 停止监听(不调用这个, 就需要等待 scrollView 释放时, 才会去停止)
//    public func xq_stopObserverContentSize() {
//
//    }
    
    /// 监听 滚动大小
    public func xq_observerContentSize() {
        
        weak var weakSelf = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            if let sSelf = weakSelf {
                let lastContentSize = sSelf.xq_lastContentSize
                sSelf.xq_observerContentSize()
                if !lastContentSize.equalTo(sSelf.contentSize) {
                    sSelf.xq_changeContentSize()
                }
            }
            
        }
    }
    
    /// 根据 tableView 滚动大小, 改变布局
    private func xq_changeContentSize() {
        self.xq_lastContentSize = self.contentSize
        self.xq_changeContentSizeCallback?(self)
    }
    
}



