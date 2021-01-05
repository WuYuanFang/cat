//
//  AC_XQPetListChildrenVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import XQAlert

class AC_XQPetListChildrenVC: XQACBaseVC, AC_XQPetListChildrenViewDelegate {
    
    var petStatus: XQSMNTGetMyPetListReqModel.PetState = .all
    
    let contentView = AC_XQPetListChildrenView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 暂时还没有繁育
        self.xq_navigationBar.isHidden = true
        self.xq_view.isHidden = true
        self.view.addSubview(self.contentView)
        
//        self.xq_view.addSubview(self.contentView)
        
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.contentView.delegate = self
        
        self.contentView.addView.xq_addTap { [unowned self] (gesture) in
            let vc = AC_XQEditPetInfoVC()
            vc.refreshCallback = { [unowned self] in
                self.contentView.tableView.mj_header?.beginRefreshing()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.contentView.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            self.getData()
        })
        
        self.contentView.tableView.mj_header?.beginRefreshing()
    }
    
    func getData() {
        
        let reqModel = XQSMNTGetMyPetListReqModel.init(state: self.petStatus)
        XQSMUserPetNetwork.getMyPetList(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            
            self.contentView.dataArr = resModel.Lss ?? []
            self.contentView.tableView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.tableView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
        
        
    }
    
    // MARK: - AC_XQPetListChildrenViewDelegate
    
    /// 点击编辑
    func petListChildrenView(_ petListChildrenView: AC_XQPetListChildrenView, didSelectEditAt indexPath: IndexPath) {
        let vc = AC_XQEditPetInfoVC()
        vc.oModel = self.contentView.dataArr[indexPath.row]
        vc.refreshCallback = { [unowned self] in
            self.contentView.tableView.mj_header?.beginRefreshing()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击删除
    func petListChildrenView(_ petListChildrenView: AC_XQPetListChildrenView, didSelectDeleteAt indexPath: IndexPath) {
        XQSystemAlert.alert(withTitle: "确定是否删除", message: nil, contentArr: ["删除"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            let model = self.contentView.dataArr[indexPath.row]
            
            SVProgressHUD.show(withStatus: nil)
            XQSMUserPetNetwork.deletePet(model.Id).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                
                if let petIndex = self.contentView.dataArr.firstIndex(where: { (petModel) -> Bool in
                    return petModel.Id == model.Id
                }) {
                    self.contentView.dataArr.remove(at: petIndex)
                    self.contentView.tableView.reloadData()
                }
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
    }
    
    /// 点击前往对应的订单页面
    func getToOrderDetail(_ petListChildrenView: AC_XQPetListChildrenView, didSelectAt indexPath: IndexPath) {
        let model = self.contentView.dataArr[indexPath.row]
        if model.State == .foster {
            // 寄养
            getFosterDetailData(id: model.oid)
        }else if model.State == .washProtect {
            // 洗护
            getWashOrderDetail(id: model.oid)
        }
    }
    
    
    /// 获取洗护订单详情
    func getWashOrderDetail(id:Int) {
        SVProgressHUD.show(withStatus: nil)
        XQSMToShopOrderNetwork.getToOrderById(id).subscribe(onNext: { (resModel) in
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            SVProgressHUD.dismiss()
            let vc = AC_XQWashProtectOrderDetailVC()
            vc.fosterModel = resModel.ToOrderItem
            self.navigationController?.pushViewController(vc, animated: true)
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取寄养订单详情
    func getFosterDetailData(id:Int) {
        XQACFosterNetwork.fosterDetails(id).subscribe(onNext: { (resModel) in
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            let vc = AC_XQFosterOrderDetailVC()
            vc.fosterModel = resModel.model
            vc.refreshCallback = { [unowned self] in
                self.getData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
}
