//
//  AC_XQHomePageViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool
import XQProjectTool_iPhoneUI
import SDCycleScrollView
import QMUIKit

class AC_XQHomePageViewHeaderView: UIView, SDCycleScrollViewDelegate {
    
    let titleLab = UILabel()
    let subtitleLab = UILabel()
    
    let cycleScrollView = SDCycleScrollView()
    
    let waveView = AC_XQHomePageViewHeaderViewWaveView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.cycleScrollView, self.titleLab, self.subtitleLab, self.waveView)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(XQIOSDevice.getStatusHeight() + 25)
            make.left.equalTo(16)
        }
        
        self.subtitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLab.snp.right).offset(16)
            make.centerY.equalTo(self.titleLab)
        }
        
        let scale = 375.0/270.0
        self.cycleScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(self.cycleScrollView.snp.width).multipliedBy(1.0/scale)
        }
        
        self.waveView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
        }
        
        // 设置属性
        self.backgroundColor = UIColor.blue
        
//        self.titleLab.font = UIFont.italicSystemFont(ofSize: 17)
        self.titleLab.font = UIFont.qmui_systemFont(ofSize: 17, weight: .bold, italic: true)
        self.titleLab.text = "Welcome!"
        
        // 中文无法 italic 斜体
        self.subtitleLab.font = UIFont.qmui_systemFont(ofSize: 17, weight: .bold, italic: true)
        self.subtitleLab.textColor = UIColor.ac_mainColor
        self.subtitleLab.text = "小古猫"
        
        self.cycleScrollView.delegate = self
        self.cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        self.cycleScrollView.autoScrollTimeInterval = 4
//        self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
        
//        self.cycleScrollView.localizationImageNamesGroup = [
//            "debugImage",
//            "debugImage",
//            "debugImage",
//        ]
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didScrollTo index: Int) {
        self.waveView.pageControl.currentPage = index
    }
}


class AC_XQHomePageViewHeaderViewWaveView: UIView {
    
    let desView = UIView()
    let desTitleLab = UILabel()
    let desMessageLab = UILabel()
    
    let waveView = UIView()
    let pageControl = UIPageControl()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.desView, self.waveView, self.pageControl)
        self.desView.xq_addSubviews(self.desTitleLab, self.desMessageLab)
        
        // 布局
        self.desView.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalToSuperview().multipliedBy(333.0/375.0)
        }
        
        self.waveView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        self.desTitleLab.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.right.equalTo(-16)
        }
        
        self.desMessageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.desTitleLab.snp.bottom).offset(4)
            make.left.equalTo(self.desTitleLab)
        }
        
        // 设置属性
        
        self.desView.backgroundColor = UIColor.ac_mainColor.withAlphaComponent(0.75)
        
        self.waveView.backgroundColor = UIColor.white
        
        self.desTitleLab.font = UIFont.systemFont(ofSize: 16)
        self.desTitleLab.textColor = UIColor.white
        
        self.desMessageLab.alpha = 0.8
        self.desMessageLab.font = UIFont.systemFont(ofSize: 13)
        self.desMessageLab.textColor = UIColor.white
        
        self.desTitleLab.text = "新上架宠物，等你挑选"
        self.desMessageLab.text = "让它们学会等待"
        
        self.pageControl.numberOfPages = 3
        self.pageControl.pageIndicatorTintColor = UIColor.init(hex: "#D2D8DE")
        self.pageControl.currentPageIndicatorTintColor = UIColor.ac_mainColor
        self.pageControl.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.waveView.setSCornerMask(with: 50)
        self.desView.xq_corners_addRoundedCorners([.topRight], withRadii: CGSize.init(width: 20, height: 20))
    }
    
}

