//
//  AC_XQCommodityDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 商城，商品详情
class AC_XQCommodityDetailVC: XQACBaseVC, AC_XQCommodityDetailViewContentViewSpecViewDelegate, XQNumberViewDelegate, AC_XQBaseVCSrollNavigationBarGradientsProtocol, UIScrollViewDelegate {
    
    var xq_ngbCurrentType: AC_XQBaseVCSrollNavigationBarGradientsProtocolTransparentType = .transparent

    let contentView = AC_XQCommodityDetailView()
    
    /// 外部一定要传 pId
    var pId: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(image: UIImage.init(named: "shopCar_mainColor"), style: .plain, target: self, action: #selector(respondsToShopCar)))
        
        self.contentView.headerView.commentView.xq_addTap { [unowned self] (gesture) in
            let vc = AC_XQShopMallCommentVC()
            vc.pId = self.contentView.attrProductInfoModel?.PId ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.contentView.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.getProductInfo()
        
        self.contentView.payView.shopCarBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.addShopCar()
        }
        
        self.contentView.payView.sideButton.xq_addTap { [unowned self] (gestur) in
            self.pay()
        }
        
        self.contentView.contentView.specView.delegate = self
        self.contentView.contentView.specView.numberView.numberView.delegate = self
        
        self.contentView.scrollView.delegate = self
    }
    
    /// 获取商品详情
    func getProductInfo() {
        guard let pId = self.pId else {
            return
        }
        
        let reqModel = XQSMNTProductInfoReqModel.init(PId: pId)
        SVProgressHUD.show(withStatus: nil)
        XQSMAroundShopNetwork.productInfo(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            self.contentView.productInfoModel = resModel.ProductInfo
            
//            self.attrChange()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    /// 改变属性
    func attrChange() {
        guard let productInfoModel = self.contentView.productInfoModel else {
            return
        }
        
        let attrArr = self.contentView.contentView.specView.getSelectAttrs()
        if attrArr.count == 0 {
            print("没有选中属性")
            return
        }
        let reqModel = XQSMNTAttOnChangeEventReqModel.init(SkuGId: productInfoModel.SkuGId, Lss: attrArr)
        SVProgressHUD.show(withStatus: nil)
        XQSMAroundShopNetwork.attOnChangeEvent(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            
            if let productInfo = resModel.ProductInfo {
                self.contentView.attrProductInfoModel = productInfo
            }else {
//                SVProgressHUD.showError(withStatus: "商品信息失败")
                SVProgressHUD.showInfo(withStatus: "该商品已售空")
                // 恢复上一次的选择
//                self.contentView.contentView.specView.reloadUI(with: productInfoModel.AttrList ?? [])
                
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 下单
    private func pay() {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先前去登录")
            return
        }
        
        // 获取购物车
        let reqModel = XQSMNTCancelOrSelectCartItemReqModel.init(Selectpids: [Int]())
        SVProgressHUD.show(withStatus: nil)
        XQSMCartNetwork.cancelOrSelectCartItem(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            for item in resModel.CartInfo?.CartInfo?.CartProductList ?? [] {
                
                if let opId = item.OrderProductInfo?.Pid, let pId = self.contentView.productInfoModel?.PId, opId == pId {
                    // 购物车已经存在该商品了
                    
                    // 改变商品的选中数量
                    self.changeShopCarNumber()
                    return
                }
            }
            
            // 购物车没有
            // 加入购物车
            self.addShopCar { [unowned self] (pid) in
                // 选中商品, 并获取购物车
                self.getSelectCartItem(pid) { [unowned self] (cartModel) in
                    SVProgressHUD.dismiss()
                    // 跳转到订单
                    self.presentOrder(cartModel)
                }
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
        
        
    }
    
    /// 改变购物车数量， 并且跳转到下单
    private func changeShopCarNumber() {
        
        guard let pId = self.contentView.productInfoModel?.PId else {
            SVProgressHUD.showError(withStatus: "获取不到商品信息")
            return
        }
        
        // 改变商品的选中数量
        let reqModel = XQSMNTChangeProductCountReqModel.init(pid: pId, buyCount: Int(self.contentView.contentView.specView.numberView.numberView.currentNumber), Selectpids: [pId])
        SVProgressHUD.show(withStatus: nil)
        XQSMCartNetwork.changeProductCount(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            self.presentOrder(resModel.CartInfo)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 跳转到下单
    private func presentOrder(_ cartModel: XQSMNTCartModel?) {
        let vc = AC_XQShopMallOrderVC()
        vc.cartModel = cartModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 加入购物车
    func addShopCar(_ callback: ( (_ pId: Int) -> () )? = nil ) {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先前去登录")
            return
        }
        
        var attrModel = self.contentView.attrProductInfoModel
        
        if attrModel == nil {
            attrModel = self.contentView.productInfoModel
        }
        
        if attrModel == nil {
            self.attrChange()
            SVProgressHUD.showInfo(withStatus: "获取商品信息失败")
            return
        }
        
        guard let attrProductInfoModel = attrModel else {
            self.attrChange()
            SVProgressHUD.showInfo(withStatus: "获取商品信息失败")
            return
        }
        
        let buyCount = Int(self.contentView.contentView.specView.numberView.numberView.currentNumber)
        let reqModel = XQSMNTAddCartReqModel.init(buyCount: buyCount, pid: attrProductInfoModel.PId)
        SVProgressHUD.show(withStatus: nil)
        XQSMCartNetwork.addCart(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            if let callback = callback {
                callback(attrProductInfoModel.PId)
            }else {
                SVProgressHUD.showSuccess(withStatus: "已加入购物车")
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取购物车
    func getSelectCartItem(_ pid: Int, callback: ( (_ cartModel: XQSMNTCartModel?) -> () )? = nil ) {
        let reqModel = XQSMNTCancelOrSelectCartItemReqModel.init(Selectpids: [pid])
        XQSMCartNetwork.cancelOrSelectCartItem(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            callback?(resModel.CartInfo)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - responds
    
    @objc func respondsToShopCar() {
        if XQSMBaseNetwork.default.token.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请先前去登录")
            return
        }
        
        let vc = AC_XQShopCarVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - AC_XQCommodityDetailViewContentViewSpecViewDelegate
    
    func commodityDetailViewContentViewSpecView(_ commodityDetailViewContentViewSpecView: AC_XQCommodityDetailViewContentViewSpecView, didSelectItemAt attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel) {
        self.attrChange()
    }
    
    // MARK: - XQNumberViewDelegate
    
    /// 加减代理回调
    /// - Parameters:
    ///   - number: 当前值
    ///   - increaseStatus: 是否为加状态
    func numberView(_ numberView: XQNumberView, number: Float, increaseStatus: Bool) {
        if let productInfoModel = self.contentView.productInfoModel {
            self.contentView.payView.priceLab.text = "¥\(productInfoModel.ShopPrice * self.contentView.contentView.specView.numberView.numberView.currentNumber)"
        }
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
