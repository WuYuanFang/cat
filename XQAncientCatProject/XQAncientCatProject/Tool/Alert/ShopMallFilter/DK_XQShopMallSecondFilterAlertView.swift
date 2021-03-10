//
//  DK_XQShopMallSecondFilterAlertView.swift
//  XQAncientCatProject
//
//  Created by wuyuanfang on 2021/3/10.
//  Copyright © 2021 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

class DK_XQShopMallSecondFilterAlertView: UIView {
    
    typealias SelectSecondMenuBlock = (_ model:XQSMNTAroundShopTopMenuModel) -> Void
    
    var selectMenuBlock:SelectSecondMenuBlock?
    var tagView: TTGTextTagCollectionView!
    
    var menuArr:[XQSMNTAroundShopTopMenuModel] = []
    var selModel:XQSMNTAroundShopTopMenuModel?
    
    private static var _menuView: DK_XQShopMallSecondFilterAlertView?
    
    static func showMenu(bgView:UIView, menus:[XQSMNTAroundShopTopMenuModel] = [], selM:XQSMNTAroundShopTopMenuModel?,  callback:SelectSecondMenuBlock?) {
        
        if let _ = _menuView {
            return
        }
        _menuView = DK_XQShopMallSecondFilterAlertView()
        
        _menuView?.selectMenuBlock = callback
        _menuView?.menuArr = menus
        _menuView?.selModel = selM
        _menuView?.setupTagData()
        bgView.addSubview(_menuView!)
        _menuView!.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(CGFloat(20 + 35 + 16 + 12) + XQIOSDevice.getStatusHeight() + 16)
        }
    }
    
    static func hide() {
        if let menuView = _menuView {
            menuView.removeFromSuperview()
        }
        _menuView = nil
    }
    
    deinit {
        print(#function, self.classForCoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.qmui_color(withHexString: "222222")?.withAlphaComponent(0.5)
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.clipsToBounds = true
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.greaterThanOrEqualTo(120)
        }
        
        // 初始化标签
        tagView = TTGTextTagCollectionView.init()
        tagView.selectionLimit = 1
        tagView.delegate = self
        tagView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        bgView.addSubview(tagView)
        tagView.snp.makeConstraints { (make) in
            make.top.left.equalTo(8)
            make.width.equalTo(SCREEN_WIDTH-16)
            make.height.greaterThanOrEqualTo(60)
        }
        setupTagConfig(tagView)
        
        let line = UIView()
        line.backgroundColor = UIColor.qmui_color(withHexString: "eeeeee")
        bgView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(tagView.snp.bottom).offset(8)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.ac_mainColor, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        bgView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(12)
            make.height.equalTo(44)
            make.width.equalTo(54)
            make.top.equalTo(line.snp.bottom)
        }
        let okBtn = UIButton()
        okBtn.setTitle("确定", for: .normal)
        okBtn.setTitleColor(.ac_mainColor, for: .normal)
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        okBtn.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        bgView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.top.height.width.equalTo(cancelBtn)
        }
        
    }
    
    // 初始化标签的数据
    func setupTagData() {
        tagView.removeAllTags()
        var strArr:[String] = []
        for dic in menuArr {
            strArr.append(dic.Name)
        }
        tagView.addTags(strArr)
        // 判断是否需要选中
        if let selM = selModel {
            if menuArr.count > 0 && menuArr[0].ParentId == selM.ParentId {
                for idx in 0..<menuArr.count {
                    if selModel?.CateId == menuArr[idx].CateId {
                        tagView.setTagAt(UInt(idx), selected: true)
                        break
                    }
                }
            }
        }else{
            tagView.setTagAt(0, selected: true)
        }
        tagView.reload()
    }
    
    @objc func cancelAction() {
        DK_XQShopMallSecondFilterAlertView.hide()
    }
    
    @objc func okAction() {
        if let selBlock = selectMenuBlock {
            selBlock(menuArr[0])
        }
        DK_XQShopMallSecondFilterAlertView.hide()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // tagconfig的配置初始化
    func setupTagConfig(_ tagView: TTGTextTagCollectionView){
        let config: TTGTextTagConfig = tagView.defaultConfig
        config.backgroundColor = .white
        config.selectedBackgroundColor = .ac_mainColor
        config.minWidth = 56
        config.textColor = UIColor.qmui_color(withHexString: "999999")
        config.selectedTextColor = .white
        config.cornerRadius = 12.0
        config.exactHeight = 24
        config.textFont = UIFont.systemFont(ofSize: 14)
        config.shadowColor = .white
    }
}

extension DK_XQShopMallSecondFilterAlertView : TTGTextTagCollectionViewDelegate {
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        if let selBlock = selectMenuBlock {
            selBlock(menuArr[Int(index)])
        }
        DK_XQShopMallSecondFilterAlertView.hide()
    }
    
}
