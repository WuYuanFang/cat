//
//  AC_XQSetPersonalInformationVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import TZImagePickerController
import SVProgressHUD
import XQAlert

class AC_XQSetPersonalInformationVC: XQACBaseVC, UITableViewDataSource, UITableViewDelegate, AC_XQImagePickerControllerProtocol, TZImagePickerControllerDelegate, AC_XQUserInfoProtocol {
    
    private let result = "cell"
    private let imgResult = "imgResult"
    var tableView: UITableView!
    
    var dataArr = [String]()
    
    var userInfoModel: XQSMNTUserInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
        self.xq_view.xq_addSubviews(self.tableView)
        
        // 布局
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 设置属性
        self.tableView.register(AC_XQSetPersonalInformationVCNameCell.classForCoder(), forCellReuseIdentifier: self.result)
        self.tableView.register(AC_XQSetPersonalInformationVCCell.classForCoder(), forCellReuseIdentifier: self.imgResult)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 44
        self.tableView.backgroundColor = UIColor.init(hex: "#F3F3F3")
        
        
        self.dataArr = [
            "头像",
            "设置昵称"
        ]
        
        self.reloadUI()
    }
    
    func reloadUI() {
        self.userInfoModel = XQSMNTUserInfoModel.getUserInfoModel()
        self.tableView.reloadData()
    }
    
    func modifyName() {
        
        XQSystemAlert.alert(withTitle: "请输入昵称", message: nil, contentArr: ["确定"], cancelText: "取消", vc: self, textFieldCount: 1, textFieldBlock: { (index, tf) in
            tf.placeholder = "请输入昵称"
        }, contentCallback: { (alert, index) in
            
            let name = alert.textFields?.first?.text
            
            if name?.count ?? 0 == 0 {
                SVProgressHUD.showInfo(withStatus: "昵称不能为空")
                return
            }
            
            let reqModel = XQSMNTUploadPhotoAndChangeNickNameReqModel.init(nickName: name ?? "")
            SVProgressHUD.show(withStatus: nil)
            XQSMUserNetwork.uploadPhotoAndChangeNickName(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.isProgress {
                    return
                }
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "修改成功")
                self.refreshUserInfo { [unowned self] (resModel) in
                    self.reloadUI()
                }
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.imgResult, for: indexPath) as! AC_XQSetPersonalInformationVCCell
            cell.titleLab.text = self.dataArr[indexPath.row]
            cell.imgView.sd_setImage(with: self.userInfoModel?.AvatarWithAddress.sm_getImgUrl())
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.result, for: indexPath) as! AC_XQSetPersonalInformationVCNameCell
        
        cell.titleLab.text = self.dataArr[indexPath.row]
        cell.messageLab.text = self.userInfoModel?.NickName
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.xq_showPickerImageAlert()
        }else if indexPath.row == 1 {
            self.modifyName()
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: - AC_XQImagePickerControllerProtocol
    func xq_pickerImg(_ img: UIImage) {
        self.uploadImg(img)
    }
    
    // MARK: - TZImagePickerControllerDelegate
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        if let img = photos.first {
            self.uploadImg(img)
        }
    }
    
    /// 上传头像
    func uploadImg(_ img: UIImage) {
        let nickName = XQSMNTUserInfoModel.getUserInfoModel()?.NickName ?? ""
        let reqModel = XQSMNTUploadPhotoAndChangeNickNameReqModel.init(nickName: nickName, imgArr: [img])
        
        SVProgressHUD.showProgress(0, status: "正在上传头像")
        XQSMUserNetwork.uploadPhotoAndChangeNickName(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.isProgress {
                let pro = Float(resModel.progress?.completedUnitCount ?? 0) / Float(resModel.progress?.totalUnitCount ?? 0)
                SVProgressHUD.showProgress(pro, status: "正在上传头像")
                return
            }
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.showSuccess(withStatus: "上传成功")
            self.refreshUserInfo { [unowned self] (resModel) in
                self.reloadUI()
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    
    
    
}
