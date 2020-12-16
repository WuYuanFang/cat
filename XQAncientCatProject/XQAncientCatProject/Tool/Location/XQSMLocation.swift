//
//  XQSMLocation.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/31.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit





private let _xqsmlocation = XQSMLocation()

class XQSMLocation: NSObject, BMKLocationManagerDelegate, BMKLocationAuthDelegate, BMKSuggestionSearchDelegate, BMKGeneralDelegate, BMKPoiSearchDelegate, BMKCloudSearchDelegate {
    
    static func shared() -> XQSMLocation {
        return _xqsmlocation
    }

    static func register() {
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: "I8fa9gdVorchOWoDVVG2xH3SdF7xdZep", authDelegate: self.shared())
        self.shared().mapManager.start("I8fa9gdVorchOWoDVVG2xH3SdF7xdZep", generalDelegate: self.shared())
    }
    
    
    /// 上一次定位的数据
    var location: BMKLocation?

    private let mapManager = BMKMapManager()
    private let locationManager = BMKLocationManager()
    private let locationSearch = BMKSuggestionSearch()
    private let poiSearch = BMKPoiSearch()
    private let cloudSearch = BMKCloudSearch()

    typealias XQSMLocationCallback = () -> Void

    typealias XQSMLocationPOISearchCallback = (_ poiInfoArr: [BMKPoiInfo]) -> Void
    typealias XQSMLocationPOISearchErrorCallback = (_ error: BMKSearchErrorCode) -> Void

    typealias XQSMLocationCloudReverseGeoCodeResultCallback = (_ cloudReverseGeoCodeResult: BMKCloudReverseGeoCodeResult) -> Void
    typealias XQSMLocationCloudReverseGeoCodeErrorCallback = (_ errorCode: Int) -> Void

    private var poiCompleteCallback: XQSMLocationCallback?

    private var poiSearchCallback: XQSMLocationPOISearchCallback?
    private var poiErrorSearchCallback: XQSMLocationPOISearchErrorCallback?

    private var cloudReverseGeoCodeResultCallback: XQSMLocationCloudReverseGeoCodeResultCallback?
    private var cloudReverseGeoCodeErrorCallback: XQSMLocationCloudReverseGeoCodeErrorCallback?

    required override init() {
        super.init()
        self.initLocation()

        self.locationSearch.delegate = self
        self.poiSearch.delegate = self
    }

    private func initLocation() {
        // 初始化实例
//        self.locationManager = BMKLocationManager.init()
        // 设置delegate
        self.locationManager.delegate = self
        // 设置返回位置的坐标系类型
        self.locationManager.coordinateType = .BMK09LL
        // 设置距离过滤参数
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        // 设置预期精度参数
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 设置应用位置类型
        self.locationManager.activityType = .automotiveNavigation
        // 设置是否自动停止位置更新
        self.locationManager.pausesLocationUpdatesAutomatically = false
        // 设置是否允许后台定位
        // self.locationManager.allowsBackgroundLocationUpdates = YES;
        // 设置位置获取超时时间
        self.locationManager.locationTimeout = 15
        // 设置获取地址信息超时时间
        self.locationManager.reGeocodeTimeout = 15

//        self.cloudSearch
    }
    
    func location(_ succeed: ((_ location: BMKLocation?, _ state: BMKLocationNetworkState) -> Void)?, failure: ((_ error: Error) -> Void)?) {
        let result = self.locationManager.requestLocation(withReGeocode: true, withNetworkState: true) { location, networkState, error in

            if let error = error {
                failure?(error)
                return
            }

            self.location = location
            succeed?(location, networkState)
        }
        
        if !result {
            failure?(NSError.init(domain: "定位失败", code: -9999, userInfo: nil))
        }
    }

    func suggestionSearch() {
//        BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
//        option.cityname = @"北京";
//        option.keyword  = @"中关村";
        let option = BMKSuggestionSearchOption()
        option.cityname = "北京"
        option.keyword = "中关村"
        option.cityLimit = true
        if self.locationSearch.suggestionSearch(option) {
            print("发送检索成功")
        } else {
            print("发送检索失败")
        }
    }

    /// 城市检索
    ///
    /// - Parameters:
    ///   - city: 城市, 可填名称 or 城市编码
    ///   - keyword: 检索词
    func poiCitySearch(_ city: String,
                       keyword: String,
                       page: Int = 0,
                       pageSize: Int = 20,
                       callback: @escaping XQSMLocationPOISearchCallback,
                       errorCallback: @escaping XQSMLocationPOISearchErrorCallback,
                       complete: @escaping XQSMLocationCallback = {}
    ) {
        self.poiSearchCallback = callback
        self.poiErrorSearchCallback = errorCallback
        self.poiCompleteCallback = complete

        print(#function, "检索城市: \(city), keyword: \(keyword)")
        // 初始化请求参数类BMKCitySearchOption的实例
        let cityOption = BMKPOICitySearchOption()
        // 检索关键字，必选。举例：小吃
//        cityOption.keyword = "小吃";
        cityOption.keyword = keyword
        // 区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
//        cityOption.city = "北京市";
        cityOption.city = city
        // 检索分类，可选，与keyword字段组合进行检索，多个分类以","分隔。举例：美食,烧烤,酒店
//        cityOption.tags = @[@"美食",@"烧烤"];
        // 区域数据返回限制，可选，为YES时，仅返回city对应区域内数据
        cityOption.isCityLimit = true
        // POI检索结果详细程度
        // cityOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
        // 检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        // cityOption.filter = filter;
        // 分页页码，默认为0，0代表第一页，1代表第二页，以此类推
        cityOption.pageIndex = page
        // 单次召回POI数量，默认为10条记录，最大返回20条
        cityOption.pageSize = pageSize

        let flag = self.poiSearch.poiSearch(inCity: cityOption)
        if flag {
            print("POI城市内检索成功")
        } else {
            print("POI城市内检索失败")
            self.poiErrorSearchCallback?(BMK_SEARCH_PARAMETER_ERROR)
            self.releasePoiCallback()
        }
    }

    /// 周边检索
    func poiNearbySearch(_ coordinate: CLLocationCoordinate2D,
                         keywords: [String],
                         page: Int = 0,
                         pageSize: Int = 20,
                         callback: @escaping XQSMLocationPOISearchCallback,
                         errorCallback: @escaping XQSMLocationPOISearchErrorCallback,
                         complete: @escaping XQSMLocationCallback = {}
    ) {
        print(#function, "检索 经纬度 周边: \(coordinate), keyword: \(keywords)")

        self.poiSearchCallback = callback
        self.poiErrorSearchCallback = errorCallback
        self.poiCompleteCallback = complete

        // 初始化请求参数类BMKNearbySearchOption的实例
        let nearbyOption = BMKPOINearbySearchOption()
        // 检索关键字，必选
        nearbyOption.keywords = keywords
        // 检索中心点的经纬度，必选
//        nearbyOption.location = CLLocationCoordinate2DMake(40.051231, 116.282051);
        nearbyOption.location = coordinate
        // 检索半径，单位是米。
        nearbyOption.radius = 1000
        // 检索分类，可选。
//        nearbyOption.tags = ["美食"];
        // 是否严格限定召回结果在设置检索半径范围内。默认值为false。
        nearbyOption.isRadiusLimit = false
        // POI检索结果详细程度
        // nearbyOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
        // 检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        // nearbyOption.filter = filter;
        // 分页页码，默认为0，0代表第一页，1代表第二页，以此类推
        nearbyOption.pageIndex = page
        // 单次召回POI数量，默认为10条记录，最大返回20条。
        nearbyOption.pageSize = pageSize

        let flag = self.poiSearch.poiSearchNear(by: nearbyOption)
        if flag {
            print("POI周边检索成功")
        } else {
            print("POI周边检索失败")
            self.poiErrorSearchCallback?(BMK_SEARCH_PARAMETER_ERROR)
            self.releasePoiCallback()
        }
    }

    /// 详情云检索
    func detailSearch(with poi: String,
                      callback: @escaping XQSMLocationCloudReverseGeoCodeResultCallback,
                      errorCallback: @escaping XQSMLocationCloudReverseGeoCodeErrorCallback
    ) {
//            self.cloudReverseGeoCodeResultCallback = callback
//            self.cloudReverseGeoCodeErrorCallback = errorCallback
//            self.poiCompleteCallback = complete

        self.cloudSearch.delegate = self
        let cloudDetailSearchInfo = BMKCloudDetailSearchInfo()
        cloudDetailSearchInfo.uid = poi
        //
        let flag = self.cloudSearch.detailSearch(with: cloudDetailSearchInfo)
        if flag {
            print("逆地理编码发送成功, 等待云端返回结果")
        } else {
            print("逆地理编码发送失败")
//                self.cloudReverseGeoCodeErrorCallback?(Int(BMK_CLOUD_PARAM_ERROR.rawValue))
//                self.releaseCloudReverseGeoCodeCallback()
        }
    }

    /// 云端逆地理编码
    func cloudReverseGeoCodeSearch(with lat: CLLocationDegrees,
                                   long: CLLocationDegrees,
                                   callback: @escaping XQSMLocationCloudReverseGeoCodeResultCallback,
                                   errorCallback: @escaping XQSMLocationCloudReverseGeoCodeErrorCallback,
                                   complete: @escaping XQSMLocationCallback = {}
    ) {
        self.cloudReverseGeoCodeResultCallback = callback
        self.cloudReverseGeoCodeErrorCallback = errorCallback
        self.poiCompleteCallback = complete

        self.cloudSearch.delegate = self
        let reverseGeoCodeInfo = BMKCloudReverseGeoCodeSearchInfo()
        // LBS 云管理后台的 id
        reverseGeoCodeInfo.geoTableId = 1000006358
        reverseGeoCodeInfo.reverseGeoPoint = CLLocationCoordinate2DMake(lat, long)
        let flag = self.cloudSearch.cloudReverseGeoCodeSearch(reverseGeoCodeInfo)
        if flag {
            print("逆地理编码发送成功, 等待云端返回结果")
        } else {
            print("逆地理编码发送失败")
            self.cloudReverseGeoCodeErrorCallback?(Int(BMK_CLOUD_PARAM_ERROR.rawValue))
            self.releaseCloudReverseGeoCodeCallback()
        }
    }

    /// 释放逆地理编码callback
    private func releaseCloudReverseGeoCodeCallback() {
        self.poiCompleteCallback?()
        self.cloudReverseGeoCodeResultCallback = nil
        self.cloudReverseGeoCodeErrorCallback = nil
        self.poiCompleteCallback = nil
    }

    /// 释放 callback
    private func releasePoiCallback() {
        self.poiCompleteCallback?()
        self.poiCompleteCallback = nil
        self.poiSearchCallback = nil
        self.poiErrorSearchCallback = nil
    }

    /// 计算经纬度距离
    static func distanceBetweenOrderBy(_ lonLat1: XQLonLatPoint, lonLat2: XQLonLatPoint) -> Double {
        let oneLocation = CLLocation(latitude: lonLat1.lat, longitude: lonLat1.lon)
        let twoLocation = CLLocation(latitude: lonLat2.lat, longitude: lonLat2.lon)

        return oneLocation.distance(from: twoLocation)
    }

    // MARK: - BMKGeneralDelegate

    func onGetNetworkState(_ iError: Int32) {
        print(#function, iError)
    }

    func onGetPermissionState(_ iError: Int32) {
        print(#function, iError)
    }

    // MARK: - BMKLocationManagerDelegate

    // MARK: - BMKLocationAuthDelegate

    func onCheckPermissionState(_ iError: BMKLocationAuthErrorCode) {
        switch iError {
        case .unknown:
            print(#function, "定位权限未知")
        case .success:
            print(#function, "定位权限成功")
        case .networkFailed:
            print(#function, "定位权限没有网络")
        case .failed:
            print(#function, "定位权限失败")
        @unknown default:
            print(#function, "定位权限其他")
            break
        }
    }

    // MARK: - BMKSuggestionSearchDelegate

    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionSearchResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            print(#function, "检索成功", searcher ?? "没有search", result ?? "没有result")

            for model in result.suggestionList ?? [] {
                print(model.city ?? "没有城市", model.district ?? "没有区县", model.address ?? "没有地址", model.children ?? "没有子节点")
            }

        } else {
            print(#function, "检索失败", error)
        }
    }

    // MARK: - BMKPoiSearchDelegate

    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPOISearchResult!, errorCode: BMKSearchErrorCode) {
        if errorCode == BMK_SEARCH_NO_ERROR {
            print(#function, "检索成功", poiResult ?? "没有poiResult")

            self.poiSearchCallback?(poiResult.poiInfoList)

            for model in poiResult.poiInfoList ?? [] {
                print(model.province ?? "没有省份", model.city ?? "没有城市", model.area ?? "没有行政区域", model.address ?? "没有地址信息")
            }

        } else {
            print(#function, "检索失败", errorCode)
            self.poiErrorSearchCallback?(errorCode)
        }

        self.releasePoiCallback()
    }

    func onGetPoiDetailResult(_ searcher: BMKPoiSearch!, result poiDetailResult: BMKPOIDetailSearchResult!, errorCode: BMKSearchErrorCode) {
        print(#function)
    }

    func onGetPoiIndoorResult(_ searcher: BMKPoiSearch!, result poiIndoorResult: BMKPOIIndoorSearchResult!, errorCode: BMKSearchErrorCode) {
        print(#function)
    }

    // MARK: - BMKCloudSearchDelegate

    func onGetCloudPoiResult(_ poiResultList: [Any]!, searchType type: Int32, errorCode error: Int32) {
        print(#function)
    }

    func onGet(_ cloudRGCResult: BMKCloudReverseGeoCodeResult!, searchType type: BMKCloudSearchType, errorCode: Int) {
        print(#function)

        if errorCode == Int(BMK_CLOUD_NO_ERROR.rawValue) {
            // 成功
            self.cloudReverseGeoCodeResultCallback?(cloudRGCResult)
        } else {
            // 失败
            self.cloudReverseGeoCodeErrorCallback?(errorCode)
        }

        self.releaseCloudReverseGeoCodeCallback()
    }

    func onGetCloudPoiDetailResult(_ poiDetailResult: BMKCloudPOIInfo!, searchType type: Int32, errorCode error: Int32) {
        print(#function)
        print(poiDetailResult, type, error)
    }
}

/// 经纬度
struct XQLonLatPoint {
    /// 经度
    var lon: Double = 0

    /// 纬度
    var lat: Double = 0
}





extension XQSMLocation {
    /// 跳转到百度app导航
    /// - Parameter locationCoordinate2D: 自己位置
    /// - Parameter name: 起点位置名称
    /// - Parameter cityName: 起点城市名称
    /// - Parameter cityCode: 起点城市code
    /// - Parameter endLocationCoordinate2D: 终点位置
    /// - Parameter endName: 终点名称
    /// - Parameter endCityName: 终点城市名称
    static func openBaiduDrivingRoute(_ locationCoordinate2D: CLLocationCoordinate2D,
                                      name: String,
                                      cityName: String,
                                      cityCode: Int,

                                      endLocationCoordinate2D: CLLocationCoordinate2D,
                                      endName: String,
                                      endCityName: String
    ) -> BMKOpenErrorCode {
        let option = BMKOpenDrivingRouteOption()
//
        option.startPoint = BMKPlanNode()
        // 当前位置
        option.startPoint.pt = locationCoordinate2D
        option.startPoint.name = name
        option.startPoint.cityName = cityName
        option.startPoint.cityID = cityCode

        // 目的地
        option.endPoint = BMKPlanNode()
        option.endPoint.pt = endLocationCoordinate2D
        option.endPoint.cityName = endCityName
        option.endPoint.name = endName

        let code = BMKOpenRoute.openBaiduMapDrivingRoute(option)
        return code
    }

    /// 打开百度地图
    /// - Parameter locationCoordinate2D: 起点
    /// - Parameter endLocationCoordinate2D: 终点
    static func openBaiduMap(_ locationCoordinate2D: CLLocationCoordinate2D, name: String,
                             endLocationCoordinate2D: CLLocationCoordinate2D, endName: String
    ) -> URL? {
//        baidumap://map/direction?origin=%f,%f&destination=%f,%f&&mode=driving

//        baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:终点&mode=driving

        let mode = URLQueryItem(name: "mode", value: "driving")
        // 起点
        let origin = URLQueryItem(name: "origin", value: "\(locationCoordinate2D.latitude),\(locationCoordinate2D.longitude)|name:\(name)")
        // 终点
        let destination = URLQueryItem(name: "destination", value: "\(endLocationCoordinate2D.latitude),\(endLocationCoordinate2D.longitude)|name:\(endName)")

        var urlCom = URLComponents(string: "baidumap://map")

        urlCom?.queryItems = [mode, origin, destination]
        return urlCom?.url
    }

    /// 跳转到高德地图
    static func openAMap(_
        locationCoordinate2D: CLLocationCoordinate2D,
        poiname: String
    ) -> URL? {
//        "iosamap://viewMap?sourceApplication=app&poiname=123&lat=27&lon=114&dev=1"

        let sourceApp = URLQueryItem(name: "sourceApplication", value: "小古猫")
        // 地点名称
        let poiname = URLQueryItem(name: "poiname", value: poiname)
        // 坐标系参数dev=0,表示高德坐标（gcj02坐标），dev=1,表示wgs84坐标（GPS原始坐标）, 默认1
        let dev = URLQueryItem(name: "dev", value: "0")
        // 跳转回来的 scheme
        let backScheme = URLQueryItem(name: "backScheme", value: "beelpusMall")
        // 纬度
        let lat = URLQueryItem(name: "lat", value: String(locationCoordinate2D.latitude))
        // 经度
        let lon = URLQueryItem(name: "lon", value: String(locationCoordinate2D.longitude))

        var urlCom = URLComponents(string: "iosamap://viewMap")

        urlCom?.queryItems = [sourceApp, poiname, lat, lon, dev, backScheme]

        return urlCom?.url
    }

    /// 跳转到高德地图, 并导航
    static func openAMap_navi(_
        locationCoordinate2D: CLLocationCoordinate2D,
        poiname: String
    ) -> URL? {
        //        "iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2"

        let sourceApp = URLQueryItem(name: "sourceApplication", value: "小古猫")
        // 地点名称
        let poiname = URLQueryItem(name: "poiname", value: poiname)
        // 坐标系参数dev=0,表示高德坐标（gcj02坐标），dev=1,表示wgs84坐标（GPS原始坐标）, 默认1
        let dev = URLQueryItem(name: "dev", value: "0")
        // 导航结束后跳转回来的 scheme
        let backScheme = URLQueryItem(name: "backScheme", value: "beelpusMall")
        // 纬度
        let lat = URLQueryItem(name: "lat", value: String(locationCoordinate2D.latitude))
        // 经度
        let lon = URLQueryItem(name: "lon", value: String(locationCoordinate2D.longitude))
        // 地图类型? 还是导航类型? 以后再看吧
        let style = URLQueryItem(name: "style", value: "2")

        var urlCom = URLComponents(string: "iosamap://navi")

        urlCom?.queryItems = [sourceApp, poiname, lat, lon, dev, backScheme, style]

        return urlCom?.url
    }

    /// 跳转到高德地图, web 页面, 如果有 app 则会自动跳转回 app
    static func openAMap_uri(_
        locationCoordinate2D: CLLocationCoordinate2D,
        poiname: String
    ) -> URL? {
//            https://uri.amap.com/marker?position=121.287689,31.234527&name=park&src=mypage&coordinate=gaode&callnative=0

        let src = URLQueryItem(name: "src", value: "小古猫")
        // 是否尝试调起高德地图APP并在APP中查看，0表示不调起，1表示调起, 默认值为0
        let callnative = URLQueryItem(name: "callnative", value: "1")
        // 坐标系参数coordinate=gaode,表示高德坐标（gcj02坐标），coordinate=wgs84,表示wgs84坐标（GPS原始坐标）, 默认gcj02
        let coordinate = URLQueryItem(name: "coordinate", value: "gaode")
        // 地点名称
        let name = URLQueryItem(name: "name", value: poiname)
        // 经纬度
        let position = URLQueryItem(name: "position", value: "\(locationCoordinate2D.longitude),\(locationCoordinate2D.latitude)")

        var urlCom = URLComponents(string: "https://uri.amap.com/marker")

        urlCom?.queryItems = [src, callnative, coordinate, name, position]

        return urlCom?.url
    }

    /// 跳转到高德地图
    static func openAMap(_ locationCoordinate2D: CLLocationCoordinate2D,
                         name: String,
                         endLocationCoordinate2D: CLLocationCoordinate2D,
                         endName: String
    ) -> URL? {
        //        iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=%f&slon=%f&sname=%@&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&m=0&t=0
        let sourceApp = URLQueryItem(name: "sourceApplication", value: "小古猫")

        let sid = URLQueryItem(name: "sid", value: "BGVIS1")
        // 地点名称
        let sname = URLQueryItem(name: "sname", value: name)
        // 纬度
        let slat = URLQueryItem(name: "slat", value: String(locationCoordinate2D.latitude))
        // 经度
        let slon = URLQueryItem(name: "slon", value: String(locationCoordinate2D.longitude))

        let did = URLQueryItem(name: "did", value: "BGVIS2")
        // 地点名称
        let dname = URLQueryItem(name: "sname", value: endName)
        // 纬度
        let dlat = URLQueryItem(name: "dlat", value: String(endLocationCoordinate2D.latitude))
        // 经度
        let dlon = URLQueryItem(name: "dlon", value: String(endLocationCoordinate2D.longitude))

        var urlCom = URLComponents(string: "iosamap://path")

        urlCom?.queryItems = [sourceApp, sid, sname, slat, slon, did, dname, dlat, dlon]
        return urlCom?.url
    }

    /// 打开QQ地图
    /// - Parameter locationCoordinate2D: 起点
    /// - Parameter endLocationCoordinate2D: 终点
    static func openQQMap(_ locationCoordinate2D: CLLocationCoordinate2D,
                          endLocationCoordinate2D: CLLocationCoordinate2D
    ) -> URL? {
//        qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1

        let type = URLQueryItem(name: "type", value: "drive")
        // 起点
        let fromcoord = URLQueryItem(name: "fromcoord", value: "\(locationCoordinate2D.latitude),\(locationCoordinate2D.longitude)")
        // 终点
        let tocoord = URLQueryItem(name: "tocoord", value: "\(endLocationCoordinate2D.latitude),\(endLocationCoordinate2D.longitude)")

        let policy = URLQueryItem(name: "policy", value: "1")

        var urlCom = URLComponents(string: "qqmap://map/routeplan")

        urlCom?.queryItems = [type, fromcoord, tocoord, policy]

        return urlCom?.url
    }

    /// 打开Google地图
    /// - Parameter locationCoordinate2D: 起点
    /// - Parameter endLocationCoordinate2D: 终点
    static func googleMap(_ locationCoordinate2D: CLLocationCoordinate2D,
                          endLocationCoordinate2D: CLLocationCoordinate2D
    ) -> URL? {
//        comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit

        // 起点
        let saddr = URLQueryItem(name: "saddr", value: String(format: "%.8f,%.8f", locationCoordinate2D.latitude, locationCoordinate2D.longitude))
        // 终点
        let daddr = URLQueryItem(name: "daddr", value: String(format: "%.8f,%.8f", endLocationCoordinate2D.latitude, endLocationCoordinate2D.longitude))

        let directionsmode = URLQueryItem(name: "directionsmode", value: "transit")

        var urlCom = URLComponents(string: "comgooglemaps://")

        urlCom?.queryItems = [saddr, daddr, directionsmode]

        return urlCom?.url
    }

    /// 打开苹果地图
    /// - Parameter locationCoordinate2D: 起点
    /// - Parameter name: 起点名
    /// - Parameter endLocationCoordinate2D: 终点
    /// - Parameter endName: 终点名
    static func openAppleMap(_ locationCoordinate2D: CLLocationCoordinate2D,
                             name: String,
                             endLocationCoordinate2D: CLLocationCoordinate2D,
                             endName: String
    ) -> Bool {
        // 当前位置
        let cLocation = MKMapItem(placemark: MKPlacemark(coordinate: locationCoordinate2D))
        cLocation.name = name

        // 终点
        let eLocation = MKMapItem(placemark: MKPlacemark(coordinate: endLocationCoordinate2D))
        eLocation.name = endName

//                    NSArray *items = [NSArrayarrayWithObjects:currentLocation, toLocation,nil];

        let options = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
            MKLaunchOptionsMapTypeKey: [MKMapType.standard],
            MKLaunchOptionsShowsTrafficKey: true,
        ] as [String: Any]

        // 打开苹果自身地图应用
        return MKMapItem.openMaps(with: [cLocation, eLocation], launchOptions: options)
    }

    /// 百度转高德位置
    /// - Parameter location: 百度定位的位置
    static func baiduToGaode(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let x_pi = 3.14159265358979324 * 3000.0 / 180.0

        let x = location.longitude - 0.0065
        let y = location.latitude - 0.006
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) - 0.000003 * cos(x * x_pi)

        let endLat = z * sin(theta)
        let endLon = z * cos(theta)

        let coordinate = CLLocationCoordinate2D(latitude: endLat, longitude: endLon)
        return coordinate
    }

    /// 百度转高德位置
    /// - Parameter location: 百度定位的位置
    static func baiduToGaode2(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        BMKLocationManager.bmkLocationCoordinateConvert(location, srcType: .GCJ02, desType: .GCJ02)

        let x_pi = 3.14159265358979324 * 3000.0 / 180.0

        let x = location.longitude
        let y = location.latitude
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi)

        let endLat = z * sin(theta) + 0.006
        let endLon = z * cos(theta) + 0.0065

        let coordinate = CLLocationCoordinate2D(latitude: endLat, longitude: endLon)

        return coordinate
    }

    /// 高德转百度位置
    /// - Parameter location: 高德定位的位置
    static func gaodeToBaidu(_ location: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let x_pi = 3.14159265358979324 * 3000.0 / 180.0

        let x = location.longitude
        let y = location.latitude

        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi)
        let theta = atan2(y, x) + 0.000003 * cos(x * x_pi)

        let endLat = z * sin(theta) + 0.006
        let endLon = z * cos(theta) + 0.0065

        let coordinate = CLLocationCoordinate2D(latitude: endLat, longitude: endLon)
        return coordinate
    }

//    +(CLLocationCoordinate2D) bd_decrypt:(double)bd_lat bd_lon:(double)bd_lon
//    {
//        double x = bd_lon - 0.0065, y = bd_lat - 0.006;
//        double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//        double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta));
//        return coordinate;
//    }

//    +(CLLocationCoordinate2D) bd_decrypt:(double)gg_lat gg_lon:(double)gg_lon
//    {
//        double x = gg_lon, y = gg_lat;
//        double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
//        double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
//
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(z * sin(theta)+0.006, z * cos(theta)+0.0065);
//        return coordinate;
//    }

    /// 原生反地理编码
    func reverseGeocodeLocation(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()

        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(loc) { placemarks, error in

            if let error = error {
                print("反地理编码错误: ", error)
                return
            }

            guard let placemarks = placemarks, let pf = placemarks.first else {
                print("反地理编码信息并没有")
                return
            }

            print(placemarks, pf)
        }
        
        //        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //            if(error || placemarks.count == 0){
        //                NSLog(@"error = %@",error);
        //            }else{
        //                CLPlacemark* placemark = placemarks.firstObject;
        //                //City 是获取城市的key
        //                NSString * city = [[placemark addressDictionary] objectForKey:@"City"];
        //                //SubLocality 是获取详细地址的key
        //                NSString * country = [[placemark addressDictionary] objectForKey:@"SubLocality"];
        //                //State 是获取省的key
        //                NSString * provice = [[placemark addressDictionary] objectForKey:@"State"];
        //                NSString * moreAddress = [[placemark addressDictionary] objectForKey:@"FormattedAddressLines"][0];
        //                NSLog(@"city：%@,country：%@,provice：%@,moreAddress：%@",city,country,provice,moreAddress);
        //
        //            }
        //        }];
    }
}
