//
//  AC_XQWashProtectOrderListView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQWashProtectOrderListViewDelegate: NSObjectProtocol {
    
    /// 去支付
    func washProtectOrderListView(pay washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath)
    
    /// 退款
    func washProtectOrderListView(refund washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath)
    
    /// 取消订单
    func washProtectOrderListView(cancel washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath)
    
    /// 删除
    func washProtectOrderListView(delete washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath)
    
    /// 点击 cell
    func washProtectOrderListView(_ washProtectOrderListView: AC_XQWashProtectOrderListView, didSelectRowAt indexPath: IndexPath)
    
}

class AC_XQWashProtectOrderListView: UIView, UITableViewDataSource, UITableViewDelegate {

    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTTinnyToOrderInfoModel]()
    
    weak var delegate: AC_XQWashProtectOrderListViewDelegate?
    
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
        cell.originPriceLab.isHidden = false
        cell.statusBtn.isHidden = true
        cell.orderCodeImgView.image = UIImage.init(named: "orderList_washProtect")
        cell.titleLab.text = model.ShopName
        cell.iconImgView.sd_setImage(with: model.PetPhotoStr.sm_getImgUrl())
//        cell.messageLab.text = "寄养 天"
        cell.messageLab.text = model.PdList?.count ?? 0 > 0 ? (model.PdList?[0].PName ?? " ") : " "
        cell.dateLab.text = "预约时间：\(model.SubscribeTime)"
        cell.originPriceLab.text = "¥\(model.TotalPrice.xq_removeDecimalPointZero())"
        
        cell.orderCodeLab.text = "洗护服务"
        
        cell.deleteBtn.isHidden = true
        
        cell.statusLab.text = model.StateDesc
        
        cell.funcBtn.isHidden = true
        cell.downStatusLab.isHidden = true
        
//        #if DEBUG
//        model.State = .reserved
//        model.CanRefund = true
//        #endif
        
        cell.washModel = model
        
        switch model.State {
        case .waitPay:
//            cell.statusLab.text = "待支付"
            cell.funcBtn.isHidden = false
            cell.funcBtn.setTitle("去付款", for: .normal)
            cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.washProtectOrderListView(pay: self, didSelectRowAt: indexPath)
            }
            
            cell.statusBtn.setTitle("取消订单", for: .normal)
            cell.statusBtn.isHidden = false
            cell.statusBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.washProtectOrderListView(cancel: self, didSelectRowAt: indexPath)
            }
            
        case .reserved:
            if model.CanRefund {
                if DK_TimerManager.getLastTime(model.PayTime).count > 0 {
                    cell.funcBtn.isHidden = false
                    cell.funcBtn.setTitle("申请退款", for: .normal)
                    cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                        self.delegate?.washProtectOrderListView(refund: self, didSelectRowAt: indexPath)
                    }
                    cell.statusBtn.isHidden = false
                }
            }
            
        case .completed:
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
            }
//            cell.funcBtn.isHidden = false
//            cell.funcBtn.setTitle("删除", for: .normal)
//            cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
//            }
            
        case .refundInProgress:
            break
            
        case .refundCompleted:
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
            }
            cell.downStatusLab.isHidden = false
            cell.downStatusLab.text = "退款成功"
//            cell.funcBtn.isHidden = false
//            cell.funcBtn.setTitle("删除", for: .normal)
//            cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
//            }
            
        case .cancel:
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
            }
//            cell.funcBtn.isHidden = false
//            cell.funcBtn.setTitle("删除", for: .normal)
//            cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
//            }
            
            /// 线下退款完成
        case .offlineRefundCompleted:
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
            }
//            cell.funcBtn.isHidden = false
//            cell.funcBtn.setTitle("删除", for: .normal)
//            cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//                self.delegate?.washProtectOrderListView(delete: self, didSelectRowAt: indexPath)
//            }
            
            /// 洗护中
        case .inCare:
            break
            
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.washProtectOrderListView(self, didSelectRowAt: indexPath)
    }

}
