//
//  XQSMWechatNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/9/25.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQSMWechatNetwork {
    
    /// App发起微信支付下单接口
    /// 当是商城支付时: 只需传{"token":"","id":"返回给你们的osn","payType":1}
    /// 当是外卖支付时: 只需传{"token":"","id":"订单id","payType":2}
    /// 当是店长支付时: 这个就有点恶心，传{"token":"","id":"申请的店铺id","Money":decimal格式,"PayType":3,"level":申请的等级(int)}
    static func unifiedorder(_ parameters: XQSMNTUnifiedorderReqModel) -> Observable<XQSMNTUnifiedorderResModel> {
        return XQSMBaseNetwork.default.post("/api/Wechat/Unifiedorder", parameters: parameters, resultType: XQSMNTUnifiedorderResModel.self)
    }
    
    /// App 微信快速登录
    static func fastLoginByOpenId(_ parameters: XQSMNTWechatLoginReqModel) -> Observable<XQSMNTWechatLoginResModel> {
        return XQSMBaseNetwork.default.get("/api/Wechat/FastLoginByOpenId", parameters: parameters, resultType: XQSMNTWechatLoginResModel.self)
    }
    
}

/// 支付类型
enum XQSMNTUnifiedorderReqModelPayType: Int, HandyJSONEnum {
    
    /// unknow: 未知
    case unknow = -1
    
    /// 商城
    case shopMall = 1
    
    /// 预约
    case appointment = 2
    
    /// 寄养
    case foster = 3
    
}

struct XQSMNTUnifiedorderReqModel: XQSMNTBaseReqModelProtocol {
    
    
    /// id (string, optional): 支付标识 ,
    var id: String = ""
    /// PayType (integer, optional): 1:商城支付 2:预约 3:寄养
    var PayType: XQSMNTUnifiedorderReqModelPayType = .unknow
    
    /// Money (number, optional): 支付金额 ,
//    var Money: Float = 0
    /// level (integer, optional): 等级 ,
//    var level: Int = 0
    
}

struct XQSMNTUnifiedorderResModel: XQSMNTBaseResModelProtocol {
    var ErrCode: XQSMNTErrorCode = .unknow
    
    var ErrMsg: String?
    
    /// appId (string, optional),
    var appId: String = ""
    /// nonceStr (string, optional),
    var nonceStr: String = ""
    /// prepay_id (string, optional),
    var prepay_id: String = ""
    /// paySign (string, optional),
    var paySign: String = ""
    /// signType (string, optional),
    var signType: String = ""
    /// timeStamp (string, optional),
    var timeStamp: String = ""
    /// mwebUrl (string, optional),
    var mwebUrl: String = ""
    /// mchId (string, optional),
    var mchId: String = ""
    
    /// 获取微信 pay model
    func getPayModel() -> PayReq {
        let payReqModel = PayReq.init()
        payReqModel.prepayId = self.prepay_id
        payReqModel.nonceStr = self.nonceStr
        payReqModel.timeStamp = UInt32(self.timeStamp) ?? 0
        payReqModel.sign = self.paySign
        
        payReqModel.partnerId = self.mchId
        payReqModel.package = "Sign=WXPay"
        
        return payReqModel
    }
    
}


struct XQSMNTWechatLoginReqModel: HandyJSON {
    
    /// 微信的 openId
    var openId = ""

}


struct XQSMNTWechatLoginResModel: XQSMNTBaseResModelProtocol {
    
    var ErrCode: XQSMNTErrorCode = .unknow

    var ErrMsg: String?
    
    /// OpenId (string, optional): 授权用户唯一标识 未绑定手机号等信息时，此字段将会返回 ,
    var OpenId = ""
    
    /// Phone (string, optional): 手机号 如果未填写过，此字段将为空字符 ,
    var Phone = ""
    
    /// IsValidReal (boolean, optional): 是否通过检验（实名认证） ,
    var IsValidReal = false
    
    /// Token (string, optional): 登录成功的token errcode为0时，此字段才会有 ,
    var Token = ""
    
}

