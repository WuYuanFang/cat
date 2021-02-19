//
//  AC_XQFosterVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 寄养
class AC_XQFosterVC: XQACBaseVC, AC_XQWashProtectViewSelectPetViewDelegate, AC_XQFosterViewSelectHouseViewDelegate, XQNumberViewDelegate, UIScrollViewDelegate {
    
    var xq_ngbCurrentType: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType = .transparent

    let contentView = AC_XQFosterView()
    
    /// 附近商店信息
    var ShopInfo: XQSMNTToShopIndexModel?
    
    /// 商店详情信息
    var shopDetailInfo: XQSMNTGetAllShopInfoWithProductV2ResModel?
    
    /// 食物列表
    var foodList: [XQACNTFosterCategoryShopModel]?
    var selectFoodIndexPaths: [IndexPath]?
    
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
        
        self.contentView.commentView.xq_addTap { [unowned self] (gesture) in
            self.navigationController?.pushViewController(AC_XQShopMallCommentVC(), animated: true)
        }
        
        self.contentView.payView.payBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.pay()
        }
        
        self.reloadHeaderUI()
        
        self.getData()
        
        self.contentView.appointmentView.callback = { [unowned self] in
            self.getCatdormitory()
//            self.calculation()
        }
        
        self.contentView.optionView.fSwitchView.xq_switch.addTarget(self, action: #selector(respondsToFood(_:)), for: .valueChanged)
        
        self.contentView.houseView.delegate = self
        self.contentView.dayView.numberView.delegate = self
        
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
            self.contentView.cycleScrollView.imageURLStringsGroup = urlArr
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
        
        self.getCatdormitory()
        
        self.getShopDetailInfo()
    }
    
    /// 获取猫舍
    func getCatdormitory() {
        let starT = self.contentView.appointmentView.date?.xq_toString("yyyy-MM-dd HH:mm") ?? "" // Date().xq_toString("yyyy-MM-dd HH:mm")
        print(self.contentView.appointmentView.date?.xq_toString("yyyy-MM-dd HH:mm") ?? "")
        let reqModel = XQACNTGetShopCatdormitoryReqModel.init(shopid: self.ShopInfo?.Id ?? 0, StartTime: starT, day: self.contentView.dayView.numberView.tf.text ?? "1")
        XQACFosterNetwork.getShopCatdormitory(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.houseView.dataArr = resModel.list ?? []
            self.contentView.houseView.collectionView.reloadData()
            
            if self.contentView.petView.dataArr.count != 0 {
                self.calculation()
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取加食投喂
    func getFood() {
        
        if let _ = self.foodList {
            self.showFoodAlert()
            return
        }
        
        let reqModel = XQACNTGetShopCatdormitoryReqModel.init(shopid: self.ShopInfo?.Id ?? 0)
        SVProgressHUD.show(withStatus: nil)
        XQACFosterNetwork.fosterCategoryShop(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            self.foodList = resModel.list
            self.showFoodAlert()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 显示加食弹框
    func showFoodAlert() {
        guard let foodList = self.foodList else {
            return
        }
        
        var modelArr = [XQAlertSelectFoodViewModel]()
        
        for item in foodList {
            var model = XQAlertSelectFoodViewModel.init(name: item.Name, foods: [String]())
            for shop in item.shoplist ?? [] {
                model.foods.append(shop.Name)
            }
            modelArr.append(model)
        }
        
        XQAlertSelectFoodView.show(modelArr) { (indexPaths) in
            self.contentView.optionView.fSwitchView.xq_switch.isOn = true
            self.selectFoodIndexPaths = indexPaths
            self.calculation()
        }
    }
    
    /// 获取宠物列表
    func getPetList() {
        if XQSMBaseNetwork.default.token.count == 0 {
            print("让用户前去登录")
        }else {
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
                
                if self.contentView.houseView.dataArr.count != 0 {
                    self.calculation()
                }
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
        }
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
        
        if self.contentView.houseView.dataArr.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择猫舍")
            self.getCatdormitory()
            return
        }
        
        // 预约时间
        var startTime = ""
        if let date = self.contentView.appointmentView.date {
            startTime = date.xq_toStringYMD()
        }
        
        if startTime.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择预约时间 ")
            return
        }
        
        guard let model = self.calculation() else {
            return
        }
        
        let vc = AC_XQFosterOrderVC()
        vc.reqModel = model.reqModel
        vc.catdormitoryModel = model.catdormitoryModel
        vc.ShopInfo = self.ShopInfo
        vc.foodList = model.foodList
        vc.petModel = model.petModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    struct CalculationModel {
        var reqModel: XQACNTAddFosterReqModel?
        /// 猫舍
        var catdormitoryModel: XQACNTGM_CatdormitoryModel?
        /// 选中的食物列表
        var foodList: [XQACNTGM_FosterShopModel]?
        /// 猫
        var petModel: XQSMNTGetMyPetListUserPetInfoModel?
    }
    
    /// 计算价格
    @discardableResult
    func calculation() -> CalculationModel? {
        
        if XQSMBaseNetwork.default.token.count == 0 {
            return nil
        }
        
        if self.contentView.petView.dataArr.count == 0 {
            return nil
        }
        
        if self.contentView.houseView.dataArr.count == 0 {
            self.getCatdormitory()
            return nil
        }
        
        // 宠物 id
        let petId = self.contentView.petView.dataArr[self.contentView.petView.selectIndex].Id
        
        // 寄养天数
        let day = Int(self.contentView.dayView.numberView.tf.text ?? "1") ?? 0
        
        // 商店 id
        let shopId = self.ShopInfo?.Id ?? 0
        
        // 加食 id
        var idList = [String]()
        var foodShopList = [XQACNTGM_FosterShopModel]()
        if self.contentView.optionView.fSwitchView.xq_switch.isOn,
            let selectFoodIndexPaths = self.selectFoodIndexPaths,
            let foodList = self.foodList {
            for item in selectFoodIndexPaths {
                if let shop = foodList[item.section].shoplist?[item.row] {
                    idList.append(shop.id)
                    foodShopList.append(shop)
                }
            }
        }
        
        // 猫舍
        let catdormitoryModel = self.contentView.houseView.dataArr[self.contentView.houseView.selectIndex]
        
        // 预约时间
        var startTime = ""
        if let date = self.contentView.appointmentView.date {
            startTime = date.xq_toStringYMD()
        }
        
        if startTime.count == 0 {
            return nil
        }
        
        let reqModel = XQACNTAddFosterReqModel.init(CatdormitoryId: catdormitoryModel.Id,
                                                    PetsId: petId,
                                                    StartTime: startTime,
                                                    Day: day,
                                                    StoreId: shopId,
                                                    Remarks: "",
                                                    Mobile: "",
                                                    Name: "",
                                                    IsMeet: self.contentView.optionView.sSwitchView.xq_switch.isOn,
                                                    IsFeed: self.contentView.optionView.fSwitchView.xq_switch.isOn,
                                                    IsMonitoring: self.contentView.optionView.tSwitchView.xq_switch.isOn,
                                                    x: "0",
                                                    y: "0",
                                                    bbSterilization: self.contentView.selectBaseView.fSwitchView.xq_switch.isOn,
                                                    bbVaccination: self.contentView.selectVaccinesView.fSwitchView.xq_switch.isOn,
                                                    bbDeworming: self.contentView.selectBaseView.sSwitchView.xq_switch.isOn,
                                                    bbRabiesVaccine: self.contentView.selectVaccinesView.sSwitchView.xq_switch.isOn,
                                                    idlist: idList,
                                                    Discount: false,
                                                    CouponId: "",
                                                    ChoseTrueMan: false)
        
        XQACFosterNetwork.fosterCalculation(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.payView.moneyLab.text = "合计 ¥\(resModel.Totalamount)"
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
        let model = CalculationModel.init(reqModel: reqModel, catdormitoryModel: catdormitoryModel, foodList: foodShopList, petModel: self.contentView.petView.dataArr[self.contentView.petView.selectIndex])
        return model
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
            self.reloadHeaderUI()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - responds
    
    @objc func respondsToFood(_ sender: UISwitch) {
        
        if !sender.isOn {
            self.calculation()
            return
        }
        
        sender.isOn = false
        self.getFood()
        
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
    
    // MARK: - AC_XQFosterViewSelectHouseViewDelegate
    func fosterViewSelectHouseView(_ fosterViewSelectHouseView: AC_XQFosterViewSelectHouseView, didSelectItemAt indexPath: IndexPath) {
        self.calculation()
    }
    

    // MARK: - XQNumberViewDelegate
    
    /// 加减代理回调
    /// - Parameters:
    ///   - number: 当前值
    ///   - increaseStatus: 是否为加状态
    func numberView(_ numberView: XQNumberView, number: Float, increaseStatus: Bool) {
        self.getCatdormitory()
    }
    
    
}
