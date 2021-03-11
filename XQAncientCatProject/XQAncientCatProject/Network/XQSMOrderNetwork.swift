//
//  XQSMOrderNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/4.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

/// 订单
struct XQSMOrderNetwork {
    
    
    /// 查询所有的订单
    static func getMyAllOrder(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTOrderListResDtoModel> {
        return XQSMBaseNetwork.default.post("/api/Order/GetMyAllOrder", parameters: parameters, resultType: XQSMNTOrderListResDtoModel.self)
    }
    
    /// 查询未支付的订单
    static func getNoPayOrder(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTOrderListResDtoModel> {
        return XQSMBaseNetwork.default.post("/api/Order/GetNoPayOrder", parameters: parameters, resultType: XQSMNTOrderListResDtoModel.self)
    }
    
    /// 查询待收货的订单
    static func getWaitReceiveOrder(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTOrderListResDtoModel> {
        return XQSMBaseNetwork.default.post("/api/Order/GetWaitReceiveOrder", parameters: parameters, resultType: XQSMNTOrderListResDtoModel.self)
    }
    
    /// 获取我的订单（根据状态来查)
    /// 上面这三个不用了, 一般用这个
    static func getMyOrder(_ parameters: XQSMNTGetOrderListReqModel) -> Observable<XQSMNTOrderListResDtoModel> {
        return XQSMBaseNetwork.default.post("/api/Order/GetMyOrder", parameters: parameters, resultType: XQSMNTOrderListResDtoModel.self)
    }
    
    /// 获取id对应的订单
    static func getOrderById(_ oId: Int) -> Observable<XQSMNTOrderGetOrderByIdResModel> {
        return XQSMBaseNetwork.default.get("/api/Order/GetOrderById/\(oId)", resultType: XQSMNTOrderGetOrderByIdResModel.self)
    }
    
    /// 提交订单(这是商城的提交订单)
    static func submitOrder(_ parameters: XQSMNTOrderReqModel) -> Observable<XQSMNTSubmitResultResModel> {
        return XQSMBaseNetwork.default.post("/api/Order/SubmitOrder", parameters: parameters, resultType: XQSMNTSubmitResultResModel.self)
    }
    
    /// 取消订单
    static func cancelOrder(_ parameters: XQSMNTCancleToOrderReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/Order/CancelOrder", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 确定收货
    static func sureReceiveProduct(_ parameters: XQSMNTSureReceiveProductReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/Order/SureReceiveProduct", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 查看物流信息
    static func getShipPluginInfo(_ parameters: XQSMNTOrderPluginInfoReqModel) -> Observable<XQSMNTOrderThePlugingResModel> {
        return XQSMBaseNetwork.default.post("/api/Order/GetShipPluginInfo", parameters: parameters, resultType: XQSMNTOrderThePlugingResModel.self)
    }
    
    /// 查询各订单状态订单数量
    static func getMyAllOrderNumber(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTOrderStatusNumberResModel> {
        return XQSMBaseNetwork.default.post("/api/Order/GetMyAllOrderNumber", parameters: parameters, resultType: XQSMNTOrderStatusNumberResModel.self)
    }
    
    /// 评价订单商品
    static func addReview(_ parameters: XQSMNTOrderAddReviewReqModel) -> Observable<XQSMNTUploadPhotoAndChangeNickNameResModel> {
        
        var dic = [String:Data]()
        for (index, item) in parameters.xq_Imgs.enumerated() {
            if let data = item.jpegData(compressionQuality: 0.5) {
                dic["Photo\(index + 1)"] = data
            }
        }
        
        return XQSMBaseNetwork.default.uploadImage_2("/api/Order/AddReview", dataDic: dic, params: parameters, resultType: XQSMNTUploadPhotoAndChangeNickNameResModel.self)
        
//        return XQSMBaseNetwork.default.uploadImage_1("/api/Order/AddReview", datas: datas, params: parameters, resultType: XQSMNTUploadPhotoAndChangeNickNameResModel.self)
    }
    
    /// 获取我的评价
    static func getMyReview(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTOrderGetMyReviewResModel> {
        return XQSMBaseNetwork.default.get("/api/Order/GetMyReview", parameters: parameters, resultType: XQSMNTOrderGetMyReviewResModel.self)
    }
    
    /// 删除我的评价
    static func deleteMyReview(_ rId: Int) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/Order/DeleteMyReview/\(rId)", resultType: XQSMNTBaseResModel.self)
    }
    
    /// 申请退款（只在订单未发货时，能申请）
    /// 确认中(40), 已确认(60), 备货中(80) 可以调用该接口
    ///
    static func requestRefund(_ parameters: XQSMNTOrderRequestRefundReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/Order/RequestRefund", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 商城申请退货退款
    /// 已发货(100), 已收货(120) 可以调用该接口
    ///
    static func aroundShopRefundOrder(_ parameters: XQSMNTOrderRequestRefundReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/Order/AroundShopRefundOrder", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 删除订单(取消/完成/售后完成 状态才可删)
    static func deleteOrder(_ rId: Int) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/Order/DeleteOrder/\(rId)", resultType: XQSMNTBaseResModel.self)
    }
    
    
}

/// 订单状态
enum XQSMNTGetOrderListReqModelState: Int, HandyJSONEnum {
    case unknow = -99
    /// 获取所有
    case all = -1
    /// 等待付款
    case waitPay = 20
    /// 确认中
    case inInspection = 40
    /// 已确认
    case confirmed = 60
    /// 备货中
    case inStock = 80
    /// 已发货
    case delivered = 100
    /// 已收货
    case receivedGoods = 120
    /// 锁定
    case lock = 140
    /// 取消
    case cancel = 160
    /// 退款中
    case refund = 180
    /// 退款完成
    case refundDone = 200
    /// 退款失败
    case refundFail = 210
    
    /// 已完成
    case done = 230
    
    
    /// 以下是请求状态, 就是发送请求的
    /// State (integer, optional): 状态 -1：查全部 20:等待付款 50:待发货 100:待收货 120:待评价 220:退款/售后
    
    /// 待发货
    case toBeDelivered = 50
    /// 退款/售后
    case refundAndAfterSale = 220
    
}

struct XQSMNTGetOrderListReqModel: XQSMNTBaseReqModelProtocol {
    
    /// State (integer, optional): 状态 -1：查全部 20:等待付款 50:待发货 100:待收货 120:待评价 220:退款/售后
    var State: XQSMNTGetOrderListReqModelState = .unknow
}

struct XQSMNTOrderGetOrderByIdResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed

    var ErrMsg: String?
    
    /// OrderList (OrderBaseInfoDto, optional): 订单 ,
    var OrderList: XQSMNTOrderBaseInfoDtoModel?
}


struct XQSMNTOrderListResDtoModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// 订单列表 ,
    var OrderList: [XQSMNTOrderBaseInfoDtoModel]?
    
}

/// 订单列表
struct XQSMNTOrderBaseInfoDtoModel: HandyJSON {
    /// Oid (integer, optional): 订单id ,
    var Oid: Int = 0
    /// OSN (string, optional): 订单编号 ,
    var OSN: String = ""
    /// OrderState (integer, optional): 订单状态 ,
    var OrderState: XQSMNTGetOrderListReqModelState = .unknow
    /// OrderStateStr (string, optional, read only): 订单状态（中文） ,
    var OrderStateStr: String = ""
    /// SurplusMoney (number, optional): 总金额 ,
    var SurplusMoney: Float = 0
    /// IsReview (integer, optional): 是否评价 ,
    var IsReview: Int = 0
    /// AddTime (string, optional): 添加时间 ,
    var AddTime: String = ""
    /// ShipSN (string, optional): 配送单号 ,
    var ShipSN: String = ""
    /// ShipSystemName (string, optional): 配送方式系统名 ,
    var ShipSystemName: String = ""
    /// ShipFriendName (string, optional): 配送方式昵称 ,
    var ShipFriendName: String = ""
    /// ShipTime (string, optional): 配送时间 ,
    var ShipTime: String = ""
    /// PayCreditCount (integer, optional): 支付积分数量 ,
    var PayCreditCount: Int = 0
    /// Consignee (string, optional): 收货人 ,
    var Consignee: String = ""
    /// Mobile (string, optional): 手机号 ,
    var Mobile: String = ""
    /// Address (string, optional): 地址 ,
    var Address: String = ""
    /// ProductList (Array[OrderProductDto], optional): 产品列表
    var ProductList: [XQSMNTOrderProductDtoModel]?
    
    /// 备注
    var BuyerRemark = ""
    
    /// RankDiscount (number, optional): 等级折扣,值为9就是9折 ,
    var RankDiscount: Float = 0
    
    /// RankDiscountPrice (number, optional): 等级折扣抵扣金额 ,
    var RankDiscountPrice: Float = 0
    
    /// PayTime (string, optional): 支付时间 ,
    var PayTime: String = ""
    /// PaySystemName (string, optional): 支付方式 值有： "支付宝支付" "微信支付" ,
    var PaySystemName: String = ""
    
    
    func getStateDes() -> String {
        switch self.OrderState {
        case .waitPay:
            return "等待付款"
        case .inInspection:
            return "确认中"
        case .toBeDelivered:
            return "待发货"
        case .confirmed:
            return "已确认"
        case .inStock:
            return "备货中"
        case .delivered:
            return "待收货"
        case .receivedGoods:
            return "已收货"
        case .cancel:
            return "交易关闭"
        case .refund:
            return "退款中"
        case .refundDone:
            return "交易关闭"
        case .refundFail:
            return "退款失败"
        case .refundAndAfterSale:
            return "交易关闭"
        case .done:
            return "交易成功"
        default:
            return self.OrderStateStr
        }
    }
}

/// 产品列表
struct XQSMNTOrderProductDtoModel: HandyJSON {
    
    /// RecordId (integer, optional): 记录id ,
    var RecordId: Int = 0
    /// Pid (integer, optional): 商品id ,
    var Pid: Int = 0
    /// Name (string, optional): 商品名称 ,
    var Name: String = ""
    /// ShowImg (string, optional): 商品展示图片 ,
    var ShowImg: String = ""
    /// DiscountPrice (number, optional): 商品折扣价格 ,
    var DiscountPrice: Float = 0
    /// IsReview (integer, optional): 是否评价(0代表未评价，1代表已评价) ,
    var IsReview: Int = 0
    /// BuyCount (integer, optional): 商品购买数量 ,
    var BuyCount: Int = 0
    /// Type (integer, optional): 商品类型(0为普遍商品,1为普通商品赠品,2为套装商品赠品,3为套装商品,4满赠商品) ,
    var xq_Type: Int = 0
    /// PayCredits (integer, optional): 支付积分 ,
    var PayCredits: Int = 0
    /// AddTime (string, optional): 添加时间
    var AddTime: String = ""
    /// 商品规格
    var Specs: String = ""
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.xq_Type <-- "Type"
    }
    
}


struct XQSMNTOrderReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// produInfos (Array[ProduInfo], optional): 购买的商品集合 ,
    var ProduInfos: [XQSMNTCartOrderProduInfoModel]?
    /// saId (integer, optional): 配送地址Id（必传） ,
    var SaId: Int = 0
    /// shipName (string, optional): 配送方式名称（也就是SystemName） ,
    var ShipName: String = ""
    /// couponIdList (Array[integer], optional): 客户已选的优惠券id ,
    var CouponId: Int = 0
    /// fullCut (integer, optional): 满减金额 ,
    /// 这个什么鬼, 应该不是app填的啊
    var FullCut: Int = 0
    /// BuyerRemark (string, optional): 买家备注 ,
    var BuyerRemark: String = ""
    /// type (integer, optional): 购买类型 （1：立即购买 0：普通购买） ,
    var xq_type: Int = 0
    
    /// ChoseTrueMan (boolean, optional): 选择实名认证优惠 ,
    var ChoseTrueMan = false
    /// ChoseRank (boolean, optional): 选择等级优惠
    var ChoseRank = false
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.xq_type <-- "Type"
        
    }

}


struct XQSMNTSubmitResultResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// Oid (integer, optional): 订单Id ,
    var Oid: Int = 0
    /// OrderInfo (OrderInfo, optional): 订单信息 ,
    var OrderInfo: XQSMNTOrderInfoModel?
}

struct XQSMNTOrderInfoModel: HandyJSON {
    
    /// Oid (integer, optional): 订单id ,
    var Oid: Int = 0
    /// OSN (string, optional): 订单编号 ,
    var OSN: String = ""
    /// Uid (integer, optional): 用户id ,
    var Uid: Int = 0
    /// OrderState (integer, optional): 订单状态 ,
    var OrderState: Int = 0
    /// ProductAmount (number, optional): 商品合计 ,
    var ProductAmount: Float = 0
    /// OrderAmount (number, optional): 订单合计 ,
    var OrderAmount: Float = 0
    /// SurplusMoney (number, optional): 剩余金钱 ,
    var SurplusMoney: Float = 0
    /// IsReview (integer, optional): 是否评价 ,
    var IsReview: Int = 0
    /// AddTime (string, optional): 添加时间 ,
    var AddTime: String = ""
    /// ShipSN (string, optional): 配送单号 ,
    var ShipSN: String = ""
    /// ShipSystemName (string, optional): 配送方式系统名 ,
    var ShipSystemName: String = ""
    /// ShipFriendName (string, optional): 配送方式昵称 ,
    var ShipFriendName: String = ""
    /// ShipTime (string, optional): 配送时间 ,
    var ShipTime: String = ""
    /// PayMode (integer, optional): 支付方式(0代表货到付款，1代表在线付款) ,
    var PayMode: Int = 0
    /// PaySN (string, optional): 支付单号 ,
    var PaySN: String = ""
    /// PaySystemName (string, optional): 支付方式系统名 ,
    var PaySystemName: String = ""
    /// PayFriendName (string, optional): 支付方式昵称 ,
    var PayFriendName: String = ""
    /// PayTime (string, optional): 支付时间 ,
    var PayTime: String = ""
    /// RegionId (integer, optional): 配送区域id ,
    var RegionId: Int = 0
    /// Consignee (string, optional): 收货人 ,
    var Consignee: String = ""
    /// Mobile (string, optional): 手机号 ,
    var Mobile: String = ""
    /// Phone (string, optional): 固话号 ,
    var Phone: String = ""
    /// Email (string, optional): 邮箱 ,
    var Email: String = ""
    /// ZipCode (string, optional): 邮政编码 ,
    var ZipCode: String = ""
    /// Address (string, optional): 详细地址 ,
    var Address: String = ""
    /// BestTime (string, optional): 最佳送货时间 ,
    var BestTime: String = ""
    /// ShipFee (number, optional): 配送费用 ,
    var ShipFee: Float = 0
    /// FullCut (integer, optional): 满减 ,
    var FullCut: Int = 0
    /// Discount (number, optional): 折扣 ,
    var Discount: Float = 0
    /// PayCreditCount (integer, optional): 支付积分数量 ,
    var PayCreditCount: Int = 0
    /// PayCreditMoney (number, optional): 支付积分金额 ,
    var PayCreditMoney: Float = 0
    /// CouponMoney (integer, optional): 优惠劵金额 ,
    var CouponMoney: Int = 0
    /// Weight (integer, optional): 重量 ,
    var Weight: Int = 0
    /// BuyerRemark (string, optional): 买家备注 ,
    var BuyerRemark: String = ""
    /// IP (string, optional): ip地址
    var IP: String = ""
}


/// 确认收货 model
struct XQSMNTSureReceiveProductReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 订单id
    var orderId = 0
}


/// 确认收货 model
struct XQSMNTOrderPluginInfoReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 订单id
    var OId: Int = 0
}

struct XQSMNTOrderThePlugingResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// pluginList (Array[ThePluging], optional): 物流信息类 ,
    var pluginList: [XQSMNTOrderThePlugingModel]?
}

struct XQSMNTOrderThePlugingModel: HandyJSON {
    
    /// AcceptTime (string, optional): 时间 ,
    var AcceptTime: String = ""
    
    /// AcceptStation (string, optional): 描述 ,
    var AcceptStation: String = ""
    
    /// Remark (string, optional): 备注
    var Remark: String = ""
}


struct XQSMNTOrderStatusNumberResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// pluginList (Array[ThePluging], optional): 物流信息类 ,
    var pluginList: [XQSMNTOrderThePlugingModel]?
    
    /// dfk (integer, optional): 待付款 ,
    var dfk: Int = 0
    
    /// dfh (integer, optional): 待发货 ,
    var dfh: Int = 0
    
    /// dsh (integer, optional): 待收货 ,
    var dsh: Int = 0
    
    /// dpj (integer, optional): 待评价 ,
    var dpj: Int = 0
    
    /// tksh (integer, optional): 退款/售后 ,
    var tksh: Int = 0
    
}

struct XQSMNTOrderAddReviewReqModel: XQSMNTBaseReqModelProtocol {
    
    /// { "PId": 16,//商品Id
//    var PId = 0
    
    /// "OId": 28,//订单Id
    var OId = 0
    
    /// "Star": 5,//评价星级5，4，3，2，1
    var Star = 0
    
    /// "Message":"我是评价内容",
    var Message = ""
    
    /// "NoShowName":1//1表示匿名，0表示非匿名 }
    var NoShowName = 0
    

    /// 图片1对应的标识为Photo1 图片2对应的标识为Photo2 图片3对应的标识为Photo3 最多上传3张图片
    var xq_Imgs = [UIImage]()
    
    
    mutating func mapping(mapper: HelpingMapper) {
        // 忽略图片
        mapper >>> self.xq_Imgs
    }
    
}

struct XQSMNTOrderGetMyReviewResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    
    /// ReviewLss (Array[ReviewDto], optional): ,
    var ReviewLss = [XQSMNTOrderMyReviewReviewModel]()
    
}

struct XQSMNTOrderMyReviewReviewModel: HandyJSON {
    
    /// PShowImgWithAddress (string, optional, read only): 商品图片(带地址) ,
    var PShowImgWithAddress = ""
    
    /// Photo1WithAddress (string, optional, read only): 图片1（带地址） ,
    var Photo1WithAddress = ""
    
    /// Photo2WithAddress (string, optional, read only): 图片2（带地址） ,
    var Photo2WithAddress = ""
    
    /// Photo3WithAddress (string, optional, read only): 图片3（带地址） ,
    var Photo3WithAddress = ""
    
    /// ReviewId (integer, optional): 评价Id ,
    var ReviewId = 0
    
    /// PId (integer, optional): 商品Id ,
    var PId = 0
    
    /// UId (integer, optional): ,
    var UId = 0
    
    /// OprId (integer, optional): 订单商品记录id ,
    var OprId = 0
    
    /// OId (integer, optional): ,
    var OId = 0
    
    /// ParentId (integer, optional): ,
    var ParentId = 0
    
    /// State (integer, optional): 状态,0待审核1通过审核 ,
    var State = 0
    
    /// Star (integer, optional): 评价星级 ,
    var Star = 0
    
    /// Quality (integer, optional): 评价质量(暂时无用) ,
    var Quality = 0
    
    /// Message (string, optional): 评价 ,
    var Message = ""
    
    /// ReviewTime (string, optional): 评价时间 ,
    /// yyyy-MM-dd HH:mm:ss
    var ReviewTime = ""
    
    /// PayCredits (integer, optional): 积分(暂时无用) ,
    var PayCredits = 0
    
    /// PName (string, optional): 商品名 ,
    var PName = ""
    
    /// PShowImg (string, optional): 商品图片 ,
    var PShowImg = ""
    
    /// BuyTime (string, optional): 购买时间 ,
    var BuyTime = ""
    
    /// Ip (string, optional): Ip ,
    var Ip = ""
    
    /// Photo1 (string, optional): Photo1 ,
    var Photo1 = ""
    
    /// Photo2 (string, optional): Photo2 ,
    var Photo2 = ""
    
    /// Photo3 (string, optional): Photo3 ,
    var Photo3 = ""
    
    /// NoShowName (integer, optional): 匿名 1为匿名，0为显示
    var NoShowName = 1
    
    /// 自定义属性, 年月日
    var xq_ReviewTime = ""
    
    /// 自定义属性, 图片url
    var imgArr = [URL]()
}



struct XQSMNTOrderRequestRefundReqModel: XQSMNTBaseReqModelProtocol {
    
    /// OId (integer, optional): 订单Id ,
    var OId = 0
    
    /// Reson (string, optional): 申请理由
    var Reson = ""
    
}

