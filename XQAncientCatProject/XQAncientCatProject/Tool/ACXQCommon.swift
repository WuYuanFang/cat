//
//  ACXQCommon.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import Foundation


/// 是否显示 v
/// - Returns: false 不显示, true 显示
func ac_isShowV() -> Bool {
    return UserDefaults.standard.bool(forKey: "ac_isShowV")
}

func ac_setIsShowV(_ isShow: Bool) {
    UserDefaults.standard.set(isShow, forKey: "ac_isShowV")
}
