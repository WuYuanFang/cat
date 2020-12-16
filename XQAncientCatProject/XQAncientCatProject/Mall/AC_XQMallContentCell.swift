//
//  AC_XQMallContentCell.swift
//  XQAncientCatProject
//
//  Created by sinking on 2020/1/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQMallContentCell: UITableViewCell {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    
    let discountLab = UILabel()
    
    let numberLab = UILabel()
    let numberImgView = UIImageView()
    
    let priceView = AC_XQPriceView()
    
    let buyBtn = UIButton()

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
        
        self.contentView.xq_addSubviews(self.imgView, self.titleLab, self.discountLab, self.numberLab, self.numberImgView, self.priceView, self.buyBtn)
        
        // 布局
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(11)
            make.top.equalTo(self.imgView).offset(5)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.discountLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(9)
            make.size.equalTo(CGSize.init(width: 29.5, height: 12.5))
        }
        
        self.numberImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.discountLab.snp.right).offset(9)
            make.centerY.equalTo(self.discountLab)
            make.size.equalTo(CGSize.init(width: 11, height: 11))
        }
        
        self.numberLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.numberImgView.snp.right).offset(2)
            make.centerY.equalTo(self.numberImgView)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.priceView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.discountLab.snp.bottom).offset(13)
        }
        
        self.buyBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.priceView)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        
        // 设置属性
        
        self.selectionStyle = .none
        
        self.imgView.layer.cornerRadius = 10
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 14)
        
        self.discountLab.font = UIFont.systemFont(ofSize: 9)
        self.discountLab.textColor = UIColor.init(hex: "#FF7E7E")
        self.discountLab.layer.cornerRadius = 12.5/2
        self.discountLab.layer.borderWidth = 1
        self.discountLab.layer.borderColor = UIColor.init(hex: "#FF7E7E").cgColor
        self.discountLab.textAlignment = .center
        
        self.numberLab.font = UIFont.systemFont(ofSize: 9)
        self.numberLab.textColor = UIColor.init(hex: "#B2B2B2")
        
        
        self.imgView.backgroundColor = UIColor.orange
        self.titleLab.text = "猫碗狗碗狗盆宠物双碗盆宠物双碗盆宠物双碗"
        self.numberLab.text = "已有225人购买"
        self.priceView.priceLab.text = "108"
        self.numberImgView.backgroundColor = UIColor.orange
        self.discountLab.text = "折扣"
        self.buyBtn.backgroundColor = UIColor.orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
