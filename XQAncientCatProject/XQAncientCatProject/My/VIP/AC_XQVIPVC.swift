//
//  AC_XQVIPVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

// 会员详情
class AC_XQVIPVC: XQACBaseVC {
    
    let contentView = AC_XQVIPView()
    
    var userInfoModel: XQSMNTUserInfoResModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "帮助", style: .plain, target: self, action: #selector(respondsToHelp)))
        
        self.xq_navigationBar.backView.setBackImg(with: UIImage.init(named: "back_arrow")?.xq_image(withTintColor: .white))
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.headerView.carView.privilegeBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.navigationController?.pushViewController(AC_XQLevelPrivilegeVC(), animated: true)
        }
        
        
        self.userInfoModel = XQSMNTUserInfoResModel.getUserInfoModel()
        self.reloadUI()
        self.getCoupon()
    }
    
    func reloadUI() {
        
        guard let userInfoModel = self.userInfoModel else {
            return
        }
        
        self.contentView.headerView.carView.headImgView.sd_setImage(with: userInfoModel.UserInfo?.AvatarWithAddress.sm_getImgUrl())
        self.contentView.headerView.carView.vipImgView.sd_setImage(with: userInfoModel.CurrentRankInfo?.RankAvatarWithAddress.sm_getImgUrl())
        self.contentView.headerView.carView.nameLab.text = userInfoModel.UserInfo?.NickName
        self.contentView.headerView.carView.phoneLab.text = userInfoModel.UserInfo?.Phone.phoneDesensitization()
        
        self.contentView.headerView.carView.scoreView.topLabel.text = "\(userInfoModel.UserInfo?.RankCredits ?? 0)"
        
        self.contentView.privilegeView.reloadUI(self.userInfoModel)
        
        
        if userInfoModel.NextRankInfo != nil {
            // 下一级的升级比率
            let scale = Float(userInfoModel.UserInfo?.RankCredits ?? 0)/Float(userInfoModel.NextRankInfo?.CreditsLower ?? 0)
            
            self.contentView.headerView.sliderView.minLab.text = userInfoModel.CurrentRankInfo?.Title
            self.contentView.headerView.sliderView.maxLab.text = userInfoModel.NextRankInfo?.Title
            
            self.contentView.headerView.sliderView.setProgress(scale)
            self.contentView.headerView.sliderView.nextLevelLab.text = "还有\(self.userInfoModel?.NeedCreditsCount ?? 0)点升级"
            
        }else {
            // 满级, 或者数据获取失败
            self.contentView.headerView.sliderView.setProgress(1)
            
        }
        
        self.contentView.headerView.sliderView.progressView.titleLab.text = "\(userInfoModel.UserInfo?.RankCredits ?? 0)"
        
        
        
    }
    
    func getCoupon() {
        let reqModel = XQSMNTBaseReqModel.init()
        XQSMCouponNetwork.getMyAllOrder(reqModel).subscribe(onNext: { (resModel) in
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.headerView.carView.couponView.topLabel.text = "\(resModel.CouponList?.count ?? 0)"
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - responds
    
    @objc func respondsToHelp() {
        
    }
    
    
    
    
}
