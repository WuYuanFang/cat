//
//  XQSMAroundShopNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/5.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

/// 商城
struct XQSMAroundShopNetwork {
    
    /// 商城首页条件搜索（带分页功能）
    static func search(_ parameters: XQSMNTSearchKeyReqModel) -> Observable<XQSMNTSearchKeyResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/Search", parameters: parameters, resultType: XQSMNTSearchKeyResModel.self)
    }
    
    
    /// 获取商品分类第一级菜单
    static func getTopMenuList(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTAroundShopTopMenuListResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/GetTopMenuList", parameters: parameters, resultType: XQSMNTAroundShopTopMenuListResModel.self)
    }
    
    
    /// 获取商品分类二级或三级菜单
    static func getSecOrThrMenuList(_ parameters: XQSMNTSecOrThrMenuReqModel) -> Observable<XQSMNTAroundShopTopMenuListResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/GetSecOrThrMenuList", parameters: parameters, resultType: XQSMNTAroundShopTopMenuListResModel.self)
    }
    
    /// 根据分类id获取所有商品
//    static func productBycateId(_ parameters: XQSMNTproductBycateIdReqModel) -> Observable<XQSMNTGetProductResModel> {
//        return XQSMBaseNetwork.default.post("/api/AroundShop/ProductBycateId", parameters: parameters, resultType: XQSMNTGetProductResModel.self)
//    }
    
    /// 获取商品(分页,带产品分类
    static func productsWithPage(_ parameters: XQSMNTGetProductReqModel) -> Observable<XQSMNTGetProductResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/ProductsWithPage", parameters: parameters, resultType: XQSMNTGetProductResModel.self)
    }
    
    /// 获取周边商城的轮播新闻
    static func aroundShopNews(_ parameters: XQSMNTBaseReqModel?) -> Observable<XQSMNTAroundShopNewResModel> {
        return XQSMBaseNetwork.default.get("/api/AroundShop/AroundShopNews", resultType: XQSMNTAroundShopNewResModel.self)
///     return XQSMBaseNetwork.default.post("/api/AroundShop/AroundShopNews", parameters: parameters, resultType: XQSMNTAroundShopNewResModel.self)
    }
    
    /// （导航菜单） 获取商品分类
//    static func productClassify(_ parameters: XQSMNTBaseReqModel?) -> Observable<XQSMNTAroundShopProductClassifyResModel> {
//        return XQSMBaseNetwork.default.get("/api/AroundShop/ProductClassify", resultType: XQSMNTAroundShopProductClassifyResModel.self)
//    }
    
    /// 商城轮播新闻查看
    static func clickNewsLink(_ parameters: XQSMNTClickNewsLinkReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/ClickNewsLink", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 商品详情
    static func productInfo(_ parameters: XQSMNTProductInfoReqModel) -> Observable<XQSMNTProductInfosResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/ProductInfo", parameters: parameters, resultType: XQSMNTProductInfosResModel.self)
    }
    
    /// 更换勾选具体规格参数触发
    static func attOnChangeEvent(_ parameters: XQSMNTAttOnChangeEventReqModel) -> Observable<XQSMNTAttResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/AttOnChangeEvent", parameters: parameters, resultType: XQSMNTAttResModel.self)
    }
    
    /// 查看某商品所有评论
    static func getProductReviews(_ parameters: XQSMNTProductInfoReqModel) -> Observable<XQSMNTAroundShopProductReviewsResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/GetProductReviews", parameters: parameters, resultType: XQSMNTAroundShopProductReviewsResModel.self)
    }
    
    /// 具体商品规格显示
    static func chanceAttribute(_ parameters: XQSMNTSearchKeyReqModel) -> Observable<XQSMNTSearchKeyResModel> {
        // 未完成接口
        return XQSMBaseNetwork.default.post("/api/AroundShop/ChanceAttribute", parameters: parameters, resultType: XQSMNTSearchKeyResModel.self)
    }
    
    /// 商城申请退款
    static func aroundShopRefundToOrder(_ parameters: XQSMNTAroundShopRefundToOrderReqModel) -> Observable<XQSMNTOrderRefundToOrderResModel> {
        
        var imgDataArr = [Data]()
        
        for item in parameters.imgArr ?? [] {
            if let data = item.jpegData(compressionQuality: 0.5) {
                imgDataArr.append(data)
            }
        }
        
        return XQSMBaseNetwork.default.uploadImage_1("/api/AroundShop/AroundShopRefundToOrder", datas: imgDataArr, params: parameters, resultType: XQSMNTOrderRefundToOrderResModel.self)
        
//        return XQSMBaseNetwork.default.post("/api/AroundShop/AroundShopRefundToOrder", parameters: parameters, resultType: XQSMNTOrderRefundToOrderResModel.self)
    }
    
    /// 获取品牌
    static func getAllBrand(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTAroundShopGetAllBrandResModel> {
        return XQSMBaseNetwork.default.post("/api/AroundShop/GetAllBrand", parameters: parameters, resultType: XQSMNTAroundShopGetAllBrandResModel.self)
    }
    
}


struct XQSMNTSearchKeyReqModel: XQSMNTBaseReqModelProtocol {
    
    /// Key (string, optional): 搜索关键字 ,
    var key: String = ""
    /// pageSize (integer, optional): 每页数 ,
    var pageSize: Int = 0
    /// pageNumber (integer, optional): 当前页 ,
    var pageNumber: Int = 10
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.key <-- "Key"
    }
}

struct XQSMNTPageReqModel: XQSMNTBaseReqModelProtocol {
    
    /// pageSize (integer, optional): 每页数 ,
    var pageSize: Int = 0
    /// pageNumber (integer, optional): 当前页 ,
    var pageNumber: Int = 10
}

struct XQSMNTProductInfoReqModel: HandyJSON {
    /// "pid":商品id（int）
    var PId: Int = 0
}

class XQSMNTProductInfosResModel: NSObject, XQSMNTBaseResModelProtocol {
    required override init() {
        super.init()
    }
    
    var ErrCode: XQSMNTErrorCode = .succeed
    var ErrMsg: String?
    
    /// ProductInfo (ProductInfoModel, optional),
    var ProductInfo: XQSMNTProductInfoModel?
}

class XQSMNTProductInfoModel: NSObject, HandyJSON {
    required override init() {
        super.init()
    }
    
    /// pid (integer, optional): 商品id ,
    var PId: Int = 0
    
    /// SkuGId (integer, optional): 商品Sku组Id ,
    var SkuGId: Int = 0
    
    /// shopprice (number, optional): 本店价格 ,
    var ShopPrice: Float = 0
    
    /// MarketPrice (number, optional): 划掉的价格（市场价） ,
    var MarketPrice: Float = 0

    /// name (string, optional): 商品名称 ,
    var Name: String = ""
    
    /// ShortDesc (string, optional): 简介 ,
    var ShortDesc: String = ""

    /// salecount (integer, optional): 销量 ,
    var SaleCount: Int = 0

    /// reviewcount (integer, optional): 评价数量 ,
    var ReviewCount: Int = 0
    
    /// GoodPercent (number, optional): 好评率(返回90为90%好评率) ,
    var GoodPercent: Float = 0

    /// weight (integer, optional): 重量 ,
    var Weight: Int = 0

    /// description (string, optional): 产品信息 , h5
    var xq_description: String = ""

    /// number (integer, optional): 库存 ,
    var Number: Int = 0
    
    /// imgs (Array[images], optional): 图片类 ,
    var Imgs: [XQSMNTImagesModel]?

    /// attrList (Array[AttList], optional): 规格属性集合
    var AttrList: [XQSMNTAttListModel]?
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.xq_description <-- "Description"
    }

}

struct XQSMNTImagesModel: HandyJSON {
    /// pimgid (integer, optional): 图片id ,
    var PimgId: Int = 0
    /// showimg (string, optional): 图片路径 ,
    var ShowImg: String = ""
    /// ShowImg (string, optional, read only): app显示用此字段 ,
    var ShowImgWithAddress: String = ""
    /// ismain (integer, optional): 是否是主图片（0为否 1为是）
    var IsMain: Int = 0

}

class XQSMNTAttListModel: NSObject, HandyJSON {
    required override init() {
        super.init()
    }
    
    /// attrid (integer, optional): 属性Id ,
    var AttrId: Int = 0
    /// name (string, optional): 属性名 ,
    var Name: String = ""
    /// attValues (Array[AttValue], optional): 属性值集合类
    @objc var AttValues: [XQSMNTAttValueModel]?
    
}

class XQSMNTAttValueModel: NSObject, HandyJSON {
    required override init() {
        super.init()
    }
    
    /// attrvalueid (integer, optional): 属性值id ,
    var AttrValueId: Int = 0
    /// attrvalue (string, optional): 属性值名
    var AttrValue: String = ""
    
    /// CurrentPdSelected (boolean, optional): 当前商品的选中
    @objc var CurrentPdSelected = false
    
}



struct XQSMNTProductModel: HandyJSON {
    
    /// pid (integer, optional): 商品Id ,
    var PId: Int = 0
    /// psn (string, optional): 商品编号 ,
    var PSn: String = ""
    /// cateid (integer, optional): 分类id ,
    var CateId: Int = 0
    /// brandid (integer, optional): 品牌Id ,
    var BrandId: Int = 0
    /// 原 skuid, 后改成 skugid (integer, optional): sku组id ,
    var SkuGId: Int = 0
    /// name (string, optional): 商品名称 ,
    var Name: String = ""
    /// shopprice (number, optional): 商城价 ,\
    var ShopPrice: Float = 0
    /// state (integer, optional): 状态 0代表上架 1代表下架 ,
    var State: Int = 0
    /// showimg (string, optional): 主图 ,
    var ShowImg: String = ""
    /// ShowImgWithAddress (string, optional, read only): 主图带地址的 ,
    var ShowImgWithAddress: String = ""
    /// salecount (integer, optional): 销售数量
    var SaleCount: Int = 0
    
    /// 自定义属性
    var xq_imgSize: CGSize?
    
    mutating func mapping(mapper: HelpingMapper) {
        // 忽略
        mapper >>> self.xq_imgSize
    }
}

struct XQSMNTSearchKeyResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    var ErrMsg: String?
    /// products (Array[product], optional),
    var products: [XQSMNTProductModel]?
}

struct XQSMNTAroundShopNewResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// lss (Array[AroundShopNewModel], optional),
    var Lss: [XQSMNTAroundShopNewModel]?
    
}

struct XQSMNTAroundShopNewModel: HandyJSON {
    
    /// adid (integer, optional): 广告id ,
    var AdId: Int = 0
    /// url (string, optional): 广告链接地址 ,
    var Url: String = ""
    /// image (string, optional, read only): 广告图片
    var Image: String = ""
    /// image (string, optional, read only): 广告图片
    var ImageWithAddress: String = ""
    
}

struct XQSMNTAroundShopTopMenuListResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// MenuList (Array[AroundShopNewModel], optional),
    var MenuList: [XQSMNTAroundShopTopMenuModel]?
    
}

struct XQSMNTAroundShopProductClassifyResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// lss (Array[AroundShopNewModel], optional),
    var productClassifys: [XQSMNTAroundShopTopMenuModel]?
    
}

struct XQSMNTAroundShopTopMenuModel: HandyJSON {
    
    /// 分类id
    var CateId: Int = 0
    /// 分类名称
    var Name: String = ""
    /// 父类id
    var ParentId: String = ""
    /// DisplayOrder (integer, optional): 显示等级
    var DisplayOrder: String = ""
    
}

struct XQSMNTSecOrThrMenuReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 分类 id
    var CateId: Int = 0
}

struct XQSMNTproductBycateIdReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 分类 id
    var cateid: Int = 0
    /// 第几页
    var pageNumber: Int = 0
    /// 分页大小
    var pageSize: Int = 10
}

struct XQSMNTGetProductReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 排序方式
    enum XQSMNTGetProductReqModelSortType: String, HandyJSONEnum {
        /// 价格高到低
        case priceHighToLow = "PD"
        /// 价格低到高
        case priceLowToHigh = "PU"
        /// 销量(默认)
        case salesVolume = "S"
    }
    
    /// 查看类型
    enum XQSMNTGetProductReqModelShowType: Int, HandyJSONEnum {
        /// 所有
        case all = 0
        /// 有活动的
        case discount = 1
        /// 有货
        case inStock = 2
    }
    
    
    
    /// CateId (integer, optional): 分类id(如果传0为查全部) ,
    var CateId: Int? = 0
    /// 第几页
    var PageNumber: Int = 0
    /// 分页大小
    var PageSize: Int = 10
    /// KeyWord (string, optional): 关键字 ,
    var KeyWord: String?
    
    
    /// SortType (string, optional): 排序方式 不传默认销量 PD:价格由高到低 PU:价格由底到高 S:销量 ,
    var SortType: XQSMNTGetProductReqModelSortType? = .salesVolume
    
    /// ShowType (integer, optional): 查看类型 0:所有 1:只看有活动的 2:只看有货的 ,
    var ShowType: XQSMNTGetProductReqModelShowType? = .all
    
    /// TheMaxPrice (integer, optional): 最高价格 ,
    var TheMaxPrice: Int?
    
    /// TheMinPrice (integer, optional): 最低价格 ,
    var TheMinPrice: Int?
    
    /// BrandId (integer, optional): 品牌Id(0为所有品牌) ,
    var BrandId: Int?
}


struct XQSMNTGetProductResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ProductList (Array[AroundShopProduct], optional): 商品列表 ,
    var ProductList: [XQSMNTProductModel]?
    
    /// TotalCount (integer, optional): 总数量 ,
    var TotalCount = 0
    
    
}

struct XQSMNTClickNewsLinkReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 广告 id
    var adid: Int = 0
}

struct XQSMNTAttOnChangeEventReqModel: HandyJSON {
    /// 选中的属性
    /// "skugid":商品skugid(int),
    var SkuGId: Int = 0
    /// Lss:[{"attrid":属性Id(int),"attrvalueid":属性值id(int)}]}
    var Lss = [XQSMNTAttValueReqModel]()
}

struct XQSMNTAttValueReqModel: HandyJSON {
    /// {"attrid":属性Id(int),
    var AttrId: Int = 0
    /// "attrvalueid":属性值id(int)}
    var AttrValueId: Int = 0
}

struct XQSMNTAttResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// ProductInfo (ProductInfoModel, optional): 商品 ,
    var ProductInfo: XQSMNTProductInfoModel?
    
}

struct XQSMNTNewPidNumberModel: HandyJSON {
    /// pid (integer, optional): 新的商品id ,
    var pid: Int = 0
    /// number (integer, optional): 库存
    var number: Int = 0
}


struct XQSMNTAroundShopRefundToOrderReqModel: XQSMNTBaseReqModelProtocol {

    

    /// ProductList:退款商品列表（对应的列表需要转成json）
    /// "{\"PId\": 13,\"PPrice\": 99,\"Num\": 2,\"recordid\":100}"
    var ProductList: String = ""
    /// 商品id
    var OId: Int = 0
    /// 退款总金额
    var RefundPrice: Float = 0
    /// 备注
    var Remark: String = ""
    
    /// 上传的图片数组
    /// 目前限制 1 ~ 3 张
    var imgArr = [UIImage]()
    
    mutating func mapping(mapper: HelpingMapper) {
        // 忽略属性
        mapper >>> self.imgArr
    }
    
    // 商品列表
    struct XQSMNTAroundShopRefundToOrderProductModel: HandyJSON {
        /// PId:商品Id
        var PId: Int = 0
        /// PPrice:商品退款金额单价（直接将查到的数据传过来）
        var PPrice: Float = 0
        /// Num:退款数量
        var Num: Int = 0
        /// recordid:记录id（直接将查到的数据传过来）
        var recordid: Int = 0
    }

}


struct XQSMNTAroundShopProductReviewsResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// Reviews (Array[ProductReviewsModel], optional): 评价列表 ,
    var Reviews = [XQSMNTAroundShopProductReviewsModel]()
}

struct XQSMNTAroundShopProductReviewsModel: HandyJSON {
    
    /// ReviewId (integer, optional): 评价Id ,
    var ReviewId = 0
    
    /// PId (integer, optional): 商品Id ,
    var PId = 0
    
    /// State (integer, optional): 状态,0待审核1通过审核 ,
    var State = 0
    
    /// Star (integer, optional): 评价星级 ,
    var Start = 0
    
    /// Message (string, optional): 评价 ,
    var Message = ""
    
    /// ReviewTime (string, optional): 评价时间 ,
    /// yyyy-MM-dd HH:mm:ss
    var ReviewTime = ""
    
    /// PName (string, optional): 商品名 ,
    var PName = ""
    
    /// PShowImg (string, optional): 商品图片 ,
    var PShowImg = ""
    
    /// PShowImgWithAddress (string, optional, read only): 商品图片(带地址) ,
    var PShowImgWithAddress = ""
    
    /// Photo1 (string, optional): Photo1 ,
    var Photo1 = ""
    
    /// Photo2 (string, optional): Photo2 ,
    var Photo2 = ""
    
    /// Photo3 (string, optional): Photo3 ,
    var Photo3 = ""
    
    /// Photo1WithAddress (string, optional, read only): 图片1（带地址） ,
    var Photo1WithAddress = ""
    
    /// Photo2WithAddress (string, optional, read only): 图片2（带地址） ,
    var Photo2WithAddress = ""
    
    /// Photo3WithAddress (string, optional, read only): 图片3（带地址） ,
    var Photo3WithAddress = ""
    
    /// NoShowName (integer, optional): 匿名 1为匿名，0为显示
    var NoShowName = 1
    
    /// UAvatar (string, optional): 用户头像 ,
    var UAvatar = ""
    
    /// UAvatarWithAddress (string, optional, read only): 用户头像(带地址) ,
    var UAvatarWithAddress = ""
    
    /// UName (string, optional): 用户名 ,
    var UName = ""
    
    /// 自定义属性, 年月日
    var xq_ReviewTime = ""
    
    /// 自定义属性, 图片url
    var imgArr = [URL]()
}

struct XQSMNTAroundShopGetAllBrandResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// BrandLss (Array[BrandInfo], optional): 品牌列表 ,
    var BrandLss = [XQSMNTAroundShopBrandInfoModel]()
}

struct XQSMNTAroundShopBrandInfoModel: HandyJSON {
    
    /// BrandId (integer, optional): 品牌id ,
    var BrandId: Int = 0
    
    /// DisplayOrder (integer, optional): 品牌排序 ,
    var DisplayOrder: Int = 0
    
    /// Name (string, optional): 品牌名称 ,
    var Name: String = ""
    
    /// Logo (string, optional): 品牌logo
    var Logo: String = ""
    
    
}





