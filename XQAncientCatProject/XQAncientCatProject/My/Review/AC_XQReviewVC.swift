//
//  AC_XQReviewVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import TZImagePickerController
import SVProgressHUD

class AC_XQReviewVC: XQACBaseVC, XQSelectPhotosViewDelegate, AC_XQImagePickerControllerProtocol, TZImagePickerControllerDelegate {
    
    /// 外部传入的列表订单model
    var orderBaseInfoModel: XQSMNTOrderBaseInfoDtoModel?
    
    typealias AC_XQReviewVCCallback = () -> ()
    var refreshCallback: AC_XQReviewVCCallback?
    
    let contentView = AC_XQReviewView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(respondsToPublish))
        self.xq_navigationBar.addRightBtn(with: item)
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.upImgView.delegate = self
    }
    
    @objc
    func respondsToPublish() {
        
        guard let orderBaseInfoModel = self.orderBaseInfoModel else {
            return
        }
        
        let star = self.contentView.starView.starSelectIndex + 1
        
        let reqModel = XQSMNTOrderAddReviewReqModel.init(OId: orderBaseInfoModel.Oid,
                                                         Star: star,
                                                         Message: self.contentView.tv.text ?? "",
                                                         NoShowName: self.contentView.anonymousView.xq_switch.isOn ? 1 : 0,
                                                         xq_Imgs: self.contentView.upImgView.imgArr)
        SVProgressHUD.show(withStatus: nil)
        XQSMOrderNetwork.addReview(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.isProgress {
                let pro = Float(resModel.progress?.completedUnitCount ?? 0) / Float(resModel.progress?.totalUnitCount ?? 0)
                SVProgressHUD.showProgress(pro, status: "正在上传图片")
                return
            }
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "发布成功")
            self.refreshCallback?()
            self.navigationController?.popViewController(animated: true)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - AC_XQImagePickerControllerProtocol
    func xq_pickerImg(_ img: UIImage) {
        self.contentView.upImgView.addImage(img)
    }
    
    // MARK: - TZImagePickerControllerDelegate
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if let img = photos.first {
            self.contentView.upImgView.addImage(img)
        }
    }
    
    // MARK: - XQSelectPhotosViewDelegate
    
    /// 要选择图片
    func selectPhotosView(addImage selectPhotosView: XQSelectPhotosView) {
        self.xq_showPickerImageAlert(false, circleCropRadius: 0)
    }
    
    /// 点击了某个图片
    func selectPhotosView(_ selectPhotosView: XQSelectPhotosView, selectImg image: UIImage) {
        
    }
    
    /// 点击删除某个图片
    func selectPhotosView(_ selectPhotosView: XQSelectPhotosView, delete index: Int, image: UIImage) {
        
    }
    
}
