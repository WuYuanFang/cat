//
//  AC_XQWashProtectViewPackageView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQWashProtectViewServiceViewDelegate: NSObjectProtocol {
    
    /// 选中内容改变
    func washProtectViewServiceView(contentChange washProtectViewServiceView: AC_XQWashProtectViewServiceView)
    
    /// 套餐查看详情
    func washProtectViewServiceView(viewPackageDetail washProtectViewServiceView: AC_XQWashProtectViewServiceView, packageModel: XQSMNTToShopPdPackageModel)
    
    /// 单项查看详情
    func washProtectViewServiceView(viewSingleServerDetail washProtectViewServiceView: AC_XQWashProtectViewServiceView, model: XQSMNTToProductTinnyV2Model)
    
}

/// 服务view
class AC_XQWashProtectViewServiceView: UIView, AC_XQWashProtectViewServiceViewContentViewDelegate, AC_XQWashProtectViewSingleServiceViewDelegate {
    
    weak var delegate: AC_XQWashProtectViewServiceViewDelegate?
    
    /// 套餐
    let packageBtn = AC_XQCommodityDetailViewContentViewBtn()
    
    /// 单项
    let singleBtn = AC_XQCommodityDetailViewContentViewBtn()
    
    /// 套餐具体内容view
    let contentView = AC_XQWashProtectViewServiceViewContentView()
    
    /// 单项具体内容view
    let singleServiceView = AC_XQWashProtectViewSingleServiceView()
    
    private var _packageList: [XQSMNTToShopPdPackageModel]?
    /// PackageList (Array[ToShopPdPackageDto], optional): 套餐列表 ,
    var packageList: [XQSMNTToShopPdPackageModel]? {
        set {
            _packageList = newValue
            
            self.contentView.reloadUI(self.packageList ?? [])
            self.singleServiceView.reloadUI(self.packageList?.first?.NoIncludePdList ?? [])
            self.delegate?.washProtectViewServiceView(contentChange: self)
        }
        get {
            return _packageList
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.packageBtn, self.singleBtn, self.contentView, self.singleServiceView)
        
        // 布局
        self.packageBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(12)
        }
        
        self.singleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.packageBtn)
            make.left.equalTo(self.packageBtn.snp.right).offset(20)
        }
        
        // 设置属性
        self.configBtn(self.packageBtn, title: "套餐服务")
        self.configBtn(self.singleBtn, title: "单项服务")
        
        self.packageBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false == true {
                return
            }
            
            self.singleUILayout(false)
        }
        
        self.singleBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false == true {
                return
            }
            
            self.singleUILayout(true)
        }
        
        self.singleUILayout(false)
        
        self.contentView.delegate = self
        self.singleServiceView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct SelectProductInfoModel {
        var packageId = ""
        var productInfoModelArr = [XQSMNTTinnyOrderProductInfoModel]()
        
        /// 选中的单品
        var singleProductArr = [XQSMNTToProductTinnyV2Model]()
        /// 选中的套餐
        var packageProductModel: XQSMNTToShopPdPackageModel?
    }
    /// 获取选中的商品
    func getProductInfoModel() -> SelectProductInfoModel? {
        
        if self.contentView.dataArr.count == 0 {
            return nil
        }
        
        var singleProductArr = [XQSMNTToProductTinnyV2Model]()
        
        var productInfoModelArr = [XQSMNTTinnyOrderProductInfoModel]()
        for item in self.singleServiceView.selectIndexArr {
            let model = self.singleServiceView.dataArr[item]
            let pModel = XQSMNTTinnyOrderProductInfoModel.init(Id: model.Id)
            productInfoModelArr.append(pModel)
            
            singleProductArr.append(model)
        }
        
        let model = self.contentView.dataArr[self.contentView.selectIndex]
        
        return SelectProductInfoModel.init(packageId: String(model.Id), productInfoModelArr: productInfoModelArr, singleProductArr: singleProductArr, packageProductModel: model)
    }
    
    private func configBtn(_ btn: AC_XQCommodityDetailViewContentViewBtn, title: String) {
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .selected)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.lineHeight = 1
        btn.setLineBackColor(UIColor.clear, for: .normal)
        btn.setLineBackColor(UIColor.ac_mainColor, for: .selected)
        btn.isSelected = false
    }
    
    private func singleUILayout(_ single: Bool) {
        
        self.packageBtn.isSelected = !single
        self.singleBtn.isSelected = single
        
        if single {
            self.contentView.removeFromSuperview()
            self.addSubview(self.singleServiceView)
            
            self.singleServiceView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.packageBtn.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            
        }else {
            self.singleServiceView.removeFromSuperview()
            self.addSubview(self.contentView)
            
            self.contentView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.packageBtn.snp.bottom)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
        }
        
    }
    
    // MARK: - AC_XQWashProtectViewServiceViewContentViewDelegate
    func washProtectViewServiceViewContentView(_ washProtectViewServiceViewContentView: AC_XQWashProtectViewServiceViewContentView, didSelectItemAt indexPath: IndexPath) {
        // 改变单品
        self.singleServiceView.reloadUI(washProtectViewServiceViewContentView.dataArr[indexPath.row].NoIncludePdList ?? [])
        self.delegate?.washProtectViewServiceView(contentChange: self)
    }
    
    func washProtectViewServiceViewContentView(tapPush washProtectViewServiceViewContentView: AC_XQWashProtectViewServiceViewContentView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.washProtectViewServiceView(viewPackageDetail: self, packageModel: washProtectViewServiceViewContentView.dataArr[indexPath.row])
    }
    
    // MARK: - AC_XQWashProtectViewSingleServiceViewDelegate
    func washProtectViewSingleServiceView(_ washProtectViewSingleServiceView: AC_XQWashProtectViewSingleServiceView, didSelectItemAt indexPath: IndexPath, select: Bool) {
        self.delegate?.washProtectViewServiceView(contentChange: self)
    }
    
    /// 查看详情, 右下角按钮
    func washProtectViewSingleServiceView(detail washProtectViewSingleServiceView: AC_XQWashProtectViewSingleServiceView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.washProtectViewServiceView(viewSingleServerDetail: self, model: self.singleServiceView.dataArr[indexPath.row])
    }
    
}
