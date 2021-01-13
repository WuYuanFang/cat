//
//  AC_XQShopMallViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView
import XQProjectTool_iPhoneUI
import SDCycleScrollView

class AC_XQShopMallViewHeaderView: UIView {
    
//    let cycleScrollView = SDCycleScrollView()
    
    let searchView = AC_XQShopMallViewHeaderViewSearchView()
    
    let titleView = CMPageTitleView()
    /// 价格
    let sortBtn = UIButton()
    /// 筛选
    let typeBtn = UIButton()
    
    var menuList = [XQSMNTAroundShopTopMenuModel]()
    
    var selectType: XQSMNTGetProductReqModel.XQSMNTGetProductReqModelSortType = .salesVolume
    
    var selectTypeUpdateCallback: AC_XQShopMallViewHeaderViewSortView.AC_XQShopMallViewHeaderViewSortViewCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.searchView, self.titleView, self.sortBtn, self.typeBtn)
        
        // 布局
//
//        self.cycleScrollView.snp.makeConstraints { (make) in
//            make.top.equalTo(XQIOSDevice.getStatusHeight() + 16)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(self.cycleScrollView.snp.width).multipliedBy(1/AC_XQShopMallViewHeaderView.getImgWHScale())
//        }
        
        self.searchView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(XQIOSDevice.getStatusHeight() + 16)
            make.height.equalTo(35)
        }
        
        self.titleView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.left.equalToSuperview()
//            make.right.equalTo(-94)
            make.right.equalTo(self.sortBtn.snp.left).offset(-8)
            make.height.equalTo(30)
        }
        
        self.typeBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.right.equalToSuperview().offset(-12)
            make.size.equalTo(30)
        }
        
        self.sortBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.typeBtn)
            make.right.equalTo(self.typeBtn.snp.left).offset(-4)
            make.size.equalTo(self.typeBtn)
        }
        
        
        // 设置属性
        
        let config = CMPageTitleConfig.default()
        
        config.sm_config()
        
//        config.cm_contentMode = .left
        
//        config.cm_titles = [
//            "全部",
//            "食品",
//            "零食",
//            "护理",
//            "保健",
//            "其他",
//        ]
        
//        self.titleView.delegate = self
        self.titleView.cm_config = config
        
//        self.cycleScrollView.backgroundColor = UIColor.clear
//        self.cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        
        self.sortBtn.setImage(UIImage.init(named: "shopMall_sort"), for: .normal)
        self.typeBtn.setImage(UIImage.init(named: "shopMall_filter"), for: .normal)
        
        
        self.sortBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            AC_XQShopMallViewHeaderViewSortView.show(self.selectType, y: sender?.frame.maxY ?? 0 + 12) { [unowned self] (sortType) in
                self.selectType = sortType
                self.selectTypeUpdateCallback?(self.selectType)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadTitles() {
        var titles = [String]()
        titles.append("全部")
        for item in self.menuList {
            titles.append(item.Name)
        }
        self.titleView.cm_config.cm_titles = titles
        self.titleView.cm_reloadConfig()
    }
    
    /// 获取图片宽高比
    static func getImgWHScale() -> CGFloat {
        return CGFloat(335.0/90.0)
    }
    
    /// cell size
    static func xq_headerSize() -> CGSize {
//        let imgScale = self.getImgWHScale()
        
        let width = system_screenWidth
//
//        let imgHeight = width / imgScale
        
        let height = CGFloat(20 + 35 + 16 + 12) + XQIOSDevice.getStatusHeight() + 16
        
        return CGSize.init(width: width, height: height)
    }
    
    

}

class AC_XQShopMallViewHeaderViewSearchView: UIView {
    
    let tf = UITextField()
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.tf)
        
        // 布局
        self.tf.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.imgView.snp.left).offset(-12)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalToSuperview()
        }
        
        
        // 设置属性
        self.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.layer.cornerRadius = 4
        
        self.tf.placeholder = "搜索您想要的商品"
        self.tf.font = UIFont.systemFont(ofSize: 13)
        self.tf.isUserInteractionEnabled = false
        
        self.imgView.image = UIImage.init(named: "shopMall_Shape")
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class AC_XQShopMallViewHeaderViewSortView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    typealias AC_XQShopMallViewHeaderViewSortViewCallback = (_ sortType: XQSMNTGetProductReqModel.XQSMNTGetProductReqModelSortType) -> ()
    
    private static var sortView_: AC_XQShopMallViewHeaderViewSortView?
    
    static func show(_ normalSelectType: XQSMNTGetProductReqModel.XQSMNTGetProductReqModelSortType = .salesVolume, y: CGFloat, callback: AC_XQShopMallViewHeaderViewSortViewCallback?) {
        
        if let _ = sortView_ {
            return
        }
        
        sortView_ = AC_XQShopMallViewHeaderViewSortView()
        sortView_?.callback = callback
        sortView_?.normalSelectType = normalSelectType
        UIApplication.shared.keyWindow?.addSubview(sortView_!)
        sortView_?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        sortView_?.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(y)
            make.left.right.equalToSuperview()
            make.height.equalTo(44 * 3)
        }
        
    }
    
    static func hide() {
        if let _ = sortView_ {
            sortView_?.removeFromSuperview()
            sortView_ = nil
        }
    }
    
    deinit {
        print(#function, self.classForCoder)
    }
    
    var callback: AC_XQShopMallViewHeaderViewSortViewCallback?
    
    var normalSelectType: XQSMNTGetProductReqModel.XQSMNTGetProductReqModelSortType = .salesVolume
    
    let topBackView = UIView()
    let bottomBackView = UIView()
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        
        self.xq_addSubviews(self.tableView, self.topBackView, self.bottomBackView)
        
        // 布局
//        self.tableView.snp.makeConstraints { (make) in
//            make.top.equalTo(y)
//            make.left.right.equalTo(y)
//            make.
//        }
        
        self.topBackView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.tableView.snp.top)
        }
        
        self.bottomBackView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.tableView.snp.bottom)
        }
        
        // 设置属性
        
        self.bottomBackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
//        self.topBackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        self.tableView.register(AC_XQShopMallViewHeaderViewSortViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 44
        
        self.dataArr = [
            "价格由低到高",
            "价格由高到低",
            "销量",
        ]
        
        self.bottomBackView.xq_addTap { [unowned self] (gesture) in
            AC_XQShopMallViewHeaderViewSortView.hide()
        }
        
        self.topBackView.xq_addTap { [unowned self] (gesture) in
            AC_XQShopMallViewHeaderViewSortView.hide()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQShopMallViewHeaderViewSortViewCell
        
        cell.titleLab.text = self.dataArr[indexPath.row]
        
        cell.imgView.isHidden = true
        
        switch self.normalSelectType {
        case .priceLowToHigh:
            if indexPath.row == 0 {
                cell.imgView.isHidden = false
            }
            
        case .priceHighToLow:
            if indexPath.row == 1 {
                cell.imgView.isHidden = false
            }
            
            
        case .salesVolume:
            if indexPath.row == 2 {
                cell.imgView.isHidden = false
            }
            
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.callback?(.priceLowToHigh)
            
        case 1:
            self.callback?(.priceHighToLow)
            
        case 2:
            self.callback?(.salesVolume)

        default:
            break
        }
        
        AC_XQShopMallViewHeaderViewSortView.hide()
    }
    
}


class AC_XQShopMallViewHeaderViewSortViewCell: UITableViewCell {
    
    let titleLab = UILabel()
    let imgView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.titleLab, self.imgView)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab.snp.right).offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(10)
        }
        
        // 设置属性
        self.selectionStyle = .none
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        self.imgView.image = UIImage.init(named: "shopMall_select")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

