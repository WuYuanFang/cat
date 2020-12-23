//
//  AC_XQHomePageVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI
import SVProgressHUD

//class AC_XQHomePageVC: XQACBaseVC, AC_XQHomePageViewAppointmentViewDelegate, AC_XQHomePageViewHotViewDelegate, AC_XQBaseVCSrollNavigationBarGradientsProtocol, UIScrollViewDelegate {
    
class AC_XQHomePageVC: XQACBaseVC, AC_XQHomePageViewAppointmentViewDelegate, AC_XQHomePageViewHotViewDelegate {
    
    let contentView = AC_XQHomePageView()
    
    var xq_ngbCurrentType: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType = .transparent
    
    /// 轮播图
    var homePageNewModels: [XQSMNTHomePageNewModel]?
    
    /// 附近商店信息
    var ShopInfo: XQSMNTToShopIndexModel?
    
    /// 商店详情信息
    var shopDetailInfo: XQSMNTGetAllShopInfoWithProductV2ResModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.top.equalTo(-XQIOSDevice.getStatusHeight())
            make.bottom.left.right.equalToSuperview()
        }
        
        #if DEBUG
        let item = UIBarButtonItem.init(title: "测试", style: .plain, target: self, action: #selector(respondsToTest))
        //        let messageItem = UIBarButtonItem.init(image: UIImage.init(named: "homePage_message"), style: .plain, target: self, action: #selector(respondsToMessageList))
        //        self.xq_navigationBar.addRightBtns(with: messageItem, item)
        self.xq_navigationBar.addRightBtns(with: item)
        #endif
        
        self.contentView.appointmentView.delegate = self
        self.contentView.hotView.delegate = self
        
//        self.contentView.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getBanner()
        self.getTheHots()
        
        #if DEBUG
        ac_setIsShowV(true)
        #else
        if !ac_isShowV() {
            self.isShowV()
        }
        #endif
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.getClosestShop()
    }
    
    /// 获取轮播图
    func getBanner() {
        if self.homePageNewModels != nil {
            return
        }
        
        XQSMHomePageNetwork.getBanner().subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.homePageNewModels = resModel.HomePageNewModels
            
            var imageURLStringsGroup = [URL]()
            for item in self.homePageNewModels ?? [] {
                if let url = item.ImageWithAddress.sm_getImgUrl() {
                    imageURLStringsGroup.append(url)
                }
            }
            
            self.contentView.headerView.cycleScrollView.imageURLStringsGroup = imageURLStringsGroup
            self.contentView.headerView.waveView.pageControl.numberOfPages = imageURLStringsGroup.count
            
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    
    /// 获取附近门店
    func getClosestShop() {
        
        if self.ShopInfo != nil {
            // 已经存在了
            return
        }
        // 改成失败成功都去获取了，反正只有一家店
        print("定位开始")
        XQSMLocation.shared().location({ (location, locationNetworkState) in
            guard let _ = location else {
                return
            }
            let reqModel = XQSMNTGetClosestShopReqModel.init(X: Float(location?.location?.coordinate.latitude ?? 0), Y: Float(location?.location?.coordinate.longitude ?? 0))
            print("定位结束")
            
            if location == nil {
                print("定位失败: ", locationNetworkState)
            }else {
                print("定位成功: ", location ?? "没有")
            }
            
//            guard let location = location else {
//                print("定位失败: ", locationNetworkState)
//                return
//            }
            
//            let reqModel = XQSMNTGetClosestShopReqModel.init(X: Float(location.location?.coordinate.latitude ?? 0), Y: Float(location.location?.coordinate.longitude ?? 0))
            
            self.getClosestShop(with: reqModel)
            
        }) { (error) in
            print("定位失败: ", error)
            let reqModel = XQSMNTGetClosestShopReqModel.init(X: 0, Y: 0)
            self.getClosestShop(with: reqModel)
        }
        
        
    }
    
    func getClosestShop(with reqModel: XQSMNTGetClosestShopReqModel) {
        XQSMToShopNetwork.getClosestShop(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            
            self.ShopInfo = resModel.ShopInfo
            if let model = resModel.ShopInfo {
                XQSMNTToShopIndexModel.xq_setModel(model)
            }
            
            self.contentView.shopInfoView.iconImgView.sd_setImage(with: self.ShopInfo?.LogoWithAddress.sm_getImgUrl())
            self.contentView.shopInfoView.nameLab.text = self.ShopInfo?.Name
            
            if let workingTime = self.ShopInfo?.WorkingTimeList?.first {
                self.contentView.shopInfoView.workTimeBtn.setTitle("营业时间: \(workingTime.BeginTime)-\(workingTime.EndTime)", for: .normal)
            }else {
                self.contentView.shopInfoView.workTimeBtn.setTitle("", for: .normal)
            }
            
            self.contentView.shopInfoView.addressBtn.setTitle("\(self.ShopInfo?.Address ?? "")(距您\(self.ShopInfo?.TheDistance ?? 0)km)", for: .normal)
            
            self.getShopDetailInfo()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取商店详情信息
    func getShopDetailInfo() {
        
        guard let ShopInfo = self.ShopInfo else {
            return
        }
        
        let reqModel = XQSMNTGetAllShopInfoWithProductReqModel.init(ShopId: ShopInfo.Id)
        XQSMToShopNetwork.getAllShopInfoV2(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            
            
            self.shopDetailInfo = resModel
            
            self.contentView.shopInfoView.phoneImgView.isUserInteractionEnabled = true
            self.contentView.shopInfoView.phoneImgView.xq_addTap { [unowned self] (gestrue) in
                
                if let phone = self.shopDetailInfo?.ShopItem?.Phone, let url = URL.init(string: "tel://\(phone)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取热门推荐
    func getTheHots() {
        if self.contentView.hotView.dataArr.count != 0 {
            return
        }
        XQSMHomePageNetwork.getTheHots().subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.hotView.dataArr = resModel.HotList ?? []
            self.contentView.hotView.collectionView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    
    func isShowV() {
        XQSMHomePageNetwork.getIsShowV().subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode == .succeed {
                // 不显示
                ac_setIsShowV(false)
            }else if resModel.ErrCode == .scoreIsNotEnough {
                // 显示
                ac_setIsShowV(true)
            }
            
        }, onError: { (error) in
            
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - responds
    
    @objc func respondsToTest() {
        self.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    @objc func respondsToMessageList() {
        self.navigationController?.pushViewController(AC_XQMessageListVC(), animated: true)
    }
    
    
    // MARK: - AC_XQHomePageViewAppointmentViewDelegate
    
    /// 点击洗护
    func homePageViewAppointmentView(tapWashProtext homePageViewAppointmentView: AC_XQHomePageViewAppointmentView) {
        guard let shopInfo = self.ShopInfo else {
            SVProgressHUD.showInfo(withStatus: "获取不到周边商店信息")
            return
        }
        
        let vc = AC_XQWashProtectVC()
        vc.ShopInfo = shopInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击寄养
    func homePageViewAppointmentView(tapFoster homePageViewAppointmentView: AC_XQHomePageViewAppointmentView) {
        guard let shopInfo = self.ShopInfo else {
            SVProgressHUD.showInfo(withStatus: "获取不到周边商店信息")
            return
        }
        
        let vc = AC_XQFosterVC()
        vc.ShopInfo = shopInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击繁育
    func homePageViewAppointmentView(tapBreed homePageViewAppointmentView: AC_XQHomePageViewAppointmentView) {
        SVProgressHUD.showInfo(withStatus: "即将上线,敬请期待!")
//        self.navigationController?.pushViewController(AC_XQBreedVC(), animated: true)
    }
    
    
    // MARK: - AC_XQHomePageViewHotViewDelegate
    func homePageViewHotView(_ homePageViewHotView: AC_XQHomePageViewHotView, didSelectItemAt indexPath: IndexPath) {
//        SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待!")
        SVProgressHUD.showInfo(withStatus: "即将上线,敬请期待!")
    }
    
//    // MARK: - UIScrollViewDelegate
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        self.xq_nbgDidScroll(with: Float(scrollView.contentOffset.y))
//    }
//
//    // MARK: - AC_XQBaseVCSrollNavigationBarGradientsProtocol
//
//    /// 导航栏变化回调
//    func xq_nbgChange(_ type: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType) {
//        print(#function, type)
//    }
    
}
