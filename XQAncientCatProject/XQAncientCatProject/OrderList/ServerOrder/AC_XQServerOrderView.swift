//
//  AC_XQServerOrderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQServerOrderViewDelegate: NSObjectProtocol {
    
    /// 去支付
    func serverOrderView(pay serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath)
    
    /// 取消订单
    func serverOrderView(cancel serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath)
    
    /// 退款
    func serverOrderView(refundToOrder serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath)
    
    /// 点击删除
    func serverOrderView(delete serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath)
    
    /// 点击 cell
    func serverOrderView(_ serverOrderView: AC_XQServerOrderView, didSelectRowAt indexPath: IndexPath)
    
}

class AC_XQServerOrderView: UIView, UITableViewDelegate, UITableViewDataSource {

    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQACNTFosterGM_FosterModel]()
    
    weak var delegate: AC_XQServerOrderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(AC_XQServerOrderViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        self.tableView.allowsMultipleSelection = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQServerOrderViewCell
        
        let model = self.dataArr[indexPath.row]
        
//        #if DEBUG
//        model.PayType = 2
//        #endif
        
        cell.originPriceLab.isHidden = false
        cell.statusBtn.isHidden = true
        
        cell.iconImgView.sd_setImage(with: model.Photo.sm_getImgUrl())
//        cell.iconImgView.sd_setImage(with: model.logo.sm_getImgUrl())
        cell.titleLab.text = model.ShopName
        cell.messageLab.text = "寄养 \(model.SeveralNights)天"
        cell.dateLab.text = "预约时间：\(model.StartTime)"
        cell.originPriceLab.text = "¥\(model.Totalamount)"
        
        cell.orderCodeLab.text = "寄养服务"
        
        cell.deleteBtn.isHidden = true
        cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.serverOrderView(delete: self, didSelectRowAt: indexPath)
        }
        
        cell.funcBtn.isHidden = true
        
        cell.statusLab.text = model.getStateDes()
        cell.serverModel = model
        switch model.State {
        case .orderPlaced:
            
            if model.PayType == 2 {
                // 超过了退款时间 model.PayTime
                if DK_TimerManager.getLastTime(model.PayTime).count > 0 {
                    cell.funcBtn.isHidden = false
                    cell.funcBtn.setTitle("申请退款", for: .normal)
                    cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                        self.delegate?.serverOrderView(refundToOrder: self, didSelectRowAt: indexPath)
                    }
                    cell.statusBtn.isHidden = false
                }
            }else {
                cell.funcBtn.isHidden = false
                cell.funcBtn.setTitle("去付款", for: .normal)
                
                cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                    self.delegate?.serverOrderView(pay: self, didSelectRowAt: indexPath)
                }
                
                cell.statusBtn.isHidden = false
                cell.statusBtn.setTitle("取消订单", for: .normal)
                cell.statusBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                    self.delegate?.serverOrderView(cancel: self, didSelectRowAt: indexPath)
                }
            }
            
        case .onTheWay:
            break
            
        case .done:
            cell.deleteBtn.isHidden = false
            
        case .cancel:
            cell.deleteBtn.isHidden = false
            
        case .waitingComments:
            cell.deleteBtn.isHidden = false
            
        case .refundInProgress:
            break
            
        case .successfulRefund:
            cell.deleteBtn.isHidden = false
        
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.serverOrderView(self, didSelectRowAt: indexPath)
    }

}
