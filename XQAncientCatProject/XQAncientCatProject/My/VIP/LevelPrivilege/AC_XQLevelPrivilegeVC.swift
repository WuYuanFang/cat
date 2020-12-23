//
//  AC_XQLevelPrivilegeVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class AC_XQLevelPrivilegeVC: XQACBaseVC {
    
    let contentView = AC_XQLevelPrivilegeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.backView.setBackImg(with: UIImage.init(named: "back_arrow")?.xq_image(withTintColor: .white))
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        if let url = URL.init(string: XQSMBaseNetwork.default.baseUrl + "/Account/UserRankInfo") {
            self.contentView.webView.webView.load(URLRequest.init(url: url))
        }
        
        self.getData()
    }
    
    func getData() {
        let reqModel = XQSMNTBaseReqModel()
        XQSMUserNetwork.getRankInfo(reqModel).subscribe(onNext: { (resModel) in
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.headerView.resModel = resModel
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }

}
