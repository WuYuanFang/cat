//
//  AC_XQShopMallVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import CMPageTitleView
import MJRefresh
import JXSegmentedView

/// 商城
class AC_XQShopMallVC: XQACBaseVC, AC_XQShopMallViewDelegate, JXSegmentedViewDelegate {
    
    let contentView = AC_XQShopMallView()
    
    var newModelArr: [XQSMNTAroundShopNewModel]?
    var selSecond: XQSMNTAroundShopTopMenuModel?
    
    /// 当前选中分类的id
    var currentCateId = 0
    /// 当前多少页
    var page = 0
    
    var brandModel: XQSMNTAroundShopBrandInfoModel?
    var minPrice: Int = 0
    var maxPrice: Int = 0
    var showType: XQSMNTGetProductReqModel.XQSMNTGetProductReqModelShowType = .all

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.delegate = self
        
        
        self.contentView.headerView.searchView.xq_addTap { [unowned self] (gestrue) in
            self.presentSearch()
        }
        
        self.contentView.headerView.segmentView.delegate = self
        
        
        self.contentView.shopCarBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.presentShopCar()
        }
        
        // 选择不同类型
        self.contentView.headerView.selectTypeUpdateCallback = { [unowned self] (sortType) in
            self.contentView.collectionView.mj_header?.beginRefreshing()
        }
        
        // 过滤规则
        self.contentView.headerView.typeBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.showSecondView()
        }
        
        self.contentView.collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            if self.contentView.collectionView.mj_footer?.isRefreshing ?? false {
                self.contentView.collectionView.mj_header?.endRefreshing()
                return
            }
            
            self.getProducts()
        })
        
        self.contentView.collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [unowned self] in
            if self.contentView.collectionView.mj_header?.isRefreshing ?? false {
                self.contentView.collectionView.mj_footer?.endRefreshing()
                return
            }
            
            self.nextProducts()
        })
        
//        self.contentView.collectionView.mj_header?.beginRefreshing()
        self.getProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTopMenu()
        self.getNews()
    }
    
    /// 获取第一层分类
    func getTopMenu() {
        if self.contentView.headerView.menuList.count != 0 {
            return
        }
        
        let reqModel = XQSMNTBaseReqModel()
        XQSMAroundShopNetwork.getTopMenuList(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            self.contentView.headerView.menuList = resModel.MenuList ?? []
            self.contentView.headerView.reloadTitles()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取商品
    func getProducts() {
        self.page = 0
        self.nextProducts()
    }
    
    /// 显示二级菜单
    func showSecondView() {
//        /api/AroundShop/GetSecOrThrMenuList
        let trq = XQSMNTSecOrThrMenuReqModel.init(CateId: self.currentCateId)
        XQSMAroundShopNetwork.getSecOrThrMenuList(trq).subscribe { (resModel) in
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            if let arr = resModel.MenuList, arr.count > 0 {
                DK_XQShopMallSecondFilterAlertView.showMenu(bgView: self.view, menus: arr, selM: self.selSecond) { (tmpM) in
                    self.selSecond = tmpM
                    self.showPingpai()
                }
            }
        } onError: { (error) in
            
        }.disposed(by: self.disposeBag)
    }
    /// 显示品牌
    func showPingpai() {
        AC_XQShopMallFilterAlertView.show(self.brandModel, Float(self.minPrice), Float(self.maxPrice), self.showType) { [unowned self] (brandInfoModel, min, max, showType, isreset) in
            self.brandModel = brandInfoModel
            self.minPrice = Int(min)
            self.maxPrice = Int(max)
            self.showType = showType
            
            if isreset {
                self.selSecond = nil
            }
            
            self.contentView.collectionView.mj_header?.beginRefreshing()
        }
    }
    
    
    /// 下一页商品
    func nextProducts() {
        self.page += 1
//        let reqModel = XQSMNTGetProductReqModel.init(CateId: self.currentCateId, PageNumber: self.page, PageSize: 20)
        let reqModel = XQSMNTGetProductReqModel.init(CateId: self.selSecond?.CateId ?? self.currentCateId,
                                                     PageNumber: self.page,
                                                     PageSize: 20,
                                                     SortType: self.contentView.headerView.selectType,
                                                     ShowType: self.showType,
                                                     TheMaxPrice: self.maxPrice,
                                                     TheMinPrice: self.minPrice,
                                                     BrandId: self.brandModel?.BrandId ?? 0)
        
        
        XQSMAroundShopNetwork.productsWithPage(reqModel).subscribe(onNext: { (resModel) in
            
            
            if resModel.ErrCode.rawValue == 1 {
                // 无商品
                self.contentView.dataArr.removeAll()
                self.contentView.collectionView.reloadData()
                return
            }else if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                self.page -= 1
                return
            }
            
            if self.page == 1 {
                self.contentView.dataArr = resModel.ProductList ?? []
            }else {
                self.contentView.dataArr.append(contentsOf: resModel.ProductList ?? [])
            }
            
            self.contentView.collectionView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.page -= 1
        }, onCompleted: {
            self.contentView.collectionView.mj_header?.endRefreshing()
            self.contentView.collectionView.mj_footer?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取轮播图
    func getNews() {
        if let _ = self.newModelArr {
            return
        }
        
        let reqModel = XQSMNTBaseReqModel()
        XQSMAroundShopNetwork.aroundShopNews(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.newModelArr = resModel.Lss
            
            var imageURLStringsGroup = [URL]()
            for item in self.newModelArr ?? [] {
                if let url = item.ImageWithAddress.sm_getImgUrl() {
                    imageURLStringsGroup.append(url)
                }
            }
            
            print(imageURLStringsGroup)
//            self.contentView.headerView.cycleScrollView.imageURLStringsGroup = imageURLStringsGroup
//            self.contentView.headerView.waveView.pageControl.numberOfPages = imageURLStringsGroup.count
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
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
    
    
    /// 跳转到搜索
    func presentSearch() {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先前去登录")
            return
        }
        
        
        
//        self.navigationController?.pushViewController(AC_XQMallSearchVC(), animated: false)
        self.navigationController?.pushViewController(AC_XQShopMallSearchVC(), animated: false)
    }
    
    // MARK: - AC_XQShopMallViewDelegate
    
    /// 点击cell
    func shopMallView(_ shopMallView: AC_XQShopMallView, didSelectItemAt indexPath: IndexPath) {
        let vc = AC_XQCommodityDetailVC()
        vc.pId = self.contentView.dataArr[indexPath.row].PId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击加入购物车
    func shopMallView(addShopCar shopMallView: AC_XQShopMallView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    // MARK: - CMPageTitleViewDelegate
    func cm_pageTitleViewClick(with index: Int, repeat xq_repeat: Bool) {
        if xq_repeat {
            return
        }
        
//        if index == 0 {
//            // 全部
//            self.currentCateId = 0
//            self.getProducts()
//        }else {
        self.selSecond = nil
        let model = self.contentView.headerView.menuList[index]
        self.currentCateId = model.CateId
        self.getProducts()
//        }
        
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.selSecond = nil
        let model = self.contentView.headerView.menuList[index]
        self.currentCateId = model.CateId
        self.getProducts()
    }
    
    
}
