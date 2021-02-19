//
//  XQSMToShopOrderNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/9/17.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import UIKit
import RxSwift
import HandyJSON

/// 预约, 洗护
struct XQSMToShopOrderNetwork {
    
    /// 获取我的外卖订单，根据状态查
    static func getMyToOrder(_ parameters: XQSMNTToShopOrderReqModel) -> Observable<XQSMNTGetMyToOrderResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShopOrder/GetMyToOrder", parameters: parameters, resultType: XQSMNTGetMyToOrderResModel.self)
    }
    
    /// 根据Id获取预约单
    static func getToOrderById(_ oId: Int) -> Observable<XQSMNTGetToOrderByIdResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShopOrder/GetToOrderById/\(oId)", resultType: XQSMNTGetToOrderByIdResModel.self)
    }
    
    /// 取消订单
    static func cancleToOrder(_ parameters: XQSMNTCancleToOrderReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/ToShopOrder/CancleToOrder", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 获取对应订单可退款商品价格等信息
    static func getCanRefundOrderDetails(_ parameters: XQSMNTCancleToOrderReqModel) -> Observable<XQSMNTCanRefundToOrderDetailResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShopOrder/GetCanRefundOrderDetails", parameters: parameters, resultType: XQSMNTCanRefundToOrderDetailResModel.self)
    }
    
    /// 申请退款(订单处于1(已预约)且CanRefund字段为True时可退)
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
        
        return XQSMBaseNetwork.default.uploadImage_1("/api/ToShopOrder/RefundToOrder", datas: imgDataArr, params: parameters, resultType: XQSMNTOrderRefundToOrderResModel.self)
    }
    
    /// 删除订单(已取消/已完成/退款完成/线下退款完成 状态才可操作)
    static func deleteOrder(_ parameters: XQSMNTToShopOrderDeleteOrderReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/ToShopOrder/DeleteOrder", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
}

enum XQSMNTTinnyToOrderInfoModelState: Int, HandyJSONEnum {
    /// unknow: 未知
    case unknow = -99
    /// 查询全部
    case all = -1
    /// waitPay: 待支付
    case waitPay = 0
    /// reserved: 已预约
    case reserved = 1
    /// completed: 服务结束
    case completed = 2
    /// refundInProgress: 退款中
    case refundInProgress = 3
    /// refundCompleted: 退款完成
    case refundCompleted = 4
    /// cancel: 已取消
    case cancel = 5
    /// 线下退款完成
    case offlineRefundCompleted = 6
    /// 洗护中
    case inCare = 7
}

struct XQSMNTToShopOrderReqModel: XQSMNTBaseReqModelProtocol {
    /// State (integer, optional): 状态 -1：查全部 0：待支付 1：已预约 2：服务结束 3：退款中 4：退款完成 5：已取消 6；线下退款完成 7：洗护中
    var State: XQSMNTTinnyToOrderInfoModelState = .all
}

struct XQSMNTGetToOrderByIdResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ToOrderItem (TinnyToOrderInfoDto, optional): 订单 ,
    var ToOrderItem: XQSMNTTinnyToOrderInfoModel?
}

struct XQSMNTGetMyToOrderResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ToOrderList (Array[TinnyToOrderInfoDto], optional): 订单列表 ,
    var ToOrderList: [XQSMNTTinnyToOrderInfoModel]?
}

struct XQSMNTTinnyToOrderInfoModel: HandyJSON {
    
    /// Id (integer, optional): 订单Id ,
    var Id: Int = 0
    /// OSN (string, optional): 订单编号
    var OSN: String = ""
    /// Creation (string, optional): 创建时间 ,
    var Creation: String = ""
    /// FinishTime (string, optional): 结束时间(仅订单完成之后此字段才有效) ,
    var FinishTime: String = ""
    
    /// 收货地址
    var RecieveAddress: String = ""
    /// 收货人
    var RecieveMan: String = ""
    /// 收货人手机
    var RecievePhone: String = ""
    
    
    /// State (integer, optional): 状态 ,
    var State: XQSMNTTinnyToOrderInfoModelState = .unknow
    
    /// StateDesc (string, optional, read only): 状态描述 ,
    var StateDesc: String = ""
    
    /// Remark (string, optional): 备注 ,
    var Remark: String = ""
    /// TotalPrice (number, optional): 实际总价 ,
    var TotalPrice: Float = 0
    
    /// ShopId (integer, optional): 店铺Id ,
    var ShopId: Int = 0
    /// ShopName (string, optional): 店铺名 ,
    var ShopName: String = ""
    /// PdList (Array[TinnyToOrderDetails], optional): 商品列表
    var PdList: [XQSMNTTinnyToOrderDetailsModel]?
    
    /// X (string, optional): X(百度地图) ,
    var X: String = ""
    /// Y (string, optional): Y(百度地图) ,
    var Y: String = ""
    /// XOther (string, optional, read only): X轴(非百度地图) ,
    var XOther: String = ""
    /// YOther (string, optional, read only): Y轴(非百度地图) ,
    var YOther: String = ""
    /// ShopPhone (string, optional): 店铺电话 ,
    var ShopPhone: String = ""

    /// PayTime (string, optional): 支付时间 ,
    var PayTime: String = ""
    
    /// PayType 支付方式  aliPay、wechat 
    var PayType: String = ""
    
    /// SubscribeTime (string, optional): 预约时间 ,
    var SubscribeTime: String = ""
    
    var CouponMoney: Float = 0
    
    var CouponId: Int = 0
    
    /// IntegralPrice (number, optional): 积分抵扣费用 ,
    var IntegralPrice: Float = 0
    
    /// UserRankDicount (integer, optional): 用户等级折扣（除以10就为X折，如值为90就表示为9折） ,
    var UserRankDiscount = 0
    
    /// UserRankDiscountPrice (number, optional): 用户等级折扣费用 ,
    var UserRankDiscountPrice: Float = 0
    
    /// TotalSendPrice (number, optional): 接送费 ,
    var TotalSendPrice: Float = 0
    
    /// ReceiveAddress (string, optional): 接地址 ,
    var ReceiveAddress: String = ""
    
    /// ReceiveAddressX (string, optional): 接地址X ,
    var ReceiveAddressX: String = ""
    
    /// ReceiveAddressY (string, optional): 接地址Y ,
    var ReceiveAddressY: String = ""
    
    /// SendBackAddress (string, optional): 送地址 ,
    var SendBackAddress: String = ""
    
    /// SendBackAddressX (string, optional): 送地址X ,
    var SendBackAddressX: String = ""
    
    /// SendBackAddressY (string, optional): 送地址Y ,
    var SendBackAddressY: String = ""
    
    /// SendBackAddressXOther (string, optional, read only): 送地址X轴(非百度地图) ,
    var SendBackAddressXOther: String = ""
    
    /// SendBackAddressYOther (string, optional, read only): 送地址Y轴(非百度地图) ,
    var SendBackAddressYOther: String = ""
    
    /// ReceiveAddressXOther (string, optional, read only): 接地址X轴(非百度地图) ,
    var ReceiveAddressXOther: String = ""
    
    /// ReceiveAddressYOther (string, optional, read only): 接地址Y轴(非百度地图) ,
    var ReceiveAddressYOther: String = ""
    
    /// ReceiveMan (string, optional): 预约人 ,
    var ReceiveMan: String = ""
    
    /// ReceivePhone (string, optional): 预约手机号 ,
    var ReceivePhone: String = ""
    
    /// ShopLogo (string, optional): 店铺Logo ,
    var ShopLogo: String = ""
    
    /// ShopLogoWithAddress (string, optional, read only): 店铺Logo(带地址) ,
    var ShopLogoWithAddress: String = ""
    
    /// ShopAddress (string, optional): 店铺地址 ,
    var ShopAddress: String = ""
    
    /// PetPhoto (string, optional): 宠物图片 ,
    var PetPhoto: String = ""
    
    /// PetPhotoStr (string, optional, read only): 宠物图片带地址 ,
    var PetPhotoStr: String = ""
    
    /// 是否能退款
    var CanRefund = false
}

extension XQSMNTTinnyToOrderInfoModel {
    
    /// 获取套餐名称
    func xq_getOrderPdListPName() -> String {
        // 套餐名称，默认只能有一个套餐
        var pName = ""
        for item in self.PdList ?? [] {
            if item.PIsPackage {
                pName = item.PName
                break
            }
        }
        
        return pName
    }
    
    /// 获取商品信息
    func xq_getOrderPdListInfo() -> String {
        
        var content = ""
        
        for item in self.PdList ?? [] {
            if item.PIsPackage {
                continue
            }
            
            if content.count == 0 {
                content = item.PName
            }else {
                content += "\n\(item.PName)"
            }
            
//            for item in item.PackageDetailsList ?? [] {
//                if content.count == 0 {
//                    content = item.PName
//                }else {
//                    content += "\n\(item.PName)"
//                }
//            }
            
        }
        
        return content
    }
    
}

class XQSMNTTinnyToOrderDetailsModel: NSObject, HandyJSON {
    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): Id ,
    var Id: Int = 0
    /// OId (integer, optional): 订单Id ,
    var OId: Int = 0
    /// PId (integer, optional): 商品Id ,
    var PId: Int = 0
    /// PName (string, optional): 商品名 ,
    var PName: String = ""
    /// PNowPrice (number, optional): 商现价 ,
    var PNowPrice: Float = 0
    /// PPhoto (string, optional): 商图片 ,
    var PPhoto: String = ""
    /// PPhotoStr (string, optional): 商图片 ,
    var PPhotoStr: String = ""
    /// Num (integer, optional): 数量
    var Num: Int = 0
    
    /// UnitContent (string, optional): 每单位包含量(如：净重800g) 新的sku参数中，此字段无用 ,
    var UnitContent: String = ""
    
    /// MaxRefundPrice (number, optional): 最大可退金额(单价) ,
    var MaxRefundPrice: Float = 0
    /// SkuId (string, optional): SkuId
    var SkuId: String = ""
    
    /// 是否是套餐内
    var PIsPackage = false
    
    /// PackageDetailsList (Array[ToProductPackageDetailTinyDto], optional): 套餐包含
    var PackageDetailsList: [XQSMNTToShopOrderToProductPackageDetailTinyModel]?
    
    /// SkuJson (string, optional): SkuJson（数据如：[{"Id":9,"PId":24,"SkuId":10,"SkuValue":"多糖","SkuName":"甜度"},{"Id":10,"PId":24,"SkuId":10,"SkuValue":"常温","SkuName":"冰量"}]）
    var SkuJson: String = ""
    
    private var _skuModelArr: [XQSMNTToShopOrderSkuJsonModel]?
    var skuModelArr: [XQSMNTToShopOrderSkuJsonModel]? {
        set {
            _skuModelArr = newValue
        }
        get {
            if _skuModelArr == nil {
                _skuModelArr = [XQSMNTToShopOrderSkuJsonModel].deserialize(from: self.SkuJson) as? [XQSMNTToShopOrderSkuJsonModel]
            }
            
            return _skuModelArr
        }
    }
    
    private var _xq_skuContent: String?
    var xq_skuContent: String? {
        set {
            _xq_skuContent = newValue
        }
        get {
            if _xq_skuContent == nil {
                var str = ""
                for item in self.skuModelArr ?? [] {
                    str += (item.SkuValue + ";")
                }
                _xq_skuContent = str
            }
            
            return _xq_skuContent
        }
    }
    
}

struct XQSMNTToShopOrderToProductPackageDetailTinyModel: HandyJSON {
    /// PName (string, optional): 商品名
    var PName: String = ""
}

class XQSMNTToShopOrderSkuJsonModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// Id
    var Id: Int = 0
    /// id
    var PId: Int = 0
    /// id
    var SkuId: Int = 0
    /// SkuValue
    var SkuValue: String = ""
    /// SkuName
    var SkuName: String = ""
}


struct XQSMNTCancleToOrderReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// oId 订单id
    var oId: Int = 0
}

struct XQSMNTGetCanRefundOrderDetailReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// oId 订单id
    var OId: Int = 0
}

class XQSMNTCanRefundToOrderDetailResModel: NSObject, XQSMNTBaseResModelProtocol {
    
    required override init() {
        super.init()
    }
    

    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// TotalPrice (number, optional): 总价 ,
    var TotalPrice: Float = 0
    
    /// ProductList (Array[RefundProductDetail], optional): 商品列表 ,
    var ProductList: [XQSMNTRefundProductDetailModel]?
    
}

class XQSMNTRefundProductDetailModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): 商品Id ,
    var Id: Int = 0
    
    /// Name (string, optional): 名称 ,
    var Name: String = ""
    
    /// Photo (string, optional): 图片 ,
    var Photo: String = ""
    
    /// PhotoStr (string, optional, read only): 图片（带具体地址） ,
    var PhotoStr: String = ""
    
    /// NumDesc (string, optional): 单位(如：1份) ,
    var NumDesc: String = ""
    
    /// UnitContent (string, optional): 每单位包含量(如：净重800g) ,
    var UnitContent: String = ""
    
    /// MaxRefundPrice (number, optional): 最大可退金额(单价) ,
    var MaxRefundPrice: Float = 0
    
    /// NowPrice (number, optional): 现价 ,
    var NowPrice: Float = 0
    
    /// PackagePrice (number, optional): 打包费 ,
    var PackagePrice: Float = 0
    
    /// Num (integer, optional): 数量 ,
    var Num: Int = 0
    
    /// SkuJson (string, optional): Sku规格的JSON（数据如：[{"Id":9,"PId":24,"SkuId":10,"SkuValue":"多糖","SkuName":"甜度"},{"Id":10,"PId":24,"SkuId":10,"SkuValue":"常温","SkuName":"冰量"}]） ,
    var SkuJson: String = ""
    
    /// SkuId (string, optional): SkuId
    var SkuId: String = ""

    
    private var _skuModelArr: [XQSMNTToShopOrderSkuJsonModel]?
    /// 自定义sku属性
    var skuModelArr: [XQSMNTToShopOrderSkuJsonModel]? {
        set {
            _skuModelArr = newValue
        }
        get {
            if _skuModelArr == nil {
                _skuModelArr = [XQSMNTToShopOrderSkuJsonModel].deserialize(from: self.SkuJson) as? [XQSMNTToShopOrderSkuJsonModel]
                
            }
            
            return _skuModelArr
        }
    }
    

    /// 自定义属性, 退款数量
    var xq_selectCount: Int = 0
    
}



struct XQSMNTOrderRefundToOrderReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// 退款商品列表,  "[{\"PId\": 13,\"PPrice\": 99,\"Num\": 2,\"SkuId\":35}]"
    /// PId 商品id
    /// SkuId 商品规格 id
    /// PPrice:商品退款金额单价（直接将查到的数据传过来）
    /// Num:退款数量
//    var ProductList: String = ""
    
    /// 订单id
    var OId: Int = 0
    
    /// RefundPrice:退款总额
    var RefundPrice: Float = 0
    
    /// 备注
    var Remark: String = ""
    
    /// 上传的图片数组
    /// 目前限制 1 ~ 3 张
    var imgArr: [UIImage]?
    
    mutating func mapping(mapper: HelpingMapper) {
        // 忽略属性
        mapper >>> self.imgArr
    }
    
    
    // 商品列表
    struct XQSMNTOrderRefundToOrderProductModel: HandyJSON {
        /// PId:商品Id
        var PId: Int = 0
        /// PPrice:商品退款金额单价（直接将查到的数据传过来）
        var PPrice: Float = 0
        /// Num:退款数量
        var Num: Int = 0
        /// SkuId:商品SkuId
        var SkuId: Int = 0
    }
    
}


struct XQSMNTOrderRefundToOrderResModel: XQSMNTBaseUploadfileResModelProtocol {
    
    var isProgress: Bool = false
    
    var progress: Progress?
    

    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
}

struct XQSMNTToShopOrderDeleteOrderReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 订单id
    var oId = 0
    
}

