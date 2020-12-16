//
//  AC_XQAddressListAlertViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import UITextField_Navigation

class AC_XQAddressListAlertViewCell: UITableViewCell {
    
    let tf = XQLineTextField()

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
        
        self.contentView.addSubview(self.tf)
        
        // 布局
        self.tf.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(27)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(44)
            make.centerY.equalToSuperview()
        }
        
        
        // 设置属性
        
        self.selectionStyle = .none
        
        let leftImgView = UIImageView.init(frame: CGRect.init(x: 0, y: 5, width: 20, height: 20))
        leftImgView.image = UIImage.init(named: "orderGoods_increase")
        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 30))
        leftView.addSubview(leftImgView)
        self.tf.leftView = leftView
        self.tf.leftViewMode = .always
        self.tf.font = UIFont.systemFont(ofSize: 13)
        self.tf.lineIgnoreLeftView = true
        self.tf.lineBottomSpacing = 10
        self.tf.applyInputAccessoryView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




class XQLineTextField: UITextField {
    
    /// 线view
    let lineView = UIView()
    
    /// 线高度
    var lineHeight: CGFloat = 1
    
    /// 线距离底部的空隙
    var lineBottomSpacing: CGFloat = 0
    
    /// 线距离左边的空隙
    var lineLeftSpacing: CGFloat = 0
    
    /// 线距离右边的空隙
    var lineRightSpacing: CGFloat = 0
    
    /// 是否忽略左边视图
    /// 设置 true 之后, 线的width, 会从 leftView 的右边开始
    var lineIgnoreLeftView: Bool = false
    
    /// 是否忽略右边视图
    /// 设置 true 之后, 线的width, 会从 rightView 的左边结束
    var lineIgnoreRightView: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.lineView)
        self.lineView.backgroundColor = UIColor.init(hex: "#E5E5E5")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var x: CGFloat = 0
        
        if self.lineIgnoreLeftView {
            // 忽略了
            x += self.leftView?.frame.width ?? 0
        }
        
        x += self.lineLeftSpacing
        
        let y = self.frame.height - self.lineHeight - self.lineBottomSpacing
        
        var width: CGFloat = self.frame.width - x
        if self.lineIgnoreRightView {
            width -= self.rightView?.frame.width ?? 0
        }
        
        width -= self.lineRightSpacing
        
        self.lineView.frame = CGRect.init(x: x, y: y, width: width, height: self.lineHeight)
        
    }
    
}

