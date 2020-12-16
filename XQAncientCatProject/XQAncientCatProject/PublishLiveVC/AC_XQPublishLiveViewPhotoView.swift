//
//  AC_XQPublishLiveViewPhotoView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQPublishLiveViewPhotoView: AC_XQPublishLiveViewCommonView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // 布局
        
        // 设置属性
        self.titleView.titleLab.text = "宠物照片"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
