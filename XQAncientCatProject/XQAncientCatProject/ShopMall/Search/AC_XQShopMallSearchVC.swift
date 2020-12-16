//
//  AC_XQShopMallSearchVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import ZQSearch

class AC_XQShopMallSearchVC: XQACBaseVC, AC_XQShopMallSearchViewDelegate, ZQSearchViewDelegate {
    
    let contentView = AC_XQShopMallSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.delegate = self
        
        self.pushSearch()
        
        self.contentView.shopCarBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.presentShopCar()
        }
        
        self.contentView.searchView.xq_addTap { [unowned self] (gestrue) in
            self.pushSearch()
        }
        
    }
    
    /// 获取商品
    func getProducts(_ str: String) {
        if str.count == 0 {
            SVProgressHUD.showInfo(withStatus: "搜索内容不可为空")
            return
        }
        
        let reqModel = XQSMNTGetProductReqModel.init(PageNumber: 1, PageSize: 30, KeyWord: str)
        XQSMAroundShopNetwork.productsWithPage(reqModel).subscribe(onNext: { (resModel) in
            
            
            if resModel.ErrCode.rawValue == 1 {
                // 无商品
                self.contentView.dataArr.removeAll()
                self.contentView.collectionView.reloadData()
                SVProgressHUD.showInfo(withStatus: resModel.ErrMsg)
                return
            }else if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.dataArr = resModel.ProductList ?? []
            
            self.contentView.collectionView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 跳转到搜索
    func pushSearch() {
        let vc = ZQSearchViewController.init(searchViewWithHotDatas: [XQZQSearchModel]())
        if let vc = vc {
            vc.placeholder = "搜索您想要的商品"
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
    /// 跳转去购物车
    func presentShopCar() {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先前去登录")
            return
        }
        
        let vc = AC_XQShopCarVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - AC_XQShopMallSearchViewDelegate
    
    /// 点击cell
    func shopMallView(_ shopMallView: AC_XQShopMallSearchView, didSelectItemAt indexPath: IndexPath) {
        let vc = AC_XQCommodityDetailVC()
        vc.pId = self.contentView.dataArr[indexPath.row].PId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击加入购物车
    func shopMallView(addShopCar shopMallView: AC_XQShopMallSearchView, didSelectItemAt indexPath: IndexPath) {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先前去登录")
            return
        }
        
        let pid = self.contentView.dataArr[indexPath.row].PId
        
        let reqModel = XQSMNTAddCartReqModel.init(buyCount: 1, pid: pid)
        SVProgressHUD.show(withStatus: nil)
        XQSMCartNetwork.addCart(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "已加入购物车")
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - ZQSearchViewDelegate
    func searchViewController(_ searchViewController: ZQSearchViewController!, resultData data: XQZQSearchModel!) {
        print("resultData 选中: \(data.title)")
        searchViewController.dismiss(animated: false, completion: nil)
        self.getProducts(data.title)
        self.contentView.searchView.tf.text = data.title
        self.isFirstSearch = false
    }
    
    func searchViewController(_ searchViewController: ZQSearchViewController!, refreshWithKeyString keyString: String!, dataBlock block: (([XQZQSearchModel]?) -> Void)!) {
        
    }
    
    func searchViewController(_ searchViewController: ZQSearchViewController!, tapSearchWithKeyString keyString: String!, dataBlock block: (([XQZQSearchModel]?) -> Void)!) {
        print("tapSearchWithKeyString 点击搜索: \(keyString)")
        searchViewController.dismiss(animated: false, completion: nil)
        self.getProducts(keyString)
        self.contentView.searchView.tf.text = keyString
        self.isFirstSearch = false
    }
    /// 是否是第一次搜索
    private var isFirstSearch = true
    func searchViewControllerDidSelectCancel(_ searchViewController: ZQSearchViewController!) {
        
        if self.isFirstSearch {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}

