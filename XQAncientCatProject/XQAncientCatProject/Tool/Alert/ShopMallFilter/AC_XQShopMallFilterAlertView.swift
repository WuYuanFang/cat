//
//  AC_XQShopMallFilterAlertView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import QMUIKit
import XQUITextField_Navigation
import RxSwift


class AC_XQShopMallFilterAlertView: UIView, AC_XQBottomAlertDelegate {
    
    typealias AC_XQShopMallFilterAlertViewCallback = (_ brandModel: XQSMNTAroundShopBrandInfoModel?, _ minPrice: Float, _ maxPrice: Float, _ showType: XQSMNTGetProductReqModel.XQSMNTGetProductReqModelShowType) -> ()
    
    static func show(_ brandModel: XQSMNTAroundShopBrandInfoModel?, _ minPrice: Float, _ maxPrice: Float, _ showType: XQSMNTGetProductReqModel.XQSMNTGetProductReqModelShowType, callback: AC_XQShopMallFilterAlertViewCallback? = nil) {
        
        if let _ = _selectAddressView {
            return
        }
        
        _selectAddressView = AC_XQShopMallFilterAlertView()
        
        // 添加到 window 上
        if let addressAlertView = _selectAddressView?.addressAlertView {
            UIApplication.shared.keyWindow?.addSubview(addressAlertView)
            addressAlertView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            addressAlertView.show()
        }
        
        _selectAddressView?.callback = callback
        
        
        _selectAddressView?.brandView.brandModel = brandModel
        
        if minPrice != 0 {
            _selectAddressView?.priceView.minTF.text = minPrice.xq_removeDecimalPointZero()
        }
        
        if maxPrice != 0 {
            _selectAddressView?.priceView.maxTF.text = maxPrice.xq_removeDecimalPointZero()
        }
        
        
        switch showType {
        case .discount:
            _selectAddressView?.selectView.discountBtn.isSelected = true
        case .inStock:
            _selectAddressView?.selectView.haveBtn.isSelected = true
        default:
            break
        }

    }
    
    static func hide() {
        if let selectAddressView = _selectAddressView {
            selectAddressView.addressAlertView.hide()
            selectAddressView.removeFromSuperview()
        }
        _selectAddressView = nil
    }
    
    deinit {
        print(#function, self.classForCoder)
    }
    
    typealias XQAlertSelectAppointmentViewCallback = (_ date: Date) -> ()
    
    
    private static var _selectAddressView: AC_XQShopMallFilterAlertView?
    
    
    
    private var callback: AC_XQShopMallFilterAlertViewCallback?
    private let addressAlertView = AC_XQBottomAlert.init(frame: UIScreen.main.bounds, contentHeight: 400)
    
    /// 品牌
    private let brandView = AC_XQShopMallFilterAlertViewCollectionView()
    /// 价格
    private let priceView = AC_XQShopMallFilterAlertViewPriceView()
    
    /// 活动，是否有货
    private let selectView = AC_XQShopMallFilterAlertViewSelectView()
    
    let resetBtn = UIButton()
    let sureBtn = UIButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addressAlertView.contentView.xq_addSubviews(self.brandView, self.priceView, self.selectView, self.resetBtn, self.sureBtn)
        
        // 布局
        
        self.brandView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.right.equalToSuperview()
        }
        
        self.priceView.snp.makeConstraints { (make) in
            make.top.equalTo(self.brandView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.selectView.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
//            make.bottom.equalTo(-30)
        }
        
        self.resetBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(44)
        }
        
        self.sureBtn.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(self.resetBtn)
            make.height.equalTo(self.resetBtn)
        }
        
        // 设置属性
        
        self.addressAlertView.baseDelegate = self
        
        self.resetBtn.setTitle("重置", for: .normal)
        self.resetBtn.backgroundColor = UIColor.init(hex: "#E9EFF1")
        self.resetBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        
        self.sureBtn.setTitle("确定", for: .normal)
        self.sureBtn.backgroundColor = UIColor.ac_mainColor
        self.sureBtn.setTitleColor(UIColor.white, for: .normal)
        
        
        self.resetBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.endEditing(true)
            self.callback?(nil, 0, 0, XQSMNTGetProductReqModel.XQSMNTGetProductReqModelShowType.all)
            AC_XQShopMallFilterAlertView.hide()
        }
        
        self.sureBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.endEditing(true)
            
            let min = Float(self.priceView.minTF.text ?? "0") ?? 0
            let max = Float(self.priceView.maxTF.text ?? "0") ?? 0
            if min > max {
                SVProgressHUD.showInfo(withStatus: "最高价不能低于最低价")
                return
            }
            
            var brandModel: XQSMNTAroundShopBrandInfoModel?
            if self.brandView.selectIndex != -1 {
                brandModel = self.brandView.dataArr[self.brandView.selectIndex]
            }
            
            var showType = XQSMNTGetProductReqModel.XQSMNTGetProductReqModelShowType.all
            
            if self.selectView.discountBtn.isSelected {
                showType = .discount
            }else if self.selectView.haveBtn.isSelected {
                showType = .inStock
            }
            
            self.callback?(brandModel, min, max, showType)
            AC_XQShopMallFilterAlertView.hide()
        }
        
        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(notification_willShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(notification_willHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        self.priceView.xq_showTextField_Navigation()
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AC_XQBottomAlertDelegate
    
    func bottomAlert(hide bottomAlert: AC_XQBottomAlert) {
        self.endEditing(true)
        AC_XQShopMallFilterAlertView.hide()
    }
    
    // MARK: - notification
    @objc func notification_willShowNotification(_ notification: Notification) {
        
        if let keyFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let rect = keyFrame.cgRectValue
            print("wxq: ", rect)
            self.addressAlertView.alertView.frame.origin.y = system_screenHeight - self.addressAlertView.alertView.frame.height - rect.height + self.addressAlertView.lc
        }
    }
    
    @objc func notification_willHideNotification(_ notification: Notification) {
        self.addressAlertView.alertView.frame.origin.y  = system_screenHeight - self.addressAlertView.alertView.frame.height + self.addressAlertView.lc
    }
    
}

class AC_XQShopMallFilterAlertViewCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let titleLab = UILabel()
    private var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private let headerReuseIdentifier = "headerReuseIdentifier"
    
    /// 默认选中
    var brandModel: XQSMNTAroundShopBrandInfoModel?
    
    var dataArr = [XQSMNTAroundShopBrandInfoModel]()
    var selectIndex = -1
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        
        
        let count: CGFloat = 3
        // 少一个像素, 以防误差导致到第二行
        let width = (system_screenWidth - (16 * 2) - (count - 1) * 12) / count - 1
        let height: CGFloat = 40
        flowLayout.itemSize = CGSize.init(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        flowLayout.minimumLineSpacing = 12
        flowLayout.minimumInteritemSpacing = 12
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        
        self.xq_addSubviews(self.titleLab, self.collectionView)
        
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(16)
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.height.equalTo(height * 2 + 12)
        }
        
        // 设置属性
        
        //        self.addressAlertView.delegate = self
        
        self.titleLab.text = "品牌"
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        
        self.collectionView.register(AC_XQShopMallFilterAlertViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        
        self.getData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() {
        
        let reqModel = XQSMNTBaseReqModel()
        XQSMAroundShopNetwork.getAllBrand(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
//            self.contentView.headerView.menuList = resModel.MenuList ?? []
            self.dataArr = resModel.BrandLss
            
            if let brandModel = self.brandModel {
                for (index, item) in self.dataArr.enumerated() {
                    if brandModel.BrandId == item.BrandId {
                        self.selectIndex = index
                        break
                    }
                }
            }
            
            self.collectionView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQShopMallFilterAlertViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.titleLab.text = model.Name
        
        cell.select = self.selectIndex == indexPath.row
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AC_XQShopMallFilterAlertViewCell {
            cell.select.toggle()
        }
        
        if self.selectIndex == indexPath.row {
           self.selectIndex = -1
        }else {
            if let cell = collectionView.cellForItem(at: IndexPath.init(row: self.selectIndex, section: 0)) as? AC_XQShopMallFilterAlertViewCell {
                cell.select = false
            }
            self.selectIndex = indexPath.row
        }
        
    }
    
}


class AC_XQShopMallFilterAlertViewPriceView: UIView {
    
    let titleLab = UILabel()
    let lineView = UITextField()
    let minTF = UITextField()
    let maxTF = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.lineView, self.minTF, self.maxTF)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        self.minTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.left.equalTo(self.titleLab)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        self.maxTF.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.width.height.equalTo(self.minTF)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.minTF.snp.right).offset(8)
            make.right.equalTo(self.maxTF.snp.left).offset(-8)
            make.centerY.equalTo(self.minTF)
            make.height.equalTo(1)
        }
        
        // 设置属性
        
        self.titleLab.text = "价格区间"
        
        self.lineView.backgroundColor = UIColor.init(hex: "#BDBDBD")
        
        self.configTF(self.minTF, placeholder: "最低价")
        self.configTF(self.maxTF, placeholder: "最高价")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configTF(_ tf: UITextField, placeholder: String) {
        
        tf.backgroundColor = UIColor.init(hex: "#F3F3F3")
        tf.textAlignment = .center
        tf.placeholder = placeholder
//        tf.keyboardType = .decimalPad
        tf.keyboardType = .numberPad
        tf.layer.cornerRadius = 4
        
    }
    
}


class AC_XQShopMallFilterAlertViewSelectView: UIView {
    
    let discountBtn = QMUIButton()
    let haveBtn = QMUIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.haveBtn, self.discountBtn)
        
        // 布局
        self.discountBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
            make.height.equalTo(25)
        }
        
        self.haveBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.discountBtn.snp.bottom).offset(8)
            make.left.equalTo(self.discountBtn)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.discountBtn)
        }
        
        // 设置属性
        
        self.discountBtn.setTitle("仅看有活动", for: .normal)
        self.discountBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.discountBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        self.discountBtn.spacingBetweenImageAndTitle = 12
        self.discountBtn.setTitleColor(UIColor.black, for: .normal)
        
        self.haveBtn.setTitle("仅看有货", for: .normal)
        self.haveBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.haveBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        self.haveBtn.spacingBetweenImageAndTitle = 12
        self.haveBtn.setTitleColor(UIColor.black, for: .normal)
        
        self.discountBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.haveBtn.isSelected = false
            sender?.isSelected.toggle()
        }
        
        self.haveBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.discountBtn.isSelected = false
            sender?.isSelected.toggle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


