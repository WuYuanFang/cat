//
//  XQStartView.swift
//  XQShopMallProject
//
//  Created by WXQ on 2020/5/5.
//  Copyright © 2020 itchen.com. All rights reserved.
//

import UIKit
import Masonry

protocol XQStarViewDelegate: NSObjectProtocol {
    
    /// 选中星星
    func starView(_ starView: XQStarView, didSelectStarAt index: Int)
    
}

class XQStarView: UIView {
    
    private var starBtnArr = [UIButton]()
    
    /// star 数量
    var starCount = 0
    
    private var _starSelectIndex = 0
    /// 当前选中的 star
    var starSelectIndex: Int {
        set {
            _starSelectIndex = newValue
            self.selectStar(_starSelectIndex)
        }
        get {
            return _starSelectIndex
        }
    }
    
    weak var delegate: XQStarViewDelegate?
    
    /// 初始化视图
    /// - Parameters:
    ///   - starCount: 星星数量
    ///   - starSelectIndex: 当前选中的星星, 如传入超出范围值, 则代表目前不选中
    init(frame: CGRect, starCount: Int = 5, starSelectIndex: Int = -1) {
        super.init(frame: frame)
        
        self.starCount = starCount
        _starSelectIndex = starSelectIndex
        
        self.reloadUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadUI() {
        
        // 移除
        for item in self.starBtnArr {
            item.removeFromSuperview()
        }
        self.starBtnArr.removeAll()
        
        // 添加
        for item in 0..<self.starCount {
            let btn = UIButton()
            btn.tag = 1000 + item
            btn.addTarget(self, action: #selector(respondsToBtn(_:)), for: .touchUpInside)
            btn.setBackgroundImage(UIImage.init(named: "start_0"), for: .normal)
            btn.setBackgroundImage(UIImage.init(named: "start_1"), for: .selected)
            
            self.addSubview(btn)
            self.starBtnArr.append(btn)
        }
        
        // 布局
        if self.starBtnArr.count > 0 {
            let arr = NSArray.init(array: self.starBtnArr)
            arr.mas_distributeViews(along: .horizontal, withFixedSpacing: 10, leadSpacing: 0, tailSpacing: 0)
            
            arr.mas_makeConstraints { (make) in
                make?.top.bottom()?.equalTo()(self)
                make?.width.equalTo()(self.starBtnArr[0].mas_height)
            }
        }
        
        // 选择
        self.selectStar(self.starSelectIndex)
    }
    
    private func selectStar(_ cIndex: Int) {
        if cIndex < 0 || cIndex >= self.starBtnArr.count {
            // 超出范围, 全部没选中
            for item in self.starBtnArr {
                item.isSelected = false
            }
            return
        }
        
        for (index, item) in self.starBtnArr.enumerated() {
            if index <= cIndex {
                item.isSelected = true
            }else {
                item.isSelected = false
            }
        }
    }
    
    // MARK: - respodns
    
    @objc func respondsToBtn(_ sender: UIButton) {
        let cIndex = sender.tag - 1000
        self.starSelectIndex = cIndex
        self.selectStar(cIndex)
        self.delegate?.starView(self, didSelectStarAt: cIndex)
    }
    
}
