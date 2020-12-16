//
//  XQSMUserNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/4.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

/// 用户网络请求模块
struct XQSMUserNetwork {
    
    /// 登录
    static func login(_ parameters: XQSMNTUserLoginReqModel) -> Observable<XQSMNTUserLoginResModel> {
        return XQSMBaseNetwork.default.post("/api/User/Login", parameters: parameters, resultType: XQSMNTUserLoginResModel.self)
    }
    
    /// 获取用户信息
    static func getUserInfo(_ parameters: XQSMNTBaseReqModelProtocol) -> Observable<XQSMNTUserInfoResModel> {
        return XQSMBaseNetwork.default.post("/api/User/GetUserInfo", parameters: parameters, resultType: XQSMNTUserInfoResModel.self)
    }
    
    /// 上传头像和修改昵称
    static func uploadPhotoAndChangeNickName(_ parameters: XQSMNTUploadPhotoAndChangeNickNameReqModel) -> Observable<XQSMNTUploadPhotoAndChangeNickNameResModel> {
        // token 和 昵称以 get 方式上传
//        var url = "/api/User/UploadPhotoAndChangeNickName" + "?" + "token=" + parameters.token
        // 必传字段
//        url = url + "&" + "nickName=" + parameters.nickName
        
        var url = "/api/User/UploadPhotoAndChangeNickName"
        url = url + "?" + "nickName=" + parameters.nickName
        
        var imgDataArr = [Data]()
        
        for item in parameters.imgArr {
            if let data = item.jpegData(compressionQuality: 0.5) {
                imgDataArr.append(data)
            }
        }
        
        return XQSMBaseNetwork.default.uploadImage(url, datas: imgDataArr, resultType: XQSMNTUploadPhotoAndChangeNickNameResModel.self)
    }
    
    /// 添加反馈, 最多三个图片
    static func addSuggestion(_ parameters: XQSMNTAddSuggestionReqModel) -> Observable<XQSMNTBaseResModel> {
        // 没完成接口
        return XQSMBaseNetwork.default.post("/api/User/AddSuggestion", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
    /// 新用户注册(或者说叫手机号快速登录)
    static func regist(_ parameters: XQSMNTUserRegistReqModel) -> Observable<XQSMNTUserLoginResModel> {
        return XQSMBaseNetwork.default.post("/api/User/Regist", parameters: parameters, resultType: XQSMNTUserLoginResModel.self)
    }
    
    /// 第三方快速登录
    static func aliPayLogin(_ parameters: XQSMNTUserAliPayLoginReqModel) -> Observable<XQSMNTUserLoginResModel> {
        return XQSMBaseNetwork.default.get("/api/User/AliPayLogin", parameters: parameters, resultType: XQSMNTUserLoginResModel.self)
    }
    
    /// 登录后绑定或解绑第三方
    static func bindOrUnBindThreeOpenId(_ parameters: XQSMNTUserAliPayLoginReqModel) -> Observable<XQSMNTUserLoginResModel> {
        return XQSMBaseNetwork.default.get("/api/User/BindOrUnBindThreeOpenId", parameters: parameters, resultType: XQSMNTUserLoginResModel.self)
    }
    
    /// 签到（进入这个接口判断是否可以签到，已经数据）
    static func signin(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTUserSignResModel> {
        return XQSMBaseNetwork.default.get("/api/User/Signin", parameters: parameters, resultType: XQSMNTUserSignResModel.self)
    }
    
    /// 签到（进入这个接口判断是否可以签到，已经数据）
    static func addSignin(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTUserSignGetJFResModel> {
        return XQSMBaseNetwork.default.get("/api/User/AddSignin", parameters: parameters, resultType: XQSMNTUserSignGetJFResModel.self)
    }
    
    /// 获取等级信息
    static func getRankInfo(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTGetRankInfoResModel> {
        return XQSMBaseNetwork.default.get("/api/User/GetRankInfo", parameters: parameters, resultType: XQSMNTGetRankInfoResModel.self)
    }
    
    /// 获取用户折扣（包含寄送，洗护，商城）
    static func getUserRankDiscount(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTGetUserRankDiscountResModel> {
        return XQSMBaseNetwork.default.get("/api/User/GetUserRankDiscount", parameters: parameters, resultType: XQSMNTGetUserRankDiscountResModel.self)
    }
    
    /// 获取邀请注册信息(二维码)
    static func getInviteQrCode(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTUserGetInviteQrCodeResModel> {
        return XQSMBaseNetwork.default.get("/api/User/GetInviteQrCode", parameters: parameters, resultType: XQSMNTUserGetInviteQrCodeResModel.self)
    }
    
//    /// 注册, 新用户绑定第三方和基本信息 绑定成功后会返回登录的token
//    static func newUserBindThreeAndBaseInfo(_ parameters: XQSMNTUserBindThreeAndBaseInfoInputReqModel) -> Observable<XQSMNTUserLoginResModel> {
//        return XQSMBaseNetwork.default.post("/api/User/NewUserBindThreeAndBaseInfo", parameters: parameters, resultType: XQSMNTUserLoginResModel.self)
//    }
//
//    /// 旧用户绑定第三方和基本信息 绑定成功后会返回登录的token
//    static func oldUserBindThreeOpenIdAndBaseInfo(_ parameters: XQSMNTUserOldUserBindWechatAndBaseInfoInputReqModel) -> Observable<XQSMNTUserLoginResModel> {
//        return XQSMBaseNetwork.default.post("/api/User/OldUserBindThreeOpenIdAndBaseInfo", parameters: parameters, resultType: XQSMNTUserLoginResModel.self)
//    }

    /// 发短信的操作，时间戳误差在10S内有效 短信300S内有效
    static func sendMsg(_ parameters: XQSMNTSendMsgReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/User/SendMsg", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }



    /// 改密码
    static func resetPassword(_ parameters: XQSMNTUserResetPasswordRecModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.post("/api/User/ResetPassword", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
//
//
//
//    /// 设置用户信息
//    static func setUserInfo(_ parameters: XQSMNTBaseReqModelProtocol) -> Observable<XQSMNTUserInfoRetModel> {
//        // 没完成接口
//        return XQSMBaseNetwork.default.post("/api/User/SetUserInfo", parameters: parameters, resultType: XQSMNTUserInfoRetModel.self)
//    }
//
    
//
//
//    /// 第三方账号和手机号绑定登录
//    static func fastLoginByThreeOpenId(_ parameters: XQSMNTUserFastLoginByThreeOpenIdReqModel) -> Observable<XQSMNTWechatLoginResModel> {
//        return XQSMBaseNetwork.default.post("/api/User/FastLoginByThreeOpenId", parameters: parameters, resultType: XQSMNTWechatLoginResModel.self)
//    }
//
//    /// QQ快速登录
//    static func gastLoginByQQOpenId(_ parameters: XQSMNTWechatLoginReqModel) -> Observable<XQSMNTWechatLoginResModel> {
//        return XQSMBaseNetwork.default.get("/api/User/FastLoginByQQOpenId", parameters: parameters, resultType: XQSMNTWechatLoginResModel.self)
//    }
    
    /// 获取实名认证 token
    static func getToken(_ parameters: XQSMNTBaseReqModel) -> Observable<XQSMNTUserGetTokenResModel> {
        return XQSMBaseNetwork.default.get("/api/User/GetToken", parameters: parameters, resultType: XQSMNTUserGetTokenResModel.self)
    }
    
    /// 认证完后请求
    static func resultToken(_ parameters: XQSMNTUserResultTokenReqModel) -> Observable<XQSMNTBaseResModel> {
        return XQSMBaseNetwork.default.get("/api/User/ResultToken", parameters: parameters, resultType: XQSMNTBaseResModel.self)
    }
    
}

struct XQSMNTUserLoginReqModel: HandyJSON {
    /// 手机号码
    var Phone = ""
    /// 密码
    var Password = ""
    /// 预留字段
    var Uid = 0
}


struct XQSMNTUserLoginResModel: XQSMNTBaseResModelProtocol {
    
    var ErrMsg: String?
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var Token: String!
    
    /// ValidateRealMan (boolean, optional): 是否实名认证过 ,
    var ValidateRealMan = true
    
}

struct XQSMNTUserResetPasswordRecModel: XQSMNTBaseReqModelProtocol {
    
    /// Code (string): 检验码
    var Code = ""
    /// Phone (string): 手机号
    var Phone = ""
    /// Password (string): 新密码
    var Password = ""
    /// RePassword (string, optional): 重输密码
    var RePassword = ""
    
}


struct XQSMNTUserInfoResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    /// UserInfo (UserInfoDto, optional): 用户信息 ,
    var UserInfo: XQSMNTUserInfoModel?
    
    
    /// NeedCreditsCount (integer, optional): 升级所属分数 ,
    var NeedCreditsCount = 0
    
    /// CurrentRankInfo (RankInfoDetail, optional): 当前等级信息 ,
    var CurrentRankInfo: XQSMNTUserRankInfoDetailModel?
    
    /// NextRankInfo (RankInfoDetail, optional): 下级等级信息 ,
    var NextRankInfo: XQSMNTUserRankInfoDetailModel?
    
}

struct XQSMNTUserInfoModel: HandyJSON {
    
    /// Phone (string, optional): 手机号 ,
    var Phone: String = ""
    /// NickName (string, optional): 昵称 ,
    var NickName: String?
    /// Avatar (string, optional): 头像，目前没用 ,
    var Avatar: String = ""
    /// PayCredits (integer, optional): 支付积分 ,
    var PayCredits = 0
    /// RankCredits (integer, optional): 等级积分 ,
    var RankCredits = 0
    /// Email (string, optional): 邮箱地址
    var Email: String = ""
    /// AvatarWithAddress (string, optional): 头像地址
    var AvatarWithAddress: String = ""
    /// VerifyMobile (boolean, optional): 是否已实名 ,
    var VerifyMobile: Bool = false
    
    /// "shopOwnerCount" : 0, 有多少间店铺
    var shopOwnerCount: Int = 0
    /// "partnerCount" : 0, 加盟了多少间店铺
    var partnerCount: Int = 0
    
    
    
    /// WechatOpenId (string, optional): 微信OpenId ,
    var WechatOpenId: String = ""
    
    /// QQOpenId (string, optional): QQOpenId ,
    var QQOpenId: String = ""
    
    /// AppleOpenId (string, optional): AppleOpen
    var AppleOpenId: String = ""
    
    /// AliPayOpenId (string, optional): AliPayOpen ,
    var AliPayOpenId: String = ""
    
    /// ParentId (integer, optional): 上级Id
    var ParentId = 0
    
}

extension XQSMNTUserInfoModel {
    
    /// 获取本地存储的用户信息
    static func getUserInfoModel() -> XQSMNTUserInfoModel? {
        let model = UserDefaults.standard.dictionary(forKey: "xq_model_XQSMNTUserInfoModel")
        if let userModel = XQSMNTUserInfoModel.deserialize(from: model) {
            return userModel
        }
        return nil
    }
    
    /// 获取本地存储的用户信息
    static func setUserInfoModel(_ userModel: XQSMNTUserInfoModel) {
        UserDefaults.standard.setValue(userModel.toJSON(), forKey: "xq_model_XQSMNTUserInfoModel")
    }
    
    /// 获取本地存储的用户信息
    static func removeUserInfoModel() {
        UserDefaults.standard.removeObject(forKey: "xq_model_XQSMNTUserInfoModel")
    }
    
}

extension XQSMNTUserInfoResModel {
    
    /// 获取本地存储的用户信息
    static func getUserInfoModel() -> XQSMNTUserInfoResModel? {
        let model = UserDefaults.standard.dictionary(forKey: "xq_model_XQSMNTUserInfoResModel")
        if let userModel = XQSMNTUserInfoResModel.deserialize(from: model) {
            return userModel
        }
        return nil
    }
    
    /// 获取本地存储的用户信息
    static func setUserInfoModel(_ userModel: XQSMNTUserInfoResModel) {
        UserDefaults.standard.setValue(userModel.toJSON(), forKey: "xq_model_XQSMNTUserInfoResModel")
    }
    
    /// 获取本地存储的用户信息
    static func removeUserInfoModel() {
        UserDefaults.standard.removeObject(forKey: "xq_model_XQSMNTUserInfoResModel")
    }
    
}

struct XQSMNTUserRankInfoDetailModel: HandyJSON {
    
    /// Title (string, optional): 用户等级标题 ,
    var Title: String = ""
    
    /// RankAvatar (string, optional): 等级头像 ,
    var RankAvatar: String = ""
    
    /// RankAvatarWithAddress (string, optional, read only): 等级图片(带地址) ,
    var RankAvatarWithAddress: String = ""
    
    /// CreditsUpper (integer, optional): 用户等级积分上限 ,
    var CreditsUpper = 0
    
    /// CreditsLower (integer, optional): 用户等级积分下限 ,
    var CreditsLower = 0
    
    /// DiscountOfAroundShop (integer, optional): 商城商品折扣 ,
    var DiscountOfAroundShop = 0
    
    /// LimitCountDiscountOfAroundShop (integer, optional): 商城商品折扣数量 ,
    var LimitCountDiscountOfAroundShop = 0
    
    /// OutOfDiscountOfAroundShop (integer, optional): 超过商城商品折扣数量打折 ,
    var OutOfDiscountOfAroundShop = 0
    
    /// HasAroundShopCheepPrice (boolean, optional): 是否拥有商城折扣价(会员尊享价) ,
    var HasAroundShopCheepPrice = false
    
    /// DiscountOfMedical (integer, optional): 医疗机构折扣 ,
    var DiscountOfMedical = 0
    
    /// LimitCountDiscountOfMedical (integer, optional): 医疗机构折扣数量 ,
    var LimitCountDiscountOfMedical = 0
    
    /// OutOfDiscountOfMedical (integer, optional): 超过医疗机构折扣数量打折 ,
    var OutOfDiscountOfMedical = 0
    
    /// DiscountOfFoster (integer, optional): 寄养的折扣 ,
    var DiscountOfFoster = 0
    
    /// LimitCountDiscountOfFoster (integer, optional): 寄养的折扣数量 ,
    var LimitCountDiscountOfFoster = 0
    
    /// OutOfDiscountOfFoster (integer, optional): 超过寄养的折扣数量打折 ,
    var OutOfDiscountOfFoster = 0
    
    /// DiscountOfBathe (integer, optional): 洗护的折扣 ,
    var DiscountOfBathe = 0
    
    /// LimitCountDiscountOfBathe (integer, optional): 洗护的折扣数量 ,
    var LimitCountDiscountOfBathe = 0
    
    /// OutOfDiscountOfBathe (integer, optional): 超过洗护的折扣数量打折
    var OutOfDiscountOfBathe = 0
    
}



struct XQSMNTUserAliPayLoginReqModel: XQSMNTBaseReqModelProtocol {
    
    enum LoginType: String, HandyJSONEnum {
        case unkonw = ""
        case qq = "qq"
        case alipay = "alipay"
        case wechat = "wechat"
        case apple = "apple"
    }
    
    /// 授权OpenId
    var openId = ""

    /// 登录类型，"alipay"表示支付宝。"qq"表示QQ，"wechat"表示微信，"apple"表示苹果
    var type: XQSMNTUserAliPayLoginReqModel.LoginType = .unkonw
    
}

struct XQSMNTUserRegistReqModel: XQSMNTBaseReqModelProtocol {
    
    /// CheckCode (string): 检验码,请调用发短信接口 ,
    var CheckCode = ""
    /// 手机号码
    var Phone = ""
    /// 密码
    var Password = ""
    /// 预留字段
    var Uid = 0
    
    /// WechatOpenId (string, optional): 微信OpenId ,
    var WechatOpenId = ""
    
    /// QQOpenId (string, optional): QQOpenId ,
    var QQOpenId = ""
    
    /// AliPayOpenId (string, optional): 支付宝Id ,
    var AliPayOpenId = ""
    
    /// AppleOpenId (string, optional): Apple Id ,
    var AppleOpenId = ""
    
}

struct XQSMNTAddSuggestionReqModel: XQSMNTBaseReqModelProtocol {
    
    var suggestion = ""
}



struct XQSMNTUploadPhotoAndChangeNickNameReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 昵称
    var nickName: String = "未设置昵称"
    /// 图片数据
    var imgArr = [UIImage]()
    
}

struct XQSMNTUploadPhotoAndChangeNickNameResModel: XQSMNTBaseUploadfileResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// true 进度, false 完成
    var isProgress: Bool = false
    /// 当前进度
    var progress: Progress?
    
}

struct XQSMNTSendMsgReqModel: HandyJSON {
    
    
    /// Phone (string): 手机号 参考：15089299694 ,
    var Phone: String = ""
    /// TimeStamp (string): 时间戳 参考：1568874405 ,
    var TimeStamp: String = ""
    /// SignStr (string): 签名检验字段 SignStr=MD5("!" + model.Phone + model.TimeStamp + "shop") 此字段无视大小写 参考：88f3a3bc76c872f31cd05799d97a1c32
    var SignStr: String = ""
    
    init() {
        
    }
    
    /// 传入 phone 初始化, 自动赋值 TimeStamp 和 SignStr
    /// - Parameter phone:  手机号码
    init(_ phone: String) {
        self.Phone = phone
        self.xq_setTimeStamp()
        self.xq_setSignStr()
    }
    
    /// 获取时间戳
    mutating func xq_setTimeStamp() {
        let TimeStamp = String.init(format: "%.0f", Date.init().timeIntervalSince1970)
        self.TimeStamp = TimeStamp
    }
    
    /// 获取加密签名
    mutating func xq_setSignStr() {
        let str = "!" + self.Phone + self.TimeStamp + "shop"
        self.SignStr = str.xq_md5String()
    }
    
    
}


struct XQSMNTUserOldUserBindWechatAndBaseInfoInputReqModel: HandyJSON {
    
    /// OpenId (string, optional): 微信OpenId ,
    var OpenId = ""
    
    /// QQOpenId (string, optional): QQOpenId ,
    var QQOpenId = ""
    
    /// AppId (string, optional): Apple Id ,
    var AppId = ""
    
    /// Phone (string, optional): 手机号(APP不需要传递，传了服务端也不会使用) ,
    var Phone = ""
    
    /// RealName (string): 真实姓名 ,
    var RealName = ""
    
    /// ComeSchoolDay (string): 入学时间 ,
    var ComeSchoolDay = ""
    
    /// IdCard (string): 身份证 ,
    var IdCard = ""
    
    /// SchoolId (integer, optional): 学校Id ,
    var SchoolId = 0
    
    /// SchoolLever1Id (integer, optional): 院系id ,
    var SchoolLever1Id = 0
    
    /// SchoolLever2Id (integer, optional): 专业id
    var SchoolLever2Id = 0
    
    
}

struct XQSMNTUserBindThreeAndBaseInfoInputReqModel: HandyJSON {
    
    /// OpenId (string, optional): 微信OpenId ,
    var OpenId = ""
    
    /// QQOpenId (string, optional): QQOpenId ,
    var QQOpenId = ""
    
    /// AppId (string, optional): Apple Id ,
    var AppId = ""
    
    /// Phone (string, optional): 手机号
    var Phone = ""
    
    /// Pwd (string): 密码 ,
    var Pwd = ""
    
    /// CheckCode (string): 短信验证码 ,
    var CheckCode = ""
    
    /// RealName (string): 真实姓名 ,
    var RealName = ""
    
    /// ComeSchoolDay (string): 入学时间 ,
    var ComeSchoolDay = ""
    
    /// IdCard (string): 身份证 ,
    var IdCard = ""
    
    /// SchoolId (integer, optional): 学校Id ,
    var SchoolId = 0
    
    /// SchoolLever1Id (integer, optional): 院系id ,
    var SchoolLever1Id = 0
    
    /// SchoolLever2Id (integer, optional): 专业id
    var SchoolLever2Id = 0
    
    
}

struct XQSMNTUserFastLoginByThreeOpenIdReqModel: HandyJSON {
    
    /// OpenId (string, optional): 微信OpenId ,
    var OpenId = ""
    
    /// QQOpenId (string, optional): QQOpenId ,
    var QQOpenId = ""
    
    /// AppId (string, optional): 苹果Id ,
    var AppId = ""
    
    /// Phone (string): 手机号 ,
    var Phone = ""
    
    /// Pwd (string): 密码
    var Pwd = ""
    
}

struct XQSMNTUserSignResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    /// Accumulative (integer, optional): 累计天数 ,
    var Accumulative = 0
    
    /// Continuous (integer, optional): 连续天数 ,
    var Continuous = 0
    
    /// IsOk (boolean, optional): 今天是否可以签到 ,
    var IsOk = false
    
}

struct XQSMNTUserSignGetJFResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .succeed

    var ErrMsg: String?
    
    /// integration (integer, optional): 签到获得得积分 ,
    var integration = 0
}


struct XQSMNTGetRankInfoResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .succeed

    var ErrMsg: String?
    
    /// RankLss (Array[RankDto], optional): 等级列表，已排序 ,
    var RankLss: [XQSMNTUserRankModel]?
    
    /// UserAvatar (string, optional): 用户头像 ,
    var UserAvatar = ""
    
    /// UserAvatarWithAddress (string, optional, read only): 用户头像 ,
    var UserAvatarWithAddress = ""
    
}

struct XQSMNTUserRankModel: HandyJSON {
    
    /// Title (string, optional): 名称（对应显示在正文的V1,V2这个文字） ,
    var Title = ""
    
    /// CreditsLower (integer, optional): 等级最低分(对应那柱体上面的数字) ,
    var CreditsLower = ""
    
    /// Avatar (string, optional): 图片 ,
    var Avatar = ""
    
    /// AvatarWithAddress (string, optional, read only): 图片(带地址)
    var AvatarWithAddress = ""
    
    
}

struct XQSMNTGetUserRankDiscountResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .succeed

    var ErrMsg: String?
        
    /// AroundDicount (number, optional): 商城折扣,(10表示无折扣，9表示 9折,下面字段同理) ,
    var AroundDicount: Float = 0
    
    /// BatheDicount (number, optional): 洗护折扣 ,
    var BatheDicount: Float = 0
    
    /// MedicalDicount (number, optional): 医疗折扣 ,
    var MedicalDicount: Float = 0
    
    /// FosterDicount (number, optional): 寄养折扣 ,
    var FosterDicount: Float = 0
    
}

struct XQSMNTUserResultTokenReqModel: XQSMNTBaseReqModelProtocol {
    
    /// 这个是, 调用 .getToken 获取的 RequestId
    var RequestId = ""
    
}


struct XQSMNTUserGetTokenResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .succeed
    
    var ErrMsg: String?
    
    ///
    var VerifyToken = ""
    
    /// 结束后，要给后台的id
    var RequestId = ""
    
}


struct XQSMNTUserGetInviteQrCodeResModel: XQSMNTBaseResModelProtocol {

    var ErrCode: XQSMNTErrorCode = .succeed

    var ErrMsg: String?
    
    /// InviteUrl (string, optional): 邀请注册链接 ,
    var InviteUrl = ""
    
    /// QrCodeAddress (string, optional): 邀请注册二维码 ,
    var QrCodeAddress = ""
    
}



