//
//  XQACNavigationBar.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import XQProjectTool_iPhoneUI

class XQACNavigationBar: UIView {
    
    /// 状态栏
    let statusView = UIView()
    /// 内容view
    let contentView = UIView()
    
    /// 默认返回的view
    let backView = XQACNavigationBarBackView.init()
    
    /// 中间标题
    let titleLab = UILabel()
    
    /// 右边按钮
    var rightBtns = [UIButton]()
    
    typealias XQACNavigationBarCallback = () -> ()
    var backCallback: XQACNavigationBarCallback?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.statusView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.backView)
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        
        self.statusView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            // 按设计图来说，要比系统的高一点才行, 所以这里放的更高, 让内容 view 往下移
            make.height.equalTo(XQIOSDevice.getStatusHeight() + 12)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.statusView.snp.bottom)
            make.left.right.equalTo(self)
            make.height.equalTo(44)
            make.bottom.equalTo(self)
        }
        
        self.backView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.top.bottom.equalTo(self.contentView)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        
        // 设置属性
        
//        self.backgroundColor = UIColor.white
        
        self.statusView.backgroundColor = UIColor.white
        
        self.titleLab.textColor = UIColor.black
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 20)
        
        weak var weakSelf = self
        self.backView.xq_addTap { (gesture) in
            weakSelf?.backCallback?()
        }
        
    }
    
    /// 设置左边返回标题
    /// - Parameter title: 标题
    func setTitle(_ title: String) {
        self.backView.setTitle(with: title)
    }
    
    /// 设置中间标题
    /// - Parameter title: 标题
    func setCenterTitle(_ title: String) {
//        self.backView.setTitle(with: title)
        self.titleLab.text = title
    }
    
    /// 显示返回箭头img
    func showBackImg() {
        self.backView.setBackImg(with: UIImage.init(named: "back_arrow"))
    }
    
    /// 添加右边按钮
    /// - Parameter item: 按钮描述
    func addRightBtn(with item: UIBarButtonItem) {
        self.removeAllRightBtn()
        self.createRightBtn(with: item)
    }
    
    /// 添加右边按钮
    /// - Parameter items: 按钮描述
    func addRightBtns(with items: UIBarButtonItem...) {
        self.removeAllRightBtn()
        items.forEach(createRightBtn(with:))
    }
    
    private func removeAllRightBtn() {
        // 移除原本的右边按钮
        for item in self.rightBtns {
            item.removeFromSuperview()
        }
        self.rightBtns.removeAll()
    }
    
    private func createRightBtn(with item: UIBarButtonItem) {
        let btn = UIButton()
        self.rightBtns.append(btn)
        self.contentView.addSubview(btn)
        
        // 布局
        if self.rightBtns.count == 1 {
            // 第一个
            btn.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-14.5)
                
                make.top.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().offset(-12)
                if let _ = item.image {
                    make.width.equalTo(btn.snp.height)
                }
            }
        }else {
            btn.snp.remakeConstraints { (make) in
                make.right.equalTo(self.rightBtns[self.rightBtns.count - 2].snp.left).offset(-30)
                
                make.top.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().offset(-12)
                if let _ = item.image {
                    make.width.equalTo(btn.snp.height)
                }
            }
        }
        
        
        // 设置属性
        
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        btn.setTitleColor(UIColor.init(hex: "#282626"), for: .normal)
        
        if let action = item.action {
            btn.addTarget(item.target, action: action, for: .touchUpInside)
        }
        
        if let title = item.title {
            btn.setTitle(title, for: .normal)
        }else if let img = item.image {
//            btn.setImage(img, for: .normal)
            btn.setBackgroundImage(img, for: .normal)
        }else {
            // 都没有
            btn.removeFromSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
