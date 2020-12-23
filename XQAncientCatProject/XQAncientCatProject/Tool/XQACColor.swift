//
//  XQSMColor.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/7/29.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import UIKit

//MARK:------- 屏幕尺寸 --------
// 屏幕的宽
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
// 屏幕的高
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//顶部状态栏高度
let StatusBarHeight = UIApplication.shared.statusBarFrame.size.height
//底部安全区域
let FootSafeHeight = CGFloat((UIApplication.shared.statusBarFrame.size.height>20) ? 34.0 : 0.0)
//导航栏高度
let NavBarHeight:CGFloat = 44
//导航栏+状态栏高度
let TopSafeHeight = UIApplication.shared.statusBarFrame.size.height+44.0
//底部Tab高度
let TabBarHeight:CGFloat = 49

let system_screenWidth = UIScreen.main.bounds.width
let system_screenHeight = UIScreen.main.bounds.height
let system_screenSize = UIScreen.main.bounds.size

extension UIColor {
    
    open class var ac_mainColor: UIColor {
        get {
            return UIColor.init(hex: "#436C6F")
        }
    }
    
    /// 16进制转颜色
    public convenience init(hex hexStr: String) {
        //处理数值
        
        var cString = hexStr.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        
        let rString = (cString as NSString).substring(with: range)
        
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    /// rgb创建颜色
    public convenience init(xq_rgbWithR r: Float, g: Float, b: Float, alpha: Float = 1) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha))
    }
}


//let SM_MainColor = UIColor.init(red: 255.0/255.0, green: 214.0/255.0, blue: 51.0/255.0, alpha: 1)
//let SM_MainColor = UIColor.init(hex: "#FFDB03")


extension UIApplication {
    
    /// 获取当前window
    func xq_getWindow() -> UIWindow? {
        
        if #available(iOS 13.0, *) {
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return windowScene.windows.first
            }
            
        } else {
            return UIApplication.shared.keyWindow
        }
        
        return nil
    }
}



