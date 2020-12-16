//
//  AC_YCMyViewController.swift
//  XQAncientCatProject
//
//  Created by YCMacMini on 2020/5/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import XQAlert
import XQProjectTool_iPhoneUI
import SVProgressHUD

import TZImagePickerController

import CoreServices

class AC_YCMyViewController: XQACBaseVC ,UITableViewDelegate, UITableViewDataSource, AC_YCMyHeaderViewDelegate, AC_YCMyInfoHeaderViewDelegate, AC_XQImagePickerControllerProtocol, TZImagePickerControllerDelegate, AC_YCMyViewControllerSignInProtocol {
    
    enum CellType {
        /// 宠物列表
        case petList
        /// 订单
        case myOrder
        /// 地址
        case address
        /// 商家入住
        case becomeStoreManager
        /// 我的评价
        case myReview
        /// 邀请注册
        case invitationRegister
    }
    struct CellModel {
        var type: AC_YCMyViewController.CellType = .petList
        var title = ""
        var img = ""
        var des = ""
    }
    
    var dataArr = [
        CellModel.init(type: .petList, title: "宠物列表", img: "my_pet", des: "编辑宠物信息、查看宠物状态"),
        CellModel.init(type: .myOrder, title: "我的订单", img: "my_indent", des: "查看商品订单、 服务订单"),
        CellModel.init(type: .address, title: "地址管理", img: "my_address", des: "新增、编辑、删除收货地址"),
//        CellModel.init(type: .becomeStoreManager, title: "商家入驻", img: "my_merchant", des: "入驻可发布商品"),
        CellModel.init(type: .myReview, title: "我的评价", img: "my_evaluate", des: "查看我所发布的商品信息"),
        CellModel.init(type: .invitationRegister, title: "邀请注册", img: "my_merchant", des: "邀请注册"),
    ]
    
    /// cell重用标识符
    private let myTableViewCellIdent = "myTableViewCell"
    
    let headerView = AC_YCMyHeaderView()
    
    // MARK: - Lazy
    
    /// tableView
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.register(AC_YCMyTableViewCell.classForCoder(), forCellReuseIdentifier: myTableViewCellIdent)
        
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: system_screenWidth, height: 400)
        tv.tableHeaderView = self.headerView
        
        return tv
    }()
    
    // MARK: - AC_YCMyHeaderViewDelegate
    
    /// 点击我的收入这些
    func myHeaderView(_ myHeaderView: AC_YCMyHeaderView, didSelectItemAt cellType: AC_YCMyHeaderView.CellType) {
        if XQSMBaseNetwork.default.token.count == 0 {
            AC_XQLoginVC.presentLogin(self)
            return
        }
        
        switch cellType {
            
        case AC_YCMyHeaderView.CellType.income:
            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
//            self.navigationController?.pushViewController(AC_XQMyIncomeVC(), animated: true)
            
        case AC_YCMyHeaderView.CellType.integral:
            if XQSMNTUserInfoResModel.getUserInfoModel() == nil {
                SVProgressHUD.showInfo(withStatus: "获取不到用户信息")
                return
            }
            self.navigationController?.pushViewController(AC_XQScoreVC(), animated: true)
            
        case AC_YCMyHeaderView.CellType.member:
            if XQSMNTUserInfoResModel.getUserInfoModel() == nil {
                SVProgressHUD.showInfo(withStatus: "获取不到用户信息")
                return
            }
            self.navigationController?.pushViewController(AC_XQVIPVC(), animated: true)
            
        case AC_YCMyHeaderView.CellType.coupon:
            self.navigationController?.pushViewController(AC_XQCouponVC(), animated: true)
            
        case AC_YCMyHeaderView.CellType.signIn:
            self.getSigninInfo { [unowned self] in
                self.refreshUserInfo { [unowned self] (resModel) in
                    self.headerView.reloadUI(resModel)
                    self.refreshUI()
                }
            }
            
        default:
            break
        }
        
    }
    
    // MARK: - AC_YCMyInfoHeaderViewDelegate
    
    /// 点击设置
    func myInfoHeaderView(didTapSet myInfoHeaderView: AC_YCMyInfoHeaderView) {
        if XQSMBaseNetwork.default.token.count == 0 {
            AC_XQLoginVC.presentLogin(self)
            return
        }
        
        self.navigationController?.pushViewController(AC_XQSetVC(), animated: true)
    }
    
    /// 点击客服
    func myInfoHeaderView(didTapCustomServer myInfoHeaderView: AC_YCMyInfoHeaderView) {
        if XQSMBaseNetwork.default.token.count == 0 {
            AC_XQLoginVC.presentLogin(self)
            return
        }
        
        SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
    }
    
    /// 点击摄像头
    func myInfoHeaderView(didTapCamera myInfoHeaderView: AC_YCMyInfoHeaderView) {
        if XQSMBaseNetwork.default.token.count == 0 {
            AC_XQLoginVC.presentLogin(self)
            return
        }
        
        SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
    }
    
    /// 点击头像
    func myInfoHeaderView(didTapHeadImg myInfoHeaderView: AC_YCMyInfoHeaderView) {
        if XQSMBaseNetwork.default.token.count == 0 {
            AC_XQLoginVC.presentLogin(self)
            return
        }
        
        self.xq_showPickerImageAlert()
    }
    
    /// 点击名称
    func myInfoHeaderView(didTapName myInfoHeaderView: AC_YCMyInfoHeaderView) {
        
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
    
}

// MARK: - Life Cycle (生命周期)
extension AC_YCMyViewController: AC_XQUserInfoProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        addElement()
        layoutElement()
        
        self.tableView.contentInsetAdjustmentBehavior = .never;
        
        self.headerView.delegate = self
        self.headerView.headerView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.headerView.headerView.vipImageView.isHidden = !ac_isShowV()
        self.headerView.config()
        self.headerView.collectionView.reloadData()
        
        if XQSMBaseNetwork.default.token.count == 0 {
            // 没有登录
            self.refreshUI()
            return
        }
        
        // 已登录
        self.refreshUserInfo({ [unowned self] (resModel) in
            self.headerView.reloadUI(resModel)
            self.refreshUI()
        })
    }
    
    func refreshUI() {
        
        if XQSMBaseNetwork.default.token.count == 0 {
            self.headerView.headerView.vipImageView.isHidden = true
            self.headerView.headerView.phoneNumberLabel.isHidden = true
            self.headerView.headerView.approveImageView.isHidden = true
            
            self.headerView.headerView.userNameLabel.text = "请先登录"
            
            return
        }
        
        let model = XQSMNTUserInfoResModel.getUserInfoModel()
        
        if let userInfoModel = XQSMNTUserInfoModel.getUserInfoModel() {
            
            self.headerView.headerView.vipImageView.isHidden = false
            self.headerView.headerView.phoneNumberLabel.isHidden = false
            self.headerView.headerView.approveImageView.isHidden = false
            
            self.headerView.headerView.userNameLabel.text = userInfoModel.NickName
            self.headerView.headerView.phoneNumberLabel.text = userInfoModel.Phone.phoneDesensitization()
            
            self.headerView.headerView.iconImageView.sd_setImage(with: userInfoModel.AvatarWithAddress.sm_getImgUrl())
            self.headerView.headerView.vipImageView.sd_setImage(with: model?.CurrentRankInfo?.RankAvatarWithAddress.sm_getImgUrl())
            
        }
        
    }
    
}

// MARK: - Config (配置)
extension AC_YCMyViewController {
    func config() {
        
    }
}

// MARK: - Structure （构造）
extension AC_YCMyViewController {
    
    func addElement() {
        self.view.addSubview(tableView)
    }
    
    func layoutElement() {
        self.tableView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(-XQIOSDevice.getStatusHeight())
//            make.left.right.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }
    }
    
}

// MARK:- UITableViewDataSource
extension AC_YCMyViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myTableViewCellIdent, for: indexPath) as! AC_YCMyTableViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.titleLabel.text = model.title
        cell.detailLabel.text = model.des
        cell.pictureImageView.image = UIImage.init(named: model.img)
        
        return cell
    }
}

// MARK:- UITableViewDelegate
extension AC_YCMyViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if XQSMBaseNetwork.default.token.count == 0 {
            AC_XQLoginVC.presentLogin(self)
            return
        }
        
        let model = self.dataArr[indexPath.row]
        
        switch model.type {
        case .petList:
//            cell.titleLabel.text = "宠物列表"
            
            self.navigationController?.pushViewController(AC_XQPetListVC(), animated: true)
            // 暂时没有繁育
//            self.navigationController?.pushViewController(AC_XQPetListChildrenVC(), animated: true)
            
            break
        case .myOrder:
//            cell.titleLabel.text = "我的订单"
            self.navigationController?.pushViewController(AC_XQOrderListVC(), animated: true)
            break
            
        case .address:
//            cell.titleLabel.text = "地址管理"
            self.navigationController?.pushViewController(AC_XQAddressListVC(), animated: true)
            break
            
        case .becomeStoreManager:
//            cell.titleLabel.text = "商家入驻"
            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
            break
            
        case .myReview:
            // 我的评价
//            SVProgressHUD.showInfo(withStatus: "暂未开放, 敬请期待")
            let vc = AC_XQMyReviewVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .invitationRegister:
            let vc = AC_XQInvitationRegisterVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }

}


extension AC_YCMyViewController {
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
            self.headerView.headerView.iconImageView.image = img
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
}



class XQImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    static func presentCamera(with vc: UIViewController, block: XQImagePickerControllerBlock?) {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            print("不支持相机")
            XQSystemAlert.alert(withTitle: "当前手机不支持相机", message: nil, contentArr: nil, cancelText: "确定", vc: vc, contentCallback: nil, cancelCallback: nil)
            return
        }
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .restricted || status == .denied {
            XQSystemAlert.alert(withTitle: "提示", message: "相机权限未开启，请进入系统【设置】>【隐私】>【相机】中打开开关，开启相机功能", contentArr: ["前去设置"], cancelText: "取消", vc: vc, contentCallback: { (alert, index) in
                
                UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                
            }, cancelCallback: nil)
            return
        }
        
        let imagePickerController = XQImagePickerController()
        imagePickerController.modalPresentationStyle = .fullScreen
        
        //                // 设置资源来源（相册、相机、图库之一）
        imagePickerController.sourceType = .camera
        
        // 允许的视屏质量（如果质量选取的质量过高，会自动降低质量）
        imagePickerController.videoQuality = .typeMedium
        
        let typeImage = kUTTypeImage as String
        imagePickerController.mediaTypes = [typeImage]
        
        //                // 设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
        imagePickerController.delegate = imagePickerController
        
        //                // 是否允许编辑（YES：图片选择完成进入编辑模式）
        //                imagePickerVC.allowsEditing = YES;
        
        imagePickerController.xq_block = block
        
        vc.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    typealias XQImagePickerControllerBlock = (_ info: [UIImagePickerController.InfoKey : Any]) -> ()
    var xq_block: XQImagePickerControllerBlock?
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        picker.dismiss(animated: true) { [unowned self] in
            self.xq_block?(info)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}



protocol AC_XQImagePickerControllerProtocol: NSObjectProtocol {
    
    /// 跳出选择图片弹框
    func xq_showPickerImageAlert(_ needCircleCrop: Bool, circleCropRadius: Int)
    
    /// 跳转到选择相册
    func xq_presentToImagePickerController(_ needCircleCrop: Bool, circleCropRadius: Int)
    
    /// 跳转, 拍照
    func xq_presentToVideoPlayerController(_ needCircleCrop: Bool, circleCropRadius: Int)
    
    /// 选择了图片，外部要自己去实现这个方法
    func xq_pickerImg(_ img: UIImage)
}


extension AC_XQImagePickerControllerProtocol where Self:UIViewController, Self:TZImagePickerControllerDelegate {
    
    /// 跳出选择图片弹框
    func xq_showPickerImageAlert(_ needCircleCrop: Bool = true, circleCropRadius: Int = 90) {
        XQSystemAlert.actionSheet(withTitle: nil, message: nil, contentArr: ["照片库选择", "拍照"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            if index == 0 {
                self.xq_presentToImagePickerController(needCircleCrop, circleCropRadius: circleCropRadius)
            }else {
                self.xq_presentToVideoPlayerController(needCircleCrop, circleCropRadius: circleCropRadius)
            }
            
        }, cancelCallback: nil)
    }
    
    /// 跳转到选择相册
    func xq_presentToImagePickerController(_ needCircleCrop: Bool = true, circleCropRadius: Int = 90) {
        
        let vc = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
        if let vc = vc {
            
            vc.allowTakeVideo = false
            vc.allowPickingVideo = false
            vc.naviBgColor = UIColor.ac_mainColor
            vc.naviTitleColor = UIColor.white
            vc.navigationBar.isTranslucent = false
            vc.modalPresentationStyle = .fullScreen
            vc.allowCrop = needCircleCrop
            vc.needCircleCrop = needCircleCrop
            vc.circleCropRadius = circleCropRadius
            vc.allowPickingOriginalPhoto = false
            self.present(vc, animated: true, completion: nil)
            
        }else {
            SVProgressHUD.showInfo(withStatus: "初始化相册失败")
        }
    }
    
    /// 跳转, 拍照
    func xq_presentToVideoPlayerController(_ needCircleCrop: Bool = true, circleCropRadius: Int = 90) {
        XQImagePickerController.presentCamera(with: self) { [unowned self] (info) in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                print("没有图片1111")
                return
            }
            
            if !needCircleCrop {
                // 不需要剪切图片
                self.xq_pickerImg(image)
                return
            }
            
            TZImageManager.default()?.savePhoto(with: image, completion: { [unowned self] (asset, error) in
                
                if let error = error {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                    return
                }
                
                let v = TZImagePickerController.init(cropTypeWith: asset, photo: image) { (img, asset) in
                    if let img = img {
                        self.xq_pickerImg(img)
                    }
                }
                
                guard let vc = v else {
                    print("初始化失败")
                    return
                }
                
                vc.navigationBar.isTranslucent = false
                vc.naviBgColor = UIColor.ac_mainColor
                vc.naviTitleColor = UIColor.white
                
                if needCircleCrop {
                    vc.needCircleCrop = true
                    vc.circleCropRadius = circleCropRadius
                }else {
//                    let height = image.size.height / (image.size.width/UIScreen.main.bounds.width)
//                    print("wxq: ", vc.cropRect)
//                    vc.cropRect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
                }
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            })
            
        }
    }
    
}


protocol AC_YCMyViewControllerSignInProtocol {
    
    typealias AC_YCMyViewControllerSignInProtocolCallback = () -> ()
    
    /// 签到
    /// - Parameter callback: 第一次签到成功了
    func getSigninInfo(_ callback: AC_YCMyViewControllerSignInProtocolCallback?)
    
}

extension AC_YCMyViewControllerSignInProtocol where Self:XQACBaseVC {
    
    /// 签到
    func getSigninInfo(_ callback: AC_YCMyViewControllerSignInProtocolCallback?) {
        
        let reqModel = XQSMNTBaseReqModel()
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.signin(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            // 获取
            SVProgressHUD.dismiss()
            
            if resModel.IsOk {
                self.addSigninInfo(resModel, callback: callback)
            }else {
                // 已签到
                AC_XQSignInView.show({ (index) in
                    self.signInPresent(with: index)
                })
                AC_XQSignInView.reloadUI(with: resModel)
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 签到, 并且显示弹框
    private func addSigninInfo(_ signResModel: XQSMNTUserSignResModel?, callback: AC_YCMyViewControllerSignInProtocolCallback?) {
        
        let reqModel = XQSMNTBaseReqModel()
        SVProgressHUD.show(withStatus: nil)
        XQSMUserNetwork.addSignin(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            SVProgressHUD.dismiss()
            AC_XQSignInView.show({ (index) in
                self.signInPresent(with: index)
            })
            AC_XQSignInView.reloadUI(with: signResModel, addSignResModel: resModel)
            callback?()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    private func signInPresent(with index: Int) {
        if index == 0 {
            if self.isKind(of: AC_XQScoreVC.classForCoder()) {
                return
            }
            let vc = AC_XQScoreVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if index == 1 {
            self.navigationController?.pushViewController(AC_XQScoreMallVC(), animated: true)
        }
    }
    
}



protocol AC_XQUserInfoProtocol {
    
    /// 刷新用户信息
    func refreshUserInfo(_ callback: ((_ resModel: XQSMNTUserInfoResModel) -> ())? )
    
}

extension AC_XQUserInfoProtocol where Self:XQACBaseVC {
    
    /// 刷新用户信息
    func refreshUserInfo(_ callback: ((_ resModel: XQSMNTUserInfoResModel) -> ())? ) {
        let reqModel = XQSMNTBaseReqModel()
        XQSMUserNetwork.getUserInfo(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            XQSMNTUserInfoResModel.setUserInfoModel(resModel)
            
            if let UserInfo = resModel.UserInfo {
                XQSMNTUserInfoModel.setUserInfoModel(UserInfo)
            }
            
            callback?(resModel)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
}


