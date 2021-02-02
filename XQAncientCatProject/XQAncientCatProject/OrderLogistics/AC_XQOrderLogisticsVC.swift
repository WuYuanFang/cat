//
//  AC_XQOrderLogisticsVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/7.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import XQAlert

class AC_XQOrderLogisticsVC: XQACBaseVC {

    let contentView = AC_XQOrderLogisticsView()
    
    /// 商城 model
    var orderBIModel: XQSMNTOrderBaseInfoDtoModel?
    
    /// 积分商城 model
    var duihuanRecModel: XQSMNTIntegralDuihuanRecModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setTitle("物流信息")
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.getData()
        
        #if DEBUG
        
        let item = UIBarButtonItem.init(title: "测试", style: .plain, target: self, action: #selector(respondsToTest))
        self.xq_navigationBar.addRightBtn(with: item)
        
        #endif
        
        if let orderBIModel = self.orderBIModel {
            self.contentView.headerView.titleLab.text = orderBIModel.ShipFriendName
            self.contentView.headerView.orderLab.text = "快递号： \(orderBIModel.ShipSN)"
            self.contentView.addressL.text = "[收货地址]\(orderBIModel.Address)"
        }
        
    }
    
    
    func getData() {
        
        if let orderBIModel = self.orderBIModel {
            
            SVProgressHUD.show(withStatus: nil)
            let reqModel = XQSMNTOrderPluginInfoReqModel.init(OId: orderBIModel.Oid)
            XQSMOrderNetwork.getShipPluginInfo(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                
                if let pluginList = resModel.pluginList?.reversed() {
                    self.contentView.dataArr = Array(pluginList)
                }else {
                    self.contentView.dataArr.removeAll()
                }
                
//                if self.contentView.dataArr.count == 0 {
//                    SVProgressHUD.showInfo(withStatus: "还没有物流信息")
//                }
                self.contentView.tableView.reloadData()
                
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }else if let duihuanRecModel = self.duihuanRecModel {
            
            SVProgressHUD.show(withStatus: nil)
            let reqModel = XQSMNTOrderPluginInfoReqModel.init(OId: duihuanRecModel.oid)
            XQSMIntegralNetwork.getIntegralOrdersShipsn(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                
                if let pluginList = resModel.list?.reversed() {
                    self.contentView.dataArr = Array(pluginList)
                }else {
                    self.contentView.dataArr.removeAll()
                }
                
//                if self.contentView.dataArr.count == 0 {
//                    SVProgressHUD.showInfo(withStatus: "还没有物流信息")
//                }
                self.contentView.tableView.reloadData()
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }else {
            SVProgressHUD.showInfo(withStatus: "没有商品信息")
        }
        
        
        
    }
    
    // MARK: - responds
    
    @objc func respondsToTest() {
        XQSystemAlert.actionSheet(withTitle: nil, message: nil, contentArr: ["已完成", "未完成", "随机多个", "一个"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            if index == 0 {
                
                self.contentView.xq_test = true
                
            }else if index == 1 {
                
                self.contentView.xq_test = false
                
            }else if index == 2 {
                self.contentView.xq_test = false
                self.contentView.dataArr.removeAll()
                
                let result = arc4random() % 10 + 1
                
                for item in 0..<result {
//                    self.contentView.dataArr.append(XQSMNTOrderThePlugingModel.init(AcceptTime: "2020.07.21", AcceptStation: "\(item)到达哪里了 15007891111", Remark: "备注..."))
                    self.contentView.dataArr.append(XQSMNTOrderThePlugingModel.init(AcceptTime: "2020.07.21", AcceptStation: "\(item)到达哪里了", Remark: "备注..."))
                }
                
                
            }else {
                self.contentView.xq_test = false
                self.contentView.dataArr.removeAll()
                
                self.contentView.dataArr.append(XQSMNTOrderThePlugingModel.init(AcceptTime: "2020.07.21", AcceptStation: "到达哪里了", Remark: "备注..."))
            }
            
            self.contentView.tableView.reloadData()
            
        }, cancelCallback: nil)
    }
    
}
