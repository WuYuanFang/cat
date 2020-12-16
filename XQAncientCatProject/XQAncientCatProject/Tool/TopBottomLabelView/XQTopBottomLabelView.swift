//
//  XQTopBottomLabelView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/11.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

/// 上面一个 label, 下面一个 label 的 view
class XQTopBottomLabelView: UIView {
    
    let topLabel = UILabel()
    let bottomLabel = UILabel()
    
    /// 初始化view
    /// - Parameters:
    ///   - bottomToTopLabelSpacing: 上下label间距
    init(frame: CGRect, bottomToTopLabelSpacing: CGFloat = 8) {
        super.init(frame: frame)
        
        self.addSubview(self.topLabel)
        self.addSubview(self.bottomLabel)
        
        // 布局
        self.topLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLabel.snp.bottom).offset(bottomToTopLabelSpacing)
            make.bottom.left.right.equalToSuperview()
        }
        
        // 设置属性
        
        self.topLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.topLabel.textAlignment = .center
        
        self.bottomLabel.font = UIFont.systemFont(ofSize: 15)
        self.bottomLabel.textAlignment = .center
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
