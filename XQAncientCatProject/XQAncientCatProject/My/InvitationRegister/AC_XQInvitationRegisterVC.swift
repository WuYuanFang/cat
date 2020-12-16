//
//  AC_XQInvitationRegisterVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/5.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import TZImagePickerController

class AC_XQInvitationRegisterVC: XQACBaseVC {

    let contentView = AC_XQInvitationRegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let item = UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(respondsToPublish))
//        self.xq_navigationBar.addRightBtn(with: item)
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.copyBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            UIPasteboard.general.string = self.contentView.titleLab.text
            SVProgressHUD.showSuccess(withStatus: "已复制")
        }
        
        self.contentView.saveBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if let img = self.contentView.imgView.image {
                SVProgressHUD.show(withStatus: nil)
                TZImageManager.default()?.savePhoto(with: img, completion: { (asset, error) in
                    if let e = error {
                        SVProgressHUD.showError(withStatus: e.localizedDescription)
                    }else {
                        SVProgressHUD.showSuccess(withStatus: "已保存到相册")
                    }
                })
            }
            
        }
        
        self.getData()
        
        
    }
    
    func getData() {
        let reqModel = XQSMNTBaseReqModel()
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.getInviteQrCode(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            self.contentView.imgView.sd_setImage(with: resModel.QrCodeAddress.sm_getImgUrl())
            self.contentView.titleLab.text = resModel.InviteUrl
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    
    
    
}
