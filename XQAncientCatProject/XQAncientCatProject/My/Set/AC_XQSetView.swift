//
//  AC_XQSetView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

protocol AC_XQSetViewDelegate: NSObjectProtocol {
    
    func setView(_ setView: AC_XQSetView, didSelectRowAt type: AC_XQSetView.AC_XQSetViewCellType)
    
}

class AC_XQSetView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    enum AC_XQSetViewCellType {
        /// 个人信息
        case personalInformation
        /// 修改密码
        case modifyPassword
        /// 第三方授权
        case thirdPartyAuthorization
        /// 支付设置
        case paySet
        /// 实名认证
        case realNameAuthentication
        /// 关于小古猫
        case aboutUs
        /// 版本更新
        case version
    }
    
    struct CellModel {
        
        var type: AC_XQSetView.AC_XQSetViewCellType = .personalInformation
        var title = ""
        var img = ""
        var des = ""
    }
    
    let result = "cell"
    var tableView: UITableView!
    
    var dataArr = [Array<AC_XQSetView.CellModel>]()
    
    weak var delegate: AC_XQSetViewDelegate?
    
    let logoutBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        self.xq_addSubviews(self.tableView, self.logoutBtn)
        
        // 布局
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.logoutBtn.snp.top)
        }
        
        self.logoutBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-34)
            make.height.equalTo(44)
        }
        
        // 设置属性
        self.tableView.register(AC_XQSetViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(hex: "#F3F3F3")
        
        self.logoutBtn.setTitle("退出登录", for: .normal)
        self.logoutBtn.backgroundColor = UIColor.ac_mainColor
        
        
        self.dataArr.append([
//            AC_XQSetView.CellModel.init(type: .personalInformation, title: "个人信息", des: "头像昵称"),
            AC_XQSetView.CellModel.init(type: .personalInformation, title: "个人信息", des: ""),
//            AC_XQSetView.CellModel.init(type: .modifyPassword, title: "修改密码", des: "修改密码、修改手机号、账号绑定管理"),
            AC_XQSetView.CellModel.init(type: .modifyPassword, title: "修改密码", des: ""),
            AC_XQSetView.CellModel.init(type: .thirdPartyAuthorization, title: "第三方授权", des: ""),
        ])
        
        self.dataArr.append([
//            AC_XQSetView.CellModel.init(type: .paySet, title: "支付设置", des: ""),
            AC_XQSetView.CellModel.init(type: .realNameAuthentication, title: "实名认证", des: ""),
        ])
        
        let dic = Bundle.main.infoDictionary
        
        self.dataArr.append([
            AC_XQSetView.CellModel.init(type: .aboutUs, title: "关于小古猫", des: ""),
            AC_XQSetView.CellModel.init(type: .version, title: "版本更新", des: "\(dic?["CFBundleShortVersionString"] ?? "")(\(dic?["CFBundleVersion"] ?? ""))"),
        ])
        
    }
    
    var resModel: XQSMNTUserInfoResModel?
    func reloadUI(_ resModel: XQSMNTUserInfoResModel?) {
        self.resModel = resModel
        self.tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQSetViewCell
        
        let model = self.dataArr[indexPath.section][indexPath.row]
        
        cell.titleLab.text = model.title
        cell.messageLab.text = model.des
        
        switch model.type {
        case .realNameAuthentication:
            if let userInfo = resModel?.UserInfo, userInfo.VerifyMobile {
                cell.messageLab.text = "已认证"
            }else {
                cell.messageLab.text = "未认证"
            }
            
            break
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataArr[indexPath.section][indexPath.row]
        self.delegate?.setView(self, didSelectRowAt: model.type)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

}
