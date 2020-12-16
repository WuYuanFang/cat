//
//  XQSMCouponNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/4.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

/// 优惠券
struct XQSMCouponNetwork {
    
    /// 周边优惠劵(所有的)
    static func getMyAllOrder(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTMyCouponListResDtoModel> {
        return XQSMBaseNetwork.default.post("/api/Coupon/GetMyAllCoupon", parameters: parameters, resultType: XQSMNTMyCouponListResDtoModel.self)
    }
    
//    /// 获取红包（下单优惠劵）
//    static func getMyRedPackage(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTMyCouponListResDtoModel> {
//        return XQSMBaseNetwork.default.post("/api/Coupon/GetMyRedPackage", parameters: parameters, resultType: XQSMNTMyCouponListResDtoModel.self)
//    }
    
    
    /// 获取预约单可用的优惠券列表(洗护)
    static func showToOrderCanUseCoupon(_ parameters: XQSMNTShowToOrderCanUseCouponInputReqModel) -> Observable<XQSMNTMyCouponListResDtoModel> {
        return XQSMBaseNetwork.default.post("/api/Coupon/ShowToOrderCanUseCoupon", parameters: parameters, resultType: XQSMNTMyCouponListResDtoModel.self)
    }
    
    /// 寄养可用
    /// - Parameter money: 订单价格
    static func getFosterCoupon(_ parameters: XQSMNTGetFosterCouponReqModel) -> Observable<XQSMNTMyCouponListResDtoModel> {
        return XQSMBaseNetwork.default.get("/api/Coupon/GetFosterCoupon", parameters: parameters, resultType: XQSMNTMyCouponListResDtoModel.self)
    }
    
    
    /// 获取可以领取的优惠券列表
    static func getCvp(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTMyCouponGetcupResModel> {
        return XQSMBaseNetwork.default.post("/api/Coupon/GetCvp", parameters: parameters, resultType: XQSMNTMyCouponGetcupResModel.self)
    }
    
    /// 获取可以领取的优惠券列表
    static func addCvp(_ parameters: XQSMNTCouponAddCvpReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/Coupon/AddCvp", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
}



struct XQSMNTGetFosterCouponReqModel: XQSMNTBaseReqModelProtocol {
    /// 订单金额
    var money: Float = 0
}

struct XQSMNTShowToOrderCanUseCouponInputReqModel: XQSMNTBaseReqModelProtocol {
    
    /// PdList (Array[TinnyOrderProductInfo], optional): 商品列表 ,
    var PdList: [XQSMNTTinnyOrderProductInfoModel]?
    
    /// PackageId (integer, optional): 套餐Id
    var PackageId = 0
    
}

struct XQSMNTMyCouponListResDtoModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// 优惠劵列表 ,
    var CouponList: [XQSMNTCouponListModel]?
    
}


struct XQSMNTCouponListModel: HandyJSON {
    
    enum ModelType: Int, HandyJSONEnum {
        /// 商品
        case commodity = 0
        /// 洗护
        case service = 1
        /// 寄养
        case otherService = 2
    }
    
    /// CouponId (integer, optional): 优惠劵id ,
    var CouponId: Int = 0
    
    /// OId (integer, optional): 使用的订单Id ,
    var OId: Int = 0
    
    /// CouponSN (string, optional): 优惠劵编号 ,
    var CouponSN: String = ""
    
    /// CouponType (integer, optional): 优惠券类型（0商品，1预约，2寄养） ,
    var CouponType: XQSMNTCouponListModel.ModelType = .commodity
    
    /// Name (string, optional): 优惠劵名 ,
    var Name: String = ""
    
    /// UseTime (string, optional): 使用时间 ,
    var UseTime: String = ""
    
    /// Money (integer, optional): 金额 ,
    var Money: Int = 0
    
    /// ActivateTime (string, optional): 领取时间 ,
    var ActivateTime: String = ""
    
    /// CreateTime (string, optional): 创建时间 ,
    var CreateTime: String = ""
    
    /// UseStartTime (string, optional): 优惠劵使用开始时间 ,
    var UseStartTime: String = ""
    
    /// UseEndTime (string, optional): 优惠劵使用结束时间 ,
    var UseEndTime: String = ""
    
    /// StateInt (integer, optional, read only): 状态(1可用，0不可用) ,
    var StateInt: Int = 0
    
    /// StateStr (string, optional, read only): 状态中文描述
    var StateStr: String = ""
    
    /// Discount (integer, optional): 折扣(为0的情况下，说明是使用Money字段) 90为9折，85为85折 ,
    var Discount = 0
    
    /// OrderAmountLower (number, optional): 最小起用金额 ,
    var OrderAmountLower: Float = 0
    
    /// ExpireTime (string, optional): 过期时间 ,
    var ExpireTime = ""
    
    
}

//extension XQSMNTCouponListModel {
//
//    /// 根据日期判断是否可以使用
//    ///
//    /// - Returns: true 可以使用, false 不可使用
//    func xq_date_useable() -> Bool {
//
//        let fm = DateFormatter.init()
//        // 中国 8 时区
//        let tz = TimeZone.init(secondsFromGMT: 8)
//        fm.timeZone = tz
//
//        fm.dateFormat = "YYYY-MM-dd HH:mm:ss"
//
//        let endTimeInterval = fm.date(from: self.UseStartTime)?.timeIntervalSince1970 ?? 0
//        let nowTimeInterval = Date.init().timeIntervalSince1970
//
//        if endTimeInterval > nowTimeInterval {
//            return true
//        }
//
//        return false
//    }
//
//}

struct XQSMNTMyCouponGetcupResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// list (Array[CouponTypeInfo], optional),
    var list: [XQSMNTCouponTypeInfoModel]?
    
}


struct XQSMNTCouponTypeInfoModel: HandyJSON {
    
    /// CouponTypeId (integer, optional): 类型id ,
    var CouponTypeId = 0
    
    
    /// State (integer, optional): 状态 ,
    var State = 0
    
    /// Name (string, optional): 优惠劵类型名称 ,
    var Name: String = ""
    
    /// Money (integer, optional): 金额 ,
    var Money = 0
    
    /// Count (integer, optional): 数量 ,
    var Count = 0
    
    /// SendMode (integer, optional): 发放方式(0代表免费领取,1代表手动发放,2代表随活动发放) ,
    var SendMode = 0
    
    /// GetMode (integer, optional): 领取方式(当且仅当发放方式为免费领取时有效.0代表无限制,1代表限领一张,2代表每天限领一张) ,
    var GetMode = 0
    
    /// UseMode (integer, optional): 使用方式(0代表可以叠加,1代表不可以叠加) ,
    var UseMode = 0
    
    /// UserRankLower (integer, optional): 最低用户级别 ,
    var UserRankLower = 0
    
    /// OrderAmountLower (integer, optional): 订单总计下限 ,
    var OrderAmountLower = 0
    
    /// LimitCateId (integer, optional): 限制分类id ,
    var LimitCateId = 0
    
    /// LimitBrandId (integer, optional): 限制品牌id ,
    var LimitBrandId = 0
    
    /// LimitProduct (integer, optional): 限制商品 ,
    var LimitProduct = 0
    
    /// SendStartTime (string, optional): 发放开始时间 ,
    var SendStartTime: String = ""
    
    /// SendEndTime (string, optional): 发放结束时间 ,
    var SendEndTime: String = ""
    
    /// UseExpireTime (integer, optional): 使用过期时间 ,
    var UseExpireTime = 0
    
    /// UseStartTime (string, optional): 使用开始时间 ,
    var UseStartTime: String = ""
    
    /// UseEndTime (string, optional): 使用结束时间 ,
    var UseEndTime: String = ""
    
    /// CouponType (integer, optional): 优惠券类型 ,
    var CouponType: XQSMNTCouponListModel.ModelType = .commodity
    
    /// sendcount (integer, optional): 领取数量 ,
    var sendcount = 0
    
    /// Discount (integer, optional): 折扣(当Money=0时，此字段才有用。) 值为90时，为9折 值为70时，为7折
    var Discount = 0
    
    
}

struct XQSMNTCouponAddCvpReqModel: XQSMNTBaseReqModelProtocol {
    /// 要领取优惠券的id, XQSMNTCouponTypeInfoModel.CouponTypeId
    var couponId = 0
}
