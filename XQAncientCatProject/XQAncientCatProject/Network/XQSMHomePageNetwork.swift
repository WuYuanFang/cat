//
//  XQSMHomePageNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/9/6.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit
import RxSwift
import HandyJSON

struct XQSMHomePageNetwork {
    
    /// 首页轮播图
    static func getBanner() -> Observable<XQSMNTHomePageNewResModel> {
        return XQSMBaseNetwork.default.get("/api/HomePage/getBanner", resultType: XQSMNTHomePageNewResModel.self)
    }
    
    /// 超值抢购
    static func getRushProductList() -> Observable<XQSMNTGetProductResModel> {
        return XQSMBaseNetwork.default.get("/api/HomePage/getRushProductList", resultType: XQSMNTGetProductResModel.self)
    }
    
    /// 超值抢购之更多
    ///
    /// - Parameter parameters: 传 page 和 size 就行, 其他不用
    static func getIsHotProductList(_ parameters: XQSMNTproductBycateIdReqModel) -> Observable<XQSMNTGetProductResModel> {
        return XQSMBaseNetwork.default.post("/api/HomePage/getIsHotProductList", parameters: parameters, resultType: XQSMNTGetProductResModel.self)
    }
    
    /// 抢购活动
    static func getRobPromotion() -> Observable<XQSMNTGetRobPromotionResModel> {
        return XQSMBaseNetwork.default.get("/api/HomePage/getRobPromotion", resultType: XQSMNTGetRobPromotionResModel.self)
    }
    
    /// 热门推荐(暂时的, 后面繁育有了，估计要换)
    static func getTheHots() -> Observable<XQSMNTHPGetTheHotsResModel> {
        return XQSMBaseNetwork.default.get("/api/HomePage/GetTheHots", resultType: XQSMNTHPGetTheHotsResModel.self)
    }
    
    /// IOS是否显示VIP
    /// ErrMsg 为0时不显示,1为显示
    static func getIsShowV() -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/HomePage/GetIsVip", resultType: XQSMNTBaseResModel.self)
    }
    
}


struct XQSMNTHomePageNewResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// homePageNewModels (Array[HomePageNewModel], optional),
    var HomePageNewModels: [XQSMNTHomePageNewModel]?
}

struct XQSMNTHomePageNewModel: HandyJSON {
    /// adid (integer, optional): 广告id ,
    var Adid: Int = 0
    /// url (string, optional): 广告链接地址 ,
    var Url: String = ""
    /// image (string, optional): 广告图片 ,
    var Image: String = ""
    /// imageWithAddress (string, optional, read only): 广告图片，加地址 ,
    var ImageWithAddress: String = ""
    /// Pid (string, optional): 商品id ,
    var Pid: String = ""
    /// skudId (string, optional): skugid ,
    var SkudId: String = ""
    /// Type (string, optional): 标识 1：外部链接 2：商品详情 3：下单页
    var type: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<<
            self.type <-- "Type"
        
    }
    
}

struct XQSMNTGetRobPromotionReqModel: HandyJSON {
    /// 分类 id
    var cateid: Int = 0
    /// 第几页
    var pageNumber: Int = 0
    /// 分页大小
    var pageSize: Int = 10
}

struct XQSMNTGetRobPromotionResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// robPromotionList (Array[RobPromotion], optional),
    var robPromotionList: [XQSMNTRobPromotionModel]?
}


struct XQSMNTRobPromotionModel: HandyJSON {
    /// pmid (integer, optional): 抢购活动Id ,
    var pmid: Int = 0
    /// name (string, optional): 活动名称 ,
    var name: String = ""
    /// slogan (string, optional): 活动标语 ,
    var slogan: String = ""
    /// img (string, optional): 活动图片 ,
    var img: String = ""
    /// showImg (string, optional, read only): app显示用的图片地址 ,
    var showImg: String = ""
    /// pid (integer, optional): 商品id ,
    var pid: Int = 0
    /// skugid (integer, optional): 商品skugid ,
    var skugid: Int = 0
    /// starttime (string, optional): 开始时间 ,
    var starttime: String = ""
    /// endtime (string, optional): 结束时间
    var endtime: String = ""
    
}

struct XQSMNTHPGetTheHotsResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// XQSMNTHPGetTheHotsModel
    var HotList: [XQSMNTHPGetTheHotsModel]?
    
}

struct XQSMNTHPGetTheHotsModel: HandyJSON {
    
    /// "Path" : "ad_2008110840528495943.jpg",
    var Path = ""
    
    /// "PathWithAddress" : "\/upload\/adv\/ad_2008110840528495943.jpg"
    var PathWithAddress = ""
    
}


