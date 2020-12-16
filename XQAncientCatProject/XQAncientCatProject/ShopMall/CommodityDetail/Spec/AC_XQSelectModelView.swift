//
//  AC_XQSelectModelView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

protocol AC_XQSelectModelViewDelegate: NSObjectProtocol {
    
    /// 选择了参数
    func selectModelView(_ selectModelView: AC_XQSelectModelView, didSelectItemAt indexPath: IndexPath, attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel)
}

class AC_XQSelectModelView: AC_XQHomePageViewTableViewHeaderView, UICollectionViewDelegate, UICollectionViewDataSource, AC_XQSelectSpecViewProtocol {
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    weak var delegate: AC_XQSelectModelViewDelegate?
    
    private let lineView = UIView()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = XQEqualSpaceFlowLayout.init(wthType: .center)
        flowLayout.betweenOfCell = 10
        let cellSize: CGFloat = 33
        flowLayout.estimatedItemSize = CGSize.init(width: 60, height: cellSize)
        flowLayout.scrollDirection = .horizontal
//        flowLayout.minimumLineSpacing = 6
//        flowLayout.minimumInteritemSpacing = 6
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.contentView.xq_addSubviews(self.lineView, self.collectionView)
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(cellSize + 12)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.center.equalTo(self.collectionView)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(27)
        }
        
        
        self.plainTextLayout()
        
        // 设置属性
        
        self.titleLab.text = "重量选择(单位)/型号选择/尺寸选择"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQSelectModelViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
        
        
        self.lineView.layer.cornerRadius = 4
        self.lineView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attListModel?.AttValues?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQSelectModelViewCell
        
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
            self.delegate?.selectModelView(self, didSelectItemAt: indexPath, attListModel: attListModel, attValueModel: attValue)
        }
        
    }
    

}


class AC_XQSelectModelViewCell: XQAlertSelectAppointmentViewCell {


    override init(frame: CGRect) {
        super.init(frame: frame)

        // 布局
        self.paddingLab.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        // 设置属性
        
        self.titleNormalColor = UIColor.init(hex: "#B1C1C2")
        
        self.paddingLab.rounded = false
        self.paddingLab.layer.cornerRadius = 4
    
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

