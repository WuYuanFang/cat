//
//  AC_XQLaunchView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SDCycleScrollView
import SnapKit

class AC_XQLaunchView: UIView, SDCycleScrollViewDelegate {
    
    private static var launchView_: AC_XQLaunchView?
    
    static func show() {
        
        if let _ = launchView_ {
            return
        }
        
        launchView_ = AC_XQLaunchView()
//        launchView_?.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(launchView_!)
        launchView_?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
//        UIView.animate(withDuration: 0.25, animations: {
//            launchView_?.alpha = 1
//        }) { (result) in
//
//        }
        
    }
    
    typealias AC_XQLaunchViewCallback = () -> ()
    var hideCallback: AC_XQLaunchViewCallback?
    
    let cycleScrollView = SDCycleScrollView()
    
    let scrollView = UIScrollView()
    var imgViewArr = [UIImageView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.addSubview(self.cycleScrollView)
        self.addSubview(self.scrollView)
        
        let imgArr = [
            "launch_0",
            "launch_1",
            "launch_2",
            "launch_3",
        ]
        
        let maxCount = imgArr.count
        
        for (index, item) in imgArr.enumerated() {
            let imgView = UIImageView()
            
            imgView.contentMode = .scaleAspectFit
            imgView.image = UIImage.init(named: item)
            imgView.isUserInteractionEnabled = true
            imgView.xq_addTap { [unowned self] (gestrue) in
                if index >= maxCount - 1 {
                    if let hideCallback = self.hideCallback {
                        hideCallback()
                    }else {
                        self.hide()
                    }
                }else {
                    self.scrollView.setContentOffset(CGPoint.init(x: CGFloat((index + 1)) * self.scrollView.frame.width, y: 0), animated: true)
                }
            }
            
            self.imgViewArr.append(imgView)
            self.scrollView.addSubview(imgView)
            
            if index == 0 {
                imgView.snp.makeConstraints { (make) in
                    make.top.left.bottom.equalToSuperview()
                    make.width.equalToSuperview()
                }
            }else if index >= maxCount - 1 {
                imgView.snp.makeConstraints { (make) in
                    make.top.bottom.equalToSuperview()
                    make.width.equalToSuperview()
                    make.left.equalTo(self.imgViewArr[index - 1].snp.right)
                    make.right.equalToSuperview()
                }
            }else {
                imgView.snp.makeConstraints { (make) in
                    make.top.bottom.equalToSuperview()
                    make.width.equalToSuperview()
                    make.left.equalTo(self.imgViewArr[index - 1].snp.right)
                }
            }
            
        }
        
        // 布局
//        self.cycleScrollView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.top.bottom.left.height.equalToSuperview()
        }
        
        // 设置属性
//        self.cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
//        self.cycleScrollView.autoScroll = false
//        self.cycleScrollView.showPageControl = false
//
//        self.cycleScrollView.localizationImageNamesGroup = [
//            "launch_0",
//            "launch_1",
//            "launch_2",
//            "launch_3",
//        ]
//        self.cycleScrollView.delegate = self
//        self.cycleScrollView.backgroundColor = UIColor.clear
        
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SDCycleScrollViewDelegate
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print("wxq: ", index)
        if index != 3 {
            cycleScrollView.makeScroll(to: index + 1)
            return
        }
        
        if let hideCallback = self.hideCallback {
            hideCallback()
        }else {
            self.hide()
        }
        
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (result) in
            self.removeFromSuperview()
            AC_XQLaunchView.launchView_ = nil
        }
    }
    
    deinit {
        print(#function, self.classForCoder)
    }
    
}
