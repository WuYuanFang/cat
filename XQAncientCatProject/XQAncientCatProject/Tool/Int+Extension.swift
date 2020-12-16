//
//  Int+Extension.swift
//  ScBaseLib
//
//  Created by Beelin on 2019/1/17.
//  用来计算屏幕倍数

import UIKit
import Foundation

/// 设计图基础的宽度(4.7英寸的宽度)
private let kDesignBasedOnScreenWidth = 375.0

public extension Int {
    var autoLayoutValue : CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGFloat(self) * (screenWidth / CGFloat(kDesignBasedOnScreenWidth))
    }
}

public extension CGFloat {
    var autoLayoutValue : CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return self * (screenWidth / CGFloat(kDesignBasedOnScreenWidth))
    }
}

public extension Double {
    var autoLayoutValue : CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return CGFloat(self) * (CGFloat(screenWidth) / CGFloat(kDesignBasedOnScreenWidth))
    }
}
