//
//  XQPresentLocation.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/7.
//  Copyright © 2020 WXQ. All rights reserved.
//

import Foundation

import SVProgressHUD
import XQAlert

extension XQSMLocation {
    
    /// 显示选择地图弹框
    /// - Parameters:
    ///   - baiduShopLocation: 百度定位
    ///   - amapShopLocation: 高德定位
    ///   - shopName: 商店名称
    func showSelectMapAlert(_ baiduShopLocation: CLLocationCoordinate2D, amapShopLocation: CLLocationCoordinate2D, shopName: String) {
        
//        guard let x = CLLocationDegrees(self.model?.XOther ?? "0") else {
//            SVProgressHUD.showError(withStatus: "获取商店坐标错误")
//            return
//        }
//
//        guard let y = CLLocationDegrees(self.model?.YOther ?? "0") else {
//            SVProgressHUD.showError(withStatus: "获取商店坐标错误")
//            return
//        }
        
        print("跳转导航. 百度: \(baiduShopLocation).  高德: \(amapShopLocation)")
        
        // ["百度地图", "高德地图", "苹果地图"]
        XQSystemAlert.actionSheet(withTitle: "选择地图", message: nil, contentArr: ["百度地图", "高德地图"], cancelText: "取消", vc: UIApplication.shared.keyWindow?.rootViewController!, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            XQSMLocation.shared().location({ (location, locationNetworkState) in
                
                guard let location = location, let loc = location.location, let rgcData = location.rgcData else {
                    SVProgressHUD.showError(withStatus: "获取定位失败")
                    return
                }
                
                SVProgressHUD.dismiss()
                
                
                
                if index == 0 {
                    self.presentBaiduMap(baiduShopLocation, shopName: shopName, location: loc.coordinate, name: rgcData.locationDescribe)
                }else if index == 1 {
                    self.presentAMap(amapShopLocation, shopName: shopName, location: loc.coordinate, name: rgcData.locationDescribe)
                }else if index == 2 {
                    self.presentAppleMap(baiduShopLocation, shopName: shopName, location: loc.coordinate, name: rgcData.locationDescribe)
                }
                
            }) { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
            
        }, cancelCallback: nil)
        
    }
    
    /// 跳转到百度地图
    func presentBaiduMap(_ shopLocation: CLLocationCoordinate2D, shopName: String, location: CLLocationCoordinate2D, name: String) {
        
        let code = XQSMLocation.openBaiduDrivingRoute(location, name: name, cityName: "", cityCode: 0, endLocationCoordinate2D: shopLocation, endName: shopName, endCityName: "")
        if code != BMK_OPEN_NO_ERROR {
            SVProgressHUD.showError(withStatus: "打开百度地图出现错误")
        }
    }
    
    /// 跳转到高德地图
    func presentAMap(_ shopLocation: CLLocationCoordinate2D, shopName: String, location: CLLocationCoordinate2D, name: String) {
        
        if let url = XQSMLocation.openAMap(shopLocation, poiname: shopName) {
            
            /// 不能调用这个
            /// 调用改这个的话, 因为百度采用的经纬度不一样, 所以用要自己去转 x, y
            //        if let url = XQSMLocation.openAMap(location, name: name, endLocationCoordinate2D: locationCoordinate2D, endName: self.model?.ShopName ?? "") {
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { (result) in
                    if result {
                        print("成功")
                    }else {
                        print("失败")
                        SVProgressHUD.showError(withStatus: "跳转失败, 请手动打开")
                    }
                }
            }else {
                print("失败")
                SVProgressHUD.showError(withStatus: "跳转失败, 请手动打开")
            }
            
        }
    }
    
    /// 跳转到苹果地图
    func presentAppleMap(_ shopLocation: CLLocationCoordinate2D, shopName: String, location: CLLocationCoordinate2D, name: String) {
        
        // 这个 location 经纬度, 要转成苹果的
        let result = XQSMLocation.openAppleMap(location, name: name, endLocationCoordinate2D: shopLocation, endName: shopName)
        
        if !result {
            SVProgressHUD.showError(withStatus: "打开苹果地图失败")
        }
    }
}
