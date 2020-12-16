//
//  XQSMImage.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/6.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit

enum XQSMImgSizeType {
    case origin
    case Thumb60
    case Thumb100
    case Thumb190
    case Thumb230
    case Thumb300
    case Thumb350
    case Thumb800
}

extension String {
    
    /// 获取原图 url
    func sm_getImgUrl() -> URL? {
        return self.sm_getThumbImgUrl(.origin)
    }
    
    /// 获取略缩图 60 x 60 url
    func sm_getImgUrl_60() -> URL? {
        return self.sm_getThumbImgUrl(.Thumb60)
    }
    
    
    /// 获取图片链接
    ///
    /// - Parameter size: 图片的大小
    func sm_getThumbImgUrl(_ sizeType: XQSMImgSizeType) -> URL? {
        
        /**
         
         1. 直接加载名称
         Api地址/upload/Api/show/thumb大小_大小/文件名
         大小有：60，100，190，230，300，350，800
         源文件地址：
         Api地址/upload/Api/show/source/文件名
         
         比如Api地址是：http://www.baidu.com/Api/
         
         图片名称是123.jpg
         
         60 x 60
         http://www.baidu.com/upload/Api/show/thumb60_60/123.jpg
         原图
         http://www.baidu.com/upload/Api/show/source/123.jpg
         
         
         2. 返回相对地址了, 拼 ip
         ip/相对地址
         
         */
        
        if self.count == 0 {
            return nil
        }
        
        let strArr = self.components(separatedBy: "/")
        if strArr.count > 1 {
            // ip/相对地址
            let baseUrl = XQSMBaseNetwork.default.baseUrl + self
            return URL.init(string: baseUrl)
        }
        
        
//        let baseUrl = XQSMBaseNetwork.default.baseUlr + "/upload/Api/show/"
        let baseUrl = XQSMBaseNetwork.default.baseUrl + "/upload/Product/show/"
        
        var imgSize = 60
        switch sizeType {
        
        case .origin:
            
            let urlStr = baseUrl + "source/" + self
            return URL.init(string: urlStr)
            
        case .Thumb60:
            break
        case .Thumb100:
            imgSize = 100
        case .Thumb190:
            imgSize = 190
        case .Thumb230:
            imgSize = 230
        case .Thumb300:
            imgSize = 300
        case .Thumb350:
            imgSize = 350
        case .Thumb800:
            imgSize = 800
        }
        
        let urlStr = baseUrl + "thumb" + String(imgSize) + "_" + String(imgSize) + "/" + self
        return URL.init(string: urlStr)
    }
    
}


extension UIImage {
    static func sm_placeholderImage() -> UIImage? {
        return UIImage.init(named: "xq_unknow")
    }
}




