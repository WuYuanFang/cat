//
//  AC_XQBusinessHistoryViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class AC_XQBusinessHistoryViewCell: AC_XQShadowCell {
    
    private var _xq_isEditing = false
    var xq_isEditing: Bool {
        set {
            _xq_isEditing = newValue
            
            if self.xq_isEditing {
                self.selectBtn.isHidden = false
                self.editLayout()
            }else {
                self.selectBtn.isHidden = true
                self.xq_normalLayout()
            }
        }
        get {
            return _xq_isEditing
        }
    }
    
    let selectBtn = UIButton()
    
    let iconImgView = UIImageView()
    let titleLab = UILabel()
    let messageLab = UILabel()
    let statusLab = XQPaddingLabel.init(frame: CGRect.zero, padding: UIEdgeInsets.init(top: 5, left: 8, bottom: -5, right: -8), rounded: false)
    let priceLab = UILabel()
    let btn = UIButton()
    
    
    
    let editBtn = UIButton()
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        self.selectBtn.isSelected = selected
        if selected {
            self.selectBtn.backgroundColor = UIColor.ac_mainColor
        }else {
            self.selectBtn.backgroundColor = UIColor.clear
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.selectBtn)
        self.xq_contentView.xq_addSubviews(self.iconImgView, self.titleLab, self.messageLab, self.statusLab, self.priceLab, self.btn, self.editBtn)
        
        // 布局
        self.iconImgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 85, height: 85))
            make.left.equalTo(10)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconImgView.snp.right).offset(12)
            make.top.equalTo(self.iconImgView).offset(6)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab)
            make.top.equalTo(self.titleLab.snp.bottom).offset(10)
        }
        
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.iconImgView).offset(-8)
            make.left.equalTo(self.titleLab)
        }
        
        self.statusLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.btn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.iconImgView)
            make.right.equalTo(self.statusLab)
        }
        
        self.editBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.centerY.equalToSuperview()
            make.size.equalTo(25)
        }
        
        // 设置属性
        
        self.selectionStyle = .none
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        self.iconImgView.layer.cornerRadius = 10
        self.iconImgView.layer.masksToBounds = true
        
        self.selectBtn.layer.cornerRadius = 8
        self.selectBtn.layer.borderWidth = 1
        self.selectBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.statusLab.label.textColor = UIColor.ac_mainColor
        self.statusLab.label.font = UIFont.systemFont(ofSize: 14)
        self.statusLab.backgroundColor = UIColor.init(hex: "#EEF3F3")
        
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        self.messageLab.font = UIFont.systemFont(ofSize: 15)
        
        self.priceLab.textColor = UIColor.ac_mainColor
        self.priceLab.font = UIFont.systemFont(ofSize: 14)
        
        self.btn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.editBtn.setBackgroundImage(UIImage.init(named: "edit"), for: .normal)
        self.editBtn.isHidden = true
        
        self.titleLab.text = "布偶猫"
        self.statusLab.label.text = "交易成功"
        self.messageLab.text = "3个月 公 温顺"
        self.priceLab.text = "实付款 ¥1888"
        
        self.btn.setTitle("联系买家", for: .normal)
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func editLayout() {
        
        self.selectBtn.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        
        self.xq_contentView.snp.remakeConstraints { (make) in
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.left.equalTo(self.selectBtn.snp.right).offset(12)
            make.right.equalTo(-15)
        }
    }
    
}
