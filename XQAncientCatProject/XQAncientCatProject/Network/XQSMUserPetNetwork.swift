//
//  XQSMUserPetNetwork.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQSMUserPetNetwork {
    
    /// 获取我的宠物列表
    static func getMyPetList(_ parameters: XQSMNTGetMyPetListReqModel) -> Observable<XQSMNTGetMyPetListOutputResModel> {
        let url = "/api/UserPet/GetMyPetList?state=\(parameters.state.rawValue)"
        return XQSMBaseNetwork.default.post(url, parameters: parameters, resultType: XQSMNTGetMyPetListOutputResModel.self)
    }
    
    /// 添加或编辑宠物
    static func addOrEditPet(_ parameters: XQSMNTPetAddOrEditPetModelReqModel) -> Observable<XQSMNTUploadPhotoAndChangeNickNameResModel> {
        let url = "/api/UserPet/AddOrEditPet"
        
        var dic = [String: Data]()
        
        if let img = parameters.xq_PhotoImg {
            if let data = img.jpegData(compressionQuality: 0.5) {
                dic["CoverFile"] = data
            }
        }
        
        if let img = parameters.xq_NosePhotoImg {
            if let data = img.jpegData(compressionQuality: 0.5) {
                dic["NoseFile"] = data
            }
        }
        
        if let img = parameters.xq_AllBodyPhotoImg {
            if let data = img.jpegData(compressionQuality: 0.5) {
                dic["AllBodyFile"] = data
            }
        }
        
        return XQSMBaseNetwork.default.uploadImage_2(url, dataDic: dic, params: parameters, resultType: XQSMNTUploadPhotoAndChangeNickNameResModel.self)
    }
    
    /// 删除宠物
    static func deletePet(_ petId: Int) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/UserPet/DeletePet/\(petId)", resultType: XQSMNTBaseResModel.self)
    }
    
    
    
    /// 获取宠物品种
    static func getAllPetVarieties(_ parameters: XQSMNTPetGetAllPetVarietiesReqModel) -> Observable<XQSMNTGetAllPetVarietiesResModel> {
        return XQSMBaseNetwork.default.get("/api/UserPet/GetAllPetVarieties", parameters: parameters, resultType: XQSMNTGetAllPetVarietiesResModel.self)
    }
    
}


struct XQSMNTGetMyPetListReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 宠物状态
    enum PetState: Int, HandyJSONEnum {
        /// 当前无状态
        case unknow = -1
        /// 全部
        case all = 0
        /// 繁育中
        case breed = 1
        /// 洗护中
        case washProtect = 2
        /// 寄养中
        case foster = 3
    }
    
    /// 状态，0表示查全部，1：繁育中，2：洗护中，3：寄养中
    var state: XQSMNTGetMyPetListReqModel.PetState = .all
    
}

struct XQSMNTGetMyPetListOutputResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// Lss (Array[UserPetInfoDto], optional): 列表 ,
    var Lss: [XQSMNTGetMyPetListUserPetInfoModel]?
    
}

struct XQSMNTGetMyPetListUserPetInfoModel: HandyJSON {
    
    /// Id (integer, optional): Id ,
    var Id: Int = 0
    
    /// Photo (string, optional): 封面图片 ,
    var Photo = ""
    
    /// PhotoWithAddress (string, optional, read only): 封面带地址 ,
    var PhotoWithAddress = ""
    
    /// NickName (string, optional): 昵称 ,
    var NickName = ""
    
    /// PetType (string, optional): 宠物类型（猫或狗） ,
    var PetType = ""
    
    /// Sex (string, optional): 性别(传输"公"或"母") ,
    var Sex = ""
    
    /// IsNoSex (boolean, optional): 是否绝育（true：已绝育） ,
    var IsNoSex = false
    
    /// BirthDate (string, optional): 生日 ,
    var BirthDate = ""
    
    /// PetVarieties (string, optional): 品种（比如田园犬之类的） ,
    var PetVarieties = ""
    
    /// NosePhoto (string, optional): 鼻头照 ,
    var NosePhoto = ""
    
    /// NosePhotoWithAddress (string, optional, read only): 鼻头照带地址 ,
    var NosePhotoWithAddress = ""
    
    /// AllBodyPhoto (string, optional): 全身照 ,
    var AllBodyPhoto = ""
    
    /// AllBodyPhotoWithAddress (string, optional, read only): 全身照 ,
    var AllBodyPhotoWithAddress = ""
    
    /// State (string, optional, read only): 状态 ,
    var State: XQSMNTGetMyPetListReqModel.PetState = .all
    
    /// Weight (number, optional): 重量 ,
    var Weight: Float = 0
    
    /// WashCount (integer, optional): 当前洗护数量（APP无视此字段）
    var WashCount = 0
    
    /// 年龄描述
    var AgeDesc = ""
    
    /// 订单id
    var oid: Int = 0
    
    
}


struct XQSMNTPetAddOrEditPetModelReqModel: XQSMNTBaseReqModelProtocol {
    
    /// Id (integer, optional): Id ,
    var Id: Int = 0
    
    /// NickName (string, optional): 昵称 ,
    var NickName = ""
    
    /// PetType (string, optional): 宠物类型（猫或狗） ,
    var PetType: XQSMNTPetGetAllPetVarietiesReqModel.PetType = .cat
    
    /// Sex (string, optional): 性别(传输"公"或"母") ,
    var Sex = ""
    
    /// IsNoSex (boolean, optional): 是否绝育（true：已绝育） ,
    var IsNoSex = false
    
    /// BirthDate (string, optional): 生日 ,
    var BirthDate = ""
    
    /// PetVarieties (string, optional): 品种（比如田园犬之类的） ,
    var PetVarieties = ""
    
    /// Weight (number, optional): 重量 , 单位 kg
    var Weight: Float = 0
    
    ///    "Photo":"",//封面图，如不改图片，就不需要上传图片，将原图片数据回传
    var Photo = ""
    
    ///    "NosePhoto":""//鼻头照，就不需要上传图片，将原图片数据回传
    var NosePhoto = ""
    
    ///    "AllBodyPhoto":"",//全身照，如不改图片，就不需要上传图片，将原图片数据回传
    var AllBodyPhoto = ""
    
    
//    图片上传时，
//    CoverFile 对应封面图
//    AllBodyFile 对应全身照
//    NoseFile 对应鼻头照
    
    /// 封面图
    var xq_PhotoImg: UIImage?
    
    /// 鼻头照
    var xq_NosePhotoImg: UIImage?
    
    /// 全身照
    var xq_AllBodyPhotoImg: UIImage?
    
    
    mutating func mapping(mapper: HelpingMapper) {
        // 忽略图片
        mapper >>> self.xq_PhotoImg
        mapper >>> self.xq_NosePhotoImg
        mapper >>> self.xq_AllBodyPhotoImg
    }
    
    
}


struct XQSMNTPetGetAllPetVarietiesReqModel: XQSMNTBaseReqModelProtocol {
    
    enum PetType: String, HandyJSONEnum {
        case cat = "猫"
        case dog = "狗"
    }
    
    var petType: XQSMNTPetGetAllPetVarietiesReqModel.PetType = .cat
    
}


struct XQSMNTGetAllPetVarietiesResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// PetVarieties (Array[string], optional): 品种列表 ,
    var PetVarieties = [String]()

}

