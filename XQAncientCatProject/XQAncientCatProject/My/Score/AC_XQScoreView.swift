//
//  AC_XQScoreView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQScoreView: UIView {
    
    let scrollView = UIScrollView()
    let headerView = AC_XQScoreViewHeaderView()
    let welfareView = AC_XQScoreHotView()
    
    let detailView = AC_XQScoreViewDetailView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        self.scrollView.xq_addSubviews(self.headerView, self.welfareView, self.detailView)
        
        // 布局
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let v1 = UIView()
        self.scrollView.addSubview(v1)
        v1.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.welfareView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        self.detailView.snp.makeConstraints { (make) in
            make.top.equalTo(self.welfareView.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class AC_XQScoreViewDetailView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    let titleLab = UILabel()
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTIntegralCrediteModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        
        
        self.tableView.register(AC_XQScoreViewDetailViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        self.titleLab.textAlignment = .center
        
        self.titleLab.text = "积分明细"
        self.titleLab.textColor = UIColor.ac_mainColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQScoreViewDetailViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.titleLab.text = model.ActionDes
        cell.messageLab.text = model.ActionTime
        if model.PayCredits < 0 {
            cell.moneyLab.text = "\(model.PayCredits)"
        }else {
            cell.moneyLab.text = "+\(model.PayCredits)"
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
}


class AC_XQScoreViewDetailViewCell: UITableViewCell {
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    let moneyLab = UILabel()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.titleLab, self.messageLab, self.moneyLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(self.moneyLab.snp.left).offset(-5)
            make.top.equalTo(12)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(7)
            make.bottom.equalTo(-12)
        }
        
        self.moneyLab.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.required.rawValue
        self.moneyLab.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        self.selectionStyle = .none
        
//        self.accessoryType = .disclosureIndicator
        
        self.titleLab.font = UIFont.systemFont(ofSize: 18)
        
        self.messageLab.font = UIFont.systemFont(ofSize: 13)
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        
        self.moneyLab.font = self.titleLab.font
        self.moneyLab.textAlignment = .right
        
        self.titleLab.text = "购买送积分（订单号：8765654345）"
        self.messageLab.text = "2019-03-03 22:00"
        self.moneyLab.text = "+11"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
