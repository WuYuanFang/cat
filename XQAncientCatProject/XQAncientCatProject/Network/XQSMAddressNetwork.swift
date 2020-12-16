//
//  XQSMAddressNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/4.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQSMAddressNetwork {
    
    /// 获取我的收货地址
    static func getMyAllAddress(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTShopAddressResDtoModel> {
        return XQSMBaseNetwork.default.post("/api/ShopAddress/GetMyAllAddress", parameters: parameters, resultType: XQSMNTShopAddressResDtoModel.self)
    }
    
    /// 添加收货地址
    static func addAddress(_ parameters: XQSMNTAddAddressDtoReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/ShopAddress/AddAddress", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 编辑收货地址
    static func editAddress(_ parameters: XQSMNTAddAddressDtoReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/ShopAddress/EditAddress", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 删除收货地址
    static func deleteShopAddress(_ parameters: XQSMNTDeleteShopAddressReqModel) -> Observable<XQSMNTBaseResModel> {
        let url = "/api/ShopAddress/DeleteShopAddress" + "/" + parameters.SaId
        return XQSMBaseNetwork.default.get(url, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 设置默认地址
    static func setAddressDefault(_ parameters: XQSMNTSetAddressDefaultReqModel) -> Observable<XQSMNTBaseResModel> {
        var url = "/api/ShopAddress/SetAddressDefault"
        url = url + "?" + "shipId=" + String(parameters.shipId)
        return XQSMBaseNetwork.default.get(url, resultType: XQSMNTBaseResModel.self)
    }
    

}

struct XQSMNTShopAddressResDtoModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    var Lss: [XQSMNTShopAddressDtoModel]?
    
}

struct XQSMNTShopAddressDtoModel: HandyJSON {
    /// SaId (string, optional): 地址Id ,
    var SaId: String = ""
    /// Alias (string, optional): 别名 ,
    var Alias: String = ""
    /// Consignee (string, optional): 收件人 ,
    var Consignee: String = ""
    /// Mobile (string, optional): 收件人手机号 ,
    var Mobile: String = ""
    /// ZipCode (string, optional): 邮政编码 ,
    var ZipCode: String = ""
    /// Address (string, optional): 详细地址 ,
    var Address: String = ""
    /// ProvinceName (string, optional): 省名 ,
    var ProvinceName: String = ""
    /// ProvinceId (string, optional): 省Id ,
    var ProvinceId: String = ""
    /// CityName (string, optional): 市名 ,
    var CityName: String = ""
    /// CityId (string, optional): 市Id ,
    var CityId: String = ""
    /// AreaName (string, optional): 区名 ,
    var AreaName: String = ""
    /// AreaId (string, optional): 区Id ,
    var AreaId: String = ""
    /// IsDefault (boolean, optional): 是否默认地址
    var IsDefault: Bool = false
    /// X (string, optional): x lat , 纬度
    var X: String = ""
    /// Y (string, optional): y lng , 经度
    var Y: String = ""
    
}

struct XQSMNTAddAddressDtoReqModel: XQSMNTBaseReqModelProtocol {
    
    
    // 这个后面要添加什么省id, 市 id 吧？？？
    
    /// Id (integer, optional): 原Id , 编辑才要填
    var Id: Int = 0
    
    
    /// Uid (integer, optional): 请无视此字段 ,
    var Uid: Int = 0
    /// RegionId (integer): 区Id ,
    var RegionId: Int = 0
    /// IsDefault (boolean, optional): 是否为默认地址 ,
    var IsDefault: Bool = false
    /// Alias (string, optional): 别名,标签。如家、公司、学校 ,
    var Alias: String = ""
    /// Consignee (string): 收件人 ,
    var Consignee: String = ""
    /// Mobile (string): 收件人手机号 ,
    var Mobile: String = ""
    /// ZipCode (string, optional): /邮编 ,
    var ZipCode: String = ""
    /// Address (string): /详细地址 ,
    var Address: String = ""
    
    /// X (string, optional): x lat , 纬度
    var X: String = ""
    /// Y (string, optional): y lng , 经度
    var Y: String = ""
    
}

struct XQSMNTDeleteShopAddressReqModel: XQSMNTBaseReqModelProtocol {
    
    /// SaId (string, optional): 地址Id
    var SaId: String = ""
}

struct XQSMNTSetAddressDefaultReqModel: XQSMNTBaseReqModelProtocol {
    
    /// shipId (int, optional): ???
    var shipId: Int = 0
}









