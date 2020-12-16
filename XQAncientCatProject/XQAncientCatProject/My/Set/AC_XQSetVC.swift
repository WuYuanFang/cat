//
//  AC_XQSetVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQAlert
import SVProgressHUD
import RPSDK

class AC_XQSetVC: XQACBaseVC, AC_XQSetViewDelegate, AC_XQUserInfoProtocol, AC_XQRealNameProtocol {
    
    let contentView = AC_XQSetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.delegate = self
        
        self.contentView.logoutBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            XQSystemAlert.alert(withTitle: "确定要退出登录吗?", message: nil, contentArr: ["确定"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
                
                if let nc = self.navigationController {
                    XQSMBaseNetwork.default.token = ""
                    nc.popViewController(animated: false)
                    AC_XQLoginVC.presentLogin(nc)
                    
                }
            }, cancelCallback: nil)
        }
        
        self.contentView.reloadUI(XQSMNTUserInfoResModel.getUserInfoModel())
        
    }
    
    #if DEBUG
    @objc func pgyUpdateDelegate(_ data: Any) {
        print("回调: ", data)
    }
    #endif
    
    // MARK: - AC_XQSetViewDelegate
    
    func setView(_ setView: AC_XQSetView, didSelectRowAt type: AC_XQSetView.AC_XQSetViewCellType) {
        
        switch type {
        case .personalInformation:
            if XQSMNTUserInfoModel.getUserInfoModel() == nil {
                SVProgressHUD.showInfo(withStatus: "获取不到用户信息")
                return
            }
            self.navigationController?.pushViewController(AC_XQSetPersonalInformationVC(), animated: true)
            
        case .modifyPassword:
            if let userInfo = XQSMNTUserInfoModel.getUserInfoModel() {
                let vc = AC_XQEditPasswordVC()
                vc.phone = userInfo.Phone
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                SVProgressHUD.showInfo(withStatus: "获取不到用户信息")
            }
            
        case .thirdPartyAuthorization:
            let vc = AC_XQThirdPartyAuthorizationVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .realNameAuthentication:
            
            if let userInfo = self.contentView.resModel?.UserInfo, userInfo.VerifyMobile {
                // 已认证
                return
            }
            
            self.realNameAuthentication { [unowned self] in
                self.refreshUserInfo { [unowned self] (resModel) in
                    self.contentView.reloadUI(resModel)
                }
            }
            
        case .version:
            
            #if DEBUG
            PgyUpdateManager.sharedPgy()?.checkUpdate()
            //                PgyUpdateManager.sharedPgy()?.checkUpdate(withDelegete: self, selector: #selector(pgyUpdateDelegate(_:)))
            #endif
            break
            
        default:
//            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
            break
        }
        
    }
    
}


protocol AC_XQRealNameProtocol: NSObjectProtocol {
    
    /// 前去实名认证
    /// - Parameter callback: 成功回调
    func realNameAuthentication(_ callback: ( () -> () )? )
    
}

extension AC_XQRealNameProtocol where Self:XQACBaseVC {
    
    /// 前去实名认证
    func realNameAuthentication(_ callback: ( () -> () )? ) {
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
            
            SVProgressHUD.dismiss()
            self.startRealNameAuthentication(resModel, callback: callback)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    private func startRealNameAuthentication(_ getTokenResModel: XQSMNTUserGetTokenResModel, callback: ( () -> () )? ) {
        
        //        guard let getTokenResModel = self.getTokenResModel else {
        //            SVProgressHUD.showError(withStatus: "获取认证token失败")
        //            return
        //        }
        
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
                SVProgressHUD.show(withStatus: nil)
                XQSMUserNetwork.resultToken(reqModel).subscribe(onNext: { (resModel) in
                    
                    if resModel.ErrCode != .succeed {
                        SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                        return
                    }
                    
                    SVProgressHUD.dismiss()
                    callback?()
                    
                }, onError: { (error) in
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }).disposed(by: self.disposeBag)
                break
            case .fail:
                // 认证不通过。
                //                SVProgressHUD.showError(withStatus: "认证失败")
                break
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


