//
//  AC_XQShopCarView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

protocol AC_XQShopCarViewDelegate: NSObjectProtocol {
    
    /// 选中某个cell
    /// - Parameters:
    ///   - select: true 选中, false 取消
    func shopCarView(_ shopCarView: AC_XQShopCarView, didSelectRowAt indexPath: IndexPath, select: Bool)
    
    /// 数量变化
    func shopCarView(_ shopCarView: AC_XQShopCarView, indexPath: IndexPath, _ numberView: XQNumberView, _ number: Float, _ increaseStatus: Bool)
    
}

class AC_XQShopCarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTCartProductInfoModel]()
    
    let footerView = AC_XQBusinessHistoryViewBottomView()
    
    weak var delegate: AC_XQShopCarViewDelegate?
    
    // 选中搞的 pid
    var selectPidArr = [Int]()
    
    private var _cartInfo: XQSMNTCartModel?
    var cartInfo: XQSMNTCartModel? {
        set {
            _cartInfo = newValue
            
            self.footerView.priceLab.text = "¥\(self.cartInfo?.OrderAmount ?? 0)"
            self.dataArr = self.cartInfo?.CartInfo?.CartProductList ?? []
            self.tableView.reloadData()
        }
        get {
            return _cartInfo
        }
    }
    
    private var _xq_isEditing = false
    var xq_isEditing: Bool {
        set {
            _xq_isEditing = newValue
            self.tableView.reloadData()
            
            if self.xq_isEditing {
                
            }else {
                
            }
        }
        get {
            return _xq_isEditing
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.footerView)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        
        self.footerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.footerView.snp.top)
        }
        
        self.tableView.register(AC_XQShopCarViewCell.classForCoder(), forCellReuseIdentifier: result)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQShopCarViewCell
        
        let model = self.dataArr[indexPath.row]
        
        if let orderProductInfo = model.OrderProductInfo {
            cell.titleLab.text = orderProductInfo.Name
            
            cell.iconImgView.sd_setImage(with: orderProductInfo.ShowImgWithAddress.sm_getImgUrl())
            
            // 这里，看UI，好像是要让用户, 能在购物车选规格，和淘宝那些相似
            cell.messageLab.text = ""
            
            cell.priceLab.text = "¥\(orderProductInfo.ShopPrice)"
            
            
            cell.numberView.currentNumber = Float(orderProductInfo.BuyCount)
            
            cell.numberView.callback = { [unowned self] (numberView, number, increaseStatus) in
                self.delegate?.shopCarView(self, indexPath: indexPath, numberView, number, increaseStatus)
            }
            
            cell.selectBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
                sender?.isSelected.toggle()
                
                if sender?.isSelected ?? false {
                    self.selectPidArr.append(orderProductInfo.Pid)
                }else {
                    self.selectPidArr.removeAll { (element) -> Bool in
                        return element == orderProductInfo.Pid
                    }
                }
                // 底部按钮
                self.footerView.selectBtn.isSelected = self.selectPidArr.count == self.dataArr.count
                // 回调给外部
                self.delegate?.shopCarView(self, didSelectRowAt: indexPath, select: sender?.isSelected ?? false)
            }
            
            cell.selectBtn.isSelected = self.selectPidArr.contains(orderProductInfo.Pid)
        }
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
