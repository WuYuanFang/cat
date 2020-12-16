//
//  XQWaterfallCollectionViewFlowLayout.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

//protocol XQWaterfallCollectionViewFlowLayoutDelegate: NSObjectProtocol {
//
//    /// 返回高度
//    func waterfallCollectionViewFlowLayout(_ waterfallCollectionViewFlowLayout: XQWaterfallCollectionViewFlowLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
//
//}

/// 瀑布流布局
/// 注意, 如 vertical 布局, 那么 cell 必须等宽
/// horizontal 布局, 那么 cell 必须等高. 不然计算上会出现一些问题
///
/// - note: 外部一定要实现 UICollectionViewDelegateFlowLayout 的 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
/// 并且传入你计算好的 size
///
class XQWaterfallCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /// 多少列, 默认两列
    var columnCount = 2
    
//    weak var delegate: XQWaterfallCollectionViewFlowLayoutDelegate?
    
    /// 自己算出来的 layout
    private var xq_layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    /// 计算完之后, 内容视图的滚动大小
    private var xq_collectionViewContentSize: CGSize = CGSize.init(width: 0, height: 0)
    
    override init() {
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 该方法的返回值是一个存放着rect范围内所有元素的布局属性的数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        print(#function)
        // 返回预先计算好的
        return self.xq_layoutAttributes
    }
    
    /// 该方法是准备布局，会在cell显示之前调用
    override func prepare() {
        super.prepare()
        
//        print(#function)
        
        guard let collectionView = self.collectionView, let count = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) else {
            return
        }
        
        self.xq_layoutAttributes.removeAll()
        
        for item in 0..<count {
            self.xq_layoutAttributes.append(self.layoutAttributesForItem(at: IndexPath.init(row: item, section: 0)))
        }
        
        self.waterfallLayout(self.xq_layoutAttributes)
        
    }
    
    /// 是否允许在里面cell位置改变的时候重新布局
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
    
    /// 重写滚动内容大小方法
    override var collectionViewContentSize: CGSize {
        get {
            return self.xq_collectionViewContentSize
        }
    }
    
    /// 生成某个cell布局
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
//        print(#function)
        
        let layoutAttribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        var size = CGSize.init(width: 0, height: 0)
        if let collectionView = self.collectionView, let layoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
            size = layoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? CGSize.init(width: 0, height: 0)
        }else {
            print("XQWaterfallCollectionViewFlowLayout: 请实现 UICollectionViewDelegateFlowLayout 协议的 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize 方法")
        }
        
        layoutAttribute.frame = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        return layoutAttribute
    }

    
    /// 进行瀑布流布局
    private func waterfallLayout(_ layoutAttributes: [UICollectionViewLayoutAttributes]) {
        
        if layoutAttributes.count == 0 {
            return
        }
        
        if self.scrollDirection == .vertical {
            // 垂直滚动
            let minY = self.sectionInset.top
            
            var currentColumnMaxY = [CGFloat]()
            for _ in 0..<self.columnCount {
                currentColumnMaxY.append(minY)
            }
            
            // 宽 + 间距
            let tempItemWidth = layoutAttributes[0].frame.width + self.minimumInteritemSpacing
            
            for (_, layoutAttribute) in layoutAttributes.enumerated() {
                
                // 获取最小y, 和他的下标
                if let rowMinY = currentColumnMaxY.min(), let yIndex = currentColumnMaxY.firstIndex(of: rowMinY) {
                    //                print(rowMinY, yIndex)
                    let x = self.sectionInset.left + CGFloat(yIndex) * tempItemWidth
                    
                    layoutAttribute.frame.origin.y = rowMinY
                    layoutAttribute.frame.origin.x = x
                    
                    currentColumnMaxY[yIndex] = layoutAttribute.frame.maxY + self.minimumLineSpacing
                }
                
            }
            
            let columnMaxY = (currentColumnMaxY.max() ?? 0) + self.sectionInset.bottom
            //        print("columnMaxY: \(columnMaxY)")
            self.xq_collectionViewContentSize = CGSize.init(width: self.collectionView?.frame.width ?? 0, height: columnMaxY)
            
        }else {
            // 横向滚动
            let minX = self.sectionInset.left
            
            var currentColumnMaxX = [CGFloat]()
            for _ in 0..<self.columnCount {
                currentColumnMaxX.append(minX)
            }
            
            // 高 + 间距
            let tempItemWidth = layoutAttributes[0].frame.height + self.minimumInteritemSpacing
            
            for (_, layoutAttribute) in layoutAttributes.enumerated() {
                
                // 获取最小x, 和他的下标
                if let rowMinX = currentColumnMaxX.min(), let yIndex = currentColumnMaxX.firstIndex(of: rowMinX) {
                    
                    let y = self.sectionInset.top + CGFloat(yIndex) * tempItemWidth
                    
                    layoutAttribute.frame.origin.x = rowMinX
                    layoutAttribute.frame.origin.y = y
                    
                    currentColumnMaxX[yIndex] = layoutAttribute.frame.maxX + self.minimumLineSpacing
                }
                
            }
            
            let columnMaxY = (currentColumnMaxX.max() ?? 0) + self.sectionInset.bottom
            self.xq_collectionViewContentSize = CGSize.init(width: columnMaxY, height: self.collectionView?.frame.height ?? 0)
            
        }
        
    }
    
}
