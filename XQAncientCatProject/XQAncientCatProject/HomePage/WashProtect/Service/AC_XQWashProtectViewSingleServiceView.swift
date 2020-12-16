//
//  AC_XQWashProtectViewSingleServiceView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQWashProtectViewSingleServiceViewDelegate: NSObjectProtocol {
    
    /// 选中或者取消某个cell
    /// - Parameters:
    ///   - select: true 选中, false 取消
    func washProtectViewSingleServiceView(_ washProtectViewSingleServiceView: AC_XQWashProtectViewSingleServiceView, didSelectItemAt indexPath: IndexPath, select: Bool)
    
    /// 查看详情, 右下角按钮
    func washProtectViewSingleServiceView(detail washProtectViewSingleServiceView: AC_XQWashProtectViewSingleServiceView, didSelectItemAt indexPath: IndexPath)
    
}

/// 单品选项
class AC_XQWashProtectViewSingleServiceView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQSMNTToProductTinnyV2Model]()
    
    /// 可多选
    var selectIndexArr = [Int]()
    
    weak var delegate: AC_XQWashProtectViewSingleServiceViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let cellHeight: CGFloat = 115
        flowLayout.itemSize = CGSize.init(width: 95, height: cellHeight)
        flowLayout.minimumLineSpacing = 16
        //        flowLayout.minimumInteritemSpacing = 25
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 12, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        // 布局
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(cellHeight + 10)
        }
        
        // 设置属性
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQWashProtectViewSingleServiceViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundView?.backgroundColor = UIColor.clear
        self.collectionView.backgroundColor = UIColor.clear
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ modelArr: [XQSMNTToProductTinnyV2Model]) {
        self.dataArr = modelArr
        self.selectIndexArr.removeAll()
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQWashProtectViewSingleServiceViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.imgView.sd_setImage(with: model.PhotoStr.sm_getImgUrl())
        cell.titleLab.text = model.Name
        cell.priceLab.text = "¥\(model.NowPrice)"
        
        cell.xq_isSelected = self.selectIndexArr.contains(indexPath.row)
        
        cell.pushBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.washProtectViewSingleServiceView(detail: self, didSelectItemAt: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectIndexArr.contains(indexPath.row) {
            // 取消选择
            self.selectIndexArr.removeAll(where: { (element) -> Bool in
                return element == indexPath.row
            })
            self.delegate?.washProtectViewSingleServiceView(self, didSelectItemAt: indexPath, select: false)
        }else {
            self.selectIndexArr.append(indexPath.row)
            self.delegate?.washProtectViewSingleServiceView(self, didSelectItemAt: indexPath, select: true)
        }
        
        // 移除刷新动画
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
        
    }

}
