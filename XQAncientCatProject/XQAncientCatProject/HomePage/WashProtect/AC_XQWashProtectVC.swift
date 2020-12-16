//
//  AC_XQWashProtectVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 洗护
class AC_XQWashProtectVC: XQACBaseVC, AC_XQWashProtectViewSelectPetViewDelegate, AC_XQWashProtectViewServiceViewDelegate, AC_XQBaseVCSrollNavigationBarGradientsProtocol, UIScrollViewDelegate {
    
    var xq_ngbCurrentType: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType = .transparent
    

    let contentView = AC_XQWashProtectView()
    
    /// 附近商店信息
    var ShopInfo: XQSMNTToShopIndexModel?
    
    /// ShopItem (ShopInfoDto, optional): 店铺基本信息 ,
    var shopDetailInfoModel: XQSMNTShopInfoModel?
    /// 商店详情信息
    var shopDetailInfo: XQSMNTGetAllShopInfoWithProductV2ResModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.left.right.equalToSuperview()
            
        }
        
        self.contentView.petView.delegate = self
        self.contentView.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.contentView.serviceView.delegate = self
        
        self.reloadHeaderUI()
        self.getData()
        
        self.contentView.payView.payBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.pay()
        }
        
        self.contentView.appointmentView.ShopInfo = self.ShopInfo
        self.contentView.appointmentView.callback = { [unowned self] in
            self.calculation()
        }
        
        self.contentView.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.contentView.petView.dataArr.count == 0 {
            self.getPetList()
        }
        
    }
    
    func reloadHeaderUI() {
        if let shopDetailInfo = self.shopDetailInfo {
            var urlArr = [URL]()
            for item in shopDetailInfo.ShopItem?.BannerList ?? [] {
                if let url = item.PhotoWithAddress.sm_getImgUrl() {
                    urlArr.append(url)
                }
            }
            self.contentView.headerView.cycleScrollView.imageURLStringsGroup = urlArr
        }
        
        self.contentView.headerView.titleLab.text = "\(self.ShopInfo?.Name ?? "")(营业中)"
        
        if let workingTime = self.ShopInfo?.WorkingTimeList?.first {
            self.contentView.headerView.timeLab.text = "营业时间: \(workingTime.BeginTime)-\(workingTime.EndTime)"
        }else {
            self.contentView.headerView.timeLab.text = ""
        }
        
        self.contentView.headerView.addressBtn.setTitle("\(self.ShopInfo?.Address ?? "")(距您\(self.ShopInfo?.TheDistance ?? 0)km)", for: .normal)
    }
    
    func getData() {
        self.getAllShopInfo()
    }
    
    /// 获取店铺信息
    func getAllShopInfo() {
        
        // 套餐单选, 单品可选多个
        // 选了套餐之后, 单品就是显示套餐的 NoIncludePdList 这个字段. 就是不包含字段.
        
        let reqModel = XQSMNTGetAllShopInfoWithProductReqModel.init(ShopId: self.ShopInfo?.Id ?? 0)
        XQSMToShopNetwork.getAllShopInfoV2(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.shopDetailInfo = resModel
            self.shopDetailInfoModel = resModel.ShopItem
            self.contentView.serviceView.packageList = resModel.PackageList
            
            self.reloadHeaderUI()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取宠物列表
    func getPetList() {
        if XQSMBaseNetwork.default.token.count == 0 {
            print("让用户前去登录")
            return
        }
        // 这里有个问题, 后台应该给个获取不在寄养和洗护中的宠物
        let reqModel = XQSMNTGetMyPetListReqModel.init(state: .all)
        
        XQSMUserPetNetwork.getMyPetList(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            var lss = [XQSMNTGetMyPetListUserPetInfoModel]()
            for item in resModel.Lss ?? [] {
                if item.State == .unknow {
                    lss.append(item)
                }
            }
            self.contentView.petView.dataArr = lss
            self.contentView.petView.collectionView.reloadData()
            
            self.calculation()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    /// 获取当前预约时间
    func getCurrentDate() -> Date? {
//        let year = Date().xq_toStringY()
//        let dateStr = year + "年" + (self.contentView.appointmentView.timeLab.text ?? "")
//        if let date = dateStr.xq_toDate("yyyy年MM月dd日 HH:mm") {
//            return date
//        }
        
        return self.contentView.appointmentView.date
    }
    
    private struct CalculationModel {
        /// 预约时间
        var appointmentDate: Date?
        
        /// 猫
        var petModel: XQSMNTGetMyPetListUserPetInfoModel?
        
        /// 套餐和单品
        var selectProductInfoModel: AC_XQWashProtectViewServiceView.SelectProductInfoModel?
    }
    
    /// 计算价格
    @discardableResult
    private func calculation(_ callback: (() -> ())? = nil ) -> CalculationModel? {
        
        if XQSMBaseNetwork.default.token.count == 0 {
            return nil
        }
        
        if self.contentView.petView.dataArr.count == 0 {
            return nil
        }
        
        guard let productInfoModelModel = self.contentView.serviceView.getProductInfoModel() else {
            return nil
        }
        
        // 宠物 id
        let petModel = self.contentView.petView.dataArr[self.contentView.petView.selectIndex]
        
        // 商店 id
        let shopId = self.ShopInfo?.Id ?? 0
        
        // 预约时间
        var startTime = ""
        if let date = self.getCurrentDate() {
            startTime = date.xq_toString("yyyy-MM-dd HH:mm:ss")
        }
        
        if startTime.count == 0 {
            return nil
        }
        
        let reqModel = XQSMNTBeginOrderReqModel.init(ShopId: shopId,
                                                     PetId: petModel.Id,
                                                     SubscribeTime: startTime,
                                                     Phone: "",
                                                     Remark: "",
                                                     PdList: productInfoModelModel.productInfoModelArr,
                                                     SendAddress: "",
                                                     SendX: "",
                                                     SendY: "",
                                                     SendBackAddress: "",
                                                     SendBackX: "",
                                                     SendBackY: "",
                                                     ManName: "",
                                                     PackageId: productInfoModelModel.packageId,
                                                     NeedSend: false,
                                                     NeedSendBack: false,
                                                     ChoseUserRank: false,
                                                     CouponId: 0,
                                                     ChoseTrueMan: false)
        
        XQSMToShopNetwork.preOrder(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.payView.moneyLab.text = "合计 ¥\(resModel.TotalPrice)"
            callback?()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
        return CalculationModel.init(appointmentDate: startTime.xq_toDate("yyyy-MM-dd HH:mm:ss"), petModel: petModel, selectProductInfoModel: productInfoModelModel)
        
    }
    
    /// 跳转到下单页面
    func pay() {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先登录")
            return
        }
        
        if self.contentView.petView.dataArr.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择宠物")
            return
        }
        
        guard let productInfoModelModel = self.contentView.serviceView.getProductInfoModel() else {
            SVProgressHUD.showInfo(withStatus: "请选择服务")
            return
        }
        
        guard let _ = self.getCurrentDate() else {
            SVProgressHUD.showInfo(withStatus: "请选择预约时间")
            return
        }
        
        self.calculation { [unowned self] in
            let vc = AC_XQWashProtectOrderVC()
            vc.appointmentDate = self.getCurrentDate()
            vc.ShopInfo = self.ShopInfo
            vc.petModel = self.contentView.petView.dataArr[self.contentView.petView.selectIndex]
            vc.packageProductModel = productInfoModelModel.packageProductModel
            vc.singleProductArr = productInfoModelModel.singleProductArr
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - AC_XQWashProtectViewSelectPetViewDelegate
    
    /// 点击某个猫
    func selectPetView(_ selectPetView: AC_XQWashProtectViewSelectPetView, didSelectItemAt indexPath: IndexPath) {
        self.calculation()
    }
    
    /// 点击添加
    func selectPetView(tapAdd selectPetView: AC_XQWashProtectViewSelectPetView) {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先登录")
            return
        }
        
        let vc = AC_XQEditPetInfoVC()
        vc.refreshCallback = { [unowned self] in
            self.getPetList()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - AC_XQWashProtectViewServiceViewDelegate
    func washProtectViewServiceView(contentChange washProtectViewServiceView: AC_XQWashProtectViewServiceView) {
        self.calculation()
    }
    
    func washProtectViewServiceView(viewPackageDetail washProtectViewServiceView: AC_XQWashProtectViewServiceView, packageModel: XQSMNTToShopPdPackageModel) {
        let vc = AC_XQWashProtectPackageDetailVC()
        vc.packageModel = packageModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 单项查看详情
    func washProtectViewServiceView(viewSingleServerDetail washProtectViewServiceView: AC_XQWashProtectViewServiceView, model: XQSMNTToProductTinnyV2Model) {
        let vc = AC_XQWashProtectPackageDetailVC()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.xq_nbgDidScroll(with: Float(scrollView.contentOffset.y))
    }
    
    // MARK: - AC_XQBaseVCSrollNavigationBarGradientsProtocol
    
    /// 导航栏变化回调
    func xq_nbgChange(_ type: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType) {
        print(#function, type)
    }

}

