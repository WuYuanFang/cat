//
//  AC_XQMoneyView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 一个字大, 一个字小的view
class AC_XQMoneyView: UIView {
    
    enum SymbolDirection {
        case left
        case right
    }
    
    /// 钱
    let moneyLab = UILabel()
    /// 符号
    let symbolLab = UILabel()
    
    private var _symbolToMoneySpacing: CGFloat = 5
    /// 符号和钱的间距
    var symbolToMoneySpacing: CGFloat {
        set {
            _symbolToMoneySpacing = newValue
            self.reloadUI()
        }
        get {
            return _symbolToMoneySpacing
        }
    }
    
    private var _direction: SymbolDirection = .left
    /// 符号所在的方向
    var direction: SymbolDirection {
        set {
            _direction = newValue
            self.reloadUI()
        }
        get {
            return _direction
        }
    }
    
    init(frame: CGRect = .zero,
         direction: SymbolDirection = .left,
         symbolToMoneySpacing: CGFloat = 5) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.moneyLab, self.symbolLab)
        
        // 布局
        self.direction = direction
        self.symbolToMoneySpacing = symbolToMoneySpacing
        // 抗拉伸, 调到最高, 就是拒绝被外部拉扯变形
        self.moneyLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.symbolLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        // 抗压缩, 调到最高, 就是拒绝被外部压缩变形
        self.moneyLab.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.required.rawValue
        self.symbolLab.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.required.rawValue
        
        // 设置属性
        self.moneyLab.font = UIFont.boldSystemFont(ofSize: 34)
        self.setSymbolFont(UIFont.systemFont(ofSize: 12))
        
        self.symbolLab.text = "¥"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 赋值符号. 这个会自动让底部对齐
    func setSymbolFont(_ font: UIFont) {
        
//        let bsaelineOffset = (self.moneyLab.font.lineHeight - self.symbolLab.font.lineHeight)/2 + (self.moneyLab.font.descender -  self.symbolLab.font.descender)
//
//        let attributesSymbol = [
//            NSAttributedString.Key.font: self.symbolLab.font ?? UIFont.systemFont(ofSize: 12),
//            NSAttributedString.Key.baselineOffset: bsaelineOffset,
//            ] as [NSAttributedString.Key : Any]
//
//        self.symbolLab.attributedText = NSMutableAttributedString.init(string: text, attributes: attributesSymbol)
        
        self.symbolLab.font = font
        self.symbolLab.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(self.moneyLab.font.descender - self.symbolLab.font.descender)
        }
        
    }
    
    private func reloadUI() {
        if self.direction == .left {
            self.moneyLab.snp.remakeConstraints { (make) in
                make.left.equalTo(self.symbolLab.snp.right).offset(self.symbolToMoneySpacing)
                make.right.equalToSuperview()
                make.top.bottom.equalToSuperview()
            }
            
            self.symbolLab.snp.remakeConstraints { (make) in
                make.left.equalToSuperview()
                make.bottom.equalToSuperview().offset(self.moneyLab.font.descender - self.symbolLab.font.descender)
            }
        }else {
            self.moneyLab.snp.remakeConstraints { (make) in
                make.left.equalToSuperview()
                make.top.bottom.equalToSuperview()
            }
            
            self.symbolLab.snp.remakeConstraints { (make) in
                make.left.equalTo(self.moneyLab.snp.right).offset(self.symbolToMoneySpacing)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview().offset(self.moneyLab.font.descender - self.symbolLab.font.descender)
            }
        }
    }
    
}


