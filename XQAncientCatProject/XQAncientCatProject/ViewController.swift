//
//  ViewController.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD



class ViewController: XQACBaseVC, UITableViewDelegate, UITableViewDataSource {
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r = arc4random() % 255
        let g = arc4random() % 255
        let b = arc4random() % 255
        self.xq_view.backgroundColor = UIColor.init(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: 1)
        self.xq_view.backgroundColor = UIColor.white
        
        self.xq_navigationBar.setTitle("首页")
        
        self.initTableView()
        
        let item = UIBarButtonItem.init(image: UIImage.init(named: "debugImage"), style: .plain, target: nil, action: nil)
        self.xq_navigationBar.addRightBtn(with: item)
        
        self.test_bezier()
        
    }
    
    func test_bezier() {
        let v = XQBezierPathView.init(frame: CGRect.init(x: 150, y: 60, width: 150, height: 100))
        v.backgroundColor = UIColor.black
        self.view.addSubview(v)
    }
    
    func initTableView() {
        
        self.dataArr = [
            "商城订单列表",
            "积分商城详情",
            "积分商城列表",
            "购物车1",
            "地址列表1",
            "测试",
            "登录",
            "交易记录",
            "状态页面",
            "购物车2",
            "基础底部弹框",
            "订单页面",
            "宠物列表",
            "地址列表2",
            "消息列表",
            "我的发布",
            "活体交易首页",
            "层级选择弹框",
            "测试CollectionView",
            "实名认证",
        ]
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.xq_view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.xq_view)
        }
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(AC_XQMallOrderListVC(), animated: true)
        case 1:
            SVProgressHUD.showInfo(withStatus: "已遗弃")
//            self.navigationController?.pushViewController(AC_YCIntegralExchangeVC(), animated: true)
        case 2:
            SVProgressHUD.showInfo(withStatus: "已遗弃")
//            self.navigationController?.pushViewController(AC_YCIntegralStoreVC(), animated: true)
            
        case 3:
            self.navigationController?.pushViewController(AC_XQShopCarListVC(), animated: true)
            
        case 4:
            self.navigationController?.pushViewController(test_AC_XQAddressListVC(), animated: true)
            
        case 5:
            self.navigationController?.pushViewController(XQTestViewController(), animated: true)
            
        case 6:
            AC_XQLoginVC.presentLogin(self)
            
        case 7:
            self.navigationController?.pushViewController(AC_XQBusinessHistoryVC(), animated: true)
                
        case 8:
            self.navigationController?.pushViewController(AC_XQStatusVC(), animated: true)
            
        case 9:
            self.navigationController?.pushViewController(AC_XQShopCarVC(), animated: true)
            
        case 10:
            AC_XQBottomAlert.show()
            
        case 11:
            self.navigationController?.pushViewController(AC_XQOrderListVC(), animated: true)
            
        case 12:
            self.navigationController?.pushViewController(AC_XQPetListVC(), animated: true)
            
        case 13:
            self.navigationController?.pushViewController(AC_XQAddressListVC(), animated: true)
            
        case 14:
            self.navigationController?.pushViewController(AC_XQMessageListVC(), animated: true)
                
        case 15:
            self.navigationController?.pushViewController(AC_XQMyPublishVC(), animated: true)
                
        case 16:
            self.navigationController?.pushViewController(AC_XQLiveBusinessVC(), animated: true)
            
        case 17:
            self.navigationController?.pushViewController(XQTestAlertVC(), animated: true)
            
        case 18:
            self.navigationController?.pushViewController(XQTestCollectionVC(), animated: true)
            
        case 19:
            self.navigationController?.pushViewController(AC_XQRealNameAuthenticationVC(), animated: true)
            
        default:
            SVProgressHUD.showInfo(withStatus: "测试")
            break
        }
        
    }
    
    
    
}

