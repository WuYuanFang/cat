//
//  AC_XQOrderListChildrenView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

protocol AC_XQOrderListChildrenViewDelegate: NSObjectProtocol {
    
    /// 去支付
    func orderListChildrenView(pay orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
    /// 查看物流
    func orderListChildrenView(viewLogistics orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
    /// 确认收货
    func orderListChildrenView(sureReceiveProduct orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
    /// 退款
    func orderListChildrenView(refundOrder orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
    /// 评价
    func orderListChildrenView(review orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
    /// 删除
    func orderListChildrenView(delete orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
    /// 点击 cell
    func orderListChildrenView(_ orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
    /// 取消订单
    func orderListChildrenView(cancelOrder orderListChildrenView: AC_XQOrderListChildrenView, didSelectRowAt indexPath: IndexPath)
    
}

class AC_XQOrderListChildrenView: UIView, UITableViewDelegate ,UITableViewDataSource {

    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTOrderBaseInfoDtoModel]()
    
    weak var delegate: AC_XQOrderListChildrenViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(AC_XQOrderListChildrenViewCell.classForCoder(), forCellReuseIdentifier: result)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQOrderListChildrenViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.orderCodeLab.text = "订单号: \(model.OSN)"
        cell.statusLab.text = model.getStateDes()
        
        cell.dateLab.text = model.AddTime
        
        // 暂时只用第一个. 后面有需求要改，再说
        if let product = model.ProductList?.first {
            cell.titleLab.text = product.Name
            cell.iconImgView.sd_setImage(with: product.ShowImg.sm_getImgUrl())
            
            cell.originPriceLab.text = ""
            cell.numberLab.text = ""
            
            cell.messageLab.text = product.Specs
        }
        
        cell.priceLab.text = "¥\(model.SurplusMoney)"
        
        
        cell.deleteBtn.isHidden = true
        
        cell.statusBtn.isHidden = true
        cell.funcBtn.isHidden = true
        cell.downStatusLab.isHidden = true
        
        cell.funcBtn.xq_addEvent(.touchUpInside) { (sender) in
            
        }
        
        cell.statusBtn.xq_addEvent(.touchUpInside) { (sender) in
            
        }
        
        #if DEBUG
//        cell.statusBtn.isHidden = false
//
//        cell.statusBtn.setTitle("查看物流", for: .normal)
//        cell.statusBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
//            self.delegate?.orderListChildrenView(viewLogistics: self, didSelectRowAt: indexPath)
//        }
        #endif
        
        cell.model = model
        
        switch model.OrderState {
        /// 等待付款
        case .waitPay:
            cell.funcBtn.isHidden = false
            cell.funcBtn.setTitle("去付款", for: .normal)
            cell.statusBtn.isHidden = false
            cell.statusBtn.setTitle("取消订单", for: .normal)
            cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.orderListChildrenView(pay: self, didSelectRowAt: indexPath)
            }
            cell.statusBtn.xq_addEvent(.touchUpInside) { (sender) in
                self.delegate?.orderListChildrenView(cancelOrder: self, didSelectRowAt: indexPath)
            }
            /// 确认中
            /// 已确认
            /// 备货中
        case .inInspection, .confirmed, .inStock:
            if DK_TimerManager.getLastTime(model.PayTime, .shop).count > 0 {
                cell.funcBtn.isHidden = false
                cell.funcBtn.setTitle("申请退款", for: .normal)
                cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                    self.delegate?.orderListChildrenView(refundOrder: self, didSelectRowAt: indexPath)
                }
                cell.statusBtn.isHidden = false
            }
            
            /// 已发货
        case .delivered:
            cell.funcBtn.isHidden = false
            cell.statusBtn.isHidden = false
            
            cell.statusBtn.setTitle("查看物流", for: .normal)
            cell.statusBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.orderListChildrenView(viewLogistics: self, didSelectRowAt: indexPath)
            }
            
            cell.funcBtn.setTitle("确认收货", for: .normal)
            cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.orderListChildrenView(sureReceiveProduct: self, didSelectRowAt: indexPath)
            }
            
            /// 已收货
        case .receivedGoods:
            if model.IsReview == 0 {
                cell.funcBtn.isHidden = false
                cell.funcBtn.setTitle("评价", for: .normal)
                cell.funcBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                    self.delegate?.orderListChildrenView(review: self, didSelectRowAt: indexPath)
                }
            }
            
            cell.statusBtn.isHidden = false
            cell.statusBtn.setTitle("查看物流", for: .normal)
            cell.statusBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.orderListChildrenView(viewLogistics: self, didSelectRowAt: indexPath)
            }
            
            /// 锁定
        case .lock:
            break
            
            /// 取消
        case .cancel:
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.orderListChildrenView(delete: self, didSelectRowAt: indexPath)
            }
            
            /// 退款中
        case .refund:
            break
            
            /// 退款完成
        case .refundDone:
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.orderListChildrenView(delete: self, didSelectRowAt: indexPath)
            }
            cell.downStatusLab.isHidden = false
            cell.downStatusLab.text = "退款成功"
        case .refundFail:
            cell.downStatusLab.isHidden = false
            cell.downStatusLab.text = "退款失败"
            
        /// 已完成
        case .done:
            cell.deleteBtn.isHidden = false
            cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                self.delegate?.orderListChildrenView(delete: self, didSelectRowAt: indexPath)
            }
            
        default:
            break
        }
        
//        self.titleLab.text = "好之味全价狗粮"
//        self.messageLab.text = "10kg | 牛肉味"
//
//        self.dateLab.text = "2019 -02-03 22:00"
//
//        self.statusBtn.setTitle("查看物流", for: .normal)
//
//        self.funcBtn.setTitle("评价", for: .normal)
//
//        self.originPriceLab.text = "¥14589"
//        self.numberLab.text = "x3"
//
//        self.priceLab.text = "¥13589"
//
//        self.orderCodeLab.text = "订单号：76567876590"
//        self.statusLab.text = "交易成功"
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.orderListChildrenView(self, didSelectRowAt: indexPath)
    }
}
