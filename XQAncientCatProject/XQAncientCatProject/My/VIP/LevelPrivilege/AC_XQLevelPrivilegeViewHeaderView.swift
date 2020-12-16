//
//  AC_XQLevelPrivilegeViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class AC_XQLevelPrivilegeViewHeaderView: UIView {
    
    private let scrollView = UIScrollView()
    private let lineView = UIView()
    
    private var columnViews = [AC_XQLevelPrivilegeViewHeaderViewColumnView]()
    
    private var selectIndex = 0
    private var userInfoModel: XQSMNTUserInfoModel?
    
    private var _resModel: XQSMNTGetRankInfoResModel?
    var resModel: XQSMNTGetRankInfoResModel? {
        set {
            _resModel = newValue
            
            for item in self.columnViews {
                item.removeFromSuperview()
            }
            self.columnViews.removeAll()
            
            let rankLss = self.resModel?.RankLss ?? []
            
            let minHeight: Float = 0
            let maxHeight: Float = 60
            
            for (index, item) in rankLss.enumerated() {
                
                let result = minHeight + ((maxHeight - minHeight) * Float(index)/Float(rankLss.count))
                
                let v = AC_XQLevelPrivilegeViewHeaderViewColumnView.init(frame: .zero, columnHeight: result, title: item.CreditsLower, bottomTitle: item.Title)
                v.imgView.isHidden = true
                self.columnViews.append(v)
                self.scrollView.addSubview(v)
            }
            
            self.userInfoModel = XQSMNTUserInfoModel.getUserInfoModel()
            
            // 获取当前自己的等级
            if let userInfoModel = self.userInfoModel {
                for (index, item) in rankLss.enumerated() {
                    if Int(item.CreditsLower) ?? 0 > userInfoModel.RankCredits {
                        self.selectIndex = index - 1
                        break
                    }
                }
            }
            
            if self.selectIndex < 0 {
                self.selectIndex = 0
            }else if self.selectIndex >= rankLss.count {
                self.selectIndex = rankLss.count - 1
            }
            
            
            self.reloadUI()
        }
        get {
            return _resModel
        }
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.lineView, self.scrollView)
        
        // 布局
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-25)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.ac_mainColor
        
        self.lineView.backgroundColor = UIColor.white
        
        self.reloadUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func reloadUI() {
        
        // 布局
        
        if self.columnViews.count != 0 {
            
//            self.columnViews[0].snp.makeConstraints { (make) in
//                make.left.equalToSuperview()
//            }
//
//            self.columnViews[self.columnViews.count - 1].snp.makeConstraints { (make) in
//                make.right.equalToSuperview()
//            }
            
            let dateArr = NSArray.init(array: self.columnViews)
            dateArr.mas_makeConstraints { (make) in
                make?.top.equalTo()(self)?.offset()(20)
                make?.bottom.equalTo()(self)?.offset()(-16)
                make?.width.mas_equalTo()(65)
            }
            dateArr.mas_distributeViews(along: .horizontal, withFixedSpacing: 0, leadSpacing: 25, tailSpacing: 25)
            
            
            self.columnViews[self.selectIndex].imgView.isHidden = false
            self.columnViews[self.selectIndex].imgView.sd_setImage(with: self.userInfoModel?.AvatarWithAddress.sm_getImgUrl())
        }
        
        
        
    }
    
}

/// 柱子view
class AC_XQLevelPrivilegeViewHeaderViewColumnView: UIView {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    let bottomTitleLab = XQPaddingLabel.init(frame: .zero, padding: UIEdgeInsets.init(top: 4, left: 8, bottom: -4, right: -8), rounded: false)
    
    let columnView = UIView()
    
    init(frame: CGRect, columnHeight: Float, title: String, bottomTitle: String) {
        super.init(frame: frame)
        
        self.addSubview(self.imgView)
        self.addSubview(self.bottomTitleLab)
        self.addSubview(self.columnView)
        self.addSubview(self.titleLab)
        
        // 布局
        self.bottomTitleLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.columnView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bottomTitleLab.snp.top).offset(-6)
            make.centerX.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(columnHeight)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.columnView.snp.top).offset(-6)
            make.centerX.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.titleLab.snp.top).offset(-12)
            make.centerX.equalToSuperview()
            make.size.equalTo(33)
        }
        
        // 设置属性
        
        self.titleLab.text = title
        self.titleLab.textColor = UIColor.white
        self.titleLab.font = UIFont.systemFont(ofSize: 13)
        
        self.bottomTitleLab.label.textColor = UIColor.init(hex: "#2C5659")
        self.bottomTitleLab.backgroundColor = UIColor.white
        self.bottomTitleLab.layer.cornerRadius = 4
        self.bottomTitleLab.label.text = bottomTitle
        self.bottomTitleLab.label.font = UIFont.systemFont(ofSize: 12)
        
        self.columnView.backgroundColor = UIColor.white
        
        self.imgView.layer.cornerRadius = 33.0/2.0
        self.imgView.layer.masksToBounds = true
//        self.imgView.backgroundColor = UIColor.clear
        
        if columnHeight == 0 {
            self.imgView.snp.remakeConstraints { (make) in
                make.bottom.equalTo(self.bottomTitleLab.snp.top).offset(-12)
                make.centerX.equalToSuperview()
                make.size.equalTo(33)
            }
            self.titleLab.isHidden = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.columnView.xq_corners_addRoundedCorners([.topLeft, .topRight], withRadii: CGSize.init(width: 2.5, height: 2.5))
        
    }
    
    
}


