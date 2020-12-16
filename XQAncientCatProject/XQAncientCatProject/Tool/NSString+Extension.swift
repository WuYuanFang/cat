//
//  NSString+Extension.swift
//  XQAncientCatProject
//
//  Created by YCMacMini on 2020/5/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 手机号码脱敏
public extension String {
    func phoneDesensitization() -> String? {
        if self.count == 11 {
            let desensitization = self.prefix(3) + "****" + self.suffix(4)
            return String(desensitization)
        }
        return nil
    }
    
}

public extension String {
    
    /// 移除小数点后的0
    func xq_removeDecimalPointZero() -> String {
        let number = NSNumber.init(value: Float(self) ?? 0)
        return "\(number)"
    }
    
}

public extension Float {
    
    /// 移除小数点后的0
    func xq_removeDecimalPointZero() -> String {
        let number = NSNumber.init(value: self)
        return "\(number)"
    }
    
}

public extension Double {
    
    /// 移除小数点后的0
    func xq_removeDecimalPointZero() -> String {
        let number = NSNumber.init(value: self)
        return "\(number)"
    }
    
}

