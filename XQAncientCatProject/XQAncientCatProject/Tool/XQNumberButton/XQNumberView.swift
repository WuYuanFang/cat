//
//  XQNumberView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

protocol XQNumberViewDelegate: NSObjectProtocol {
    
    /// 加减代理回调
    /// - Parameters:
    ///   - number: 当前值
    ///   - increaseStatus: 是否为加状态
    func numberView(_ numberView: XQNumberView, number: Float, increaseStatus: Bool)
    
}

class XQNumberView: UIView, UITextFieldDelegate {
    
    typealias XQNumberViewCallback = (_ numberView: XQNumberView, _ number: Float, _ increaseStatus: Bool) -> ()
    var callback: XQNumberViewCallback?
    
    /// 输入框
    let tf = UITextField()
    
    /// 加按钮
    let increaseBtn = UIButton()
    
    /// 减按钮
    let decreaseBtn = UIButton()
    
    weak var delegate: XQNumberViewDelegate?
    
    /// 递增步长，默认步长为1
    var stepValue: Float = 1
    
    private var _minValue: Float = 0
    /// 最小值
    var minValue: Float {
        set {
            
            if newValue >= _maxValue {
                print("最小值不能大于等于最大值")
                return
            }
            
            _minValue = newValue
            
            if self.currentNumber < _minValue {
                self.currentNumber = _minValue
            }
            
        }
        get {
            return _minValue
        }
    }
    
    /// 最大值
    private var _maxValue: Float = Float(CGFloat.greatestFiniteMagnitude)
    var maxValue: Float {
        set {
            
            if newValue <= _minValue {
                print("最大值不能小于等于最小值")
                return
            }
            
            _maxValue = newValue
            
            if self.currentNumber > _maxValue {
                self.currentNumber = _maxValue
            }
            
        }
        get {
            return _maxValue
        }
    }
    
    private var _currentNumber: Float = 0
    /// 当前输入框的值
    var currentNumber: Float {
        set {
            
            if newValue < self.minValue {
                self.setTFText(with: self.minValue)
            }else if newValue > self.maxValue {
                self.setTFText(with: self.maxValue)
            }else {
                self.setTFText(with: newValue)
            }
            
        }
        get {
            return _currentNumber
        }
    }
    
    /// 输入框前缀
    var prefix = ""
    /// 输入框后缀
    var suffix = ""
    
    private var _btnSize: CGSize?
    /// 固定按钮大小, 默认是跟随视图的高度
    var btnSize: CGSize? {
        set {
            _btnSize = newValue
            
            if let btnSize = _btnSize {
                
                self.decreaseBtn.snp.remakeConstraints { (make) in
                    make.left.centerY.equalToSuperview()
                    make.size.equalTo(btnSize)
                }
                
                self.increaseBtn.snp.remakeConstraints { (make) in
                    make.right.centerY.equalToSuperview()
                    make.size.equalTo(btnSize)
                }
                
            }
            
        }
        get {
            return _btnSize
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tf)
        self.addSubview(self.increaseBtn)
        self.addSubview(self.decreaseBtn)
        
        
        // 布局
        
        self.decreaseBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.decreaseBtn.snp.height)
        }
        
        self.increaseBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(self.increaseBtn.snp.height)
        }
        
        self.tf.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.decreaseBtn.snp.right).offset(5)
            make.right.equalTo(self.increaseBtn.snp.left).offset(-5)
        }
        
        // 设置属性
        
        self.tf.delegate = self
        self.tf.isEnabled = false
        self.tf.font = UIFont.systemFont(ofSize: 15)
        self.tf.textAlignment = .center
        
        self.decreaseBtn.addTarget(self, action: #selector(respondsToDecrease(_:)), for: .touchUpInside)
        self.increaseBtn.addTarget(self, action: #selector(respondsToIncrease(_:)), for: .touchUpInside)
        
        self.decreaseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.increaseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.setTFText(with: self.minValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTFText(with value: Float) {
        
        let str = value.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", value) : String(value)
        _currentNumber = value
        self.tf.text = "\(self.prefix)\(str)\(self.suffix)"
    }
    
    // MARK: - responds
    
    @objc private func respondsToDecrease(_ sender: UIButton) {
        var cNumber = self.currentNumber
        cNumber -= self.stepValue
        self.currentNumber = cNumber
        
        self.delegate?.numberView(self, number: self.currentNumber, increaseStatus: false)
        self.callback?(self, self.currentNumber, false)
    }
    
    @objc private func respondsToIncrease(_ sender: UIButton) {
        var cNumber = self.currentNumber
        cNumber += self.stepValue
        self.currentNumber = cNumber
        
        self.delegate?.numberView(self, number: self.currentNumber, increaseStatus: true)
        self.callback?(self, self.currentNumber, true)
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
}
