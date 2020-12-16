//
//  AC_XQEditAddressViewRowView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit


protocol AC_XQEditAddressViewRowViewBtnDelegate: NSObjectProtocol {
    
    /// 选中哪个
    /// - Parameters:
    ///   - didSelectLeft: ture 选中左边
    func editAddressViewRowView(_ editAddressViewRowView: AC_XQEditAddressViewRowView, didSelectLeft: Bool)
    
}

/// 表单输入框
class AC_XQEditAddressViewRowView: UIView {
    
    /// 左边标题
    let titleLab = UILabel()
    
    let tv = UITextView()
    
    let tf = UITextField()
    /// 右边箭头
    let arrowImgView = UIImageView()
    
    
    let leftBtn = QMUIButton()
    let rightBtn = QMUIButton()
    
    weak var btnDelegate: AC_XQEditAddressViewRowViewBtnDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.tf, self.tv, self.arrowImgView, self.leftBtn, self.rightBtn)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.tf)
            make.left.equalTo(16)
            make.width.equalTo(80)
        }
        
        self.tf.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        self.titleLab.textColor = UIColor.ac_mainColor
        
        self.tf.font = UIFont.systemFont(ofSize: 15)
        
        self.tv.isHidden = true
        self.tv.backgroundColor = UIColor.clear
        self.tv.font = UIFont.systemFont(ofSize: 15)
        
        self.arrowImgView.contentMode = .scaleAspectFit
        self.arrowImgView.isHidden = true
        self.arrowImgView.image = UIImage.init(named: "pushImage")
        
        self.layer.cornerRadius = 4
        
        self.leftBtn.isHidden = true
        self.leftBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.leftBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        self.leftBtn.setTitleColor(UIColor.black, for: .normal)
        self.leftBtn.spacingBetweenImageAndTitle = 6
        self.leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.leftBtn.isSelected = true
        
        self.rightBtn.isHidden = true
        self.rightBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        self.rightBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        self.rightBtn.setTitleColor(UIColor.black, for: .normal)
        self.rightBtn.spacingBetweenImageAndTitle = 6
        self.rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.leftBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false {
                return
            }
            sender?.isSelected.toggle()
            self.rightBtn.isSelected = false
            self.btnDelegate?.editAddressViewRowView(self, didSelectLeft: true)
        }
        
        self.rightBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false {
                return
            }
            sender?.isSelected.toggle()
            self.leftBtn.isSelected = false
            self.btnDelegate?.editAddressViewRowView(self, didSelectLeft: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// tv 输入框
    func tvUI() {
        
        self.tf.isHidden = true
        self.arrowImgView.isHidden = true
        self.tv.isHidden = false
        
        self.tf.snp.remakeConstraints { (make) in
            
        }
        
        self.titleLab.snp.remakeConstraints { (make) in
            make.top.equalTo(self.tv).offset(8)
            make.left.equalTo(16)
            make.width.equalTo(80)
        }
        
        self.tv.snp.remakeConstraints { (make) in
            make.height.equalTo(50)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
        
    }
    
    /// tf 输入框, 并且有箭头
    func arrowUI() {
        self.tv.isHidden = true
        self.arrowImgView.isHidden = false
        self.tf.isHidden = false
        self.tf.isUserInteractionEnabled = false
        
        self.tf.snp.remakeConstraints { (make) in
            make.height.equalTo(30)
            make.top.equalTo(12)
            make.bottom.equalTo(-12)
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.right.equalTo(self.arrowImgView.snp.left).offset(-12)
        }
        
        self.arrowImgView.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(15)
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    /// 选择 btn
    func btnUI() {
        
        self.tf.isHidden = true
        self.tv.isHidden = true
        self.arrowImgView.isHidden = true
        self.leftBtn.isHidden = false
        self.rightBtn.isHidden = false
        
        self.leftBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
        self.rightBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.leftBtn.snp.right).offset(20)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        
    }
    
    /// 可以调用这个设置, 会自动取反另一个
    func setSelectLeft(_ select: Bool) {
        self.leftBtn.isSelected = select
        self.rightBtn.isSelected = !select
    }
    
}
