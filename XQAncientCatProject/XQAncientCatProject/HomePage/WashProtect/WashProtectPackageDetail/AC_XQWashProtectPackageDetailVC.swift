//
//  AC_XQWashProtectPackageDetailVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQAlert

class AC_XQWashProtectPackageDetailVC: XQACBaseVC {
    
    /// 套餐
    var packageModel: XQSMNTToShopPdPackageModel?
    
    /// 单项
    var model: XQSMNTToProductTinnyV2Model?

    let contentView = AC_XQWashProtectPackageDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        #if DEBUG
        self.xq_navigationBar.addRightBtns(with: UIBarButtonItem.init(title: "测试", style: .plain, target: self, action: #selector(respondsToTest)))
        #endif
        
        
        if let packageModel = self.packageModel {
            self.contentView.imgView.sd_setImage(with: self.packageModel?.DetailPhotoStr.sm_getImgUrl()) { [unowned self] (img, error, imageCacheType, url) in
                
                if let img = img {
                    self.reloadUI(img)
                }
                
            }
        }else if let model = self.model {
            self.contentView.imgView.sd_setImage(with: self.model?.DetailPhotoStr.sm_getImgUrl()) { [unowned self] (img, error, imageCacheType, url) in
                
                if let img = img {
                    self.reloadUI(img)
                }
                
            }
        }
        
        
    }
    
    private func reloadUI(_ img: UIImage) {
        let scale = img.size.height/img.size.width
        let height = UIScreen.main.bounds.width * scale
        self.contentView.imgView.snp.remakeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    // MARK: - responds
    @objc func respondsToTest() {
        
        XQSystemAlert.actionSheet(withTitle: nil, message: nil, contentArr: ["长图", "宽图"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            var urlStr = ""
            
            if index == 0 {
                urlStr = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1597406289856&di=7a5bbbce75d1ec28a9ab800bb7808a72&imgtype=0&src=http%3A%2F%2Fww2.sinaimg.cn%2Forj480%2F6825a5a6jw1f1hh035rktj20c827zwr3.jpg"
            }else {
                urlStr = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2757524834,2720270849&fm=26&gp=0.jpg"
            }
            
            self.contentView.imgView.sd_setImage(with: URL.init(string: urlStr)) { [unowned self] (img, error, cacheType, url) in
//                self.contentView.imgView.snp.remakeConstraints { (make) in
//                    make.edges.equalToSuperview()
//                }
            }
            
        }, cancelCallback: nil)
        
    }
    
}
