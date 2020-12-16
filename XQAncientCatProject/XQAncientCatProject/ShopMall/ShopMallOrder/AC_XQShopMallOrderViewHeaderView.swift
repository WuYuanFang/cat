//
//  AC_XQShopMallOrderViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopMallOrderViewHeaderView: UIView {

    let imgView = UIImageView()
    
    let addLab = UILabel()
    
    let nameLab = UILabel()
    let phoneLab = UILabel()
    let addressLab = UILabel()
    let arrowImgView = UIImageView()
    
    private var _addressModel: XQSMNTShopAddressDtoModel?
    /// 地址 model
    var addressModel: XQSMNTShopAddressDtoModel? {
        set {
            _addressModel = newValue
            
            var haveAddress = false
            if let addressModel = _addressModel {
                haveAddress = true
                
                self.nameLab.text = addressModel.Consignee
                self.phoneLab.text = addressModel.Mobile
                self.addressLab.text = addressModel.Address
            }
            
            self.addLab.isHidden = haveAddress
            
            self.nameLab.isHidden = !haveAddress
            self.phoneLab.isHidden = !haveAddress
            self.addressLab.isHidden = !haveAddress
            self.arrowImgView.isHidden = !haveAddress
            
        }
        get {
            return _addressModel
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.addLab, self.nameLab, self.phoneLab, self.addressLab, self.arrowImgView)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(25)
        }
        
        
        self.addLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.imgView.snp.right).offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(self.imgView.snp.right).offset(16)
        }
        
        self.phoneLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.nameLab)
            make.left.equalTo(self.nameLab.snp.right).offset(4)
        }
        
        self.addressLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom).offset(4)
            make.left.equalTo(self.nameLab)
            make.right.equalTo(self.arrowImgView.snp.left).offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        self.arrowImgView.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        // 设置属性
        
        self.imgView.image = UIImage.init(named: "mall_order_address")
        
        self.arrowImgView.image = UIImage.init(named: "arrow_right_mainColor_o")
        
        self.addLab.text = "添加收货地址"
        self.addLab.textColor = UIColor.ac_mainColor
        self.addLab.font = UIFont.systemFont(ofSize: 16)
        
        self.phoneLab.textColor = UIColor.init(hex: "#999999")
        self.phoneLab.font = UIFont.systemFont(ofSize: 13)
        
        self.nameLab.font = UIFont.systemFont(ofSize: 15)
        
        self.addressLab.font = UIFont.systemFont(ofSize: 15)
        
        
        self.addressModel = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
