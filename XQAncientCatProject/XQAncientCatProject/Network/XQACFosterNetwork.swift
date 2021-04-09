//
//  XQACFosterNetwork.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQACFosterNetwork {
    
    /// 获取店铺的猫舍
    static func getShopCatdormitory(_ parameters: XQACNTGetShopCatdormitoryReqModel) -> Observable<XQACNTCatdormitoryResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/GetShopCatdormitory", parameters: parameters, resultType: XQACNTCatdormitoryResModel.self)
    }
    
    /// 获取店铺的投食商品
    static func fosterCategoryShop(_ parameters: XQACNTGetShopCatdormitoryReqModel) -> Observable<XQACNTCategoryShopResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/FosterCategoryShop", parameters: parameters, resultType: XQACNTCategoryShopResModel.self)
    }
    
    /// 用户与店铺的距离，导航距离
    static func getShopZUserjl(_ parameters: XQACNTGetShopZUserjlReqModel) -> Observable<XQACNTFosterDistanceResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/GetShopZUserjl", parameters: parameters, resultType: XQACNTFosterDistanceResModel.self)
    }
    
    /// 添加寄养
    static func AddFoster(_ parameters: XQACNTAddFosterReqModel) -> Observable<XQACNTFosterFoPayResModel> {
        return XQSMBaseNetwork.default.post("/api/Foster/AddFoster", parameters: parameters, resultType: XQACNTFosterFoPayResModel.self)
    }
    
    /// 寄养计算价
    static func fosterCalculation(_ parameters: XQACNTAddFosterReqModel) -> Observable<XQACNTFosterCalculationResModel> {
        return XQSMBaseNetwork.default.post("/api/Foster/FosterCalculation", parameters: parameters, resultType: XQACNTFosterCalculationResModel.self)
    }
    
    /// 获取会员能打多少折
    static func getzq(_ parameters: XQSMNTBaseReqModel) -> Observable<XQACNTFosterUserzqResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/Getzq", parameters: parameters, resultType: XQACNTFosterUserzqResModel.self)
    }
    
    /// 寄养订单列表
    static func fosterList(_ parameters: XQSMNTBaseReqModel) -> Observable<XQACNTFosterListResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/FosterList", parameters: parameters, resultType: XQACNTFosterListResModel.self)
    }
    
    /// 寄养详情
    static func fosterDetails(_ fosterOrderId: Int) -> Observable<XQACNTFosterListDetailResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/FosterDetails/\(fosterOrderId)", resultType: XQACNTFosterListDetailResModel.self)
    }
    
    /// 寄养取消订单
    static func fosteState(_ oId: Int) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/FosteState/\(oId)", resultType: XQSMNTBaseResModel.self)
    }
    
    /// 寄养删除订单
    static func deleteOrder(_ oId: Int) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/Foster/DeleteOrder/\(oId)", resultType: XQSMNTBaseResModel.self)
    }
    
    /// 申请退款
    static func refundToOrder(_ parameters: XQSMNTOrderRefundToOrderReqModel) -> Observable<XQSMNTOrderRefundToOrderResModel> {
        
        //        OId:订单Id
        //        RefundPrice:退款总额
        //        Remark:备注
        //        3张图片可直接上传...
        
        var imgDataArr = [Data]()
        
        for item in parameters.imgArr ?? [] {
            if let data = item.jpegData(compressionQuality: 0.5) {
                imgDataArr.append(data)
            }
        }
        
        return XQSMBaseNetwork.default.uploadImage_1("/api/Foster/RefundToOrder", datas: imgDataArr, params: parameters, resultType: XQSMNTOrderRefundToOrderResModel.self)
    }
    
    
}


struct XQACNTGetShopCatdormitoryReqModel: XQSMNTBaseReqModelProtocol {
    var shopid = 0
    var StartTime:String?
    var day = "1"
}


struct XQACNTCatdormitoryResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// list (Array[GM_Catdormitory], optional),
    var list: [XQACNTGM_CatdormitoryModel]?
    
}

struct XQACNTGM_CatdormitoryModel: HandyJSON {
    
    /// Id (string, optional),
    var Id = ""
    
    /// ShopId (integer, optional),
    var ShopId = 0
    
    /// DormitoryName (string, optional),
    var DormitoryName = ""
    
    /// dayMoney (number, optional),
    var dayMoney: Float = 0
    
    /// Number (integer, optional),
    var Number = 0
    
    /// Logo (string, optional)
    var Logo = ""
    
}



struct XQACNTCategoryShopResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// list (Array[FosterCategoryShop], optional),
    var list: [XQACNTFosterCategoryShopModel]?
    
}

struct XQACNTFosterCategoryShopModel: HandyJSON {
    
    /// shoplist (Array[GM_FosterShop], optional),
    var shoplist: [XQACNTGM_FosterShopModel]?
    
    /// id (string, optional),
    var id = ""
    
    /// Name (string, optional),
    var Name = ""
    
    /// sort (integer, optional),
    var sort = 0
    
    /// ShopId (integer, optional)
    var ShopId = 0
    
}

struct XQACNTGM_FosterShopModel: HandyJSON {
    
    /// id (string, optional),
    var id = ""
    
    /// FosterCategoryId (string, optional), XQACNTFosterCategoryShopModel.id
    var FosterCategoryId = ""
    
    /// Name (string, optional),
    var Name = ""
    
    /// Money (number, optional),
    var Money: Float = 0
    
    /// ShopId (integer, optional)
    var ShopId = 0
    
}

struct XQACNTGetShopZUserjlReqModel: XQSMNTBaseReqModelProtocol {
    
    var shopid = 0
    
    /// 经度
    var x: Float = 0
    /// 纬度
    var y: Float = 0
    
}


struct XQACNTFosterDistanceResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    
    /// Distance (string, optional): 距离 ,
    var Distance = ""
    
    /// Money (number, optional): 金额
    var Money: Float = 0
    
}

struct XQACNTAddFosterReqModel: XQSMNTBaseReqModelProtocol {
    
    /// CatdormitoryId (string, optional): 猫舍ID ,
    var CatdormitoryId = ""
    
    /// PetsId (integer, optional): 宠物ID ,
    var PetsId = 0
    
    /// StartTime (string, optional): 预约时间 ,
    var StartTime = ""
    
    /// Day (integer, optional): 寄养天数 ,
    var Day = 0
    
    /// StoreId (integer, optional): 门店Id ,
    var StoreId = 0
    
    /// Remarks (string, optional): 备注 ,
    var Remarks = ""
    
    /// Mobile (string, optional): 手机号 ,
    var Mobile = ""
    
    /// Name (string, optional): 姓名 ,
    var Name = ""
    
    /// IsMeet (boolean, optional): 是否接送 ,
    var IsMeet = false
    
    /// IsFeed (boolean, optional): 是否投食 ,
    var IsFeed = false
    
    /// IsMonitoring (boolean, optional): 是否开启监控 ,
    var IsMonitoring = false
    
    /// 经度
    var x = ""
    
    /// 纬度
    var y = ""
    
    /// bbSterilization (boolean, optional): 绝育 ,
    var bbSterilization = false
    
    /// bbVaccination (boolean, optional): 注射疫苗 ,
    var bbVaccination = false
    
    /// bbDeworming (boolean, optional): 驱虫 ,
    var bbDeworming = false
    
    /// bbRabiesVaccine (boolean, optional): 狂犬疫苗 ,
    var bbRabiesVaccine = false
    
    /// idlist (Array[string], optional): 投食id集合 ,
    var idlist = [String]()
    
    /// Discount (boolean, optional): 使用会员折扣 ,
    var Discount = false
    
    /// CouponId (string, optional): 优惠券id
    var CouponId = ""
    
    /// ChoseTrueMan (boolean, optional): 实名认证优惠 ,
    var ChoseTrueMan = false
    
    
    
}


struct XQACNTFosterCalculationResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// dayMoney (number, optional): 猫舍多少钱一天 ,
    var dayMoney: Float = 0
    
    /// FeedingMoney (number, optional): 投食金额 ,
    var FeedingMoney: Float = 0
    
    /// PickMoney (number, optional): 接送费 ,
    var PickMoney: Float = 0
    
    /// Totalamount (number, optional): 总价 ,
    var Totalamount: Float = 0
    
}


struct XQACNTFosterUserzqResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// zq (number, optional): 折扣 ,
    var zq: Float = 0
}

struct XQACNTFosterFoPayResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// oid (integer, optional),
    var oid = 0
    
    /// osn (string, optional),
    var osn = ""
    
}

struct XQACNTFosterListResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// list (Array[GM_Foster], optional),
    var list: [XQACNTFosterGM_FosterModel]?
    
}

struct XQACNTFosterGM_FosterModel: HandyJSON {
    
    /// 订单状态
    /// State (integer, optional): 订单状态 1 已下单 2接送中 3待评论 0取消 4 已完成 5退款中 6退款成功 ,
    enum State: Int, HandyJSONEnum {
        /// 0取消 ,
        case cancel = 0
        /// 1 已下单
        case orderPlaced = 1
        /// 2接送中
        case onTheWay = 2
        /// 3 待评论
        case waitingComments = 3
        /// 4 已完成
        case done = 4
        /// 退款中
        case refundInProgress = 5
        /// 退款成功
        case successfulRefund = 6
        /// 寄养中
        case fostering = 7
        
    }
    
    func getStateDes() -> String {
        
        switch self.State {
        case .fostering:
            return "寄养中"
        
        case .orderPlaced:
            
            if self.PayType == 2 {
//                return "已下单"
                return "已预约"
            }else {
                return "待支付"
            }
            
        case .onTheWay:
            return "接送中"
            
        case .done:
//            return "已完成"
            return "服务结束"
            
        case .cancel:
            return "交易关闭"
            
        case .waitingComments:
            return "服务结束"
            
        case .refundInProgress:
            return "退款中"
            
        case .successfulRefund:
            return "退款成功"
        
        }
        
        return ""
    }
    
    /// Id (integer, optional): id ,
    var Id = 0
    
    /// UserId (integer, optional): 用户Id ,
    var UserId = 0
    
    /// OSN (string, optional): 订单号 ,
    var OSN = ""
    
    /// Name (string, optional): 姓名 ,
    var Name = ""
    
    /// Mobile (string, optional): 手机号 ,
    var Mobile = ""
    
    /// PetsId (integer, optional): 宠物ID ,
    var PetsId = 0
    
    /// StartTime (string, optional): 开始时间 ,
    var StartTime = ""
    
    /// EndTime (string, optional): 结束时间 ,
    var EndTime = ""
    
    /// StoreId (integer, optional): 门店Id ,
    var StoreId = 0
    
    /// Remarks (string, optional): 备注 ,
    var Remarks = ""
    
    /// SeveralNights (integer, optional): 几个晚上？ ,
    var SeveralNights = 0
    
    /// IsMeet (boolean, optional): 是否接 ,
    var IsMeet = false
    
    /// IsMeetsong (boolean, optional): 是否送 ,
    var IsMeetsong = false
    
    /// Amount (number, optional): 金额 ,
    var Amount: Float = 0
    
    /// PickMoney (number, optional): 接费 ,
    var PickMoney: Float = 0
    
    /// PickMoneysong (number, optional): 送费 ,
    var PickMoneysong: Float = 0
    
    /// x (string, optional): 接地址x ,
    var x = ""
    
    /// y (string, optional): 接地址y ,
    var y = ""
    
    /// xsong (string, optional): 送地址x ,
    var xsong = ""
    
    /// ysong (string, optional): 送地址y ,
    var ysong = ""
    
    /// PayType (integer, optional): 支付状态 1 没 2有 ,
    var PayType = 0
    
    /// PayTime (string, optional): 支付时间 ,
    var PayTime = ""
    
    /// PayMode (string, optional): 支付方式 aliPay、wechat ,
    var PayMode = ""
    
    /// State (integer, optional): 订单状态 1 已下单 2接送中 3已完成 4取消 ,
    var State: XQACNTFosterGM_FosterModel.State = .orderPlaced
    
    /// AddTIme (string, optional): 添加时间 ,
    var AddTIme = ""
    
    /// NickName (string, optional): 宠物昵称 ,
    var NickName = ""
    
    /// PetType (string, optional): 宠物类型（猫或狗） ,
    var PetType = ""
    
    /// Sex (string, optional): 性别 ,
    var Sex = ""
    
    /// PetVarieties (string, optional): 品种（比如田园犬之类的） ,
    var PetVarieties = ""
    
    /// logo (string, optional): 图片 ,
    var logo = ""
    
    /// Photo (string, optional): 图片 ,
    var Photo = ""
    
    /// bbSterilization (boolean, optional): 绝育 ,
    var bbSterilization = false
    
    /// bbVaccination (boolean, optional): 注射疫苗 ,
    var bbVaccination = false
    
    /// bbDeworming (boolean, optional): 驱虫 ,
    var bbDeworming = false
    
    /// bbRabiesVaccine (boolean, optional): 狂犬疫苗 ,
    var bbRabiesVaccine = false
    
    /// IsFeed (boolean, optional): 是否投食 ,
    var IsFeed = false
    
    /// FeedingList (string, optional): 投食列表 ,
    var FeedingList = ""
    
    var sumjmmoney: Float = 0
    
    var couponsId: Int = 0
    
    /// FeedingMoney (number, optional): 投食金额 ,
    var FeedingMoney: Float = 0
    
    /// IsMonitoring (boolean, optional): ,
    var IsMonitoring = false
    
    /// Totalamount (number, optional): 实付总金额 ,
    var Totalamount: Float = 0
    
    /// MemberDiscount (number, optional): 会员折扣 ,
    var MemberDiscount: Float = 0
    
    /// dayMoeny (number, optional): 多少钱一天？ ,
    var dayMoeny: Float = 0
    
    /// ShopName (string, optional): 店铺名称
    var ShopName = ""
    
    /// address (string, optional),
    var address = ""
    
    /// phone (string, optional),
    var phone = ""
    
    /// shopx (string, optional),
    var shopx = ""
    
    /// shopy (string, optional),
    var shopy = ""
    
    /// XOther (string, optional, read only): 店铺X轴(非百度地图) ,
    var XOther = ""
    
    /// YOther (string, optional, read only): 店铺Y轴(非百度地图)
    var YOther = ""
}


struct XQACNTFosterListDetailResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    
    /// Days (string, optional): 寄养结束剩下多少天【其他接口无视】 ,
    var Days: String?
    
    /// model (GM_Foster, optional),
    var model: XQACNTFosterGM_FosterModel?
    
}
