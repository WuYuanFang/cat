//
//  AC_XQShopCarListCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import PPNumberButton

class AC_XQShopCarListCell: UITableViewCell, PPNumberButtonDelegate {
    
    let selectBtn = UIButton()
    let imgView = UIImageView()
    let titleLab = UILabel()
    
    let messageLab = AC_XQPaddingLabel()
    
    let priceView = AC_XQPriceView()
    
    let numberBtn = PPNumberButton()
    
    
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
        
        self.contentView.xq_addSubviews(self.selectBtn, self.imgView, self.titleLab, self.messageLab, self.priceView, self.numberBtn)
        
        // 布局
        
        self.selectBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.selectBtn.snp.right).offset(21.5)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 80, height: 80))
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(18.2)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(self.imgView)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(9.5)
        }
        
        self.priceView.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.messageLab.snp.bottom).offset(18.5)
        }
        
        self.numberBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.priceView)
            make.size.equalTo(CGSize.init(width: 80, height: 20))
        }
        
        
        // 设置属性
        
        self.selectionStyle = .none
        
        self.imgView.layer.cornerRadius = 10
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 14)
        
        self.numberBtn.keyboardType = .numberPad
        //        self.numberBtn.increaseTitle = "+"
        //        self.numberBtn.decreaseTitle = "-"
        //        self.numberBtn.decreaseHide = true
        self.numberBtn.isEditing = false
        self.numberBtn.inputFieldFont = 16
        self.numberBtn.minValue = 1
        self.numberBtn.currentNumber = 1
        self.numberBtn.increaseImage = UIImage(named: "orderGoods_increase")
        self.numberBtn.decreaseImage = UIImage(named: "orderGoods_decrease")
        self.numberBtn.delegate = self
        
        
        
        self.selectBtn.backgroundColor = UIColor.orange
        self.imgView.backgroundColor = UIColor.orange
        self.titleLab.text = "全封闭式猫砂盆大号防外溅"
        self.messageLab.titleLab.text = "特大超大号"
        self.priceView.priceLab.text = "208"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class AC_XQPaddingLabel: UIView {
    
    let titleLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(3.5)
            make.bottom.equalToSuperview().offset(-2.5)
            make.left.equalToSuperview().offset(9)
            make.right.equalToSuperview().offset(-9)
        }
        
        // 属性
        self.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
        self.titleLab.font = UIFont.systemFont(ofSize: 9)
        self.titleLab.textColor = UIColor.init(hex: "#B2B2B2")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height/2
    }
    
}


class AC_XQPriceView: UIView {
    
    let priceLab = UILabel()
    let symbolLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.priceLab, self.symbolLab)
        
        // 布局
        
        self.symbolLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(self.priceLab).offset(-2)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.symbolLab.snp.right)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        // 设置属性
        self.priceLab.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.symbolLab.font = UIFont.boldSystemFont(ofSize: 12)
        self.symbolLab.text = "¥"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}






