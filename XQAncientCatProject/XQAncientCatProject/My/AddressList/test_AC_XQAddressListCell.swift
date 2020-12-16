//
//  AC_XQAddressListCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class test_AC_XQAddressListCell: UITableViewCell {
    
    private let xq_contentView = UIView()
    
    let normalAddressBtn = UIButton()
//    let normalAddressLab = UILabel()
    
    let editBtn = UIButton()
    let deleteBtn = UIButton()
    
    let lineView = UIView()
    
    let nameLab = UILabel()
    let phoneLab = UILabel()
    let addressLab = UILabel()

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
//        self.xq_contentView.xq_addSubviews(self.normalAddressBtn, self.normalAddressLab, self.editBtn, self.deleteBtn, self.lineView, self.nameLab, self.phoneLab, self.addressLab)
        self.xq_contentView.xq_addSubviews(self.normalAddressBtn, self.editBtn, self.deleteBtn, self.lineView, self.nameLab, self.phoneLab, self.addressLab)
        
        
        // 布局
        self.xq_contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.normalAddressBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(11.5)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(20)
        }
        
//        self.normalAddressLab.snp.makeConstraints { (make) in
//            make.left.equalTo(self.normalAddressBtn.snp.right).offset(8.5)
//            make.centerY.equalTo(self.normalAddressBtn)
//        }
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(self.normalAddressBtn)
            make.height.equalTo(self.normalAddressBtn)
        }
        
        self.editBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.deleteBtn.snp.left).offset(-12)
            make.centerY.equalTo(self.deleteBtn)
            make.height.equalTo(self.deleteBtn)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(self.normalAddressBtn)
            make.right.equalTo(self.deleteBtn)
            make.top.equalTo(self.normalAddressBtn.snp.bottom).offset(8)
            make.height.equalTo(1)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView)
            make.top.equalTo(self.lineView.snp.bottom).offset(18)
        }
        
        self.phoneLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLab.snp.right).offset(14.5)
            make.centerY.equalTo(self.nameLab)
        }
        
        self.addressLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLab)
            make.top.equalTo(self.nameLab.snp.bottom).offset(12.5)
            make.right.equalTo(self.lineView)
        }
        
        
        // 设置属性
        
        self.selectionStyle = .none
        
        self.xq_contentView.backgroundColor = UIColor.white
        self.xq_contentView.layer.cornerRadius = 10
        self.xq_contentView.layer.shadowOpacity = 0.2
        self.xq_contentView.layer.shadowColor = UIColor.black.cgColor
        self.xq_contentView.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        
        
//        self.normalAddressLab.textColor = UIColor.init(hex: "#B2B2B2")
//        self.normalAddressLab.font = UIFont.systemFont(ofSize: 12)
        
        self.normalAddressBtn.setTitleColor(UIColor.init(hex: "#B2B2B2"), for: .normal)
        self.normalAddressBtn.setTitle(" 设为默认地址", for: .normal)
        self.normalAddressBtn.setTitle(" 默认地址", for: .selected)
        self.normalAddressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.normalAddressBtn.setImage(UIImage.init(named: "orderGoods_increase"), for: .normal)
        self.normalAddressBtn.imageView?.contentMode = .scaleAspectFit
        
        self.editBtn.setTitleColor(UIColor.init(hex: "#B2B2B2"), for: .normal)
        self.editBtn.setTitle(" 编辑", for: .normal)
        self.editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.editBtn.setImage(UIImage.init(named: "orderGoods_increase"), for: .normal)
        self.editBtn.imageView?.contentMode = .scaleAspectFit
        
        self.deleteBtn.setTitleColor(UIColor.init(hex: "#B2B2B2"), for: .normal)
        self.deleteBtn.setTitle(" 删除", for: .normal)
        self.deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.deleteBtn.setImage(UIImage.init(named: "orderGoods_increase"), for: .normal)
        self.deleteBtn.imageView?.contentMode = .scaleAspectFit
        
        self.lineView.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
        self.nameLab.font = UIFont.systemFont(ofSize: 12)
        self.phoneLab.font = UIFont.systemFont(ofSize: 12)
        self.addressLab.font = UIFont.systemFont(ofSize: 12)
        
        
        
        self.nameLab.text = "周小明"
        self.phoneLab.text = "136*******36"
        self.addressLab.text = "广东省惠州市惠城区河南岸68号"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
