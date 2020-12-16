//
//  XQCollectionViewEqualSpacingFlowLayout.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/8.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 等间距
class XQCollectionViewEqualSpacingFlowLayout: UICollectionViewFlowLayout {
    
//    - (instancetype)init{
//        self = [super init];
//        if (self){
//            self.scrollDirection = UICollectionViewScrollDirectionVertical;
//            self.minimumLineSpacing = 5;
//            self.minimumInteritemSpacing = 5;
//            self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//            _betweenOfCell = 5.0;
//            _cellType = XQEqualSpaceFlowLayoutAlignTypeLeft;
//        }
//        return self;
//    }
//
//    - (instancetype)initWthType:(XQEqualSpaceFlowLayoutAlignType)cellType {
//        self = [super init];
//        if (self){
//            self.scrollDirection = UICollectionViewScrollDirectionVertical;
//            self.minimumLineSpacing = 5;
//            self.minimumInteritemSpacing = 5;
//            self.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
//            _betweenOfCell = 5.0;
//            _cellType = cellType;
//        }
//        return self;
//    }

//    - (void)setBetweenOfCell:(CGFloat)betweenOfCell {
//        _betweenOfCell = betweenOfCell;
//        self.minimumInteritemSpacing = betweenOfCell;
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes_t = super.layoutAttributesForElements(in: rect)
        
        guard let layoutAttributes = layoutAttributes_t else {
            return layoutAttributes_t
        }
        
        var lastY: CGFloat = -1
        // 当前行
        var currentRowItems = [UICollectionViewLayoutAttributes]()
        
        var currentRowTotalWidth: CGFloat = 0
        
        for (index, item) in layoutAttributes.enumerated() {
            
            if index == 0 {
                lastY = item.frame.minY
                
                currentRowTotalWidth += item.frame.width
                currentRowItems.append(item)
                
                continue
            }
            
            if item.frame.minY != lastY {
                // 下一行了
                lastY = item.frame.minY
                
                self.xq_equalSpacingLayout(currentRowItems, currentRowTotalWidth: currentRowTotalWidth)
                
                currentRowTotalWidth = 0
                currentRowTotalWidth += item.frame.width
                currentRowItems.removeAll()
                currentRowItems.append(item)
                
                continue
            }
            
            currentRowTotalWidth += item.frame.width
            currentRowItems.append(item)
            
        }
        
        self.xq_equalSpacingLayout(currentRowItems, currentRowTotalWidth: currentRowTotalWidth)
        
        return layoutAttributes
    }
    
    private func xq_equalSpacingLayout(_ currentRowItems: [UICollectionViewLayoutAttributes], currentRowTotalWidth: CGFloat) {
        
        let totalSpacing = (self.collectionView?.frame.width ?? 0) - currentRowTotalWidth - (self.sectionInset.left + self.sectionInset.right)
        
        let spacing = totalSpacing/CGFloat(currentRowItems.count - 1)
        
        for (cIndex, cItem) in currentRowItems.enumerated() {
            if cIndex == 0 {
                continue
            }
            
            let lastItem = currentRowItems[cIndex - 1]
            cItem.frame.origin.x = lastItem.frame.maxX + spacing
        }
        
    }

//    - (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//        NSArray * layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
//        NSArray * layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
//        //用来临时存放一行的Cell数组
//        NSMutableArray * layoutAttributesTemp = [[NSMutableArray alloc]init];
//        for (NSUInteger index = 0; index < layoutAttributes.count ; index++) {
//
//            UICollectionViewLayoutAttributes *currentAttr = layoutAttributes[index]; // 当前cell的位置信息
//            UICollectionViewLayoutAttributes *previousAttr = index == 0 ? nil : layoutAttributes[index-1]; // 上一个cell 的位置信
//            UICollectionViewLayoutAttributes *nextAttr = index + 1 == layoutAttributes.count ?
//            nil : layoutAttributes[index + 1];//下一个cell 位置信息
//
//    //        NSLog(@"%@", NSStringFromCGRect(currentAttr.frame));
//
//            //加入临时数组
//            [layoutAttributesTemp addObject:currentAttr];
//            _sumWidth += currentAttr.frame.size.width;
//
//            CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
//            CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
//            CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
//            //如果当前cell是单独一行
//            if (currentY != previousY && currentY != nextY){
//                if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//                    [layoutAttributesTemp removeAllObjects];
//                    _sumWidth = 0.0;
//                }else if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
//                    [layoutAttributesTemp removeAllObjects];
//                    _sumWidth = 0.0;
//                }else{
//                    [self setCellFrameWith:layoutAttributesTemp];
//                }
//            }
//            //如果下一个不cell在本行，则开始调整Frame位置
//            else if( currentY != nextY) {
//                [self setCellFrameWith:layoutAttributesTemp];
//            }
//        }
//        return layoutAttributes;
//    }
//
//    -(void)setCellFrameWith:(NSMutableArray*)layoutAttributes{
//        CGFloat nowWidth = 0.0;
//        switch (_cellType) {
//            case XQEqualSpaceFlowLayoutAlignTypeLeft:
//                nowWidth = self.sectionInset.left;
//                for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
//                    CGRect nowFrame = attributes.frame;
//                    nowFrame.origin.x = nowWidth;
//                    attributes.frame = nowFrame;
//                    nowWidth += nowFrame.size.width + self.betweenOfCell;
//                }
//
//                break;
//            case XQEqualSpaceFlowLayoutAlignTypeCenter:
//                nowWidth = (self.collectionView.frame.size.width - _sumWidth - (layoutAttributes.count * _betweenOfCell)) / 2;
//                for (UICollectionViewLayoutAttributes * attributes in layoutAttributes) {
//                    CGRect nowFrame = attributes.frame;
//                    nowFrame.origin.x = nowWidth;
//                    attributes.frame = nowFrame;
//                    nowWidth += nowFrame.size.width + self.betweenOfCell;
//                }
//
//                break;
//
//            case XQEqualSpaceFlowLayoutAlignTypeRight:
//                nowWidth = self.collectionView.frame.size.width - self.sectionInset.right;
//                for (NSInteger index = layoutAttributes.count - 1 ; index >= 0 ; index-- ) {
//                    UICollectionViewLayoutAttributes * attributes = layoutAttributes[index];
//                    CGRect nowFrame = attributes.frame;
//                    nowFrame.origin.x = nowWidth - nowFrame.size.width;
//                    attributes.frame = nowFrame;
//                    nowWidth = nowWidth - nowFrame.size.width - _betweenOfCell;
//                }
//
//                break;
//
//        }
//
//        _sumWidth = 0.0;
//        [layoutAttributes removeAllObjects];
//    }

}
