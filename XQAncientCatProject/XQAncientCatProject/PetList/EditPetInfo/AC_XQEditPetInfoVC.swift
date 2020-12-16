//
//  AC_XQEditPetInfoVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import TZImagePickerController

class AC_XQEditPetInfoVC: XQACBaseVC, AC_XQImagePickerControllerProtocol, TZImagePickerControllerDelegate {
    
    let contentView = AC_XQEditPetInfoView()
    
    /// 列表传进来，原来的 model
    var oModel: XQSMNTGetMyPetListUserPetInfoModel?
    
    /// 封面图
    var xq_PhotoImg: UIImage?
    /// 鼻头照
    var xq_NosePhotoImg: UIImage?
    /// 全身照
    var xq_AllBodyPhotoImg: UIImage?
    
    typealias AC_XQEditPetInfoVCCallback = () -> ()
    var refreshCallback: AC_XQEditPetInfoVCCallback?
    
    var petType: XQSMNTPetGetAllPetVarietiesReqModel.PetType = .cat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.birthdayView.xq_addTap { [unowned self] (gesture) in
            // 选择生日
            XQAlertSelectYMDPickerView.show { (date, year, month, day) in
                print(date, year, month, day)
                self.contentView.birthdayView.tf.text = date.xq_toString("yyyy年MM月dd日")
            }
        }
        
        self.contentView.varietiesView.xq_addTap { [unowned self] (gesture) in
            // 选择品种
            let vc = AC_XQSelectVarietiesVC()
            vc.callback = { [unowned self] (sModel, model) in
                self.contentView.varietiesView.tf.text = model.title
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.contentView.saveBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.save()
        }
        
        self.contentView.imgView.isUserInteractionEnabled = true
        self.contentView.imgView.xq_addTap { [unowned self] (gesture) in
            self.selectPhotoImg()
        }
        
        self.contentView.fullBodyView.xq_addTap { [unowned self] (gesture) in
            self.selectFullBodyImg()
        }
        
        self.contentView.noseView.xq_addTap { [unowned self] (gesture) in
            self.selectNoseImg()
        }
        
        
        
        
//        #if DEBUG
//        self.contentView.varietiesView.tf.text = "埃及猫"
//        #endif
        
        if let model = self.oModel {
            
            self.contentView.imgView.imgView.sd_setImage(with: self.oModel?.PhotoWithAddress.sm_getImgUrl())
            
            self.contentView.nameView.tf.text = model.NickName
            
            self.contentView.varietiesView.tf.text = model.PetVarieties
            
            self.contentView.weightView.tf.text = "\(model.Weight)"
            
            self.contentView.genderView.setSelectLeft(model.Sex == "公")
            
            self.contentView.sterilizationView.setSelectLeft(model.IsNoSex)
            
            self.contentView.birthdayView.tf.text = model.BirthDate.xq_toDateYMD()?.xq_toString("yyyy年MM月dd日")
            
            self.contentView.fullBodyView.imgView.sd_setImage(with: self.oModel?.AllBodyPhotoWithAddress.sm_getImgUrl())
            self.contentView.noseView.imgView.sd_setImage(with: self.oModel?.NosePhotoWithAddress.sm_getImgUrl())
        }
        
    }
    
    /// 当前选择图片类型
    /// 0 封面
    /// 1 全身照
    /// 2 鼻照
    var currentSelectImgType = 0
    
    /// 选择封面照片
    func selectPhotoImg() {
        self.currentSelectImgType = 0
        self.xq_showPickerImageAlert()
    }
    
    /// 选择全身照
    func selectFullBodyImg() {
        self.currentSelectImgType = 1
        self.xq_showPickerImageAlert(false, circleCropRadius: 0)
    }
    
    /// 选择鼻照
    func selectNoseImg() {
        self.currentSelectImgType = 2
        self.xq_showPickerImageAlert(false, circleCropRadius: 0)
    }
    
    
    /// 保存
    private func save() {
        
        var petId = 0
        
        var Photo = ""
        var NosePhoto = ""
        var AllBodyPhoto = ""
        
        if let model = self.oModel {
            petId = model.Id
            
            // 没选择图片, 则传回原来的地址
            if self.xq_PhotoImg == nil {
                Photo = model.Photo
                print("没修改封面")
            }
            
            if self.xq_NosePhotoImg == nil {
                NosePhoto = model.NosePhoto
                print("没修改鼻头照")
            }
            
            if self.xq_AllBodyPhotoImg == nil {
                AllBodyPhoto = model.AllBodyPhoto
                print("没修改全身照")
            }
            
        }else {
            // 必须要选择图片
            
            if self.xq_PhotoImg == nil {
                SVProgressHUD.showInfo(withStatus: "请选择封面照")
                return
            }
            
            if self.xq_AllBodyPhotoImg == nil {
                SVProgressHUD.showInfo(withStatus: "请选择全身照")
                return
            }
            
            if self.xq_NosePhotoImg == nil {
                SVProgressHUD.showInfo(withStatus: "请选择鼻头照")
                return
            }
            
        }
        
        if self.contentView.nameView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请填写宠物昵称")
            return
        }
        
        if self.contentView.varietiesView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择宠物品种")
            return
        }
        
        if self.contentView.weightView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请填写宠物体重")
            return
        }
        
        if self.contentView.birthdayView.tf.text?.count ?? 0 == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择宠物生日")
            return
        }
        
        let isNoSex = self.contentView.sterilizationView.leftBtn.isSelected
        
        let gender = self.contentView.genderView.leftBtn.isSelected ? "公" : "母"
        
        let weight = Float(self.contentView.weightView.tf.text ?? "0") ?? 0
        
        let date = self.contentView.birthdayView.tf.text?.xq_toDate("yyyy年MM月dd日")
        let dateStr = date?.xq_toStringYMD()
        
        let reqModel = XQSMNTPetAddOrEditPetModelReqModel.init(Id: petId,
                                                               NickName: self.contentView.nameView.tf.text ?? "",
                                                               PetType: self.petType,
                                                               Sex: gender,
                                                               IsNoSex: isNoSex,
                                                               BirthDate: dateStr ?? "2020-07-11",
                                                               PetVarieties: self.contentView.varietiesView.tf.text ?? "",
                                                               Weight: weight,
                                                               Photo: Photo,
                                                               NosePhoto: NosePhoto,
                                                               AllBodyPhoto: AllBodyPhoto,
                                                               xq_PhotoImg: self.xq_PhotoImg,
                                                               xq_NosePhotoImg: self.xq_NosePhotoImg,
                                                               xq_AllBodyPhotoImg: self.xq_AllBodyPhotoImg)
        
        SVProgressHUD.show(withStatus: nil)
        XQSMUserPetNetwork.addOrEditPet(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.isProgress {
                let pro = Float(resModel.progress?.completedUnitCount ?? 0)/Float(resModel.progress?.totalUnitCount ?? 0)
                SVProgressHUD.showProgress(pro, status: "正在保存信息")
                return
            }
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "保存成功")
            self.navigationController?.popViewController(animated: true)
            self.refreshCallback?()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    
    
    func selectImg(_ img: UIImage) {
        if self.currentSelectImgType == 0 {
            self.xq_PhotoImg = img
            self.contentView.imgView.imgView.image = self.xq_PhotoImg
        }else if self.currentSelectImgType == 1 {
            self.xq_AllBodyPhotoImg = img
            self.contentView.fullBodyView.imgView.image = self.xq_AllBodyPhotoImg
        }else if self.currentSelectImgType == 2 {
            self.xq_NosePhotoImg = img
            self.contentView.noseView.imgView.image = self.xq_NosePhotoImg
        }
    }
    
    
    // MARK: - AC_XQImagePickerControllerProtocol
    func xq_pickerImg(_ img: UIImage) {
        self.selectImg(img)
    }
    
    // MARK: - TZImagePickerControllerDelegate
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if let img = photos.first {
            self.selectImg(img)
        }
    }

}
