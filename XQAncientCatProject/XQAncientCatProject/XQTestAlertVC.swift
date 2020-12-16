//
//  XQTestAlertVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/26.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

class XQTestAlertVC: XQACBaseVC, UITableViewDelegate, UITableViewDataSource, XQAlertSelectLevelViewDataSource, XQAlertSelectLevelViewDelegate {
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    let addressAlertView = XQAlertSelectLevelView.init(frame: CGRect.zero, contentHeight: 400)
    var addressDataArr = [Array<String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressAlertView.dataSource = self
        self.addressAlertView.delegate = self
        self.initTableView()
        
    }
    
    func initTableView() {
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.xq_view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.rowHeight = 60
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.dataArr = [
            "基础弹框",
            "选择层级弹框",
            "选择地址弹框",
            "花里胡哨选择时间弹框",
            "花里胡哨选择食物",
            "选择年月日",
            "支付弹框",
        ]
        
        self.addressAlertView.selectSectionMax = 2
        
//        self.addressDataArr = [
//            [
//                "0000",
//                "1111",
//                "2222",
//            ],
//            [
//                "5555",
//                "6666",
//            ],
//            [
//                "0000",
//                "1111",
//                "2222",
//                "3333",
//                "4444",
//                "5555",
//                "6666",
//            ]
//        ]
        
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath)
        cell.textLabel?.text = self.dataArr[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0:
            AC_XQBottomAlert.show()
            
        case 1:
            self.addressAlertView.show()
                
        case 2:
            XQAlertSelectAddressView.show(nil)
            
        case 3:
            XQAlertSelectAppointmentView.show([], callback: nil)
                
        case 4:
            XQAlertSelectFoodView.show()
            
        case 5:
            XQAlertSelectYMDPickerView.show(.md, sureCallback: nil)
            
        case 6:
            AC_XQAlertSelectPayView.show("", money: 0, payType: .shopMall, callback: { (payId, payType) in
                print("点击了支付: ", payType)
            }) {
                print("隐藏了")
            }
            
        default:
            break
        }
    }
    
    // MARK: - XQAlertSelectLevelViewDataSource
    
    /// 某个分区, 多少行
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, numberOfRowsInSection section: Int) -> Int {
        print(#function, Date.init().timeIntervalSince1970)
        
        if self.addressDataArr.count <= section {
            // 模拟网络请求
            SVProgressHUD.show(withStatus: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                SVProgressHUD.dismiss()
                
                let count = arc4random() % 10 + 2
                var titles = [String]()
                for item in 0..<count {
                    titles.append("\(item)\(item)\(item)\(item)")
                }
                
                self.addressDataArr.append(titles)
                self.addressAlertView.reloadCurrentSection()
            }
            return 0
        }
        
        return self.addressDataArr[section].count
    }
    
    /// 某行标题
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, titleForRowAt indexPath: IndexPath) -> String {
        return self.addressDataArr[indexPath.section][indexPath.row]
    }
    
    
    // MARK: - XQAlertSelectLevelViewDelegate
    
    /// 点击取消或者点击背景
    func alertSelectLevelView(hide alertSelectLevelView: XQAlertSelectLevelView) {
        print("wxq: 隐藏了")
    }
    
    /// 点击选择了某个分区
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, didSelectSectionAt section: Int) {
        print("wxq: 点击了")
    }
    
    /// 点击选择了某一行
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
