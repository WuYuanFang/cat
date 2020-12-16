//
//  AC_XQCommodityDetailViewContentViewSpecView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQCommodityDetailViewContentViewSpecViewDelegate: NSObjectProtocol {
    
    /// 选中了某个 model
    func commodityDetailViewContentViewSpecView(_ commodityDetailViewContentViewSpecView: AC_XQCommodityDetailViewContentViewSpecView, didSelectItemAt attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel)
    
}

class AC_XQCommodityDetailViewContentViewSpecView: UIView, AC_XQSelectColorViewDelegate, AC_XQSelectModelViewDelegate, AC_XQSelectSpecViewDelegate {
    
    weak var delegate: AC_XQCommodityDetailViewContentViewSpecViewDelegate?
    
    /// 数量
    let numberView = XQRowNumberView()
    
    private var attrList: [XQSMNTAttListModel]?
    
    private var specViewArr = [UIView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.numberView)
        
        // 布局
        
        self.reloadUI(with: [])
        
        // 设置属性
        
        self.numberView.titleLab.text = "数量选择"
        self.numberView.titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        self.numberView.numberView.increaseBtn.setTitle("+", for: .normal)
        self.numberView.numberView.increaseBtn.setTitleColor(UIColor.black, for: .normal)
        self.numberView.numberView.increaseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        self.numberView.numberView.minValue = 1
        
        self.numberView.numberView.decreaseBtn.setTitle("-", for: .normal)
        self.numberView.numberView.decreaseBtn.setTitleColor(UIColor.black, for: .normal)
        self.numberView.numberView.decreaseBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(with attrList: [XQSMNTAttListModel]) {
        
        for item in self.specViewArr {
            item.removeFromSuperview()
        }
        self.specViewArr.removeAll()
        
        if attrList.count == 0 {
            // 什么都没有
            self.numberView.snp.remakeConstraints { (make) in
                make.top.equalTo(30)
                make.right.equalTo(-16)
                make.left.equalTo(12)
                make.height.equalTo(35)
                make.bottom.equalToSuperview()
            }
            return
        }
        
        for (index, item) in attrList.enumerated() {
            
            var v: UIView?
            
            switch item.Name {
            case "颜色":
                
                let colorView = AC_XQSelectColorView()
                colorView.attListModel = item
                colorView.delegate = self
                v = colorView
                
                break
                
            case "重量", "尺寸", "型号":
                
                let modelView = AC_XQSelectModelView()
                modelView.attListModel = item
                modelView.delegate = self
                v = modelView
                
                break
                
            default:
                
                let specView = AC_XQSelectSpecView()
                specView.attListModel = item
                specView.delegate = self
                v = specView
                
                break
            }
            
            if let v = v {
                self.addSubview(v)
                self.specViewArr.append(v)
                
                if self.specViewArr.count == 1 {
                    v.snp.makeConstraints { (make) in
                        make.top.equalTo(30)
                        make.left.right.equalToSuperview()
                    }
                    
                }else {
                    
                    v.snp.makeConstraints { (make) in
                        make.top.equalTo(self.specViewArr[index - 1].snp.bottom).offset(30)
                        make.left.right.equalToSuperview()
                    }
                    
                }
                
            }
            
        }
        
        if let v = self.specViewArr.last {
            self.numberView.snp.remakeConstraints { (make) in
                make.top.equalTo(v.snp.bottom).offset(30)
                make.right.equalTo(-16)
                make.left.equalTo(12)
                make.height.equalTo(35)
                make.bottom.equalToSuperview()
            }
        }else {
            self.numberView.snp.remakeConstraints { (make) in
                make.top.equalTo(30)
                make.right.equalTo(-16)
                make.left.equalTo(12)
                make.height.equalTo(35)
                make.bottom.equalToSuperview()
            }
        }
           
    }
    
    /// 获取当前选中的属性
    func getSelectAttrs() -> [XQSMNTAttValueReqModel] {
        
        var modelArr = [XQSMNTAttValueReqModel]()
        
        
        
        for item in self.specViewArr {
            if let v = item as? AC_XQSelectModelView, let attListModel = v.attListModel, let model = attListModel.AttValues?[v.getCurrentSelectIndex()?.row ?? 0] {
                modelArr.append(XQSMNTAttValueReqModel.init(AttrId: attListModel.AttrId, AttrValueId: model.AttrValueId))
            }else if let v = item as? AC_XQSelectColorView, let attListModel = v.attListModel, let model = attListModel.AttValues?[v.getCurrentSelectIndex()?.row ?? 0] {
                modelArr.append(XQSMNTAttValueReqModel.init(AttrId: attListModel.AttrId, AttrValueId: model.AttrValueId))
            }else if let v = item as? AC_XQSelectSpecView, let attListModel = v.attListModel, let model = attListModel.AttValues?[v.getCurrentSelectIndex()?.row ?? 0] {
                modelArr.append(XQSMNTAttValueReqModel.init(AttrId: attListModel.AttrId, AttrValueId: model.AttrValueId))
            }
        }
        
        return modelArr
    }
    
    // MARK: - AC_XQSelectColorViewDelegate
    
    func selectColorView(_ selectColorView: AC_XQSelectColorView, didSelectItemAt indexPath: IndexPath, attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel) {
        self.delegate?.commodityDetailViewContentViewSpecView(self, didSelectItemAt: attListModel, attValueModel: attValueModel)
    }
    
    // MARK: - AC_XQSelectModelViewDelegate
    
    func selectModelView(_ selectModelView: AC_XQSelectModelView, didSelectItemAt indexPath: IndexPath, attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel) {
        self.delegate?.commodityDetailViewContentViewSpecView(self, didSelectItemAt: attListModel, attValueModel: attValueModel)
    }
    
    // MARK: - AC_XQSelectSpecViewDelegate
    
    func selectSpecView(_ selectSpecView: AC_XQSelectSpecView, didSelectItemAt indexPath: IndexPath, attListModel: XQSMNTAttListModel, attValueModel: XQSMNTAttValueModel) {
        self.delegate?.commodityDetailViewContentViewSpecView(self, didSelectItemAt: attListModel, attValueModel: attValueModel)
    }

}






