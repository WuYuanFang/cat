//
//  AC_XQRealNameAuthenticationVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/24.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import RPSDK
import SVProgressHUD

class AC_XQRealNameAuthenticationVC: XQACBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item0 = UIBarButtonItem.init(title: "测试", style: .plain, target: self, action: #selector(respondsToTest))
        self.xq_navigationBar.addRightBtn(with: item0)
        
        RPSDK.setup()
    }
    
    var getTokenResModel: XQSMNTUserGetTokenResModel?
    
    // MARK: - responds
    
    @objc
    func respondsToTest() {
        
        let reqModel = XQSMNTBaseReqModel()
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.getToken(reqModel).subscribe(onNext: { (resModel) in
            
            // 后台没返回...
//            if resModel.ErrCode != .succeed {
//                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
//                return
//            }
            
            if resModel.VerifyToken.count == 0 {
                SVProgressHUD.showError(withStatus: "获取token失败")
                return
            }
            
            self.getTokenResModel = resModel
            self.start()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    func start() {
        
        guard let getTokenResModel = self.getTokenResModel else {
            SVProgressHUD.showError(withStatus: "获取token失败")
            return
        }
        
        // 场景标识(bizType):
        
        // 由于安全原因，实人认证不支持模拟器调试。
        RPSDK.start(withVerifyToken: getTokenResModel.VerifyToken, viewController: self) { result in
            // 建议接入方调用实人认证服务端接口DescribeVerifyResult，
            // 来获取最终的认证状态，并以此为准进行业务上的判断和处理。
            print("实人认证结果：", result);
            switch result.state {
            case .pass:
                // 认证通过。
                let reqModel = XQSMNTUserResultTokenReqModel.init(RequestId: getTokenResModel.RequestId)
                XQSMUserNetwork.resultToken(reqModel).subscribe(onNext: { (resModel) in
                    
                    if resModel.ErrCode != .succeed {
                        SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                        return
                    }
                    
                }, onError: { (error) in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }).disposed(by: self.disposeBag)
                break
            case .fail:
                // 认证不通过。
                SVProgressHUD.showError(withStatus: "认证失败")
            case .notVerify:
                // 未认证。
                // 通常是用户主动退出或者姓名身份证号实名校验不匹配等原因导致。
                // 具体原因可通过result.errorCode来区分（详见文末错误码说明表格）。
                break
            default:
                break
            }
        }
    }
    
}
