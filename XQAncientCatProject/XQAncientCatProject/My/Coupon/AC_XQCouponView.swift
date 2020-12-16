//
//  AC_XQCouponView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import SnapKit

protocol AC_XQCouponViewDelegate: NSObjectProtocol {
    
    /// 点击立即使用
    func couponView(tapUse couponView: AC_XQCouponView, didSelectRowAt indexPath: IndexPath)
    
}

class AC_XQCouponView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: AC_XQCouponViewDelegate?
    
    let receiveBtn = QMUIButton()
    
    let contentView = UIView()
    
    let titleView = XQLineLabelView.init(frame: .zero, lineColor: UIColor.ac_mainColor)
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTCouponListModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.receiveBtn, self.contentView)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.contentView.xq_addSubviews(self.tableView, self.titleView)
        
        // 布局
        
        self.receiveBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(UIApplication.shared.statusBarFrame.height + 47)
            make.size.equalTo(CGSize.init(width: 130, height: 40))
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.receiveBtn.snp.bottom).offset(34)
        }
        
        self.titleView.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.left.equalTo(24)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.ac_mainColor
        
        self.contentView.backgroundColor = UIColor.white
        
        self.receiveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.receiveBtn.setTitle("领券中心", for: .normal)
        self.receiveBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.receiveBtn.backgroundColor = UIColor.white
        self.receiveBtn.layer.cornerRadius = 20
        self.receiveBtn.setImage(UIImage.init(named: "coupon_icon"), for: .normal)
        self.receiveBtn.spacingBetweenImageAndTitle = 12
        
        
        self.titleView.titleLab.text = "我的优惠券"
        
        self.tableView.register(AC_XQCouponViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 103 + 12
        
        self.tableView.separatorStyle = .none
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.xq_corners_addRoundedCorners([.topLeft, .topRight], withRadii: CGSize.init(width: 25, height: 25))
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQCouponViewCell
        
        let model = self.dataArr[indexPath.row]
        cell.reloadUI(with: model)
        if model.StateInt == 1 {
            cell.useBtn.isHidden = false
        }else {
            cell.useBtn.isHidden = true
        }
        cell.useBtn.isUserInteractionEnabled = true
        cell.useBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.couponView(tapUse: self, didSelectRowAt: indexPath)
        }
        
        
//        cell.titleLab.text = model.Name
//        if model.OrderAmountLower == 0 {
//            cell.messageLab.text = "无门槛"
//        }else {
//            cell.messageLab.text = "满\(model.OrderAmountLower)元使用"
//        }
//        
//        cell.dateLab.text = "有效期限：\(model.CreateTime) ~ \(model.ExpireTime)"
//        
//        
//        if model.Discount == 0 {
//            cell.moneyView.direction = .left
//            cell.moneyView.symbolLab.text = "¥"
//            cell.moneyView.moneyLab.text = "\(model.Money)"
//        }else {
//            cell.moneyView.direction = .right
//            cell.moneyView.symbolLab.text = "折"
//            cell.moneyView.moneyLab.text = "\(model.Discount)"
//        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}



