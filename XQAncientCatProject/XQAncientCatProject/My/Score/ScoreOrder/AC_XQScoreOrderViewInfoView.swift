//
//  AC_XQScoreOrderViewInfoView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQScoreOrderViewInfoView: AC_XQFosterOrderViewInfoViewBaseView, UITableViewDelegate, UITableViewDataSource {
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTIntegralIntegralProductInfoModel]()
    
    /// 运费
    let freightView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 数量
    let numberView = XQRowNumberView()
    
    let spacing: CGFloat = 12
    
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
            make.top.equalTo(self.numberView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-16)
            make.bottom.equalTo(-30)
        }
        
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
    
    func reloadUI(_ modelArr: [XQSMNTIntegralIntegralProductInfoModel]) {
        self.dataArr = modelArr
        
        self.numberView.numberView.currentNumber = Float(modelArr.count)
        
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
        
        cell.xq_contentView.imgView.sd_setImage(with: model.ShowImgWithAddress.sm_getImgUrl())
        cell.xq_contentView.nameLab.text = model.ShopName
        cell.xq_contentView.priceLab.text = "\(model.ShopPrice.xq_removeDecimalPointZero())积分"
        cell.xq_contentView.priceLab.font = UIFont.systemFont(ofSize: 13)
        cell.xq_contentView.numberLab.text = ""
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
