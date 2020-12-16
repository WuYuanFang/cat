//
//  XQSMAlipayNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/9/27.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON

struct XQSMAlipayNetwork {

    
    /// App发起支付宝支付下单接口
    /// 当是商城支付时，只需传{"token":"","id":"订单id","payType":1}
    /// 当是外卖支付时：只需传{"token":"","id":"订单id","payType":2}
    /// 当是店长支付时：这个就有点恶心，传{"token":"","id":"申请的店铺id","Money":decimal格式,"PayType":3,"level":申请的等级(int)}
    static func aliPayOrder(_ parameters: XQSMNTUnifiedorderReqModel) -> Observable<XQSMNTUnifiedorderResModel> {
        return XQSMBaseNetwork.default.post("/api/AliPay/AliPayOrder", parameters: parameters, resultType: XQSMNTUnifiedorderResModel.self)
    }
    
}

struct XQSMAlipayAppPayResultModel: HandyJSON {
    
    /// 状态码,
    /// 9000: 为正确
    /// 6001: 用户取消
    var resultStatus: Int = -100
    
    /// memo
    var memo: String = ""
        
    /// 数据,  原本是个 json 字符串
//    var result: XQSMAlipayAppPayResultDataModel?
    var result: String = ""
    /// 吧 result 转为 resultModel
    var resultModel: XQSMAlipayAppPayResultDataModel?
}

struct XQSMAlipayAppPayResultDataModel: HandyJSON {
    /// 状态码
    var alipay_trade_app_pay_response: XQSMAlipayTradeAppPayResponseModel?
    /// 加密??
    var sign: String = ""
    /// 加密方式
    var sign_type: String = ""
        
}

struct XQSMAlipayTradeAppPayResponseModel: HandyJSON {
    /// 错误码, 10000 为正确 "code":"10000",
    var code: String = ""
    /// "msg":"Success",
    var msg: String = ""
    /// "app_id":"2019091967577826",
    var app_id: String = ""
    /// "auth_app_id":"2019091967577826",
    var auth_app_id: String = ""
    /// "charset":"utf-8",
    var charset: String = ""
    /// "timestamp":"2019-10-10 17:01:14",
    var timestamp: String = ""
    /// "out_trade_no":"201909196757782620191010170110192108",
    var out_trade_no: String = ""
    /// "total_amount":"0.01",
    var total_amount: String = ""
    /// "trade_no":"2019101022001432020553884379",
    var trade_no: String = ""
    /// "seller_id":"2088631332147574"
    var seller_id: String = ""
    
}
