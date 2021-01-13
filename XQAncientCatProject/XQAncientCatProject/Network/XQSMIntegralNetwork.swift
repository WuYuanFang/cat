//
//  XQSMIntegralNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/4.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

/// 积分商城相关
struct XQSMIntegralNetwork {
    
    /// 获取积分明细
    static func getMyCreditLog(_ parameters: XQSMNTIntegralGetMyCreditLogReqModel) -> Observable<XQSMNTIntegralGetMyCreditLogResModel> {
        return XQSMBaseNetwork.default.get("/api/Integral/GetMyCreditLog", parameters: parameters, resultType: XQSMNTIntegralGetMyCreditLogResModel.self)
    }
    
    /// 获取全部热门商品
    static func getHotProducts(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTIntegralResModel> {
        return XQSMBaseNetwork.default.get("/api/Integral/GetHotProducts", parameters: parameters, resultType: XQSMNTIntegralResModel.self)
    }
    
    /// 获取积分商城商品列表
    static func getIntegralProductInfo(_ parameters: XQSMNTIntegralReqModel) -> Observable<XQSMNTIntegralResModel> {
        return XQSMBaseNetwork.default.post("/api/Integral/GetIntegralProductInfo", parameters: parameters, resultType: XQSMNTIntegralResModel.self)
    }
    
    /// 获取积分商品详情
    static func getIntegralProductById(_ parameters: XQSMNTIntegralGetIntegralProductByIdReqModel) -> Observable<XQSMNTIntegralGetIntegralProductByIdResModel> {
        return XQSMBaseNetwork.default.get("/api/Integral/GetIntegralProductById", parameters: parameters, resultType: XQSMNTIntegralGetIntegralProductByIdResModel.self)
    }
    
    /// 积分兑换商品
    static func addIntegralProductOrder(_ parameters: XQSMNTIntegralDuihuanApiReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/Integral/AddIntegralProductOrder", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 查看积分兑换订单
    static func getUserIntegralProductOrderInfo(_ parameters: XQSMNTIntegralProductOrderReqModel) -> Observable<XQSMNTIntegralProductOrderResModel> {
        return XQSMBaseNetwork.default.post("/api/Integral/GetUserIntegralProductOrderInfo", parameters: parameters, resultType: XQSMNTIntegralProductOrderResModel.self)
    }
    
    /// 用户我的界面获取一个推荐的积分商品【返回也是一个list，不过只有一条记录】
    static func getTuijianIntegralProductInfo(_ parameters: XQSMNTIntegralReqModel) -> Observable<XQSMNTIntegralResModel> {
        return XQSMBaseNetwork.default.post("/api/Integral/GetTuijianIntegralProductInfo", parameters: parameters, resultType: XQSMNTIntegralResModel.self)
    }
    
    /// 查看积分订单物流信息
    static func getIntegralOrdersShipsn(_ parameters: XQSMNTOrderPluginInfoReqModel) -> Observable<XQSMNTIntegralOrderShipsnResModel> {
        return XQSMBaseNetwork.default.post("/api/Integral/GetIntegralOrdersShipsn", parameters: parameters, resultType: XQSMNTIntegralOrderShipsnResModel.self)
    }
    
    
    
}

struct XQSMNTIntegralGetIntegralProductByIdReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 商品id
    var pId = 0
}

struct XQSMNTIntegralReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 页码
    var pageNumber = 1
    /// 排序字段 1 从大到小， 0 从小到大
    var SortType = 1
}

struct XQSMNTIntegralResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// 在售积分商城列表
    var IntegralInfoList: [XQSMNTIntegralIntegralProductInfoModel]?
    
}

struct XQSMNTIntegralGetIntegralProductByIdResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// pdItem (IntegralProductInfo, optional): 商品信息 ,
    var pdItem: XQSMNTIntegralIntegralProductInfoModel?
    
}

/// 积分订单状态
enum XQSMNTIntegralProductOrderState: Int, HandyJSONEnum {
    case unknow = -1
    /// 全部
    case all = 0
    /// 等待发货
    case waitDeliverGoods = 1
    /// 等待收货
    case waitReceiveGoods = 2
    /// 完成收货
    case doneReceiveGoods = 3
}

struct XQSMNTIntegralProductOrderReqModel: XQSMNTBaseReqModelProtocol {
    
    /// OrderState (integer, optional): 订单状态 1待发货 2待收货 3已收货 ,
    var OrderState: XQSMNTIntegralProductOrderState = .unknow
}

struct XQSMNTIntegralProductOrderResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    var ErrMsg: String?
    
    ///  IntegralProductsOrdersInfo (Array[IntegralProductsOrdersInfo], optional): 用户积分订单列表 ,
    var IntegralProductsOrdersInfo: [XQSMNTIntegralProductsOrdersInfoModel]?
    
}

struct XQSMNTIntegralIntegralProductInfoModel: HandyJSON {
    
    /// PId (integer, optional): 商品Id ,
    var PId = 0
    
    /// Psn (string, optional): 商品编号 ,
    var Psn = ""
    
    /// ShopName (string, optional): 商品名称 ,
    var ShopName = ""
    
    /// ShopPrice (number, optional): 积分价格 ,
    var ShopPrice: Float = 0
    
    /// State (integer, optional): 商品状态 ,
    var State = 0
    
    /// Plv (integer, optional): 排序 ,
    var Plv = 0
    
    /// Weight (number, optional): 重量 ,
    var Weight: Float = 0
    
    /// ShowImg (string, optional): 主图 ,
    var ShowImg = ""
    
    /// ShowImgWithAddress (string, optional, read only): 主图（带地址） ,
    var ShowImgWithAddress = ""
    
    /// FuImgOne (string, optional): 附图1 ,
    var FuImgOne = ""
    
    /// FuImgOneWithAddress (string, optional, read only): 附图1（带地址） ,
    var FuImgOneWithAddress = ""
    
    /// FuImgTwo (string, optional): 附图2 ,
    var FuImgTwo = ""
    
    /// FuImgTwoWithAddress (string, optional, read only): 附图2（带地址） ,
    var FuImgTwoWithAddress = ""
    
    /// AddTime (string, optional): 添加时间 ,
    var AddTime = ""
    
    /// Description (string, optional): 备注
    var Description = ""
    
    /// IsHot (boolean, optional): 热门推荐
    var IsHot = false
    
}


struct XQSMNTIntegralProductsOrdersInfoModel: HandyJSON {
    
    /// OId (integer, optional): 订单iD ,
    var OId = 0
    
    /// PId (integer, optional): 商品Id ,
    var PId = 0
    
    /// Osn (string, optional): 订单编号 ,
    var Osn = ""
    
    /// OrderState (integer, optional): 订单类型 ,
    var OrderState = 0
    
    /// ProductName (string, optional): 商品名称 ,
    var ProductName = ""
    
    /// Psn (string, optional): 商品编号 ,
    var Psn = ""
    
    /// ShopPrice (integer, optional): 单个商品消耗积分 ,
    var ShopPrice = 0
    
    /// Weight (number, optional): 重量 ,
    var Weight: Float = 0
    
    /// ShowImg (string, optional): 主图 ,
    var ShowImg = ""
    
    /// Consignee (string, optional): 收货人 ,
    var Consignee = ""
    
    /// Mobile (string, optional): 手机 ,
    var Mobile = ""
    
    /// Address (string, optional): 收货地址 ,
    var Address = ""
    
    /// ZipCode (string, optional): 邮政编码 ,
    var ZipCode = ""
    
    /// Email (string, optional): 邮箱 ,
    var Email = ""
    
    /// Number (integer, optional): 数量 ,
    var Number = 0
    
    /// SumShopPrice (integer, optional): 总消耗积分
    var SumShopPrice = 0
    
}


struct XQSMNTIntegralDuihuanRecModel: XQSMNTBaseReqModelProtocol {
    /// 发送兑换商品, 才需要填这个
    
    
    /// oid (integer, optional): 订单iD ,
    var oid: Int = 0
    
    /// osn (string, optional): 订单编号 ,
    var osn: String = ""
    
    ///    psn (string, optional): 商品编号 ,
    var psn: String = ""
    ///    shopname (string, optional): 商品名称 ,
    var shopname: String = ""
    /// 商品名称
    var productname: String = ""
    ///        shopprice (integer, optional): 单个商品消耗积分 ,
    var shopprice: Int = 0
    ///    weight (number, optional): 重量 ,
    var weight: Float = 0
    ///    showimg (string, optional): 主图 ,
    var showimg: String = ""
    
    
    ///    fuimgone (string, optional): 附图 ,
    var fuimgone: String = ""
    ///    fuimgtwo (string, optional): 附图 ,
    var fuimgtwo: String = ""
    
    /// shipregionid (integer, optional): 配送区域id , 兑换商品要有该属性
    var shipregionid: Int = 0
    /// consignee (string, optional): 收货人 , 兑换商品要有该属性
    var consignee: String = ""
    /// address (string, optional): 收货地址 , 兑换商品要有该属性
    var address: String = ""
    /// zipcode (string, optional): 邮政编码 , 兑换商品要有该属性
    var zipcode: String = ""
    /// email (string, optional): 邮箱 , 兑换商品要有该属性
    var email: String = ""
    /// number (integer, optional): 数量, 兑换商品要有该属性
    var number: Float = 0
    /// mobile (string, optional): 手机 , 兑换商品要有该属性
    var mobile: String = ""
    
    ///    sumshopprice (integer, optional): 总消耗积分, 这个 XQSMNTIntegralProductOrderResModel 才有
    var sumshopprice: Int = 0
    ///    addtime (string, optional): 添加时间 ,
    var addtime: String = ""
    ///    description (string, optional): 备注
    var description: String = ""
    
    /// orderstate (integer, optional): 订单状态 1待发货 2待收货 3已收货 ,
    var orderstate: XQSMNTIntegralProductOrderState = .unknow
}

struct XQSMNTIntegralDuihuanApiReqModel: XQSMNTBaseReqModelProtocol {
    
    /// PId (integer, optional): 商品Id ,
    var PId = 0
    
    /// ShopAddressId (integer, optional): 收货地址Id ,
    var ShopAddressId: Int = 0
    
    /// Number (integer, optional): 数量 ,
    var Number: Int = 0
    
    /// Remark (string, optional): 备注
    var Remark: String = ""
    
}


struct XQSMNTIntegralOrderShipsnResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .succeed


    var ErrMsg: String?
    
    /// list (Array[ThePluging], optional): 物流信息类 ,
    var list: [XQSMNTOrderThePlugingModel]?
    
}

struct XQSMNTIntegralGetMyCreditLogReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 页码, 1 开始
    var pageIndex = 0
    
    /// 页数量
    var pageSize = 10
    
}

struct XQSMNTIntegralGetMyCreditLogResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// TotalCount (integer, optional): 总数量 ,
    var TotalCount = 0
    
    /// PageSize (integer, optional): 每页数量 ,
    var PageSize = 0
    
    /// PageIndex (integer, optional): 页码 ,
    var PageIndex = 0
    
    /// CreditLss (Array[CrediteDto], optional): 积分记录列表 ,
    var CreditLss = [XQSMNTIntegralCrediteModel]()

}

struct XQSMNTIntegralCrediteModel: HandyJSON {
    
    /// PayCredits (integer, optional): 积分 ,
    var PayCredits = 0
    
    /// Action (integer, optional): 动作值 ,
    var Action = 0
    
    /// ActionTime (string, optional): 触发时间 ,
    var ActionTime = ""
    
    /// ActionDes (string, optional): 变动描述
    var ActionDes = ""
    
}
