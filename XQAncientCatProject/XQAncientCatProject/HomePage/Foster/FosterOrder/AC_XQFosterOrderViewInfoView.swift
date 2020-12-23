//
//  AC_XQFosterOrderViewContentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/2.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQFosterOrderViewInfoView: AC_XQFosterOrderViewInfoViewBaseView {
    
    /// 套餐服务
    let serverView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 食物
    let foodView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 预约时间
    let timeView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 天数
    let dayView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 接送服务
    let takeServerView = AC_XQFosterOrderViewInfoViewLabelView()
    
    
    let startLab = UILabel()
    let endLab = UILabel()
    
    let spacing: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.serverView, self.foodView, self.timeView, self.dayView, self.takeServerView, self.startLab, self.endLab)
        
        
        // 布局
        self.serverView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(12)
            make.right.equalTo(-20)
        }
        
        self.foodView.snp.makeConstraints { (make) in
            make.top.equalTo(self.serverView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.timeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.foodView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.dayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.takeServerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.dayView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.startLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.takeServerView.snp.bottom).offset(8)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.endLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.startLab.snp.bottom).offset(6)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
            make.bottom.equalTo(-30)
        }
        
        // 设置属性
        
        
        self.startLab.textColor = UIColor.init(hex: "#666666")
        self.startLab.font = UIFont.systemFont(ofSize: 12)
        
        self.endLab.textColor = UIColor.init(hex: "#666666")
        self.endLab.font = UIFont.systemFont(ofSize: 12)
        
        
//        self.serverView, self.foodView, self.timeView, self.dayView, self.takeServerView, self.startLab, self.endLab
        
        self.serverView.titleLab.text = "服务项目"
        self.serverView.desLab.text = "寄养(别墅)"
        self.serverView.contentLab.text = "¥188/天"
        
        self.foodView.titleLab.text = "投食加喂"
//        self.foodView.desLab.text = "AD罐头\n红狗营养膏"
//        self.foodView.contentLab.text = "¥188"
        
        self.timeView.titleLab.text = "预约时间"
        self.timeView.contentLab.text = "3月14日 20:00"
        
        self.dayView.titleLab.text = "寄养天数"
        self.dayView.contentLab.text = "5天"
        
        self.takeServerView.titleLab.text = "接送服务"
        self.takeServerView.contentLab.text = "¥30"
        
        self.startLab.text = "接：阳光小区9号楼一单元403"
        self.endLab.text = "送：阳光小区9号楼一单元403"
        
        
        
        // 暂时不用接送
        self.takeServerView.removeFromSuperview()
        self.startLab.removeFromSuperview()
        self.endLab.removeFromSuperview()
        
        self.dayView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.timeView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
            make.bottom.equalTo(-30)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 去掉
    func noFood() {
        self.foodView.removeFromSuperview()
        self.timeView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.serverView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
    }
    

}


class AC_XQFosterOrderViewInfoViewBaseView: UIView {
    
    let lineView = UIView()
    let contentView = UIView()
    
    private let xq_contentView = UIView()
    
    private let corners: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.lineView, self.xq_contentView, self.contentView)
        
        // 布局
        self.lineView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(6)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(-12)
            make.left.equalTo(self.lineView.snp.right)
        }
        
        self.xq_contentView.snp.makeConstraints { (make) in
//            make.top.left.bottom.equalTo(self.contentView)
//            make.right.equalTo(self.contentView).offset(-self.corners)
            make.edges.equalTo(self.contentView)
        }
        
        // 设置属性
        self.lineView.backgroundColor = UIColor.init(hex: "#D1DEE0")
        
        
        self.contentView.backgroundColor = UIColor.white
        
        self.xq_contentView.backgroundColor = UIColor.white
        self.xq_contentView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.xq_contentView.layer.shadowOpacity = 0.15
        self.xq_contentView.layer.shadowColor = UIColor.black.cgColor
        self.xq_contentView.layer.cornerRadius = self.corners
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.xq_corners_addRoundedCorners([.topRight, .bottomRight], withRadii: CGSize.init(width: self.corners, height: self.corners))
    }
    
}


class AC_XQFosterOrderViewInfoViewLabelView: UIView {
    
    let titleLab = UILabel()
    
    let desLab = UILabel()
    
    let contentLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xq_addSubviews(self.titleLab, self.desLab, self.contentLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        self.desLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.right.equalTo(self.contentLab.snp.left).offset(12)
        }
        
        self.contentLab.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
        }
        
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        self.titleLab.textAlignment = .left
        
        self.desLab.font = UIFont.systemFont(ofSize: 14)
        self.desLab.numberOfLines = 0
        self.desLab.textAlignment = .left
        
        self.contentLab.font = UIFont.systemFont(ofSize: 14)
        self.contentLab.textAlignment = .right
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


