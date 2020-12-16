//
//  AC_XQAddressListVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class AC_XQAddressListVC: XQACBaseVC, AC_XQAddressListViewDelegate {
    
    let contentView = AC_XQAddressListView()
    
    /// 从订单跳转进来的..原来已选中的 model
    var oSelectModel: XQSMNTShopAddressDtoModel?
    
    typealias AC_XQAddressListVCCallback = (_ addressModel: XQSMNTShopAddressDtoModel?) -> ()
    var callback: AC_XQAddressListVCCallback?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "添加", style: .plain, target: self, action: #selector(respondsToAdd)))

        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addView.xq_addTap { [unowned self] (gesture) in
            self.respondsToAdd()
        }
        
        self.contentView.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            self.getData()
        })
        
        self.contentView.tableView.mj_header?.beginRefreshing()
        self.contentView.delegate = self
    }
    
    func getData() {
        
        let reqModel = XQSMNTBaseReqModel.init()
        XQSMAddressNetwork.getMyAllAddress(reqModel).subscribe(onNext: { (resModel) in
            
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
    
    // MARK: - responds
    
    @objc func respondsToAdd() {
        let vc = AC_XQEditAddressVC()
        vc.refreshCallback = { [unowned self] (isDelete) in
            self.contentView.tableView.mj_header?.beginRefreshing()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - AC_XQAddressListViewDelegate
    
    func addressListView(_ addressListView: AC_XQAddressListView, didSelectEditAt indexPath: IndexPath) {
        let model = self.contentView.dataArr[indexPath.row]
        let vc = AC_XQEditAddressVC()
        vc.oModel = model
        vc.refreshCallback = { [unowned self] (isDelete) in
            
            if isDelete {
                if let oSelectModel = self.oSelectModel, model.SaId == oSelectModel.SaId {
                    self.callback?(nil)
                }
            }
            
            self.contentView.tableView.mj_header?.beginRefreshing()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 点击 cell
    func addressListView(_ addressListView: AC_XQAddressListView, didSelectRowAt indexPath: IndexPath) {
        
        if let callback = self.callback {
            callback(self.contentView.dataArr[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
