//
//  XQAlertSelectYMDPickerView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool

/// 选择年月日
class XQAlertSelectYMDPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    enum YMDPickerViewType {
        /// 年月日
        case ymd
        /// 月日
        case md
    }
    
    typealias XQAlertSelectYMDPickerViewCallback = (_ date: Date, _ year: Int, _ month: Int, _ day: Int) -> ()
    
    private static var _alertSelectYMDPickerView: XQAlertSelectYMDPickerView?
    
    static func show(_ vType: XQAlertSelectYMDPickerView.YMDPickerViewType = .ymd, sureCallback: XQAlertSelectYMDPickerViewCallback?) {
        if let _ = _alertSelectYMDPickerView {
            return
        }
        
        _alertSelectYMDPickerView = self.init()
        
        
        var datas = [Array<String>]()
        
        if vType == .ymd {
            // 获取当前年
            let year = self.getCurrentYear()
            
//            format.dateFormat = "yyyy-MM-dd HH:mm:ss";
            // 一直循环到当前年
            var yearArr = [String]()
            for item in 2000...year {
                yearArr.append("\(item)")
            }
            
            datas.append(yearArr)
            
        }
        
        var mArr = [String]()
        for item in 1...12 {
            mArr.append("\(item)")
        }
        datas.append(mArr)
        
        // 每个月不一定是 30 日, 所以里面还需要刷新
        var dArr = [String]()
        for item in 1...28 {
            dArr.append("\(item)")
        }
        datas.append(dArr)
        
        _alertSelectYMDPickerView?.datas = datas
        _alertSelectYMDPickerView?.vType = vType
        _alertSelectYMDPickerView?.show()
        _alertSelectYMDPickerView?.reloadTitleLabel()
        
        // 选中中间
        for (index, item) in datas.enumerated() {
            _alertSelectYMDPickerView?.pickerView.selectRow(item.count/2, inComponent: index, animated: false)
        }
        // 刷新天数
        _alertSelectYMDPickerView?.reloadDays()
        
        _alertSelectYMDPickerView?.sureCallback = sureCallback
    }
    
    static func hide() {
        if let alertSelectYMDPickerView = _alertSelectYMDPickerView {
            alertSelectYMDPickerView.hide()
            _alertSelectYMDPickerView = nil
        }
    }
    
    private var vType: XQAlertSelectYMDPickerView.YMDPickerViewType = .ymd
    
    private var labels = [UILabel]()
    private let stackView = UIStackView()
    
    private let alertView = AC_XQBottomAlert.init(frame: UIScreen.main.bounds, contentHeight: 336)
    private let cancelBtn = UIButton()
    private let sureBtn = UIButton()
    private let pickerView = UIPickerView()
    private var datas = [Array<String>]()
    
    private var sureCallback: XQAlertSelectYMDPickerViewCallback?
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        self.alertView.contentView.xq_addSubviews(self.sureBtn, self.cancelBtn, self.stackView, self.pickerView)
        
        
        // 布局
        
        self.cancelBtn.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(30)
        }
        
        self.sureBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.centerY.equalTo(self.cancelBtn)
        }
        
        let stackViewHeight: CGFloat = 40
        self.stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancelBtn.snp.bottom).offset(12)
            make.height.equalTo(stackViewHeight)
            make.left.right.equalToSuperview()
        }
        
        self.pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.stackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.cancelBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.cancelBtn.setTitle("取消", for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(respondsToCancel), for: .touchUpInside)
        self.cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.sureBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.sureBtn.setTitle("确定", for: .normal)
        self.sureBtn.addTarget(self, action: #selector(respondsToSure), for: .touchUpInside)
        self.sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.alertView.hideCallback = { [unowned self] in
            self.removeStaticAlertPickerView()
        }
        
        self.stackView.distribution = .fillEqually
        
        UIView.xq_setBorder(with: self.stackView, direction: .bottom, headSpacing: 0, lineWidth: UIScreen.main.bounds.width, borderColor: UIColor.init(hex: "#EEEEEE"), borderWidth: 1, y: stackViewHeight)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func reloadTitleLabel() {
        for item in self.labels {
            item.removeFromSuperview()
            self.stackView.removeArrangedSubview(item)
        }
        self.labels.removeAll()
        
        var arr = [String]()
        if self.vType == .ymd {
            arr = ["年", "月", "日"]
        }else {
            arr = ["月", "日"]
        }
        
        for item in arr {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15)
            label.text = item
            label.textAlignment = .center
            self.labels.append(label)
            self.stackView.addArrangedSubview(label)
        }
        
    }
    
    /// 隐藏
    private func hide() {
        self.alertView.hide()
    }
    
    private func show() {
        self.alertView.showWindow()
    }
    
    private func removeStaticAlertPickerView() {
        XQAlertSelectYMDPickerView._alertSelectYMDPickerView = nil
    }
    
    // MARK: - responds
    @objc func respondsToCancel() {
        self.alertView.hide()
    }
    
    @objc func respondsToSure() {
        
        if let date = self.getCurrentSelectDate() {
            let dateStr = date.xq_toStringYMD()
            let arr = dateStr.components(separatedBy: "-")
            
            self.sureCallback?(date, Int(arr[0]) ?? 0, Int(arr[1]) ?? 0, Int(arr[2]) ?? 0)
        }
        self.alertView.hide()
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.datas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.vType == .ymd, component == 1 {
            // 月刷新
            let yearRow = pickerView.selectedRow(inComponent: 0)
            if yearRow == self.datas[0].count - 1 {
                // 最后一个, 就是当前年
                return XQAlertSelectYMDPickerView.getCurrentMonth()
            }
        }
        
        return self.datas[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.datas[component][row]
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.vType == .ymd, component == 0 {
            pickerView.reloadComponent(1)
        }
        
        if (self.vType == .md && component == 0) ||
           (self.vType == .ymd && component <= 1) {
            self.reloadDays()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    /// 根据选中的年和月刷新天数
    private func reloadDays() {
        var mComponent = 1
        if self.vType == .md {
            mComponent = 0
        }else {
            mComponent = 1
        }
        
        let date = self.getCurrentSelectDate()
        
        if let date = date {
            self.datas.removeLast()
            
            var days = self.getMonthDays(date)
            
            let cDate = Date.init()
            let cYM = cDate.xq_toStringYM()
            if date.xq_toStringYM() == cYM {
                // 当前年, 当前月
                let ymd = cDate.xq_toStringYMD()
                let maxDay = Int(ymd.components(separatedBy: "-")[2]) ?? 1
                days = maxDay
            }
            
            var dayArr = [String]()
            for item in 1...days {
                dayArr.append("\(item)")
            }
            self.datas.append(dayArr)
            
            self.pickerView.reloadComponent(mComponent + 1)
        }
    }
    
    /// 获取当前选中的时间
    private func getCurrentSelectDate() -> Date? {
        var mComponent = 1
        
        var date: Date?
        let dFormat = DateFormatter.init()
        dFormat.dateFormat = "yyyy-MM-dd"
        
        var year: Int = 2020
        
        if self.vType == .md {
            mComponent = 0
            year = XQAlertSelectYMDPickerView.getCurrentYear()
        }else {
            mComponent = 1
            let yearRow = pickerView.selectedRow(inComponent: 0)
            year = Int(self.datas[0][yearRow]) ?? 2020
        }
        
        let row = self.pickerView.selectedRow(inComponent: mComponent)
        
        let month = self.datas[mComponent][row]
        let day = self.datas[mComponent + 1][self.pickerView.selectedRow(inComponent: mComponent + 1)]
        
        date = dFormat.date(from: "\(year)-\(month)-\(day)")
        
        if date == nil {
            /// 当出现日历没有这个日期时, 会转化失败
            /// 比如 2020-02-31, 这个字符串，就会转化失败. 所以这里再判断一下
            dFormat.dateFormat = "yyyy-MM"
            date = dFormat.date(from: "\(year)-\(month)")
        }
        
        return date
    }
    
    /// 根据日期, 获取当前月，有多少天
    private func getMonthDays(_ date: Date) -> Int {
        
//        if let date = date.xq_toStringYM().xq_toDateYM() {
//            // 带天的, 获取不了, 这里转一下
//            let calendar = Calendar.current
//            let range = calendar.range(of: .day, in: .month, for: date)
//            return range?.max() ?? 0
//        }
        
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)
        return range?.max() ?? 0
    }
    
    /// 获取当前年
    private static func getCurrentYear() -> Int {
        let date = Date.init()
        let dFormat = DateFormatter.init()
        dFormat.dateFormat = "yyyy"
        let year = Int(dFormat.string(from: date)) ?? 2030
        return year
    }
    
    /// 获取当前月
    private static func getCurrentMonth() -> Int {
        let date = Date.init()
        let dFormat = DateFormatter.init()
        dFormat.dateFormat = "MM"
        let year = Int(dFormat.string(from: date)) ?? 1
        return year
    }
    
}
