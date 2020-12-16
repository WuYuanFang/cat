//
//  AC_XQSelectVarietiesVCSearchView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit


class AC_XQSelectVarietiesVCSearchView: UIView, UITextFieldDelegate {
    
    let tf = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tf)
        
        // 布局
        self.tf.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        self.tf.placeholder = "请输入品种名"
        
        let leftV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        let imgView = UIImageView.init(frame: CGRect.init(x: 2.5, y: 2.5, width: 25, height: 25))
        imgView.image = UIImage.init(named: "pet_search")
        leftV.addSubview(imgView)
        self.tf.leftView = leftV
        self.tf.leftViewMode = .always
        
        self.tf.applyInputAccessoryView()
        
//        self.tf.delegate = self
        
//        self.tf.addTarget(self, action: #selector(notification_tfChange(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - notificaiton
    @objc
    func notification_tfChange(_ sender: UITextField) {
        
    }
    
    // MARK: - UITextFieldDelegate
    
}
