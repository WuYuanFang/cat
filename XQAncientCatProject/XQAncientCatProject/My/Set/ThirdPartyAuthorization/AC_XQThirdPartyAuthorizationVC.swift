//
//  AC_XQThirdPartyAuthorizationVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/22.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import XQAlert
import XQTencent
import XQWechat

/// 第三方授权
class AC_XQThirdPartyAuthorizationVC: XQACBaseVC, UITableViewDelegate, UITableViewDataSource, AC_XQUserInfoProtocol {
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    var userInfoModel: XQSMNTUserInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
    }
    
    func initTableView() {
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.xq_view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(AC_XQThirdPartyAuthorizationVCCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 44
        self.tableView.separatorStyle = .none
        
        self.dataArr = [
            "QQ登录",
            "微信登录"
        ]
        
        self.reloadUI()
    }
    
    func reloadUI() {
        self.userInfoModel = XQSMNTUserInfoModel.getUserInfoModel()
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQThirdPartyAuthorizationVCCell
        
        cell.titleLab.text = self.dataArr[indexPath.row]
        
        
        if indexPath.row == 0 {
            cell.imgView.image = UIImage.init(named: "qq")
            
            if self.userInfoModel?.QQOpenId.count ?? 0 == 0 {
                cell.messageLab.text = "未绑定"
            }else {
                cell.messageLab.text = "已绑定"
            }
            
        }else {
            cell.imgView.image = UIImage.init(named: "wechat")
            
            if self.userInfoModel?.WechatOpenId.count ?? 0 == 0 {
                cell.messageLab.text = "未绑定"
            }else {
                cell.messageLab.text = "已绑定"
            }
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            if self.userInfoModel?.QQOpenId.count ?? 0 == 0 {
                
                XQTencentOpenApi.manager().sendAutInfo(withPermissionsArr: [kOPEN_PERMISSION_GET_USER_INFO], callback: { [unowned self] (openId, errcode) in
                    if errcode == .succeed {
                        self.bingTP(XQSMNTUserAliPayLoginReqModel.init(openId: openId, type: .qq))
                    }else if errcode != .cancel {
                        SVProgressHUD.showError(withStatus: "授权失败")
                    }
                })
                
            }else {
                
                XQSystemAlert.alert(withTitle: "确定要解绑吗?", message: nil, contentArr: ["确定"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
                    self.bingTP(XQSMNTUserAliPayLoginReqModel.init(openId: "", type: .qq))
                }, cancelCallback: nil)
                
            }
            
        case 1:
//            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
            
            if self.userInfoModel?.WechatOpenId.count ?? 0 == 0 {
//                XQWechat.manager().sendAutInfo(withViewContoller: self)
                XQWechat.manager().sendAutInfo { [unowned self] (code, errCode) in
                    if errCode == WXSuccess.rawValue {
                        self.wechatLogin(withCode: code)
                    }else if errCode != WXErrCodeUserCancel.rawValue {
                        SVProgressHUD.showError(withStatus: "授权失败")
                    }
                }
                
            }else {
                
                XQSystemAlert.alert(withTitle: "确定要解绑吗?", message: nil, contentArr: ["确定"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
                    self.bingTP(XQSMNTUserAliPayLoginReqModel.init(openId: "", type: .wechat))
                }, cancelCallback: nil)
                
            }
            
            break
            
        default:
            break
        }
        
    }
    
    private func bingTP(_ reqModel: XQSMNTUserAliPayLoginReqModel) {
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.bindOrUnBindThreeOpenId(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            if reqModel.openId.count == 0 {
                SVProgressHUD.showSuccess(withStatus: "解绑成功")
            }else {
                SVProgressHUD.showSuccess(withStatus: "绑定成功")
            }
            
            self.refreshUserInfo { [unowned self] (resModel) in
                self.reloadUI()
            }
            
        }, onError: { (error) in
            
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            
        }).disposed(by: self.disposeBag)
    }
    
    /// 通过 code 获取 openid, 并且绑定
    private func wechatLogin(withCode code: String) {
        SVProgressHUD.show(withStatus: nil)
        XQWechat.manager().getTokenWithCode(code, succeed: { (respondsData) in
            
            if let respondsData = respondsData as? Dictionary<String, Any>, let openId = respondsData["openid"] as? String {
                
                self.bingTP(XQSMNTUserAliPayLoginReqModel.init(openId: openId, type: .wechat))
                
            }else {
                SVProgressHUD.showError(withStatus: "获取微信信息失败")
            }
            
        }) { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
}
