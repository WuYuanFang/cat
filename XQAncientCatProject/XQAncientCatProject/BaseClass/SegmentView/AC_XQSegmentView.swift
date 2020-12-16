//
//  AC_XQSegmentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

protocol AC_XQSegmentViewDelegate: NSObjectProtocol {
    func segmentView(_ segmentView: AC_XQSegmentView, didSelectAtIndex index: Int)
}

class AC_XQSegmentView: UIView {
    
    let contentView = UIView()
    private var paddingViewArr = [XQPaddingLabel]()
    
    weak var delegate: AC_XQSegmentViewDelegate?
    
    init(frame: CGRect = CGRect.zero, titleArr: [String]) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        
        // 布局
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let spacing: CGFloat = 0
        
        if titleArr.count == 1 {
            let paddingView = XQPaddingLabel.init(frame: CGRect.zero, padding: UIEdgeInsets.init(top: 5, left: 12, bottom: -5, right: -12), rounded: true)
            self.configPaddingView(paddingView)
            self.contentView.addSubview(paddingView)
            self.paddingViewArr.append(paddingView)
            
            paddingView.label.text = titleArr.first
            
            paddingView.snp.makeConstraints { (make) in
                make.top.equalTo(4)
                make.bottom.equalTo(-4)
                make.left.equalTo(8)
                make.right.equalTo(-8)
                make.width.greaterThanOrEqualTo(70)
            }
            
            return
        }
        
        weak var weakSelf = self
        
        for (index, item) in titleArr.enumerated() {
            let paddingView = XQPaddingLabel.init(frame: CGRect.zero, padding: UIEdgeInsets.init(top: 5, left: 12, bottom: -5, right: -12), rounded: true)
            self.configPaddingView(paddingView)
            self.contentView.addSubview(paddingView)
            self.paddingViewArr.append(paddingView)
            
            paddingView.label.text = item
            
            paddingView.xq_addTap { (gestrue) in
                if let pdView = gestrue?.view as? XQPaddingLabel {
                    weakSelf?.tapPaddingView(pdView)
                }
            }
            
            if index == 0 {
                self.configPaddingView(paddingView, status: 1)
                paddingView.snp.makeConstraints { (make) in
                    make.top.equalTo(4)
                    make.bottom.equalTo(-4)
                    make.width.greaterThanOrEqualTo(70)
                    make.left.equalTo(8)
                }
                continue
            }
            
            let lastView = self.paddingViewArr[index - 1]
            
            if index == (titleArr.count - 1) {
                
                paddingView.snp.makeConstraints { (make) in
                    make.top.equalTo(lastView)
                    make.bottom.equalTo(lastView)
                    make.left.equalTo(lastView.snp.right).offset(spacing)
                    make.width.greaterThanOrEqualTo(70)
                    make.right.equalTo(-8)
                }
                
            }else {
                
                paddingView.snp.makeConstraints { (make) in
                    make.top.equalTo(lastView)
                    make.bottom.equalTo(lastView)
                    make.left.equalTo(lastView.snp.right).offset(spacing)
                    make.width.greaterThanOrEqualTo(70)
                }
                
            }
            
            
        }
        
        // 设置属性
        self.contentView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.cornerRadius = self.contentView.frame.height/2
        
    }
    
    private func configPaddingView(_ paddingView: XQPaddingLabel, status: Int = 0) {
        
        paddingView.label.font = UIFont.systemFont(ofSize: 15)
        paddingView.label.textAlignment = .center
        
        if status == 0 {
            paddingView.backgroundColor = UIColor.clear
            paddingView.label.textColor = UIColor.ac_mainColor
        }else {
            paddingView.backgroundColor = UIColor.ac_mainColor
            paddingView.label.textColor = UIColor.white
        }
        
    }
    
    func tapPaddingView(_ paddingView: XQPaddingLabel) {
        
        guard let index = self.paddingViewArr.firstIndex(of: paddingView) else {
            print("没有找到 pddingView")
            return
        }
        
        for item in self.paddingViewArr {
            self.configPaddingView(item)
        }
        
        self.configPaddingView(paddingView, status: 1)
        
        self.delegate?.segmentView(self, didSelectAtIndex: index)
    }
    
}




