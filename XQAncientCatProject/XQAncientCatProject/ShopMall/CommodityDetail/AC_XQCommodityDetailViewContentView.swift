//
//  AC_XQCommodityDetailViewContentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQCommodityDetailViewContentView: UIView {
    
    let detailBtn = AC_XQCommodityDetailViewContentViewBtn()
    let specBtn = AC_XQCommodityDetailViewContentViewBtn()
    
    private let contentView = UIView()
    
    /// 产品详情
    let detailView = XQAutoHeightWebView()
//    let paramView = AC_XQCommodityDetailViewContentViewParamView()
//    let detailView = AC_XQLiveBusinessDetailViewDetailView()
//    let showView = AC_XQLiveBusinessDetailViewShowView()
    
    /// 规格选择
    let specView = AC_XQCommodityDetailViewContentViewSpecView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.detailBtn, self.specBtn, self.contentView)
        
        // 布局
        self.detailBtn.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(44)
        }
        
        self.specBtn.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(self.detailBtn)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailBtn.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.showDetail()
        
        // 设置属性
        
        self.detailBtn.setTitle("产品详情", for: .normal)
        self.detailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.detailBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.detailBtn.setTitleColor(UIColor.ac_mainColor, for: .selected)
        
        self.specBtn.setTitle("规格选择", for: .normal)
        self.specBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.specBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.specBtn.setTitleColor(UIColor.ac_mainColor, for: .selected)
        
//        self.detailView.titleLab.text = "特色"
        
//        self.showView.titleLab.text = "展示"
        
        
        self.detailBtn.isSelected = true
        self.detailBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false == true {
                return
            }
            
            self.specBtn.isSelected.toggle()
            self.detailBtn.isSelected.toggle()
            
            self.showDetail()
        }
        
        self.specBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false == true {
                return
            }
            
            self.specBtn.isSelected.toggle()
            self.detailBtn.isSelected.toggle()
            
            
            self.showSpec()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func showDetail() {
//        self.contentView.xq_addSubviews(self.paramView, self.detailView, self.showView)
        self.contentView.xq_addSubviews(self.detailView)
        self.specView.removeFromSuperview()
        
//        self.paramView.snp.remakeConstraints { (make) in
//            make.top.equalToSuperview().offset(12)
//            make.left.right.equalToSuperview()
//        }
        
        self.detailView.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.paramView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            
            make.top.equalToSuperview().offset(12)
            make.bottom.equalTo(-12)
        }
        
//        self.showView.snp.remakeConstraints { (make) in
//            make.top.equalTo(self.detailView.snp.bottom).offset(12)
//            make.left.right.equalToSuperview()
//            make.bottom.equalTo(-12)
//        }
    }
    
    private func showSpec() {
        self.contentView.xq_addSubviews(self.specView)
        self.detailView.removeFromSuperview()
//        self.showView.removeFromSuperview()
//        self.paramView.removeFromSuperview()
        
        self.specView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
}


class AC_XQCommodityDetailViewContentViewBtn: UIButton {
    
    private var _xq_isSelected: Bool = false
    override var isSelected: Bool {
        set {
            super.isSelected = newValue
            
            _xq_isSelected = newValue
            if _xq_isSelected {
                self.lineView.backgroundColor = self.lineSelectedColor
            }else {
                self.lineView.backgroundColor = self.lineNormalColor
            }
        }
        get {
            return _xq_isSelected
        }
    }
    
    private var _lineHeight: CGFloat = 4
    /// 底部线条高度
    var lineHeight: CGFloat {
        set {
            _lineHeight = newValue
            
            self.lineView.snp.updateConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(self.lineHeight)
            }
            
        }
        get {
            return _lineHeight
        }
    }
    
    private var lineNormalColor: UIColor? = UIColor.init(hex: "#F4F4F4")
    private var lineSelectedColor: UIColor? = UIColor.init(hex: "#B5CACC")
    
    
    let lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.lineView)
        
        // 布局
        self.lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.lineHeight)
        }
        
        // 设置属性
        self.lineView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLineBackColor(_ color: UIColor?, for state: UIControl.State) {
        switch state {
        case .normal:
            self.lineNormalColor = color
            
        case .selected:
            self.lineSelectedColor = color
            
        default:
            break
        }
    }
    
}








