//
//  AC_XQScoreOrderDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQScoreOrderDetailVC: XQACBaseVC {
    
    let contentView = AC_XQScoreOrderDetailView()
    
    var fosterModel: XQSMNTIntegralProductsOrdersInfoModel?
    
    typealias AC_XQFosterOrderDetailVCCallback = () -> ()
    var refreshCallback: AC_XQFosterOrderDetailVCCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.setCenterTitle("订单详情")
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.reloadUI()
    }
    
    func reloadUI() {
        guard let fosterModel = self.fosterModel else {
            return
        }
        
        self.contentView.headerView.addressModel = XQSMNTShopAddressDtoModel.init(SaId: "", Alias: "", Consignee: fosterModel.Consignee, Mobile: fosterModel.Mobile, ZipCode: "", Address: fosterModel.Address, ProvinceName: "", ProvinceId: "", CityName: "", CityId: "", AreaName: "", AreaId: "", IsDefault: false, X: "", Y: "")
        
        self.contentView.headerView.arrowImgView.isHidden = true
        
        self.contentView.infoView.productView.imgView.sd_setImage(with: fosterModel.ShowImg.sm_getImgUrl())
        self.contentView.infoView.productView.nameLab.text = fosterModel.ProductName
        self.contentView.infoView.productView.priceLab.text = "\(fosterModel.ShopPrice)积分"
        
        self.contentView.infoView.buyNumberView.contentLab.text = "\(fosterModel.Number)"
        self.contentView.infoView.moneyView.contentLab.text = "\(fosterModel.SumShopPrice)积分"
        
        self.contentView.infoView.remarkView.contentLab.text = "没有备注字段"
        
        self.contentView.infoView.orderLab.text = "订单编号 \(fosterModel.Osn)"

//        self.contentView.headerView.titleLab.text = fosterModel.ShopName
//        self.contentView.headerView.imgView.sd_setImage(with: fosterModel.Photo.sm_getImgUrl())


//        self.contentView.infoView.serverView.contentLab.text = "¥\(fosterModel.dayMoeny)/天"
//        self.contentView.infoView.dayView.contentLab.text = "\(fosterModel.SeveralNights)天"
//        self.contentView.infoView.timeView.contentLab.text = fosterModel.StartTime

//                    self.contentView.infoView.timeView.contentLab.text = fosterModel.StartTime
        
//        self.contentView.infoView.moneyView.contentLab.text = "¥\(fosterModel.Totalamount)"

//        self.contentView.infoView.phoneView.contentLab.text = fosterModel.Mobile
//        self.contentView.infoView.nameView.contentLab.text = fosterModel.Name
//        self.contentView.infoView.remarkView.contentLab.text = fosterModel.Remarks

//        self.contentView.infoView.orderLab.text = "订单编号 \(fosterModel.OSN)"

//        self.contentView.infoView.cancelOrderBtn.isHidden = true
//        self.contentView.infoView.cancelOrderLab.isHidden = true

    }
    
}
