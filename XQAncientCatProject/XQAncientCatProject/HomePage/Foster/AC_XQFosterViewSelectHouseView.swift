//
//  AC_XQFosterViewSelectHouseView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQFosterViewSelectHouseViewDelegate: NSObjectProtocol {
    func fosterViewSelectHouseView(_ fosterViewSelectHouseView: AC_XQFosterViewSelectHouseView, didSelectItemAt indexPath: IndexPath)
}

class AC_XQFosterViewSelectHouseView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [XQACNTGM_CatdormitoryModel]()
    
    /// 当前选中的下标
    var selectIndex = 0
    
    weak var delegate: AC_XQFosterViewSelectHouseViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        
        // 布局
        
        let leftSpacing: CGFloat = 12
        let spacing: CGFloat = 12
        let size = AC_XQFosterViewSelectHouseView.getCellSize()
        
        self.collectionView.snp.makeConstraints { (make) in
            make.height.equalTo(size.height + 12 * 2)
            //            make.height.equalTo(30)
            make.edges.equalToSuperview()
            //            make.top.left.equalToSuperview()
        }
        
        // 设置属性
//        let flowLayout = XQCollectionViewScaleLayout()
//        flowLayout.scaleOffset = leftSpacing + width/2
//        flowLayout.minimumScale = 0.85
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.minimumInteritemSpacing = spacing
        
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: leftSpacing, bottom: 0, right: leftSpacing)
//        flowLayout.itemSize = size
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQFosterViewSelectHouseViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQFosterViewSelectHouseViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.imgView.sd_setImage(with: model.Logo.sm_getImgUrl())
        cell.nameLab.text = model.DormitoryName
        cell.moneyLab.text = "¥\(model.dayMoney)/天"
        cell.numberLab.text = "剩余 \(model.Number) 空位"
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row
        collectionView.reloadData()
        
        self.delegate?.fosterViewSelectHouseView(self, didSelectItemAt: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = AC_XQFosterViewSelectHouseView.getCellSize()
        if indexPath.row == self.selectIndex {
            return CGSize.init(width: size.width * 1.1, height: size.height * 1.1)
        }
        return size
    }
    
    private static func getCellSize() -> CGSize {
        return CGSize.init(width: 107, height: 137)
        
        let leftSpacing: CGFloat = 12
        let spacing: CGFloat = 12
        let width = (system_screenWidth - leftSpacing * 2 - spacing * 2) / 3
        let height = width * (129.0/100.0)
        
        return CGSize.init(width: width, height: height)
    }

}
