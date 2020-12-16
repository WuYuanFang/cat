//
//  AC_XQStatusView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQStatusView: UIView {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    let btn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.titleLab, self.btn)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.titleLab.snp.top).offset(-16)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 81, height: 74))
        }
        
        self.btn.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        // 设置属性
        
        
        
//        self.titleLab.font = UIFont.
        
        self.btn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        
        self.imgView.image = UIImage.init(named: "done")
        self.titleLab.text = "恭喜您，商品发布成功！"
        self.btn.setTitle("查看详情", for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
