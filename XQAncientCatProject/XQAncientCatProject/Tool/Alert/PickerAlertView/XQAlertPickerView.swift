//
//  XQAlertPickerView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQAlertPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private static var _alertPickerView: XQAlertPickerView?
    
    static func show(_ datas: [Array<String>]) {
        if let _ = _alertPickerView {
            return
        }
        
        _alertPickerView = self.init()
        _alertPickerView?.datas = datas
        _alertPickerView?.alertView.showWindow()
    }
    
    static func hide() {
        if let alertPickerView = _alertPickerView {
            alertPickerView.hide()
            _alertPickerView = nil
        }
    }
    
    let alertView = AC_XQBottomAlert.init(frame: UIScreen.main.bounds, contentHeight: 270)
    let cancelBtn = UIButton()
    let sureBtn = UIButton()
    let pickerView = UIPickerView()
    var datas = [Array<String>]()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        self.alertView.contentView.xq_addSubviews(self.sureBtn, self.cancelBtn, self.pickerView)
        
        
        // 布局
        
        self.sureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(16)
        }
        
        self.cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(self.sureBtn)
        }
        
        self.pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancelBtn.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.cancelBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.cancelBtn.setTitle("取消", for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(respondsToCancel), for: .touchUpInside)
        
        self.sureBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.sureBtn.setTitle("确定", for: .normal)
        self.sureBtn.addTarget(self, action: #selector(respondsToSure), for: .touchUpInside)
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.alertView.hideCallback = { [unowned self] in
            self.removeStaticAlertPickerView()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 隐藏
    func hide() {
        self.alertView.hide()
    }
    
    func show() {
        self.alertView.showWindow()
    }
    
    private func removeStaticAlertPickerView() {
        XQAlertPickerView._alertPickerView = nil
    }
    
    // MARK: - responds
    @objc func respondsToCancel() {
        self.alertView.hide()
    }
    
    @objc func respondsToSure() {
        self.alertView.hide()
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.datas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.datas[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.datas[component][row]
    }
    
    // MARK: - UIPickerViewDelegate
    
    

}
