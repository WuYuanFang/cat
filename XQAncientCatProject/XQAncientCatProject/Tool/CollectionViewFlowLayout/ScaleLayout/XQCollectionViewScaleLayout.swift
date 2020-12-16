//
//  XQCollectionViewScaleLayout.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQCollectionViewScaleLayout: UICollectionViewFlowLayout {
    
    /// 最小缩放
    var minimumScale: CGFloat = 0.9
    /// 最大缩放
    var maximumScale: CGFloat = 1
    
    
    private var _scaleOffset: CGFloat = -1
    /// 偏移中心点, 如果设置了这个，那么则忽略 scaleOffsetPercent
    var scaleOffset: CGFloat {
        set {
            _scaleOffset = newValue
            if _scaleOffset < -1 {
               _scaleOffset = -1
            }
        }
        get {
            return _scaleOffset
        }
    }
    
    private var _scaleOffsetPercent: CGFloat = 0.5
    /// 偏移中心点, 百分比 0 ~ 1
    var scaleOffsetPercent: CGFloat {
        set {
            _scaleOffsetPercent = newValue
            if _scaleOffsetPercent < 0 {
                _scaleOffsetPercent = 0
            }else if _scaleOffsetPercent > 1 {
                _scaleOffsetPercent = 1
            }
        }
        get {
            return _scaleOffsetPercent
        }
    }
    
    private var _finalItemSize: CGSize = CGSize.init(width: 0, height: 0)
    
    override init() {
        super.init()
        self.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 该方法的返回值是一个存放着rect范围内所有元素的布局属性的数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
//        print(#function)
        
        guard let resultAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let collectionWidth = self.collectionView?.bounds.width ?? 0
        let leftBounds = self.collectionView?.bounds.minX ?? 0
        let rightBounds = self.collectionView?.bounds.maxX ?? 0
        
        let itemSize = _finalItemSize
        
        // 没带 x 的中心点
        var centerX = collectionWidth * self.scaleOffsetPercent
        if self.scaleOffset != -1 {
            centerX = self.scaleOffset
        }
        
        // 当前中心点, 带 x 的
        let xq_currentCenterX = centerX + leftBounds
        
        // 计算相对于中心的最大距离
        let minDistance: CGFloat = 0
        let maxDistance: CGFloat = (collectionWidth - centerX) + itemSize.width/2
        
//        print("offset:\(offset), collectionWidth:\(collectionWidth), leftBounds:\(leftBounds), rightBounds:\(rightBounds), xq_currentCenterX:\(xq_currentCenterX), maxDistance:\(maxDistance)")
        
        for attributes in resultAttributes {
            
            var scale: CGFloat = 0
            
            // 相对于中间的绝对值
            let distance = CGFloat(abs(Int(xq_currentCenterX - attributes.center.x)))
            
            if distance >= maxDistance {
                // 屏幕外
                scale = self.minimumScale
                
            }else if distance == minDistance {
                // 最大
                scale = self.maximumScale
                
            }else {
                scale = 1 - (1 - self.minimumScale) * distance/maxDistance;
            }
            
            
//            print("scale:\(scale), centerX:\(attributes.center.x), distance:\(distance), left:\(attributes.frame.maxX - leftBounds), right:\(attributes.frame.minX - rightBounds)")
            
            attributes.transform3D = CATransform3DMakeScale(scale, scale, 1)
            attributes.zIndex = 1
            
        }
        
        return resultAttributes
    }
    
    /// 该方法是准备布局，会在cell显示之前调用
    override func prepare() {
        super.prepare()
//        print(#function)
        
        // 直接设置 item size 的大小
        var iSize = self.itemSize;
        
        // 代理的大小
        if let collectionView = self.collectionView, let layoutDelegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let size = layoutDelegate.collectionView?(collectionView, layout: self, sizeForItemAt: IndexPath.init(item: 0, section: 0)) {
            iSize = size
        }
        
        _finalItemSize = iSize
//        print(_finalItemSize)
    }
    
    /// 是否允许在里面cell位置改变的时候重新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
    /// 停止位置
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//
//        let itemSpacing = _finalItemSize.width
//
//        let contentSize = self.collectionViewContentSize
//
//        guard let frameSize = self.collectionView?.bounds.size else {
//            return proposedContentOffset
//        }
        
//        UIEdgeInsets contentInset = self.collectionView?.qmui_contentInset;

//        BOOL scrollingToRight = proposedContentOffset.x < self.collectionView.contentOffset.x;// 代表 collectionView 期望的实际滚动方向是向右，但不代表手指拖拽的方向是向右，因为有可能此时已经在左边的尽头，继续往右拖拽，松手的瞬间由于回弹，这里会判断为是想向左滚动，但其实你的手指是向右拖拽
//        BOOL scrollingToBottom = proposedContentOffset.y < self.collectionView.contentOffset.y;
//        BOOL forcePaging = NO;
//
//        CGPoint translation = [self.collectionView.panGestureRecognizer translationInView:self.collectionView];
//
//        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
//            if (!self.allowsMultipleItemScroll || ABS(velocity.y) <= ABS(self.multipleItemScrollVelocityLimit)) {
//                proposedContentOffset = self.collectionView.contentOffset;// 一次性滚多次的本质是系统根据速度算出来的 proposedContentOffset 可能比当前 contentOffset 大很多，所以这里既然限制了一次只能滚一页，那就直接取瞬时 contentOffset 即可。
//
//                // 只支持滚动一页 或者 支持滚动多页但是速度不够滚动多页，时，允许强制滚动
//                if (ABS(velocity.y) > self.velocityForEnsurePageDown) {
//                    forcePaging = YES;
//                }
//            }
//
//            // 最顶/最底
//            if (proposedContentOffset.y < -contentInset.top || proposedContentOffset.y >= contentSize.height + contentInset.bottom - frameSize.height) {
//                if (IOS_VERSION_NUMBER < 100000) {
//                    // iOS 10 及以上的版本，直接返回当前的 contentOffset，系统会自动帮你调整到边界状态，而 iOS 9 及以下的版本需要自己计算
//                    // https://github.com/Tencent/QMUI_iOS/issues/499
//                    proposedContentOffset.y = MIN(MAX(proposedContentOffset.y, -contentInset.top), contentSize.height + contentInset.bottom - frameSize.height);
//                }
//                return proposedContentOffset;
//            }
//
//            CGFloat progress = ((contentInset.top + proposedContentOffset.y) + _finalItemSize.height / 2/*因为第一个 item 初始状态中心点离 contentOffset.y 有半个 item 的距离*/) / itemSpacing;
//            NSInteger currentIndex = (NSInteger)progress;
//            NSInteger targetIndex = currentIndex;
//            // 加上下面这两个额外的 if 判断是为了避免那种“从0滚到1的左边 1/3，松手后反而会滚回0”的 bug
//            if (translation.y < 0 && (ABS(translation.y) > _finalItemSize.height / 2 + self.minimumLineSpacing)) {
//            } else if (translation.y > 0 && ABS(translation.y > _finalItemSize.height / 2)) {
//            } else {
//                CGFloat remainder = progress - currentIndex;
//                CGFloat offset = remainder * itemSpacing;
//                BOOL shouldNext = (forcePaging || (offset / _finalItemSize.height >= self.pagingThreshold)) && !scrollingToBottom && velocity.y > 0;
//                BOOL shouldPrev = (forcePaging || (offset / _finalItemSize.height <= 1 - self.pagingThreshold)) && scrollingToBottom && velocity.y < 0;
//                targetIndex = currentIndex + (shouldNext ? 1 : (shouldPrev ? -1 : 0));
//            }
//            proposedContentOffset.y = -contentInset.top + targetIndex * itemSpacing;
//        }
//        else if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//            if (!self.allowsMultipleItemScroll || ABS(velocity.x) <= ABS(self.multipleItemScrollVelocityLimit)) {
//                proposedContentOffset = self.collectionView.contentOffset;// 一次性滚多次的本质是系统根据速度算出来的 proposedContentOffset 可能比当前 contentOffset 大很多，所以这里既然限制了一次只能滚一页，那就直接取瞬时 contentOffset 即可。
//
//                // 只支持滚动一页 或者 支持滚动多页但是速度不够滚动多页，时，允许强制滚动
//                if (ABS(velocity.x) > self.velocityForEnsurePageDown) {
//                    forcePaging = YES;
//                }
//            }
//
//            // 最左/最右
//            if (proposedContentOffset.x < -contentInset.left || proposedContentOffset.x >= contentSize.width + contentInset.right - frameSize.width) {
//                if (IOS_VERSION_NUMBER < 100000) {
//                    // iOS 10 及以上的版本，直接返回当前的 contentOffset，系统会自动帮你调整到边界状态，而 iOS 9 及以下的版本需要自己计算
//                    // https://github.com/Tencent/QMUI_iOS/issues/499
//                    proposedContentOffset.x = MIN(MAX(proposedContentOffset.x, -contentInset.left), contentSize.width + contentInset.right - frameSize.width);
//                }
//                return proposedContentOffset;
//            }
//
//            CGFloat progress = ((contentInset.left + proposedContentOffset.x) + _finalItemSize.width / 2/*因为第一个 item 初始状态中心点离 contentOffset.x 有半个 item 的距离*/) / itemSpacing;
//            NSInteger currentIndex = (NSInteger)progress;
//            NSInteger targetIndex = currentIndex;
//            // 加上下面这两个额外的 if 判断是为了避免那种“从0滚到1的左边 1/3，松手后反而会滚回0”的 bug
//            if (translation.x < 0 && (ABS(translation.x) > _finalItemSize.width / 2 + self.minimumLineSpacing)) {
//            } else if (translation.x > 0 && ABS(translation.x > _finalItemSize.width / 2)) {
//            } else {
//                CGFloat remainder = progress - currentIndex;
//                CGFloat offset = remainder * itemSpacing;
//                // collectionView 关闭了 bounces 后，如果在第一页向左边快速滑动一段距离，并不会触发上一个「最左/最右」的判断（因为 proposedContentOffset 不够），此时的 velocity 为负数，所以要加上 velocity.x > 0 的判断，否则这种情况会命中 forcePaging && !scrollingToRight 这两个条件，当做下一页处理。
//                BOOL shouldNext = (forcePaging || (offset / _finalItemSize.width >= self.pagingThreshold)) && !scrollingToRight && velocity.x > 0;
//                BOOL shouldPrev = (forcePaging || (offset / _finalItemSize.width <= 1 - self.pagingThreshold)) && scrollingToRight && velocity.x < 0;
//                targetIndex = currentIndex + (shouldNext ? 1 : (shouldPrev ? -1 : 0));
//            }
//            proposedContentOffset.x = -contentInset.left + targetIndex * itemSpacing;
//        }
//
//        return proposedContentOffset;
        
//        return CGPoint.init(x: 0, y: 0)
//    }
    
}
