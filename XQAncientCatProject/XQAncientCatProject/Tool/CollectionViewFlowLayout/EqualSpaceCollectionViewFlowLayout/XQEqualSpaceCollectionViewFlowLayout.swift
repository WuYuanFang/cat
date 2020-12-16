//
//  XQEqualSpaceCollectionViewFlowLayout.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQEqualSpaceCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /// 布局类型
    enum LayoutType {
        /// 左边
        case left
        /// 右边
        case right
        /// 中间
        case center
    }
    
    var layoutType: XQEqualSpaceCollectionViewFlowLayout.LayoutType = .left
    
    private var _cellSpacing: CGFloat = 12
    /// cell 间距
    var cellSpacing: CGFloat {
        set {
            _cellSpacing = newValue
            self.minimumInteritemSpacing = self.cellSpacing
        }
        get {
            return _cellSpacing
        }
    }
    
    override init() {
        super.init()
        self.minimumInteritemSpacing = self.cellSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 该方法的返回值是一个存放着rect范围内所有元素的布局属性的数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let resultAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        switch self.layoutType {
        case .left:
            self.leftLayout(resultAttributes)
        case .right:
            self.rightLayout(resultAttributes)
        case .center:
            self.centerLayout(resultAttributes)
        }
        
        return resultAttributes
    }
    
    /// 左边布局
    private func leftLayout(_ attributes: [UICollectionViewLayoutAttributes]) {
        
        var currentRowY: CGFloat = 0
        var currentRowAttrs = [UICollectionViewLayoutAttributes]()
        for item in attributes {
            
            if item.frame.minY == currentRowY {
                currentRowAttrs.append(item)
            }else {
                
                self.xq_layout(currentRowAttrs)
                
                currentRowY = item.frame.minY
                currentRowAttrs.removeAll()
                currentRowAttrs.append(item)
            }
            
        }
        
        // 最后一行
        self.xq_layout(currentRowAttrs)
        
    }
    
    /// 右边布局
    private func rightLayout(_ attributes: [UICollectionViewLayoutAttributes]) {
        
    }
    
    /// 中间布局
    private func centerLayout(_ attributes: [UICollectionViewLayoutAttributes]) {
        
    }
    
    private func xq_layout(_ currentRowAttrs: [UICollectionViewLayoutAttributes]) {
        for (index, item) in currentRowAttrs.enumerated() {
            // 进行布局
            var frame = item.frame
            if index == 0 {
                frame.origin.x = self.sectionInset.left
            }else {
                frame.origin.x = currentRowAttrs[index - 1].frame.maxX + self.minimumLineSpacing
            }
            item.frame = frame
        }
        
    }

}
