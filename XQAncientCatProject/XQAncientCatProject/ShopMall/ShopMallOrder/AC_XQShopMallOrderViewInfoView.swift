//
//  AC_XQShopMallOrderViewInfoView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

class AC_XQShopMallOrderViewInfoView: AC_XQFosterOrderViewInfoViewBaseView, UITableViewDelegate, UITableViewDataSource {
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTCartProductInfoModel]()
    
    /// 运费
    let freightView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 数量
    let numberView = XQRowNumberView()
    
    let spacing: CGFloat = 12
    
    private var _isShopCar = false
    /// 是否购物车结账
    var isShopCar: Bool {
        set {
            _isShopCar = newValue
            
            self.numberView.isHidden = _isShopCar
            if _isShopCar {
                
                self.freightView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.tableView.snp.bottom).offset(12)
                    make.left.equalTo(12)
                    make.right.equalTo(-16)
                    make.bottom.equalTo(-30)
                }
                
            }else {
                
                self.freightView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.numberView.snp.bottom).offset(12)
                    make.left.equalTo(12)
                    make.right.equalTo(-16)
                    make.bottom.equalTo(-30)
                }
            }
            
            self.tableView.reloadData()
            
        }
        get {
            return _isShopCar
        }
    }
    
    let cellRowHeight: CGFloat = 75
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.contentView.xq_addSubviews(self.tableView, self.freightView, self.numberView)
        
        // 布局
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
        }
        
        self.numberView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(16)
            make.right.left.equalTo(self.freightView)
            make.height.equalTo(35)
        }
        
        self.freightView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tableView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-16)
            make.bottom.equalTo(-30)
        }
        
        self.isShopCar = true
        
        // 设置属性
        
        self.freightView.titleLab.text = "运费"
        self.freightView.contentLab.text = "包邮"
        
        self.numberView.titleLab.text = "购买数量"
        self.numberView.titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        self.numberView.numberView.increaseBtn.setTitle("+", for: .normal)
        self.numberView.numberView.increaseBtn.setTitleColor(UIColor.black, for: .normal)
        self.numberView.numberView.increaseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.numberView.numberView.decreaseBtn.setTitle("-", for: .normal)
        self.numberView.numberView.decreaseBtn.setTitleColor(UIColor.black, for: .normal)
        self.numberView.numberView.decreaseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.numberView.numberView.minValue = 1
        
        self.tableView.register(AC_XQShopMallOrderViewInfoViewCell.classForCoder(), forCellReuseIdentifier: result)
        self.tableView.isScrollEnabled = false
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = self.cellRowHeight
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ modelArr: [XQSMNTCartProductInfoModel]) {
        self.dataArr = modelArr
        
        if let model = modelArr.first {
            self.numberView.numberView.currentNumber = Float(model.OrderProductInfo?.BuyCount ?? 1)
        }
        
        self.tableView.snp.updateConstraints { (make) in
            make.height.equalTo(CGFloat(self.dataArr.count) * self.cellRowHeight)
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQShopMallOrderViewInfoViewCell
        
        let model = self.dataArr[indexPath.row]
        
        if let orderProductInfo = model.OrderProductInfo {
            cell.xq_contentView.imgView.sd_setImage(with: orderProductInfo.ShowImgWithAddress.sm_getImgUrl())
            cell.xq_contentView.nameLab.text = orderProductInfo.Name
            cell.xq_contentView.priceLab.text = "¥\(orderProductInfo.ShopPrice)"
            cell.xq_contentView.numberLab.text = "X\(orderProductInfo.BuyCount)"
        }
        
        if self.isShopCar {
            cell.xq_contentView.haveNumberUILayout()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
