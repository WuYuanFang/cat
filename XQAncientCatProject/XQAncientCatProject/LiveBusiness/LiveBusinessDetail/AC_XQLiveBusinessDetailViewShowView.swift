//
//  AC_XQLiveBusinessDetailViewShowView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLiveBusinessDetailViewShowView: UIView {

    let titleLab = UILabel()
    
    let imgView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.imgView)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(135)
        }
        
        // 设置属性
        
        self.titleLab.text = "详情"
        
        self.imgView.contentMode = .scaleAspectFit
        
        self.imgView.image = UIImage.init(named: "gender_man")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
