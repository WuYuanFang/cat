//
//  UIButton+Extension.swift
//  ScBaseLib_Example
//
//  Created by Beelin on 2019/5/14.
//  Copyright © 2019 CocoaPods. All rights reserved.
//  按钮增加点击范围

import Foundation
import UIKit

public enum ButtonMode {
    case Top
    case Bottom
    case Left
    case Right
}

private var hitTestInsetsKey: UInt = 0

// MARK: - 按钮扩充点击区域
public extension UIButton {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let b = bounds
        
        let areaForTouch: UIEdgeInsets! = hitTestInsets != nil
            ? hitTestInsets : .zero
        
        let expandRect = CGRect(x: b.origin.x - areaForTouch.left,
                                y: b.origin.y - areaForTouch.top,
                                width: b.size.width + areaForTouch.left + areaForTouch.right,
                                height: b.size.height + areaForTouch.top + areaForTouch.bottom)
        
        return expandRect.contains(point)
    }
    
    
    var hitTestInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, &hitTestInsetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &hitTestInsetsKey) as? UIEdgeInsets
        }
    }
    
    func locationAdjust(buttonMode: ButtonMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = titleLabel?.text?.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key: titleFont!]) ?? CGSize.zero
        var titleInsets: UIEdgeInsets
        
        
        var imageInsets: UIEdgeInsets
        switch (buttonMode){
        case .Top:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing)/2, left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing)/2,left: 0, bottom: 0, right: -titleSize.width)
        case .Bottom:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing)/2, left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing)/2, left: 0, bottom: 0, right: 0)
        case .Left:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .Right:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        }
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}

