//
//  AC_XQMallOrderListCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMallOrderListCell: UITableViewCell {
    
    private let xq_contentView = UIView()
    
    let orderNumberLab = UILabel()
    let statusLab = UILabel()
    let lineView = UIView()
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    let messageLab = AC_XQPaddingLabel()
    
    let priceView = AC_XQPriceView()
    
    let numberLab = UILabel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.xq_contentView)
        self.xq_contentView.xq_addSubviews(self.orderNumberLab, self.statusLab, self.lineView, self.imgView, self.titleLab, self.messageLab, self.priceView, self.numberLab)
        
        // 布局
        self.xq_contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.orderNumberLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11.5)
            make.top.equalToSuperview().offset(13.5)
            make.right.equalToSuperview().offset(-60)
        }
        
        self.statusLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.orderNumberLab)
            make.right.equalToSuperview().offset(-11.5)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.orderNumberLab)
            make.right.equalTo(self.statusLab)
            make.height.equalTo(1)
            make.top.equalTo(self.orderNumberLab.snp.bottom).offset(10.5)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.orderNumberLab)
            make.top.equalTo(self.lineView.snp.bottom).offset(12)
            make.size.equalTo(CGSize.init(width: 70, height: 70))
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(18)
            make.top.equalTo(self.imgView).offset(8)
            make.right.lessThanOrEqualTo(self.priceView.snp.left).offset(-12)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(17.5)
        }
        
        self.priceView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(self.lineView)
        }
        
        self.numberLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.messageLab)
            make.right.equalTo(self.priceView)
        }
        
        // 设置属性
        
        self.selectionStyle = .none
        
        self.xq_contentView.backgroundColor = UIColor.white
        self.xq_contentView.layer.cornerRadius = 10
        self.xq_contentView.layer.shadowOpacity = 0.2
        self.xq_contentView.layer.shadowColor = UIColor.black.cgColor
        self.xq_contentView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        
        
        self.orderNumberLab.font = UIFont.systemFont(ofSize: 12)
        self.orderNumberLab.textColor = UIColor.init(hex: "#B2B2B2")
        
        self.statusLab.font = UIFont.systemFont(ofSize: 12)
        self.statusLab.textColor = UIColor.init(hex: "#B2B2B2")
        
        self.lineView.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
        self.imgView.layer.cornerRadius = 10
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 14)
        
        self.numberLab.font = UIFont.systemFont(ofSize: 12)
        self.numberLab.textColor = UIColor.init(hex: "#B2B2B2")
        
        
        self.orderNumberLab.text = "订单号：54365413214321"
        self.statusLab.text = "未发货"
        self.imgView.backgroundColor = UIColor.orange
        self.titleLab.text = "全封闭式猫砂盆大号防外溅"
        self.messageLab.titleLab.text = "特大超大号"
        self.priceView.priceLab.text = "208"
        self.numberLab.text = "x1"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
