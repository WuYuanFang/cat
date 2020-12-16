//
//  AC_XQFosterViewDayView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQFosterViewDayView: AC_XQHomePageViewTableViewHeaderView {
    
    let numberView = XQNumberView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.numberView)
        
        // 布局
        self.numberView.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.top.bottom.equalToSuperview()
            make.left.equalTo(12)
            make.width.equalTo(140)
        }
        
        // 设置属性
        
        self.titleLab.text = "寄养天数"
        self.imgView.image = UIImage.init(named: "foster_day")
        self.numberView.increaseBtn.setBackgroundImage(UIImage.init(named: "arrow_right_mainColor"), for: .normal)
        self.numberView.decreaseBtn.setBackgroundImage(UIImage.init(named: "arrow_left_mainColor"), for: .normal)
        self.numberView.tf.backgroundColor = UIColor.init(hex: "#F3F3F3")
        self.numberView.minValue = 1
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
