//
//  XQAlertSelectAddressView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQAlertSelectAddressView: UIView, XQAlertSelectLevelViewDataSource, XQAlertSelectLevelViewDelegate {
    
    static func show(_ callback: XQAlertSelectAddressViewCallback?) {
        
        if let _ = _selectAddressView {
            return
        }
        
        _selectAddressView = XQAlertSelectAddressView()
        _selectAddressView?.addressAlertView.show()
        _selectAddressView?.callback = callback
    }
    
    static func hide() {
        if let selectAddressView = _selectAddressView {
            selectAddressView.addressAlertView.hide()
        }
        _selectAddressView = nil
    }
    
    private static var _selectAddressView: XQAlertSelectAddressView?
    
    private let addressAlertView = XQAlertSelectLevelView.init(frame: CGRect.zero, contentHeight: 400)
    private var addressDataArr = [XQAlertSelectAddressViewModel]()
    
    typealias XQAlertSelectAddressViewCallback = (_ provinceModel: XQAlertSelectAddressViewModel, _ cityModel: XQAlertSelectAddressViewModel, _ areaModel: XQAlertSelectAddressViewModel) -> ()
    private var callback: XQAlertSelectAddressViewCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addressAlertView.delegate = self
        self.addressAlertView.dataSource = self
        self.addressAlertView.selectSectionMax = 2
        self.addressAlertView.isUserInteractionEnabled = false
        DispatchQueue.init(label: "XQAlertSelectAddressView").async {
            // 获取数据
            if let path = Bundle.main.path(forResource: "pcas-code", ofType: "json") {
                let pathUrl = URL.init(fileURLWithPath: path)
                
                if let data = try? Data.init(contentsOf: pathUrl), let dicArr = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Array<Dictionary<String, Any>> {
                    
                    for item in dicArr {
                        let model = XQAlertSelectAddressViewModel.init()
                        model.setValuesForKeys(item)
                        
                        self.addressDataArr.append(model)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.addressAlertView.isUserInteractionEnabled = true
                self.addressAlertView.reloadCurrentSection()
            }
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var currentModelArr: [XQAlertSelectAddressViewModel]?
    
    func getCurrentDataArr(_ dataArr: Array<NSObject>, key: String) -> Array<NSObject>? {
        
        if self.addressAlertView.selectIndexArr.count == 0 {
            return dataArr
        }
        
        if self.addressAlertView.currentSection == 0 {
            return dataArr
        }
        
        var muDataArr = dataArr;
        for (section, row) in self.addressAlertView.selectIndexArr.enumerated() {
            
            if section == self.addressAlertView.currentSection {
                return muDataArr
            }
            
            if let arr = muDataArr[row].value(forKey: key) as? Array<NSObject> {
                muDataArr = arr
            }else {
                return nil
            }
        }
        
        return muDataArr
    }
    
    // MARK: - XQAlertSelectLevelViewDataSource
    
    /// 某个分区, 多少行
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, numberOfRowsInSection section: Int) -> Int {
        self.currentModelArr = self.getCurrentDataArr(self.addressDataArr, key: "children") as? Array<XQAlertSelectAddressViewModel>
        if let currentModelArr = self.currentModelArr {
            return currentModelArr.count
        }
        
        XQAlertSelectAddressView.hide()
        return 0
    }
    
    /// 某行标题
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, titleForRowAt indexPath: IndexPath) -> String {
        return self.currentModelArr?[indexPath.row].name ?? ""
    }
    
    
    // MARK: - XQAlertSelectLevelViewDelegate
    
    /// 点击取消或者点击背景
    func alertSelectLevelView(hide alertSelectLevelView: XQAlertSelectLevelView) {
        print(#function)
        XQAlertSelectAddressView._selectAddressView = nil
    }
    
    /// 点击选择了某个分区
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, didSelectSectionAt section: Int) {
        print(#function)
    }
    
    /// 点击选择了某一行
    func alertSelectLevelView(_ alertSelectLevelView: XQAlertSelectLevelView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
    
    /// 选到了最后一个
    func alertSelectLevelView(didEnd alertSelectLevelView: XQAlertSelectLevelView) {
        let model = self.addressDataArr[alertSelectLevelView.selectIndexArr[0]]
        let model1 = model.children?[alertSelectLevelView.selectIndexArr[1]]
        let model2 = model1?.children?[alertSelectLevelView.selectIndexArr[2]]
        
        if let model1 = model1, let model2 = model2 {
            self.callback?(model, model1, model2)
        }
    }
    
    deinit {
        print(self.classForCoder, #function)
    }

}


class XQAlertSelectAddressViewModel: NSObject {
    
//    "code": "1101",
//    "name": "市辖区",
//    "children": []
    
    @objc var code = ""
    
    @objc var name = ""
    
    @objc var children: [XQAlertSelectAddressViewModel]?
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if key == "children", let dataArr = value as? Array<Dictionary<String, Any>> {
            self.children = [XQAlertSelectAddressViewModel]()
            for item in dataArr {
                let model = XQAlertSelectAddressViewModel()
                model.setValuesForKeys(item)
                self.children?.append(model)
            }
            
            return
        }
        
        super.setValue(value, forKey: key)
        
    }
    
}






