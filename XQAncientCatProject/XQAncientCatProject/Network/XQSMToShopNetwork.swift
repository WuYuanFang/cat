//
//  XQSMToShopNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/21.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQSMToShopNetwork {
    
    /// 获取周边能配送且工作中的店铺
    static func getClosestShop(_ parameters: XQSMNTGetClosestShopReqModel) -> Observable<XQSMNTGetClosestShopResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShop/GetClosestShop", parameters: parameters, resultType: XQSMNTGetClosestShopResModel.self)
    }
    
    /// 获取周边所有能配送且工作中的店铺 根据距离排序
//    static func getOpeningShop(_ parameters: XQSMNTGetClosestShopReqModel) -> Observable<XQSMNTGetOpeningShopResModel> {
//        return XQSMBaseNetwork.default.post("/api/ToShop/GetOpeningShop", parameters: parameters, resultType: XQSMNTGetOpeningShopResModel.self)
//    }
    
    /// 获取店铺所有信息类 包含商品、轮播图、公告什么鬼信息的 如需要测试，店铺Id为3的数据比较全 2019年8月20日11:56:31
//    static func getAllShopInfo(_ parameters: XQSMNTGetAllShopInfoWithProductReqModel) -> Observable<XQSMNTGetAllShopInfoWithProductResModel> {
//        return XQSMBaseNetwork.default.post("/api/ToShop/GetAllShopInfo", parameters: parameters, resultType: XQSMNTGetAllShopInfoWithProductResModel.self)
//    }
    
    /// 获取店铺所有信息类 包含商品、轮播图、公告等信息的
    static func getAllShopInfoV2(_ parameters: XQSMNTGetAllShopInfoWithProductReqModel) -> Observable<XQSMNTGetAllShopInfoWithProductV2ResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShop/GetAllShopInfoV2", parameters: parameters, resultType: XQSMNTGetAllShopInfoWithProductV2ResModel.self)
    }
    
    /// 根据sku信息获取商品详细信息
//    static func getProductBySkuInfo(_ parameters: XQSMNTGetProductBySkuInfoReqModel) -> Observable<XQSMNTGetProductBySkuInfoResModel> {
//        return XQSMBaseNetwork.default.post("/api/ToShop/GetProductBySkuInfo", parameters: parameters, resultType: XQSMNTGetProductBySkuInfoResModel.self)
//    }
    
    /// 获取店铺列表(根据区域ID和关键字) 此接口返回的距离请无视此字段
    static func getShopListByRegion(_ parameters: XQSMNTGetShopListByRegionReqModel) -> Observable<XQSMNTGetOpeningShopResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShop/GetShopListByRegion", parameters: parameters, resultType: XQSMNTGetOpeningShopResModel.self)
    }
    
    /// 下单
    static func beginOrder(_ parameters: XQSMNTBeginOrderReqModel) -> Observable<XQSMNTPreOrderResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShop/BeginOrder", parameters: parameters, resultType: XQSMNTPreOrderResModel.self)
    }
    
    /// static func preOrder(_ parameters: XQSMNTPreOrderReqModel) -> Observable<XQSMNTPreOrderResModel> {
    /// 计算价格, 改成和下单一样的 model 了
    static func preOrder(_ parameters: XQSMNTBeginOrderReqModel) -> Observable<XQSMNTPreOrderResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShop/PreOrder", parameters: parameters, resultType: XQSMNTPreOrderResModel.self)
    }
    
    /// 计算价格, 改成和下单一样的 model 了
//    static func preOrderV2(_ parameters: XQSMNTBeginOrderReqModel) -> Observable<XQSMNTPreOrderResModel> {
//        return XQSMBaseNetwork.default.post("/api/ToShop/PreOrderV2", parameters: parameters, resultType: XQSMNTPreOrderResModel.self)
//    }
    
    /// 获取外卖可用红包列表
    static func getCanUseRedPackage(_ parameters: XQSMNTGetCanUseRedPackageReqModel) -> Observable<XQSMNTMyCouponListResModel> {
        return XQSMBaseNetwork.default.post("/api/ToShop/GetCanUseRedPackage", parameters: parameters, resultType: XQSMNTMyCouponListResModel.self)
    }
    
    /// 获取店铺的预约时间（包含不可预约）
    static func getShopOrderTime(_ parameters: XQSMNTToShopGetShopOrderTimeReqModel) -> Observable<XQSMNTToShopGetShopOrderTimeResModel> {
        return XQSMBaseNetwork.default.get("/api/ToShop/GetShopOrderTime", parameters: parameters, resultType: XQSMNTToShopGetShopOrderTimeResModel.self)
    }
    
    
}


struct XQSMNTGetClosestShopReqModel: HandyJSON {
    /// 纬度 X (number, optional): lat ,
    var X: Float = 0
    /// 经度 Y (number, optional): lng ,
    var Y: Float = 0
    
}

struct XQSMNTGetClosestShopResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ShopInfo (ToShopIndexDto, optional): 店铺信息 ,
    var ShopInfo: XQSMNTToShopIndexModel?
}

struct XQSMNTGetOpeningShopResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ShopList (ToShopIndexDto, optional): 店铺信息 ,
    var ShopList: [XQSMNTToShopIndexModel]?
}

struct XQSMNTToShopIndexModel: HandyJSON, XQUserDefaultSaveModelProtocol {
    
    static var UserDefaultSaveModelProtocolkey_: String = "xq_XQSMNTToShopIndexModel"
    
    /// Id (integer, optional): 外卖店铺Id ,
    var Id: Int = 0
    /// Name (string, optional): 店铺名称 ,
    var Name: String = ""
    /// Address (string, optional): 具体地址 ,
    var Address: String = ""
    /// Logo (string, optional): LOGO图 ,
    var Logo: String = ""
    /// Logo (string, optional): LOGO图 ,
    var LogoWithAddress: String = ""
    /// X (string, optional): 定位X ,
    var X: String = ""
    /// Y (string, optional): 定位Y ,
    var Y: String = ""
    /// TheDistance (number, optional): 当前离你有多少公里 ,
    var TheDistance: Float = 0
    /// WorkingTimeList (Array[ToShopWorkingTimeDto], optional): 工作时间列表
    var WorkingTimeList: [XQSMNTToShopWorkingTimeModel]?
    
    /// OutMaxAreas (number, optional): 外送最大公里数 ,
//    var OutMaxAreas: Float = 0
    
    
    /// 自定义属性, true 表示当前已选中这个店铺
    var xq_select: Bool = false
    
}

/// 遵守这个协议, 可以直接实现本地 UserDefaults 存储
protocol XQUserDefaultSaveModelProtocol where Self:HandyJSON {
    /// 保存到本地的key
    static var UserDefaultSaveModelProtocolkey_: String { get }
    
    /// 获取本地存储的用户信息
    static func xq_getModel() -> Self?
    
    /// 获取本地存储的用户信息
    static func xq_setModel(_ model: Self)
    
    /// 获取本地存储的用户信息
    static func xq_removeModel()
    
}

extension XQUserDefaultSaveModelProtocol {
    /// 获取本地存储的信息
    static func xq_getModel() -> Self? {
        let model = UserDefaults.standard.dictionary(forKey: self.UserDefaultSaveModelProtocolkey_)
        if let userModel = Self.deserialize(from: model) {
            return userModel
        }
        return nil
    }
    
    /// 获取本地存储的信息
    static func xq_setModel(_ model: Self) {
        UserDefaults.standard.setValue(model.toJSON(), forKey: self.UserDefaultSaveModelProtocolkey_)
    }
    
    /// 获取本地存储的信息
    static func xq_removeModel() {
        UserDefaults.standard.removeObject(forKey: self.UserDefaultSaveModelProtocolkey_)
    }
}

struct XQSMNTToShopWorkingTimeModel: HandyJSON {
    
    /// ShopId (integer, optional): 店铺Id ,
    var ShopId: Int = 0
    /// BeginTime (string, optional): 开始时间 ,
    var BeginTime: String = ""
    /// EndTime (string, optional): 结束时间
    var EndTime: String = ""
    
}

struct XQSMNTGetAllShopInfoWithProductReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// ShopId (integer, optional): 店铺Id ,
    var ShopId: Int = 0
}


class XQSMNTGetAllShopInfoWithProductResModel: NSObject, XQSMNTBaseResModelProtocol {
    
    required override init() {
        super.init()
    }
    
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ShopItem (ShopInfoDto, optional): 店铺基本信息 ,
    var ShopItem: XQSMNTShopInfoModel?
    /// ShopCategory (Array[ToProductCategoryWithPdDto], optional): 商品分类信息 ,
    var ShopCategory: [XQSMNTToProductCategoryWithPdModel]?
}

class XQSMNTGetAllShopInfoWithProductV2ResModel: NSObject, XQSMNTBaseResModelProtocol {
    required override init() {
        super.init()
    }
    
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ShopItem (ShopInfoDto, optional): 店铺基本信息 ,
    var ShopItem: XQSMNTShopInfoModel?
    
    /// ShopCategory (Array[ToProductCategoryWithPdV2Dto], optional): 商品分类信息 ,
//    var ShopCategory: [XQSMNTToProductCategoryWithPdV2Model]?
    
    /// PackageList (Array[ToShopPdPackageDto], optional): 套餐列表 ,
    var PackageList: [XQSMNTToShopPdPackageModel]?
    
}

class XQSMNTToShopPdPackageModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): Id ,
    var Id: Int = 0
    
    /// PackageName (string, optional): 套餐名称 ,
    var PackageName: String = ""
    
    /// PrimePrice (number, optional): 成本价 ,
    var PrimePrice: Float = 0
    
    /// OldPrice (number, optional): 原价 ,
    var OldPrice: Float = 0
    
    /// NowPrice (number, optional): 现价 ,
    var NowPrice: Float = 0
    
    /// Descs (string, optional): 描述 ,
    var Descs: String = ""
    
    /// Photo (string, optional): 封面图片 ,
    var Photo: String = ""
    
    /// PhotoStr (string, optional, read only): 封面图片(带地址) ,
    var PhotoStr: String = ""
    
    /// DetailPhoto (string, optional): 详情图片 ,
    var DetailPhoto: String = ""
    
    /// DetailPhotoStr (string, optional, read only): 详情图片(带地址) ,
    var DetailPhotoStr: String = ""
    
    /// Creation (string, optional): 创建时间 ,
    var Creation: String = ""
    
    /// PackageDetails (Array[TinyPdPackageDetailDto], optional): 套餐包含详情 ,
    var PackageDetails: [XQSMNTTinyPdPackageDetailModel]?
    
    /// NoIncludePdList (Array[ToProductTinnyV2Dto], optional): 未包含的单品
    var NoIncludePdList: [XQSMNTToProductTinnyV2Model]?
    
}

class XQSMNTTinyPdPackageDetailModel: NSObject, HandyJSON {

    required override init() {
        super.init()
    }
    
    /// PId (integer, optional): 商品Id ,
    var PId: Int = 0
    
    /// PName (string, optional): 名称 ,
    var PName: String = ""
    
    /// PPrimePrice (number, optional): 成本价 ,
    var PPrimePrice: Float = 0
    
    /// POldPrice (number, optional): 原价 ,
    var POldPrice: Float = 0
    
    /// PNowPrice (number, optional): 现价 ,
    var PNowPrice: Float = 0
    
    /// PPhoto (string, optional): 图片 ,
    var PPhoto: String = ""
    
    /// PPhotoStr (string, optional, read only): 图片(带详细地址) ,
    var PPhotoStr: String = ""
    
    /// PDetailPhoto (string, optional): 详情图片 ,
    var PDetailPhoto: String = ""
    
    /// PDetailPhotoStr (string, optional, read only): 详情图片
    var PDetailPhotoStr: String = ""
    
    
}


class XQSMNTToProductTinnyV2Model: NSObject, HandyJSON {

    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): 商品Id ,
    var Id: Int = 0
    
    /// Name (string, optional): 商品名称 ,
    var Name: String = ""
    
    /// Photo (string, optional): 图片 ,
    var Photo: String = ""
    
    /// PhotoStr (string, optional, read only): 图片带完整地址 ,
    var PhotoStr: String = ""
    
    /// DetailPhoto (string, optional): 详情图片 ,
    var DetailPhoto: String = ""
    
    /// DetailPhotoStr (string, optional, read only): 详情图片带完整地址 ,
    var DetailPhotoStr: String = ""
    
    /// PrimePrice (number, optional): 成本价(参考价) ,
    var PrimePrice: Float = 0
    
    /// OldPrice (number, optional): 原价(参考价) ,
    var OldPrice: Float = 0
    
    /// NowPrice (number, optional): 现价(参考价)
    var NowPrice: Float = 0
    
}


class XQSMNTShopInfoModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): 店铺Id ,
    var Id: Int = 0
    /// BelongUid (integer, optional): 所属用户Id ,
    var BelongUid: Int = 0
    /// BelongUName (string, optional): 所属用户名称 ,
    var BelongUName: String? = ""
    /// Name (string, optional): 名称 ,
    var Name: String = ""
    /// Announce (string, optional): 公告 ,
    var Announce: String = ""
    /// Logo (string, optional): LOGO图 ,
    var Logo: String? = ""
    /// LogoStr (string, optional, read only): Logo带详细地址 ,
    var LogoStr: String = ""
    /// Address (string, optional): 具体地址 ,
    var Address: String? = ""
    /// Phone (string, optional): 商家电话 ,
    var Phone: String? = ""
    /// Mark1 (boolean, optional): 标签1 ,
    var Mark1: Bool = false
    /// Mark2 (boolean, optional): 标签2 ,
    var Mark2: Bool = false
    /// Mark3 (boolean, optional): 标签3 ,
    var Mark3: Bool = false
    /// IsChecked (boolean, optional): 是否审核 ,
    var IsChecked: Bool = false
    /// Creation (string, optional): 创建时间 ,
    var Creation: String = ""
    /// X (string, optional): 定位X ,
    var X: String = ""
    /// Y (string, optional): 定位Y ,
    var Y: String = ""
    /// OutMaxAreas (number, optional): 最远配送公里 ,
    var OutMaxAreas: Float = 0
    /// SendPrice (number, optional): 配送费 ,
    var SendPrice: Float = 0
    /// WorkingTimeList (Array[ToShopWorkingTimeDto], optional): 工作时间列表 ,
    var WorkingTimeList: [XQSMNTToShopWorkingTimeModel]?
    /// SendTimeList (Array[ToShopWorkingTimeDto], optional): 外送时间列表 ,
    var SendTimeList: [XQSMNTToShopWorkingTimeModel]?
    /// OrderTimeList (Array[ToShopWorkingTimeDto], optional): 预约时间列表 ,
    var OrderTimeList: [XQSMNTToShopWorkingTimeModel]?
    /// BannerList (Array[ToShopBannerTinnyDto], optional): 轮播图列表
    var BannerList: [XQSMNTToShopBannerTinnyModel]?
    
    /// RegionId (integer, optional): 区域Id ,
    var RegionId: Int = 0
    
    /// Kilometre (integer, optional): 基础公里数 ,
    var Kilometre: Int = 0
    
    /// StartingPrice (number, optional): 接送初始金额 ,
    var StartingPrice: Float = 0
    
    /// Perkilometre (number, optional): 每公里多加费用 ,
    var Perkilometre: Float = 0
    
}

class XQSMNTToProductCategoryWithPdModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): 分类 Id ,
    var Id: Int = 0
    /// Name (string, optional): 名称 ,
    var Name: String = ""
    /// PId (integer, optional): 父id ,
    var PId: Int = 0
    /// SortNum (integer, optional): 排序号 ,
    var SortNum: Int = 0
    /// ProductList (Array[ToProductTinnyDto], optional): 商品列表
    var ProductList: [XQSMNTToProductTinnyModel]?
}

class XQSMNTToProductCategoryWithPdV2Model: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): 分类 Id ,
    var Id: Int = 0
    /// Name (string, optional): 名称 ,
    var Name: String = ""
    /// PId (integer, optional): 父id ,
    var PId: Int = 0
    /// SortNum (integer, optional): 排序号 ,
    var SortNum: Int = 0
    /// ProductList (Array[ToProductTinnyDto], optional): 商品列表
    var ProductList: [XQSMNTToProductTinnyV2Model]?
}

struct XQSMNTToShopBannerTinnyModel: HandyJSON {
    /// Photo (string, optional): 图片 ,
    var Photo: String = ""
    /// PhotoWithAddress (string, optional, read only): 图片带具体目录
    var PhotoWithAddress: String = ""
}

class XQSMNTToProductTinnyModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// Id (integer, optional): Id ,
    var Id: Int = 0
    /// PrimePrice (number, optional): 商品成本价 ,
    var PrimePrice: Float = 0
    /// OldPrice (number, optional): 商品原价 ,
    var OldPrice: Float = 0
    /// NowPrice (number, optional): 商品现价 ,
    var NowPrice: Float = 0
    /// IsExclude (boolean, optional): 是否与满减冲突 ,
    var IsExclude: Bool = false
    /// Photo (string, optional): 图片 ,
    var Photo: String = ""
    /// PhotoStr (string, optional, read only): 图片带完整地址 ,
    var PhotoStr: String = ""
    /// Discount (number, optional): 折扣值,单位 折.如返回的是4.5，表示的就是4.5折 ,
    var Discount: Float = 0
    /// PackagePrice (number, optional): 打包费 ,
    var PackagePrice: Float = 0
    /// StockNum (integer, optional): 库存量 ,
    var StockNum: Int = 0
    /// BelongCateId (integer, optional): 所属商品分类Id
    var BelongCateId: Int = 0
    /// 商品名称
    var Name: String = ""
    
    
    /// 自定义属性, 当前选择了购买多少个
    var xq_select_number: Int = 0
}

class XQSMNTTempSkuItemModel: NSObject, HandyJSON {
    required override init() {
        super.init()
        
    }
    
    
    /// Name (string, optional): 名称 ,
    var Name: String = ""
    /// ChildSku (Array[TempChildSku], optional): 子规格
    var ChildSku: [XQSMNTTempChildSkuModel]?
    
    
}

class XQSMNTTempChildSkuModel: NSObject, HandyJSON {
    required override init() {
        super.init()
        
    }
    
    /// SkuValue (string, optional): 对应的值
    var SkuValue: String = ""
    
    /// 自定义属性
    var xq_select = false
}

struct XQSMNTGetShopListByRegionReqModel: HandyJSON {
    
    /// RegionId (integer, optional): 区域Id ,
    var RegionId: Int = 0
    
    /// Keyword (string, optional): 店铺名称搜索关键字(不传或为空就查全部)
    var Keyword: String = ""
    
    /// 纬度 X (number, optional): lat ,
    var X: Float = 0
    /// 经度 Y (number, optional): lng ,
    var Y: Float = 0
    
}

/// 配送模式
/// - selfTaking 自取
/// - takeOut 外卖
enum XQSMTakeOutFoodSendType: Int, HandyJSONEnum {
    case takeOut = 0
    case selfTaking = 1
}

struct XQSMNTBeginOrderReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// ShopId (integer, optional): 店铺Id ,
    var ShopId: Int = 0
    
    /// PetId (integer, optional): 宠物Id ,
    var PetId: Int = 0
    
    /// SubscribeTime (string, optional): 预约时间 ,
    /// 时间格式, yyyy-MM-dd HH:mm:ss
    var SubscribeTime: String = ""
    
    /// Phone (string, optional): 手机号 ,
    var Phone: String = ""
    /// Remark (string, optional): 备注 ,
    var Remark: String = ""
    
    /// PdList (Array[TinnyOrderProductInfo], optional): 商品列表
    var PdList = [XQSMNTTinnyOrderProductInfoModel]()

    /// SendAddress (string, optional): 接地名 ,
    var SendAddress: String = ""
    
    /// SendX (string, optional): 接的X ,
    var SendX: String = ""
    
    /// SendY (string, optional): 接的Y ,
    var SendY: String = ""
    
    /// SendBackAddress (string, optional): 送地名 ,
    var SendBackAddress: String = ""
    
    /// SendBackX (string, optional): 送的X ,
    var SendBackX: String = ""
    
    /// SendBackY (string, optional): 送的Y ,
    var SendBackY: String = ""
    
    /// ManName (string, optional): 预约人 ,
    var ManName: String = ""
    
    /// PackageId (integer, optional): 套餐Id ,
    var PackageId: String = ""
    
    /// NeedSend (boolean, optional): 是否需接送到店 ,
    var NeedSend = false
    
    /// NeedSendBack (boolean, optional): 是否需接送回家 ,
    var NeedSendBack = false
    
    /// ChoseUserRank (boolean, optional): 是否选择等级优惠 ,
    var ChoseUserRank = false
    
    /// CouponId (integer, optional): 优惠券Id ,
    var CouponId = 0
    
    /// ChoseTrueMan (boolean, optional): 选择实名认证优惠
    var ChoseTrueMan = false
    
}


struct XQSMNTTinnyOrderProductInfoModel: HandyJSON {
    
    /// Id (integer, optional): 商品Id ,
    var Id: Int = 0
    /// BuyNum (integer, optional): 购买数量
//    var BuyNum: Int = 0
    
}


struct XQSMNTPreOrderReqModel: HandyJSON {
    /// ShopId (integer, optional): 店铺Id ,
    var ShopId: Int = 0
    /// PdList (Array[TinnyOrderProductInfo], optional): 商品列表
    var PdList = [XQSMNTTinnyOrderProductInfoModel]()
}

// 用这个 XQSMNTBeginOrderReqModel 就行了
//struct XQSMNTPreOrderV2ReqModel: XQSMNTBaseReqModelProtocol {
//
//
//    /// ShopId (integer, optional): 店铺Id ,
//    var ShopId: Int = 0
//    /// PdList (Array[TinnyOrderProductInfo], optional): 商品列表
//    var PdList = [XQSMNTTinnyOrderProductInfoModel]()
//
//    /// RedPackageId (integer, optional): 红包Id ,
//    var RedPackageId: Int = 0
//
//    /// ReceiveAddressId (integer, optional): 收货地址Id ,
//    var ReceiveAddressId: Int = 0
//
//    /// SendType (integer, optional): 收货类型（0为店家送，1为自取） ,
//    var SendType: XQSMTakeOutFoodSendType = .takeOut
//
//    /// Phone (string, optional): 手机号，自取的时候传此字段 ,
//    var Phone: String = ""
//
//    /// Remark (string, optional): 备注 ,
//    var Remark: String = ""
//}

struct XQSMNTPreOrderResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// OId (integer, optional): 使用的订单Id ,
    var OId: Int = 0
    /// OSN (string, optional): 订单编号 ,
    var OSN: String = ""
    /// OldPrice (number, optional): 原价 ,
    var OldPrice: Float = 0
    
    /// TotalPrice (number, optional): 最终金额 ,
    var TotalPrice: Float = 0
    
    /// TotalSendPrice (number, optional): 送到店费用 ,
    var TotalSendPrice: Float = 0
    
    /// TotalSendBackPrice (number, optional): 送回费用 ,
    var TotalSendBackPrice: Float = 0
    
    /// OldTotalPrice (number, optional): 原套餐和单品总价 ,
    var OldTotalPrice: Float = 0
    
    /// TrueManPrice (number, optional): 实名认证优惠金额 ,
    var TrueManPrice: Float = 0
    
    /// UserRankDiscountPrice (number, optional): 用户等级折扣金额 ,
    var UserRankDiscountPrice: Float = 0
    
    /// CouponPrice (number, optional): 优惠券抵扣 ,
    var CouponPrice: Float = 0
    
}

struct XQSMNTCanNotOrderProductInfoModel: HandyJSON {
    /// Id (integer, optional): 商品Id ,
    var Id: Int = 0
    /// Reson (string, optional): 不可计算原因
    var Reson: String = ""
}


struct XQSMNTTinyShopGiftWithPurchaseModel: HandyJSON {
    /// BeginPrice (number, optional): 开始价格 ,
    var BeginPrice: Float = 0
    /// DiscountPrice (number, optional): 优惠金额
    var DiscountPrice: Float = 0
}





struct XQSMNTGetProductBySkuInfoReqModel: XQSMNTBaseReqModelProtocol {
    
    
    
    /// PId (integer, optional): 商品Id ,
    var PId: Int = 0
    
    /// SkuInfos (Array[SkuInfoDto], optional): Sku参数列表 ,
    var SkuInfos: [XQSMNTSkuInfoModel]?
    
}

struct XQSMNTSkuInfoModel: HandyJSON {
    
    /// SkuName (string, optional): Sku名称 ,
    var SkuName: String = ""
    
    /// SkuValue (string, optional): Sku值
    var SkuValue: String = ""
    
}


class XQSMNTGetProductBySkuInfoResModel: NSObject, XQSMNTBaseResModelProtocol {

    required override init() {
        super.init()
    }

    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// PId (integer, optional): 商品Id ,
    var PId: Int = 0
    /// SkuId (integer, optional): SkuId ,
    var SkuId: Int = 0
    /// PrimePrice (number, optional): 成本价 ,
    var PrimePrice: Float = 0
    /// OldPrice (number, optional): 原价 ,
    var OldPrice: Float = 0
    /// NowPrice (number, optional): 现价 ,
    var NowPrice: Float = 0
    /// PackagePrice (number, optional): 打包费 ,
    var PackagePrice: Float = 0
    /// SkuInfos (Array[SkuInfoDto], optional): Sku参数列表 ,
    var SkuInfos: [XQSMNTSkuInfoModel]?
    
}



struct XQSMNTGetCanUseRedPackageReqModel: XQSMNTBaseReqModelProtocol {
    
    
    
    /// PdList (Array[TinnyOrderProductInfo], optional): 商品列表
    var PdList: [XQSMNTTinnyOrderProductInfoModel]?
}


struct XQSMNTMyCouponListResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// CouponList (Array[UserCouponInfoDto], optional): 优惠劵列表 ,
    var CouponList: [XQSMNTUserCouponInfoModel]?
    
}


struct XQSMNTUserCouponInfoModel: HandyJSON {
    

    /// CouponId (integer, optional): 优惠劵id ,
    var CouponId: Int = 0
    
    /// OId (integer, optional): 使用的订单Id ,
    var OId: Int = 0
    
    /// CouponSN (string, optional): 优惠劵编号 ,
    var CouponSN: String = ""
    
    /// CouponTypeId (integer, optional): 优惠劵类型id ,
    var CouponTypeId: Int = 0
    
    /// CouponName (string, optional): 优惠劵名 ,
    var CouponName: String = ""
    
    /// UseTime (string, optional): 使用时间 ,
    var UseTime: String = ""
    
    /// Money (number, optional): 金额 ,
    var Money: Float = 0
    
    /// MiniMoney (number, optional): 最小起用金（只有红包才用此字段） ,
    var MiniMoney: Float = 0
    
    /// ActivateTime (string, optional): 领取时间 ,
    var ActivateTime: String = ""
    
    /// CreateTime (string, optional): 创建时间 ,
    var CreateTime: String = ""
    
    /// StartTime (string, optional): 优惠劵使用开始时间 ,
    var StartTime: String = ""
    
    /// EndTime (string, optional): 优惠劵过期 ,
    var EndTime: String = ""
    
    /// StateInt (integer, optional, read only): 状态(1可用，0不可用) ,
    var StateInt: Int = 0
    
    /// StateStr (string, optional, read only): 状态中文描述
    var StateStr: String = ""
    
}


struct XQSMNTLevelInfoModel: HandyJSON {
    /// levelId (integer, optional): 等级id ,
    var levelId: Int = 0
    /// levelName (string, optional): 等级名称 ,
    var levelName: String = ""
    /// percentAge (number, optional): 分红百分比 ,
    var percentAge: Float = 0
    /// askForMoney (number, optional): 申请费用 ,
    var askForMoney: Float = 0
    /// displayOrder (integer, optional): 排序 ,
    var displayOrder: Int = 0
    /// remark (string, optional): 描述 ,
    var remark: String = ""
    /// setTime (string, optional): 设置时间
    var setTime: String = ""
}


struct XQSMNTToShopGetShopOrderTimeReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 商店 id
    var shopId = 0
    
    /// 多少天
    var theDateCount = 5
    
}

struct XQSMNTToShopGetShopOrderTimeResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// Lss (Array[TempDt], optional): 时间点列表 ,
    var Lss: [XQSMNTToShopTempModel]?
    
}

extension XQSMNTToShopGetShopOrderTimeResModel {
    /// 获取默认的选择
    ///   - count: 可用的第几个, 默认为第一个(0)
    static func getNormalSelectIndexPath(_ dataArr: [XQSMNTToShopTempModel], count: Int = 0) -> (day: Int, hour: Int, minute: Int, model: XQSMNTToShopTempModel)? {
        
        if dataArr.count == 0 {
            return nil
        }
        
        var cCount = count
        
        for (section, item) in dataArr.enumerated() {
            // 天
            if !item.IsVisibled {
                continue
            }
            
            let timeList = item.TimeList ?? []
            
            for (row, rItem) in timeList.enumerated() {
                // 小时
                if !rItem.IsVisibled {
                    continue
                }
                
                let smallTimes = rItem.SmallTimes ?? []
                for (dRow, dItem) in smallTimes.enumerated() {
                    // 具体多少点
                    if !dItem.IsVisibled {
                        continue
                    }
                    
                    if cCount <= 0 {
                        return (section, row, dRow, item)
                    }
                    
                    cCount -= 1
                }
                
            }
            
        }
        
        return nil
    }
}

struct XQSMNTToShopTempModel: HandyJSON {
    
    /// TheYear (string, optional): 年 ,
    var TheYear = ""
    
    /// TheMonth (string, optional): 月 ,
    var TheMonth = ""
    
    /// TheDay (string, optional): 日 ,
    var TheDay = ""
    
    /// TheDate (string, optional): 具体几号 ,
    var TheDate = ""
    
    /// DateDesc (string, optional): 今天，明天，后天，周X ,
    var DateDesc = ""
    
    /// IsVisibled (boolean, optional): 是否可点 ,
    var IsVisibled = false
    
    /// TimeList (Array[TempTimeDto], optional): 具体小时列表
    var TimeList: [XQSMNTToShopTempTimeModel]?
    
}

class XQSMNTToShopTempTimeModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// TimeTitle (string, optional): 时间点,比如：10:00 ,
    var TimeTitle = ""
    
    /// TheHour (string, optional): 小时位 ,
    var TheHour = ""
    
    /// ITheHour (integer, optional): 小时位(int) ,
    var ITheHour = 0
    
    /// IsVisibled (boolean, optional): 是否可点 ,
    var IsVisibled = false
    
    /// SmallTimes (Array[TempDetailTimeDto], optional): 具体分钟列表
    var SmallTimes: [XQSMNTToShopTempDetailTimeModel]?
    
}

struct XQSMNTToShopTempDetailTimeModel: HandyJSON {
    
    /// TimeTitle (string, optional): 具体的时间点 ,
    var TimeTitle = ""
    
    /// TheMin (string, optional): 分钟数 ,
    var TheMin = ""
    
    /// ITheMin (integer, optional): 分钟数(int) ,
    var ITheMin = 0
    
    /// IsVisibled (boolean, optional): 是否可点
    var IsVisibled = false
    
    
}





