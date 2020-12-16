//
//  XQDispatchQueueOnce.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/7.
//  Copyright © 2020 WXQ. All rights reserved.
//

import Foundation

/// 参考 https://www.jianshu.com/p/4cdf795eaea3
/// https://stackoverflow.com/questions/37886994/dispatch-once-after-the-swift-3-gcd-api-changes

/// 实现 dispatch once
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    typealias XQDispatchQueueBlock = () -> ()

    class func xq_once(file: String = #file, function: String = #function, line: Int = #line, block: XQDispatchQueueBlock?) {
        let token = file + ":" + function + ":" + String(line)
        xq_once(token: token, block: block)
    }

    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.

     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    class func xq_once(token: String, block: XQDispatchQueueBlock?) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }


        if _onceTracker.contains(token) {
            return
        }

        _onceTracker.append(token)
        block?()
    }
}

