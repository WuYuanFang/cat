//
//  AC_XQCollectCouponView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import CMPageTitleView
import SnapKit

protocol AC_XQCollectCouponViewDelegate: NSObjectProtocol {
    
    /// 点击立即领取
    func collectCouponView(receive collectCouponView: AC_XQCollectCouponView, didSelectRowAt indexPath: IndexPath)
    
}


class AC_XQCollectCouponView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: AC_XQCollectCouponViewDelegate?
    
    let titleView = CMPageTitleView()
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTCouponTypeInfoModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        self.xq_addSubviews(self.titleView)
        
        // 布局
        self.titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        let config = CMPageTitleConfig.default()
        
        config.sm_config()
        config.cm_minTitleMargin = 10
        config.cm_titleMargin = 10
        config.cm_contentMode = .center
        config.cm_titles = [
            "全部",
            "商品券",
            "服务券",
        ]
        
        
        self.titleView.cm_config = config
        
        self.tableView.register(AC_XQCollectCouponViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 103 + 16
        
        
        
        // 暂时不要分类
        self.titleView.isHidden = true
        self.tableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQCollectCouponViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.titleLab.text = model.Name
        if model.OrderAmountLower == 0 {
            cell.messageLab.text = "无门槛"
        }else {
            cell.messageLab.text = "满\(model.OrderAmountLower)元使用"
        }
        cell.dateLab.text = "有效期限:\(model.UseStartTime) ~ \(model.UseEndTime)"
        
        if model.Money == 0 {
            cell.moneyView.direction = .right
            cell.moneyView.symbolLab.text = "折"
            cell.moneyView.moneyLab.text = String(Float(model.Discount)/10)
        }else {
            cell.moneyView.direction = .left
            cell.moneyView.symbolLab.text = "¥"
            cell.moneyView.moneyLab.text = String(model.Money)
        }
        
        cell.typeView.vType = model.CouponType
        
        
        if model.sendcount == model.Count {
            
            cell.roundView.isHidden = true
            cell.alreadyBuyLab.isHidden = true
            cell.nowBuyBtn.isHidden = true
            cell.outOfStockImgView.isHidden = false
            
        }else {
            
            cell.roundView.isHidden = false
            cell.alreadyBuyLab.isHidden = false
            cell.nowBuyBtn.isHidden = false
            cell.outOfStockImgView.isHidden = true
            
            let scale = Float(model.sendcount)/Float(model.Count)
            let result = scale * 100
            cell.alreadyBuyLab.text = String.init(format: "已抢\n%.1f%@", result, "%")
            //        cell.alreadyBuyLab.text = "已抢\n\(result)%"
            cell.roundView.changeProgress(CGFloat(scale))
        }
        
        cell.nowBuyBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.collectCouponView(receive: self, didSelectRowAt: indexPath)
        }
        
        
//        cell.titleLab.text = "现金券"
//        cell.messageLab.text = "满200元使用"
//        cell.dateLab.text = "有效期限：2019.07.30 ~ 2019.08.30"
//
//        if indexPath.row == 3 {
//            cell.moneyView.direction = .right
//            cell.moneyView.symbolLab.text = "折"
//            cell.moneyView.moneyLab.text = "7.7"
//        }else {
//            cell.moneyView.direction = .left
//            cell.moneyView.symbolLab.text = "¥"
//            cell.moneyView.moneyLab.text = "20"
//        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
