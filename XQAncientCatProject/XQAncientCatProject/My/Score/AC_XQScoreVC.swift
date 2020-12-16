//
//  AC_XQScoreVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

/// 积分界面
class AC_XQScoreVC: XQACBaseVC, AC_YCMyViewControllerSignInProtocol, AC_XQScoreHotViewDelegate, AC_XQUserInfoProtocol {
    
    let contentView = AC_XQScoreView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "积分说明", style: .plain, target: self, action: #selector(respondsToHelp)))
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.welfareView.delegate = self
        self.contentView.welfareView.moreBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.navigationController?.pushViewController(AC_XQScoreMallVC(), animated: true)
        }
        
        self.contentView.headerView.signInBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.getSigninInfo { [unowned self] in
                self.refreshUserInfo { [unowned self] (resModel) in
                    self.reloadUI()
                    self.getCreditLog()
                }
            }
        }
        
        self.reloadUI()
        
        self.getHotData()
        
        self.contentView.detailView.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            if self.contentView.detailView.tableView.mj_footer?.isRefreshing ?? false {
                self.contentView.detailView.tableView.mj_header?.endRefreshing()
                return
            }
            
            self.getCreditLog()
        })
        
        self.contentView.detailView.tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [unowned self] in
            if self.contentView.detailView.tableView.mj_header?.isRefreshing ?? false {
                self.contentView.detailView.tableView.mj_footer?.endRefreshing()
                return
            }
            
            self.nextCreditLog()
        })
        
        self.contentView.detailView.tableView.mj_header?.beginRefreshing()
    }
    
    func reloadUI() {
        if let resModel = XQSMNTUserInfoResModel.getUserInfoModel() {
            self.contentView.headerView.currentScoreLab.text = "当前\(resModel.UserInfo?.PayCredits ?? 0)积分"
            // 当前积分不给扣钱
            //            self.contentView.headerView.moneyLab.text = "可抵扣2.2元"
            self.contentView.headerView.moneyLab.text = ""
        }
    }
    
    func getHotData() {
        let reqModel = XQSMNTBaseReqModel()
        XQSMIntegralNetwork.getHotProducts(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.welfareView.dataArr = resModel.IntegralInfoList ?? []
            self.contentView.welfareView.collectionView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    var page = 0
    
    /// 获取积分明细
    func getCreditLog() {
        self.page = 0
        self.nextCreditLog()
    }
    
    /// 下一页积分明细
    func nextCreditLog() {
        self.page += 1
        let reqModel = XQSMNTIntegralGetMyCreditLogReqModel.init(pageIndex: self.page)
        XQSMIntegralNetwork.getMyCreditLog(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                self.page -= 1
                return
            }
            
            if self.page == 1 {
                self.contentView.detailView.dataArr = resModel.CreditLss
            }else {
                self.contentView.detailView.dataArr.append(contentsOf: resModel.CreditLss)
            }
            
            self.contentView.detailView.tableView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.page -= 1
        }, onCompleted: {
            self.contentView.detailView.tableView.mj_header?.endRefreshing()
            self.contentView.detailView.tableView.mj_footer?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - responds
    
    @objc func respondsToHelp() {
        
    }

    // MARK: - AC_XQScoreHotViewDelegate
    func scoreHotView(_ scoreHotView: AC_XQScoreHotView, didSelectItemAt indexPath: IndexPath) {
        let vc = AC_XQScoreMallDetailVC()
        vc.productInfoModel = scoreHotView.dataArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
