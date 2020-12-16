//
//  XQSMCommonNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/24.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQSMCommonNetwork {
    
    /// 查所有区域
    static func getAllRegion() -> Observable<XQSMNTRegionResModel> {
        return XQSMBaseNetwork.default.get("/api/Common/GetAllRegion", resultType: XQSMNTRegionResModel.self)
    }
    
    /// 查某Id下的子区域
    static func getChildrenRegion(_ regionId: Int) -> Observable<XQSMNTRegionResModel> {
        let url = "/api/Common/GetChildrenRegion/" + String(regionId)
        return XQSMBaseNetwork.default.get(url, resultType: XQSMNTRegionResModel.self)
    }
    
    /// 查错误码对应的中文描述
    static func getErrorCodeDesc() -> Observable<XQSMNTErrorCodeResModel> {
        return XQSMBaseNetwork.default.get("/api/Common/GetErrorCodeDesc", resultType: XQSMNTErrorCodeResModel.self)
    }
    
    /// 获取学校全部信息(包含学院，专业的信息
    static func getAllSchoolInfo() -> Observable<XQSMNTGetAllSchoolInfoResModel> {
        return XQSMBaseNetwork.default.get("/api/Common/GetAllSchoolInfo", resultType: XQSMNTGetAllSchoolInfoResModel.self)
    }
    
    /// 获取系统配置数据
    static func getSystemConfig() -> Observable<XQSMNTCommonGetSystemConfigResModel> {
        return XQSMBaseNetwork.default.get("/api/Common/GetSystemConfig", resultType: XQSMNTCommonGetSystemConfigResModel.self)
    }
    
}

struct XQSMNTRegionResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// RegionList (Array[RegionDto], optional): 列表 ,
    var RegionList: XQSMNTRegionModel?
}

struct XQSMNTRegionModel: HandyJSON {
    //    Id (integer, optional): 对应的Id ,
    var Id: Int = 0
    //    Name (string, optional): 名称 ,
    var Name: String = ""
    //    PId (integer, optional): 父Id
    var PId: Int = 0
}


struct XQSMNTErrorCodeResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// Item (ErrorCodeInfo, optional): 列表 ,
    var Item: XQSMNTErrorCodeInfoModel?
}

struct XQSMNTErrorCodeInfoModel: HandyJSON {
    /// k__BackingField (Array[ErrorItem], optional)
    var k__BackingField: [XQSMNTErrorItemModel]?
}

struct XQSMNTErrorItemModel: HandyJSON {
    //    Code (integer, optional): 错误码 ,
    var Code: Int = 0
    //    Desc (string, optional): 对应的描述
    var Desc: String = ""
}


struct XQSMNTGetAllSchoolInfoResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// SchoolLss (Array[ExSchoolDto], optional): 学校列表 ,
    var SchoolLss: [XQSMNTExSchoolModel]?
}

struct XQSMNTExSchoolModel: HandyJSON {
    
    /// Id (integer, optional): id ,
    var Id: Int = 0
    
    /// SchoolName (string, optional): 学校名 ,
    var SchoolName = ""
    
    /// Address (string, optional): 地址 ,
    var Address = ""
    
    /// LeverLss (Array[ExSchoolLeverDto], optional): 学院列表
    var LeverLss: [XQSMNTExSchoolLeverModel]?
    
}

struct XQSMNTExSchoolLeverModel: HandyJSON {
    
    /// Id (integer, optional): id ,
    var Id = 0
    
    /// LevelName (string, optional): LevelName ,
    var LevelName = ""
    
    /// LevelTwoLss (Array[ExSchoolLevelTwoDto], optional): 专业列表
    var LevelTwoLss: [XQSMNTExSchoolLevelTwoModel]?
    
}

struct XQSMNTExSchoolLevelTwoModel: HandyJSON {
    
    /// Id (integer, optional): id ,
    var Id = 0
    
    /// LevelTwoName (string, optional): 名称
    var LevelTwoName = ""
    
}

struct XQSMNTCommonGetSystemConfigResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    
    /// TrueManPrice (number, optional): 实名认证优惠 ,
    var TrueManPrice: Float = 0
    
    /// TrueManMinPrice (number, optional): 实名认证最小金额 ,
    var TrueManMinPrice: Float = 0
    
}
