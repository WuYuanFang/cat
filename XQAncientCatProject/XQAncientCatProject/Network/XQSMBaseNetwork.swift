//
//  XQSMBaseNetwork.swift
//  XQShopMallProject
//
//  Created by WXQ on 2019/8/4.
//  Copyright © 2019 itchen.com. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire
import HandyJSON
import CommonCrypto

let XQSM_Notification_TokenOverdue = NSNotification.Name(rawValue: "xqsm_tokenOverdue")

struct XQSMBaseNetwork {
    
    static var `default` = { () -> XQSMBaseNetwork in
        var bn = XQSMBaseNetwork()
        var config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        let sManager = SessionManager.init(configuration: config)
        
        bn.sManager = sManager
        
        return bn
    }()
    
    private var sManager: SessionManager!
    
    var baseUrl = XQSMBaseNetwork.getUrl()
    
    /// token, 登录成功后, 要设置一下这里的token
    private var _token: String = UserDefaults.standard.string(forKey: "xq_ac_token") ?? ""
    var token: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "xq_ac_token")
            _token = newValue
        }
        get {
//            if _token.count == 0 {
//               _token = UserDefaults.standard.string(forKey: "xq_ac_token") ?? ""
//            }
            return _token
        }
    }
    
    /// 设置基础url
    static func setUrl(_ url: String) {
        UserDefaults.standard.setValue(url, forKey: "lm_BEEPLUS_url")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            exit(0)
        }
    }
    
    /// 获取基础url
    static func getUrl() -> String {
        if let url = UserDefaults.standard.string(forKey: "lm_BEEPLUS_url"), url.count != 0 {
            return url
        }
        
        return self.getNormalUrl()
    }
    
    /// 获取默认url
    static func getNormalUrl() -> String {
//        #if DEBUG
        return "http://cx.gdmiacid.com:8088" // 测试地址
//        #else
//        return "http://app.beeplustea.com" // 正是环境地址
//        #endif
    }

    
    let disposeBag = DisposeBag()
    
    /// post请求
    ///
    /// - Parameters:
    ///   - sUrl: url后缀
    ///   - parameters: 参数
    /// - Note:
    /// 不能直接 XQSMBaseNetwork.default.post<Txxxxx>(), 系统会推断错误
    /// 所以这里加了一个 type 类型, 这个是让外面来制定这个 T 的类型
    func post<T: XQSMNTBaseResModelProtocol>(_ sUrl: String, parameters: HandyJSON? = nil, resultType: T.Type) -> Observable<T> {
        return self.request(.post, sUrl: sUrl, parameters: parameters?.toJSON(), resultType: resultType)
    }
    
    /// get请求
    ///
    /// - Parameter sUrl: 后缀 + 参数
    func get<T: XQSMNTBaseResModelProtocol>(_ sUrl: String, parameters: HandyJSON? = nil, resultType: T.Type) -> Observable<T> {
        return self.request(.get, sUrl: sUrl, parameters: parameters?.toJSON(), resultType: resultType)
    }
    
    /// 请求
    ///
    /// - Parameters:
    ///   - method: 请求方法
    ///   - sUrl: 后缀
    ///   - parameters: 参数
    private func request<T: XQSMNTBaseResModelProtocol>(_ method: Alamofire.HTTPMethod, sUrl: String, parameters: [String: Any]? = nil, resultType: T.Type) -> Observable<T> {
        
        #if DEBUG
        print("当前token: ", self.token)
        #endif
        
        var url = self.baseUrl + sUrl
        
        if method == .get, let parameters = parameters {
            let paramsStr = parameters.xq_toGetUrlParams()
            if paramsStr.count != 0 {
                url = url + "?" + paramsStr
            }
            
            // url 中文 问题
            if let nUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                url = nUrl
            }
        }
        
        #if DEBUG
        if let parameters = parameters {
            print("发送请求: ", method, url, parameters.xq_toJsonStr() ?? parameters)
        }else {
            print("发送请求: ", method, url, "没有参数")
        }
        #endif
        
        let ob = Observable<T>.create { (obs) -> Disposable in
            
            var observer: Observable<Any>!

            if method == .get {
                observer = self.sManager.rx.request(method, url, encoding: JSONEncoding.default, headers: [
                    "Authorization": "Bear \(self.token)"
                ]).json()
                
            }else {
                // 在 header 里面附带 token
                observer = self.sManager.rx.request(method, url, parameters: parameters, encoding: JSONEncoding.default, headers: [
                    "Authorization": "Bear \(self.token)"
                    ]).json()
            }
            
            
            observer.subscribe(onNext: { (response) in
                
                let dic = response as? Dictionary<String, Any>
//                let dic = response
                
                #if DEBUG
                
                if let dic = dic {
                    print("接收到消息: ", method, url, dic.xq_toJsonStr() ?? dic)
                }else {
                    print("接收到消息: ", method, url, "没有参数")
                }
                #endif
                
                let model = self.handleDoneData(dic, resultType: resultType)
                obs.onNext(model)
                
            }, onError: { (error) in
                #if DEBUG
                print("网络请求发送错误: ", method, url, error)
                #endif
                
                obs.onError(error)
                
            }, onCompleted: {
//                print(#function, "onCompleted")
                obs.onCompleted()
            }) {
                // onDisposed
//                print(#function, "onDisposed")
            }.disposed(by: self.disposeBag)
            
            return Disposables.create {
//                print(#function, "结束请求")
            }
        }
        
        return ob
    }
    
    public enum UploadFileResult {
        case progress
        case success(request: UploadRequest)
    }
    
    
    
    
    /// 上传图片请求
    ///
    /// - Parameters:
    ///   - sUrl: 后缀
    ///   - datas: 文件数据
    func uploadImage<T: XQSMNTBaseUploadfileResModelProtocol>(_ sUrl: String, datas: [Data], resultType: T.Type) -> Observable<T> {
        return self.uploadImage_1(sUrl, datas: datas, params: nil, resultType: resultType)
    }
    
    /// 上传图片请求
    ///
    /// - Parameters:
    ///   - sUrl: 后缀
    ///   - datas: 文件数据
    func uploadImage_1<T: XQSMNTBaseUploadfileResModelProtocol>(_ sUrl: String, datas: [Data], params: HandyJSON?, resultType: T.Type) -> Observable<T> {
        
        var dic = [String: Data]()
        for (index, item) in datas.enumerated() {
            // 随机名称
            let dateStr = String(Date.init().timeIntervalSince1970)
            let name = dateStr + "_name_" + String(index)
            dic[name] = item
        }
        
        return self.uploadImage_2(sUrl, dataDic: dic, params: params, resultType: resultType)
    }
    
    
    /// 上传图片请求
    ///
    /// - Parameters:
    ///   - sUrl: 后缀
    ///   - datas: 文件数据
    func uploadImage_2<T: XQSMNTBaseUploadfileResModelProtocol>(_ sUrl: String, dataDic: Dictionary<String, Data>, params: HandyJSON?, resultType: T.Type) -> Observable<T> {
        
        #if DEBUG
        print("当前token: ", self.token)
        #endif
        
        var url = self.baseUrl + sUrl
        // 网络请求时url不能包含ASSIC码, 中文..
        if let charUrl = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            url = charUrl
        }
        
        
        #if DEBUG
        if let params = params {
            print("上传图片发送: \(url), 图片个数: \(dataDic.keys.count), 参数: \(params.toJSONString() ?? "")")
        }else {
            print("上传图片发送: \(url), 图片个数: \(dataDic.keys.count), 参数: 没有")
        }
        #endif
        
        let json = params?.toJSON()
        
        let ob = Observable<T>.create { (obs) -> Disposable in
            
            let headers = [
                "Authorization": "Bear \(self.token)"
            ]
            
            Alamofire.upload(multipartFormData: { (formData) in
                
                for item in dataDic {
                    formData.append(item.value, withName: item.key, fileName: item.key + ".jpg", mimeType: "image/jpeg")
                }
                
                // 这里就是绑定参数的地方 param 是需要上传的参数，我这里是封装了一个方法从外面传过来的参数，你可以根据自己的需求用NSDictionary封装一个param
                
                for (key, value) in json ?? [String: Any]() {
                    if let value = value as? String {
                        if let data = value.data(using: .utf8) {
                            formData.append(data, withName:key)
                        }
                    }else if let value = value as? Int {
                        let str = String(value)
                        if let data = str.data(using: .utf8) {
                            formData.append(data, withName:key)
                        }
                    }else if let value = value as? Float {
                        let str = String(value)
                        if let data = str.data(using: .utf8) {
                            formData.append(data, withName:key)
                        }
                    }else if let value = value as? Bool {
                        let str = value ? "1" : "0"
                        if let data = str.data(using: .utf8) {
                            formData.append(data, withName:key)
                        }
                    }else if let value = value as? Array<Any> {
                        print("error: 还没定该类型", value)
                    }else if let value = value as? Dictionary<String, Any> {
                        print("error: 还没定该类型", value)
                    }else {
                        print("error: 还没定该类型", value)
                    }
                    
                }
                
            }, to: url, headers: headers, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                    
                case .success(let request, let streamingFromDisk, let streamFileURL):
                    
                    print("开始上传: ", request, streamingFromDisk, streamFileURL ?? "没有streamFileURL")
                    
                    request.uploadProgress(closure: { (progress) in
                        
                        print("上传进度: ", progress)
                        var model = T.init()
                        model.isProgress = true
                        model.progress = progress
                        obs.onNext(model)
                        
                    }).responseJSON(completionHandler: { (response) in
                        
                        if let error = response.error {
                            
                            print("上传失败: ", error)
                            obs.onError(error)
                            
                        }else {
                            
                            if let value = response.value as? [String : Any] {
                                #if DEBUG
                                print("上传成功: ", value)
                                #endif
                                var model = self.handleDoneData(value, resultType: resultType)
                                model.isProgress = false
                                obs.onNext(model)
                            }else {
                                #if DEBUG
                                print("上传失败: ", response.value ?? "没有 error, 没有 value, 或者 value 不是 Dictionary")
                                #endif
                                obs.onError(NSError.init(domain: "没有value, 或者 value 不是 Dictionary", code: -99999, userInfo: nil))
                            }
                            
                        }
                        
                        obs.onCompleted()
                        
                    })
                    
                case .failure(let error):
                    
                    print("上传失败: ", error)
                    obs.onError(error)
                    obs.onCompleted()
                }
                
            })
            
            return Disposables.create {
                
            }
            
        }
        
        return ob
    }
    
    /// 处理请求返回的数据
    private func handleDoneData<T: XQSMNTBaseResModelProtocol>(_ value: [String: Any]?, resultType: T.Type) -> T {
        
        // 没有数据, 默认成功
        let normalDic = ["errcode": -12312, "errmsg": "未知错误"] as [String : Any]
        let model = T.deserialize(from: value ?? normalDic)!
        
        switch model.ErrCode {
        case .succeed:
            break
        case .tokenOverdue:
            #if DEBUG
            print("token 过期了")
            #endif
            XQSMBaseNetwork.default.token = ""
            NotificationCenter.default.post(name: XQSM_Notification_TokenOverdue, object: model)
        @unknown default:
            break
        }
     
        return model
//        obs.onNext(model)
    }
    
    func test_createObservable() -> Observable<String> {
        
        // 这里创建一个观察者
        let ob = Observable<String>.create { (observer) -> Disposable in
            print("Observable.create")
            // 做具体的代码, 动作等等, 然后发消息出去
            observer.onNext("asdasd")
            //            observer.onError(URLError.init(URLError.Code.badURL, userInfo: ["asd": "qweqwe"]))
            observer.onCompleted()
            // 创建一个 Disposable 返回出去.  其实就是给外面的持有这个 Disposable, 然后处理释放时机
            // 并且搞一个block, 监听释放了, 这里可以做释放之后要做的代码
            return Disposables.create {
                // 这里是取消了
                print("Disposables, 释放了")
            }
        }
        
        return ob
    }
    
    private struct test_XQResultModel {
        /// true 结束请求, false 进度
        var isEnd: Bool = false
        /// 当前进度
        var progress: Float = 0
        /// 这里放想要放的数据
        var data: Any?
    }
    
    private func test_request<T: XQSMNTBaseResModelProtocol>(_ method: Alamofire.HTTPMethod, sUrl: String, parameters: [String: Any]? = nil, resultType: T.Type) -> Observable<T> {
        
        
        let ob = Observable<T>.create { (obs) -> Disposable in
            return Disposables.create {
                
            }
        }
        
        return ob
    }
    
    private func test_beginReqeust() {
        let semaphore = DispatchSemaphore.init(value: 1)
//        dispatch_semaphore_t
    }
    
    
    
}

/// 通用错误码
///
/// - unknow: 未知错误
/// - succeed: 成功
/// - scoreIsNotEnough: 积分兑换商品, 积分不够
/// - unbindThree: 第三方登录未绑定
/// - incompleteUserInfo: 用户信息未完善(身份证，学校这些)
/// - addAddressFail: 添加地址失败 The value '1' is not valid for IsDefault.
/// - tokenOverdue: token 过期
enum XQSMNTErrorCode: Int, HandyJSONEnum {
    case unknow = -12312
    
    case succeed = 0
    case scoreIsNotEnough = 1
    case unbindThree = 8
    case incompleteUserInfo = 9
    case addAddressFail = -1
    case tokenOverdue = 999
}

protocol XQSMNTBaseResModelProtocol: HandyJSON {
    
    /// errcode (integer, optional): 错误码，0为成功 ,
    var ErrCode: XQSMNTErrorCode { get set }
    
    /// errmsg (string, optional): 错误信息
    var ErrMsg: String? { get set }
    
}

struct XQSMNTBaseResModel: XQSMNTBaseResModelProtocol {
    var ErrMsg: String?
    var ErrCode: XQSMNTErrorCode = .unknow
    
    init() {
        
    }
}

protocol XQSMNTBaseReqModelProtocol: HandyJSON {
    /// 会话标识符
//    var token: String! {set get}
}

struct XQSMNTBaseReqModel: XQSMNTBaseReqModelProtocol {
    
}

protocol XQSMNTBaseUploadfileResModelProtocol: XQSMNTBaseResModelProtocol {
    /// true 进度, false 完成
    var isProgress: Bool {set get}
    /// 当前进度
    var progress: Progress? {set get}
}


extension Dictionary {
    
    /// 字典转 json str
    func xq_toJsonStr() -> String? {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        if let data = data {
            let str = String.init(data: data, encoding: .utf8)
            return str
        }
        return nil
    }
    
    /// 字典转 url 后面的参数
    /// 例如传入, {"1": "3", "2": "4"}, 那么结果为 1=3&2=4
    func xq_toGetUrlParams() -> String {
        guard let dic = self as? Dictionary<String, Any> else {
            return ""
        }
        
        var arr = [String]()
        for (key, value) in dic {
            var str = key + "="
            if let value = value as? Int {
                str = key + "=" + String(value)
            }else if let value = value as? UInt {
                str = key + "=" + String(value)
            }else if let value = value as? Float {
                str = key + "=" + String(value)
            }else if let value = value as? Double {
                str = key + "=" + String(value)
            }else if let value = value as? String {
                str = key + "=" + value
                
                // 不要加进去的
            }else if let _ = value as? UIImage {
                continue
            }
            
            arr.append(str)
        }
        
        
        if arr.count == 0 {
            return ""
        }
        
        return arr.joined(separator: "&")
    }
    
}


extension String {
    
    func xq_toDic() -> Dictionary<AnyHashable, Any>? {
        let data = self.data(using: .utf8)
        
        if let data = data {
            let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<AnyHashable, Any>
            return dic
        }
        
        return nil
    }
    
}



extension String {
    /// md 加密
    func xq_md5String() -> String {
        let cStr = self.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr, (CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}




