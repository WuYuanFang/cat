//
//  XQACTabBarContentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

struct XQACTabBarContentViewItem {
    
    /// 标题
    var title: String = ""
    
    /// 默认图片
    var normalImg: UIImage?
    
    /// 选中图片
    var selectImg: UIImage?
    
}

class XQACTabBarContentView: UIView {
    
    /// 底部栏显示的内容model
    var items = [XQACTabBarContentViewItem]()
    
    private var contentItemViews = [XQACTabBarContentItemView]()
    
    /// 当前选中的下标
    var selectIndex = 0
    
    typealias XQACTabBarContentViewCallback = (_ index: Int) -> ()
    /// 选中哪个
    var selectCallback: XQACTabBarContentViewCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 记录是否要更新布局
    private var xq_needLayout = false
    
    /// 左右间距
    private let spacing: CGFloat = 20
    
    /// item 高度
    private let itemViewHeight: CGFloat = 34
    
    /// 如果 items 数量改变, 要调用这个来刷新UI
    func refreshUI() {
        
        if self.selectIndex >= self.items.count {
            self.selectIndex = 0
        }
        
        // 移除原本的 view
        for item in self.contentItemViews {
            item.removeFromSuperview()
        }
        self.contentItemViews.removeAll()
        
        // 0 那么不需要走下面流程了
        if self.items.count == 0 {
            return
        }
        
        self.xq_needLayout = true
        
        // 添加新的 view
        for (index, item) in self.items.enumerated() {
            let itemView = XQACTabBarContentItemView()
            self.addSubview(itemView)
            
            let select = self.selectIndex == index
            itemView.select = select
            itemView.titleLab.text = item.title
            itemView.imgView.image = select ? item.selectImg : item.normalImg
            
            itemView.normalImg = item.normalImg
            itemView.selectImg = item.selectImg
            
            // 判断布局
            if index == 0 {
                itemView.snp.makeConstraints { (make) in
                    make.left.equalTo(self).offset(self.spacing)
                    make.top.equalTo(self).offset(9.5)
                    make.height.equalTo(itemViewHeight)
                }
                
            }else if index == (self.items.count - 1) {
                itemView.snp.makeConstraints { (make) in
                    make.right.equalTo(self).offset(-self.spacing)
                    make.top.equalTo(self).offset(9.5)
                    make.height.equalTo(itemViewHeight)
                }
                
            }else {
                
                itemView.snp.makeConstraints { (make) in
                    make.left.lessThanOrEqualTo(self.contentItemViews[index - 1].snp.right)
                    make.top.equalTo(self).offset(9.5)
                    make.height.equalTo(itemViewHeight)
                }
            }
            
            // 点击事件
            itemView.xq_addTap { [unowned self] (gesture) in
                self.selectBtn(index)
            }
            
            self.contentItemViews.append(itemView)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 计算相等空格
        if self.xq_needLayout {
            
            let width = self.frame.width
            var totalWidth: CGFloat = 0
            
            for contentItemView in self.contentItemViews {
                totalWidth += contentItemView.frame.width
            }
            
            let count = CGFloat(self.contentItemViews.count - 1)
            let spacingTotal = (width - (self.spacing * 2) - totalWidth)
            let eqSpacing = spacingTotal / count
//            print(width, totalWidth, spacingTotal, count, eqSpacing)
            self.xq_needLayout = false
            
            for (index, itemView) in self.contentItemViews.enumerated() {
                
                if index == 0 {
                    itemView.snp.updateConstraints { (make) in
                        make.left.equalTo(self).offset(self.spacing)
                        make.top.equalTo(self).offset(9.5)
                        make.height.equalTo(itemViewHeight)
                    }
                    
                }else if index == (self.items.count - 1) {
                    itemView.snp.updateConstraints { (make) in
                        make.right.equalTo(self).offset(-self.spacing)
                        make.top.equalTo(self).offset(9.5)
                        make.height.equalTo(itemViewHeight)
                    }
                    
                }else {
                    
                    itemView.snp.updateConstraints { (make) in
                        make.left.lessThanOrEqualTo(self.contentItemViews[index - 1].snp.right).offset(eqSpacing)
                        make.top.equalTo(self).offset(9.5)
                        make.height.equalTo(itemViewHeight)
                    }
                }
                
            }
        }
        
    }
    
    func selectBtn(_ index: Int) {
        if self.selectIndex == index {
            return
        }
        
        if index == 2 {
            SVProgressHUD.showInfo(withStatus: "即将上线,敬请期待!")
            return
        }
        
        self.xq_needLayout = true
        self.contentItemViews[self.selectIndex].select = false
        self.contentItemViews[index].select = true
        self.selectIndex = index
        self.selectCallback?(index)
    }
    
}

class XQACTabBarContentItemView: UIView {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    
    var normalImg: UIImage?
    var selectImg: UIImage?
    
    private var _select: Bool = false
    var select: Bool {
        set {
            _select = newValue
            self.xq_layout()
        }
        get {
            return _select
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imgView)
        self.addSubview(self.titleLab)
        
        // 布局
        self.xq_layout()
        
        // 设置属性
        
        self.titleLab.font = UIFont.systemFont(ofSize: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func xq_layout() {
        
        let spacing: CGFloat = 16
        let size = CGSize.init(width: 20, height: 20)
        
        self.imgView.image = self.select ? self.selectImg : self.normalImg
        
        if self.select {
            
            self.layer.cornerRadius = 17
            
            self.backgroundColor = UIColor.init(hex: "#EEEEEE")
            self.titleLab.isHidden = false
            
            self.imgView.snp.remakeConstraints { (make) in
                make.left.equalTo(self).offset(spacing)
                make.centerY.equalTo(self)
                make.size.equalTo(size)
            }
            
            self.titleLab.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self.imgView)
                make.left.equalTo(self.imgView.snp.right).offset(4)
                make.right.equalTo(self).offset(-20)
            }
            
        }else {
            
            self.layer.cornerRadius = 0
            
            self.backgroundColor = UIColor.clear
//            self.backgroundColor = UIColor.blue
            self.titleLab.isHidden = true
            self.titleLab.snp.remakeConstraints { (make) in
                
            }
            
            self.imgView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(self).offset(spacing)
                make.right.equalTo(self).offset(-spacing)
                make.size.equalTo(size)
            }
            
        }
    }
    
}
