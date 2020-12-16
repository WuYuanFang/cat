//
//  XQSpringCollectionViewFlowLayout.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 源码 https://github.com/onevcat/VVSpringCollectionViewFlowLayout
/// 这里是把 oc 转为 swift, 并且支持 CocoaPod
///
/// 这里好像有个进阶的 https://wiki.jikexueyuan.com/project/objc/iOS-7/5-2.html , 不过还没看, 到时候可以补一下
///

/// 弹性 layout
/// 注意! 经过测试发现一个问题. 就是 item 的 size, 不能有小数点, 不然会出现 cell 在画圆圈一样的弹性动画 ~.~
class XQSpringCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var _springDamping: Float = 0.5
    var springDamping: Float {
        set {
            
            if _springDamping >= 0 && _springDamping != newValue {
                _springDamping = newValue;
                for spring in self.animator?.behaviors ?? [] {
                    if let spring = spring as? UIAttachmentBehavior {
                        spring.damping = CGFloat(_springDamping)
                    }
                }
            }
        }
        get {
            return _springDamping
        }
    }
    
    private var _springFrequency: Float = 0.8
    var springFrequency: Float {
        set {
            
            if _springFrequency >= 0 && _springFrequency != newValue {
                _springFrequency = newValue
                for spring in self.animator?.behaviors ?? [] {
                    if let spring = spring as? UIAttachmentBehavior {
                        spring.frequency = CGFloat(_springFrequency);
                    }
                }
            }
            
        }
        get {
            return _springFrequency
        }
    }
    
    private var _resistanceFactor: Float = 500
    var resistanceFactor: Float {
        set {
            _resistanceFactor = newValue
        }
        get {
            return _resistanceFactor
        }
    }
    
    private var animator: UIDynamicAnimator?
    
    override init() {
        super.init()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        if self.animator == nil {
            self.animator = UIDynamicAnimator.init(collectionViewLayout: self)

            let contentSize = self.collectionViewContentSize
            
            if let items = super.layoutAttributesForElements(in: .init(x: 0, y: 0, width: contentSize.width, height: contentSize.height)) {
                
                for item in items {
                    let spring = UIAttachmentBehavior.init(item: item, attachedToAnchor: item.center)
                    
                    spring.length = 0;
                    spring.damping = CGFloat(self.springDamping);
                    spring.frequency = CGFloat(self.springFrequency);
                    
                    self.animator?.addBehavior(spring)
                }
                
            }
            
        }

        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if let layoutAttrs = self.animator?.items(in: rect) as? [UICollectionViewLayoutAttributes] {
            return layoutAttrs
        }
        
        return nil
    }
    
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.animator?.layoutAttributesForCell(at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        
        if let scrollView = self.collectionView {
            
            let scrollDelta = newBounds.origin.y - scrollView.bounds.origin.y
            
            let touchLocation = scrollView.panGestureRecognizer.location(in: scrollView)
            
            for spring in self.animator?.behaviors ?? [] {
                
                if let spring = spring as? UIAttachmentBehavior {
                    
                    let anchorPoint = spring.anchorPoint;
                    let distanceFromTouch = fabsf(Float(touchLocation.y - anchorPoint.y));
                    let scrollResistance = distanceFromTouch / self.resistanceFactor;
                    
//                    UICollectionViewLayoutAttributes
                    if let item = spring.items.first {
                        var center = item.center
                        
                        center.y += (scrollDelta > 0) ?
                            min(scrollDelta, scrollDelta * CGFloat(scrollResistance))
                            : max(scrollDelta, scrollDelta * CGFloat(scrollResistance));
//                        center.y += (scrollDelta > 0) ? MIN(scrollDelta, scrollDelta * scrollResistance)
//                            : MAX(scrollDelta, scrollDelta * scrollResistance);
                        
                        item.center = center;
                        
                        self.animator?.updateItem(usingCurrentState: item)
                    }
                    
                    
                }

            }
            
        }
        
                
        return false
    }
    

}
