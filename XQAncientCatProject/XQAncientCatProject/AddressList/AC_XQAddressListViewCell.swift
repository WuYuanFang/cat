//
//  AC_XQAddressListViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class AC_XQAddressListViewCell: AC_XQShadowCell {
    
    let addressImgView = UIImageView()
    
    let titleLab = UILabel()
    let phoneLab = UILabel()
    let normalLab = XQPaddingLabel.init(frame: CGRect.zero, padding: UIEdgeInsets.init(top: 2, left: 5, bottom: -2, right: -5), rounded: false)
    let addressLab = UILabel()
    
    let lineView = UILabel()
    let editBtn = UIButton()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.xq_contentView.xq_addSubviews(self.addressImgView, self.titleLab, self.phoneLab, self.addressLab, self.normalLab,  self.lineView, self.editBtn)
        
        // 布局
        
        self.addressImgView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(self.addressImgView.snp.right).offset(12)
        }
        
        self.phoneLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab.snp.right).offset(10)
            make.centerY.equalTo(self.titleLab)
        }
        
        self.normalLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.addressLab)
            make.left.equalTo(self.addressLab)
        }
        
        self.addressLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(8)
            make.left.equalTo(self.titleLab)
            make.right.equalTo(self.lineView.snp.left).offset(-30)
        }
        
        self.editBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-24)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.bottom.equalTo(-25)
            make.right.equalTo(self.editBtn.snp.left).offset(-24)
            make.width.equalTo(1)
            make.height.equalTo(54)
        }
        
        
        
        
        // 设置属性
        
        self.normalLab.label.text = "默认"
        self.normalLab.backgroundColor = UIColor.init(hex: "#E3EBEC")
        self.normalLab.label.textColor = UIColor.ac_mainColor
        self.normalLab.label.font = UIFont.systemFont(ofSize: 12)
        
        self.addressLab.numberOfLines = 2
        self.addressLab.font = UIFont.systemFont(ofSize: 14)
        
        self.addressImgView.image = UIImage.init(named: "address_list")
        self.editBtn.setBackgroundImage(UIImage.init(named: "edit"), for: .normal)
        
        self.phoneLab.textColor = UIColor.init(hex: "#999999")
        self.phoneLab.font = UIFont.systemFont(ofSize: 15)
        
        self.lineView.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
//        self.titleLab.text = "娜娜"
//        self.addressLab.text = "            " + "河北省东城区上海路华安大厦A区1号门5单元1040室"
//        self.phoneLab.text = "13907145333"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
