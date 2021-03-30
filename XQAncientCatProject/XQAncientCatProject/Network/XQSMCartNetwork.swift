//
//  XQSMCartNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/25.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQSMCartNetwork {
    
    /// 我的购物车
    /// - note: 用 cancelOrSelectCartItem 不要用这个接口, 获取直接传空选择数组就行了
    static func getMyCart() -> Observable<XQSMNTCartResModel> {
        return XQSMBaseNetwork.default.get("/api/Cart/GetMyCart", resultType: XQSMNTCartResModel.self)
    }
    
    /// 添加到购物车
    static func addCart(_ parameters: XQSMNTAddCartReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/AddCart", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 移除购物车的商品（注意:删除的同时也把选中的Pid以List集合格式传过来）
    static func delCartProduct(_ parameters: XQSMNTDelCartProductReqModel) -> Observable<XQSMNTCartResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/delCartProduct", parameters: parameters, resultType: XQSMNTCartResModel.self)
    }
    
    /// 购物车中更改购买数量
    static func changeProductCount(_ parameters: XQSMNTChangeProductCountReqModel) -> Observable<XQSMNTCartResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/ChangeProductCount", parameters: parameters, resultType: XQSMNTCartResModel.self)
    }
    
    /// 购物车选项的勾选
    static func cancelOrSelectCartItem(_ parameters: XQSMNTCancelOrSelectCartItemReqModel) -> Observable<XQSMNTCartResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/CancelOrSelectCartItem", parameters: parameters, resultType: XQSMNTCartResModel.self)
    }
    
    /// 获取配送快递
    static func getShipPlugin(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTPluginResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/GetShipPlugin", parameters: parameters, resultType: XQSMNTPluginResModel.self)
    }
    
    /// 去结算 （注意：提交的字段saId和couponid如果没有值时，默认填0） app需要多次调用
    static func confirmOrder(_ parameters: XQSMNTCanceOrSelectReqModel) -> Observable<XQSMNTConfirmOrderResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/ConfirmOrder", parameters: parameters, resultType: XQSMNTConfirmOrderResModel.self)
    }
    
    /// 获取此用户的优惠券
    static func couponByUid(_ parameters: XQSMNTCartCouponByUidReqModel) -> Observable<XQSMNTCartCouponResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/CouponByUid", parameters: parameters, resultType: XQSMNTCartCouponResModel.self)
    }
    
    /// 获取此用户下单时可用优惠券
    static func queryCanUseCouponByUid(_ parameters: XQSMNTCartCouponByUidReqModel) -> Observable<XQSMNTCartCouponResModel> {
        return XQSMBaseNetwork.default.post("/api/Cart/QueryCanUseCouponByUid", parameters: parameters, resultType: XQSMNTCartCouponResModel.self)
    }
    
}

struct XQSMNTAddCartReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// "buyCount":购买数量（int）,
    var buyCount: Int = 0
    /// "pid":商品Id(int)}
    var pid: Int = 0
    
}

struct XQSMNTDelCartProductReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 选中的 pid, "rest_pids":[商品id,商品id,商品id]}
    var PIds = [Int]()
}

struct XQSMNTChangeProductCountReqModel: XQSMNTBaseReqModelProtocol {
    /// {"token":"",
    
    
    /// "pid":商品id(int)
    var pid: Int = 0

    /// "buyCount":购买数量（int）,
    var buyCount: Int = 0
    
    /// 选中的 pid, "Selectpids":[商品id,商品id,商品id]}
    var Selectpids = [Int]()
    
}

struct XQSMNTCancelOrSelectCartItemReqModel: XQSMNTBaseReqModelProtocol {
    /// {"token":"",
    
    /// 选中的 pid, "Selectpids":[商品id,商品id,商品id]}
    var Selectpids = [Int]()
}

struct XQSMNTCartResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// CartInfo (CartModel, optional),
    var CartInfo: XQSMNTCartModel?
}

struct XQSMNTCartModel: HandyJSON {
    /// TotalCount (integer, optional): 商品总数量 ,
    var TotalCount: Int = 0
    /// ProductAmount (number, optional): 商品合计 ,
    var ProductAmount: Float = 0
    /// FullCut (integer, optional): 满减 ,
    var FullCut: Int = 0
    /// OrderAmount (number, optional): 订单合计 ,
    var OrderAmount: Float = 0
    /// CartInfo (CartInfo, optional): 购物车信息
    var CartInfo: XQSMNTCartInfoModel?
    
}

struct XQSMNTCartInfoModel: HandyJSON {
    /// IsSelected (boolean, optional): 是否选中 ,
    var IsSelected: Bool = false
    /// CartProductList (Array[CartProductInfo], optional): 购物车商品列表 ,
    var CartProductList: [XQSMNTCartProductInfoModel]?
    /// CartSuitList (Array[CartSuitInfo], optional): 购物车套装列表 ,
    var CartSuitList: [XQSMNTCartSuitInfoModel]?
    /// CartFullSendList (Array[CartFullSendInfo], optional): 购物车满赠列表 ,
    var CartFullSendList: [XQSMNTCartFullSendInfoModel]?
    /// CartFullCutList (Array[CartFullCutInfo], optional): 购物车满减列表 ,
    var CartFullCutList: [XQSMNTCartFullCutInfoModel]?
    /// SelectedOrderProductList (Array[OrderProductInfo], optional): 选中的订单商品列表 ,
    var SelectedOrderProductList: [XQSMNTOrderProductInfoModel]?
    /// RemainedOrderProductList (Array[OrderProductInfo], optional): 剩余的订单商品列表
    var RemainedOrderProductList: [XQSMNTOrderProductInfoModel]?
}

/// 购物车商品信息
struct XQSMNTCartProductInfoModel: HandyJSON {
    /// IsSelected (boolean, optional): 是否选中 ,
    var IsSelected: Bool = false
    /// OrderProductInfo (OrderProductInfo, optional): 商品信息 ,
    var OrderProductInfo: XQSMNTOrderProductInfoModel?
    /// GiftList (Array[OrderProductInfo], optional): 赠品列表
    var GiftList: [XQSMNTOrderProductInfoModel]?
}

/// 商品套装信息
struct XQSMNTCartSuitInfoModel: HandyJSON {
    /// IsSelected (boolean, optional): 是否选中 ,
    var IsSelected: Bool = false
    /// PmId (integer, optional): 套装促销活动id ,
    var PmId: Int = 0
    /// BuyCount (integer, optional): 购买数量 ,
    var BuyCount: Int = 0
    /// SuitPrice (number, optional): 套装价格 ,
    var SuitPrice: Float = 0
    /// SuitAmount (number, optional): 套装合计 ,
    var SuitAmount: Float = 0
    /// ProductAmount (number, optional): 商品合计 ,
    var ProductAmount: Float = 0
    /// Discount (number, optional): 折扣 ,
    var Discount: Float = 0
    /// CartProductList (Array[CartProductInfo], optional): 购物车商品列表
    var CartProductList: [XQSMNTCartProductInfoModel]?
}

/// 满赠商品信息
struct XQSMNTCartFullSendInfoModel: HandyJSON {
    /// IsEnough (boolean, optional): 是否达到满赠促销活动的金额 ,
    var IsEnough: Bool = false
    /// FullSendPromotionInfo (FullSendPromotionInfo, optional): 满赠促销活动 ,
    var FullSendPromotionInfo: XQSMNTFullSendPromotionInfoModel?
    /// FullSendMinorOrderProductInfo (OrderProductInfo, optional): 满赠赠品 ,
    var FullSendMinorOrderProductInfo: XQSMNTOrderProductInfoModel?
    /// FullSendMainCartProductList (Array[CartProductInfo], optional): 满赠主商品列表 ,
    var FullSendMainCartProductList: [XQSMNTCartProductInfoModel]?
    /// MainProductAmount (number, optional): 主商品合计
    var MainProductAmount: Float = 0
}

/// 满减商品信息
struct XQSMNTCartFullCutInfoModel: HandyJSON {
    /// IsEnough (boolean, optional): 是否达到满减促销活动的金额 ,
    var IsEnough: Int = 0
    /// LimitMoney (integer, optional): 限制金额 ,
    var LimitMoney: Int = 0
    /// CutMoney (integer, optional): 减小金额 ,
    var CutMoney: Int = 0
    /// FullCutPromotionInfo (FullCutPromotionInfo, optional): 满减促销活动 ,
    var FullCutPromotionInfo: XQSMNTFullCutPromotionInfoModel?
    /// FullCutCartProductList (Array[CartProductInfo], optional): 满减商品列表 ,
    var FullCutCartProductList: [XQSMNTCartProductInfoModel]?
    /// ProductAmount (number, optional): 商品合计
    var ProductAmount: Float = 0
}

/// 商品信息
struct XQSMNTOrderProductInfoModel: HandyJSON {
    /// RecordId (integer, optional): 记录id ,
    var RecordId: Int = 0
    /// Oid (integer, optional): 订单id ,
    var Oid: Int = 0
    /// Uid (integer, optional): 用户id ,
    var Uid: Int = 0
    /// Sid (string, optional): sessionId ,
    var Sid: String = ""
    /// Pid (integer, optional): 商品id ,
    var Pid: Int = 0
    /// PSN (string, optional): 商品编码 ,
    var PSN: String = ""
    /// CateId (integer, optional): 分类id ,
    var CateId: Int = 0
    /// BrandId (integer, optional): 品牌id ,
    var BrandId: Int = 0
    /// Name (string, optional): 商品名称 ,
    var Name: String = ""
    /// ShowImg (string, optional): 商品展示图片 ,
    var ShowImg: String = ""
    /// ShowImgWithAddress (string, optional): 商品展示图片 ,
    var ShowImgWithAddress: String = ""
    /// DiscountPrice (number, optional): 商品折扣价格 ,
    var DiscountPrice: Float = 0
    /// ShopPrice (number, optional): 商品商城价格 ,
    var ShopPrice: Float = 0
    /// CostPrice (number, optional): 商品成本价格 ,
    var CostPrice: Float = 0
    /// MarketPrice (number, optional): 商品市场价格 ,
    var MarketPrice: Float = 0
    /// Weight (integer, optional): 商品重量 ,
    var Weight: Int = 0
    /// IsReview (integer, optional): 是否评价(0代表未评价，1代表已评价) ,
    var IsReview: Int = 0
    /// RealCount (integer, optional): 真实数量 ,
    var RealCount: Int = 0
    /// BuyCount (integer, optional): 商品购买数量 ,
    var BuyCount: Int = 0
    /// SendCount (integer, optional): 商品邮寄数量 ,
    var SendCount: Int = 0
    /// Type (integer, optional): 商品类型(0为普遍商品,1为普通商品赠品,2为套装商品赠品,3为套装商品,4满赠商品) ,
    var xq_type: Int = 0
    /// PayCredits (integer, optional): 支付积分 ,
    var PayCredits: Int = 0
    /// CouponTypeId (integer, optional): 赠送优惠劵类型id ,
    var CouponTypeId: Int = 0
    /// ExtCode1 (integer, optional): 普通商品时为单品促销活动id,赠品时为赠品促销活动id,套装商品时为套装促销活动id,满赠赠品时为满赠促销活动id ,
    var ExtCode1: Int = 0
    /// ExtCode2 (integer, optional): 普通商品时为买送促销活动id,赠品时为赠品赠送数量,套装商品时为套装商品数量 ,
    var ExtCode2: Int = 0
    /// ExtCode3 (integer, optional): 普通商品时为赠品促销活动id,套装商品时为赠品促销活动id ,
    var ExtCode3: Int = 0
    /// ExtCode4 (integer, optional): 普通商品时为满赠促销活动id ,
    var ExtCode4: Int = 0
    /// ExtCode5 (integer, optional): 普通商品时为满减促销活动id ,
    var ExtCode5: Int = 0
    /// AddTime (string, optional): 添加时间
    var AddTime: String = ""
    /// 商品规格
    var Specs: String = ""
    /// IsVip (boolean, optional): 是否VIP
    var IsVip = false
    
    /// 自定义属性, 当前是否选中了这个商品
    /// true 选中
/// var xq_select: Bool = false
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.xq_type <-- "Type"
    }
    
    
}

struct XQSMNTFullSendPromotionInfoModel: HandyJSON {
    /// PmId (integer, optional): 活动id ,
    var PmId: Int = 0
    /// StartTime (string, optional): 开始时间 ,
    var StartTime: String = ""
    /// EndTime (string, optional): 结束时间 ,
    var EndTime: String = ""
    /// UserRankLower (integer, optional): 用户等级下限 ,
    var UserRankLower: Int = 0
    /// State (integer, optional): 状态 ,
    var State: Int = 0
    /// Name (string, optional): 名称 ,
    var Name: String = ""
    /// LimitMoney (integer, optional): 限制金额 ,
    var LimitMoney: Int = 0
    /// AddMoney (integer, optional): 添加金额
    var AddMoney: Int = 0
    
}

struct XQSMNTFullCutPromotionInfoModel: HandyJSON {
    /// PmId (integer, optional): 活动id ,
    var PmId: Int = 0
    /// Type (integer, optional): 活动类型,0代表全场商品满减，1代表部分商品满减，2代表部分商品不满减 ,
    var xq_type: Int = 0
    /// StartTime (string, optional): 开始时间 ,
    var StartTime: String = ""
    /// EndTime (string, optional): 结束时间 ,
    var EndTime: String = ""
    /// UserRankLower (integer, optional): 用户等级下限 ,
    var UserRankLower: Int = 0
    /// State (integer, optional): 状态 ,
    var State: Int = 0
    /// Name (string, optional): 名称 ,
    var Name: String = ""
    /// LimitMoney1 (integer, optional): 限制金额1 ,
    var LimitMoney1: Int = 0
    /// CutMoney1 (integer, optional): 减小金额1 ,
    var CutMoney1: Int = 0
    /// LimitMoney2 (integer, optional): 限制金额2 ,
    var LimitMoney2: Int = 0
    /// CutMoney2 (integer, optional): 减小金额2 ,
    var CutMoney2: Int = 0
    /// LimitMoney3 (integer, optional): 限制金额3 ,
    var LimitMoney3: Int = 0
    /// CutMoney3 (integer, optional): 减小金额3
    var CutMoney3: Int = 0
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.xq_type <-- "Type"
    }
}

struct XQSMNTCanceOrSelectReqModel: XQSMNTBaseReqModelProtocol {
    
    /// produInfos (Array[ProduInfo], optional): 购买的商品集合 ,
    var ProduInfos = [XQSMNTCartOrderProduInfoModel]()
    /// saId (integer, optional): 配送地址Id ,
    var SaId: Int = 0
    /// shipName (string, optional): 配送插件名称 ,
    var ShipName: String = ""
    /// couponid (integer, optional): 优惠券id ,
    var CouponId: Int = 0
    /// type (integer, optional): 立即购买1 普通购买0 ,
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


struct XQSMNTCartOrderProduInfoModel: HandyJSON {
    /// pId (integer, optional): 商品Id ,
    var pId: Int = 0
    /// buyCount (integer, optional): 购买数量
    var buyCount: Int = 0
}


struct XQSMNTConfirmOrderResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// model (ConfirmOrderModel, optional): 订单信息类 ,
    var OrderModel: XQSMNTConfirmOrderModel?
    
}

struct XQSMNTConfirmOrderModel: HandyJSON {
    /// PayMode (integer, optional): 支付方式(0代表货到付款,1代表在线支付) ,
    var PayMode: Int = 0
    /// DefaultFullShipAddressInfo (FullShipAddressInfo, optional): 默认完整用户配送地址 ,
    var DefaultFullShipAddressInfo: XQSMNTFullShipAddressInfoModel?
    /// DefaultShipPluginInfo (PluginInfo, optional): 默认配送插件 ,
    var DefaultShipPluginInfo: XQSMNTCartPluginInfoModel?
    /// ShipPluginList (Array[PluginInfo], optional): 配送插件列表 ,
    var ShipPluginList: [XQSMNTCartPluginInfoModel]?
    /// PayCreditName (string, optional): 支付积分名称 ,
    var PayCreditName: String = ""
    /// UserPayCredits (integer, optional): 用户支付积分 ,
    var UserPayCredits: Int = 0
    /// MaxUsePayCredits (integer, optional): 最大使用支付积分 ,
    var MaxUsePayCredits: Int = 0
    /// TotalWeight (integer, optional): 商品总重量 ,
    var TotalWeight: Int = 0
    /// TotalCount (integer, optional): 商品总数量 ,
    var TotalCount: Int = 0
    /// ProductAmount (number, optional): 商品合计 ,
    var ProductAmount: Float = 0
    /// ShipFee (number, optional): 配送费用 ,
    var ShipFee: Float = 0
    /// FullCut (integer, optional): 满减 ,
    var FullCut: Int = 0
    /// OrderAmount (number, optional): 订单合计 ,
    var OrderAmount: Float = 0
    /// CartInfo (CartInfo, optional): 购物车信息
    var CartInfo: XQSMNTCartInfoModel?
    
    /// CouponPrice (number, optional): 优惠券抵扣金额 ,
    var CouponPrice: Float = 0
    /// RankDiscountPrice (number, optional): 等级优惠金额 ,
    var RankDiscountPrice: Float = 0
    /// TrueManPrice (number, optional): 实名认证优惠金额 ,
    var TrueManPrice: Float = 0
    
}

struct XQSMNTFullShipAddressInfoModel: HandyJSON {
    // 这个真的有必要吗??? 为什么有两个收货地址的 model
    
    /// ProvinceId (integer, optional): 省id ,
    var ProvinceId: Int = 0
    /// ProvinceName (string, optional): 省名称 ,
    var ProvinceName: String = ""
    /// CityId (integer, optional): 市id ,
    var CityId: Int = 0
    /// CityName (string, optional): 市名称 ,
    var CityName: String = ""
    /// CountyId (integer, optional): 县或区id ,
    var CountyId: Int = 0
    /// CountyName (string, optional): 县或区名称 ,
    var CountyName: String = ""
    /// SAId (integer, optional): 配送地址id ,
    var SAId: Int = 0
    /// Uid (integer, optional): 用户id ,
    var Uid: Int = 0
    /// RegionId (integer, optional): 区域id ,
    var RegionId: Int = 0
    /// IsDefault (integer, optional): 是否是默认地址 ,
    var IsDefault: Int = 0
    /// Alias (string, optional): 别名 ,
    var Alias: String = ""
    /// Consignee (string, optional): 收货人 ,
    var Consignee: String = ""
    /// Mobile (string, optional): 收货人手机 ,
    var Mobile: String = ""
    /// Phone (string, optional): 收货人固定电话 ,
    var Phone: String = ""
    /// Email (string, optional): 收货人邮箱 ,
    var Email: String = ""
    /// ZipCode (string, optional): 邮政编码 ,
    var ZipCode: String = ""
    /// Address (string, optional): 地址 ,
    var Address: String = ""
    /// X (string, optional): x ,
    var X: String = ""
    /// Y (string, optional): Y
    var Y: String = ""
}

struct XQSMNTCartPluginInfoModel: HandyJSON {
    /// SystemName (string, optional): 插件系统名称 ,
    var SystemName: String = ""
    /// FriendlyName (string, optional): 插件友好名称 ,
    var FriendlyName: String = ""
    /// ClassFullName (string, optional): 插件类型名称 ,
    var ClassFullName: String = ""
    /// Folder (string, optional): 插件目录 ,
    var Folder: String = ""
    /// Description (string, optional): 插件描述 ,
    var Description: String = ""
    /// Type (integer, optional): 插件类型(0代表开放授权插件，1代表支付插件，2代表配送插件) ,
    var xq_Type: String = ""
    /// Author (string, optional): 插件作者 ,
    var Author: String = ""
    /// Version (string, optional): 插件版本 ,
    var Version: String = ""
    /// SupVersion (string, optional): 插件支持的BrnShop版本 ,
    var SupVersion: String = ""
    /// DisplayOrder (integer, optional): 插件顺序 ,
    var DisplayOrder: String = ""
    /// IsDefault (integer, optional): 是否是默认插件 ,
    var IsDefault: String = ""
    /// Instance (IPlugin, optional, read only): 插件实例
    var Instance: XQSMNTCartIPluginInfoModel?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.xq_Type <-- "Type"
    }
}

struct XQSMNTCartIPluginInfoModel: HandyJSON {
    /// ConfigController (string, optional, read only): 插件配置控制器 ,
    var ConfigController: String = ""
    /// ConfigAction (string, optional, read only): 插件配置动作方法
    var ConfigAction: String = ""
}


struct XQSMNTPluginResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// fullshipInfo (PluginInfo, optional),
    var fullshipInfo: XQSMNTCartPluginInfoModel?
}


struct XQSMNTCartCouponByUidReqModel: XQSMNTBaseReqModelProtocol {
    
    /// "couponList":[{"pId":商品Id(int),"buyCount":购买数量(int)}],
    var CartPdList: [XQSMNTCartOrderProduInfoModel] = []
    /// "type":int(1:立即购买 0：普通购买)
    var BuyType: Int = 0
    
}

struct XQSMNTCartCouponResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// couponList (Array[CouponMessage], optional),
    var CouponList: [XQSMNTCouponListModel] = []
}


