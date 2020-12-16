//
//  AC_XQScoreMallVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

/// 积分商城
class AC_XQScoreMallVC: XQACBaseVC, AC_XQScoreHotViewDelegate, AC_XQScoreMallViewAllViewDelegate {
    
    let contentView = AC_XQScoreMallView()
    
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "兑换记录", style: .plain, target: self, action: #selector(respondsToHistory)))
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.welfareView.delegate = self
        self.contentView.allView.delegate = self
        
        self.contentView.allView.collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            if self.contentView.allView.collectionView.mj_footer?.isRefreshing ?? false {
                self.contentView.allView.collectionView.mj_header?.endRefreshing()
                return
            }
            
            self.getData()
        })
        
        self.contentView.allView.collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [unowned self] in
            if self.contentView.allView.collectionView.mj_header?.isRefreshing ?? false {
                self.contentView.allView.collectionView.mj_footer?.endRefreshing()
                return
            }
            
            self.nextProducts()
        })
        
        self.contentView.allView.collectionView.mj_header?.beginRefreshing()
        
        self.getHotData()
    }
    
    /// 获取商品
    func getData() {
        self.page = 0
        self.nextProducts()
    }
    
    /// 下一页商品
    func nextProducts() {
        self.page += 1
        let reqModel = XQSMNTIntegralReqModel.init(pageNumber: self.page)
        XQSMIntegralNetwork.getIntegralProductInfo(reqModel).subscribe(onNext: { (resModel) in
            
            
            if resModel.ErrCode.rawValue == 1 {
                // 无商品
                self.contentView.allView.dataArr.removeAll()
                self.contentView.allView.collectionView.reloadData()
                return
            }else if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                self.page -= 1
                return
            }
            
            if self.page == 1 {
                self.contentView.allView.dataArr = resModel.IntegralInfoList ?? []
            }else {
                self.contentView.allView.dataArr.append(contentsOf: resModel.IntegralInfoList ?? [])
            }
            
            self.contentView.allView.collectionView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.page -= 1
        }, onCompleted: {
            self.contentView.allView.collectionView.mj_header?.endRefreshing()
            self.contentView.allView.collectionView.mj_footer?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    /// 获取热门商品
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
    
    // MARK: - responds
    
    @objc func respondsToHistory() {
        self.navigationController?.pushViewController(AC_XQScoreOrderListVC(), animated: true)
    }
    
    // MARK: - AC_XQScoreHotViewDelegate
    
    func scoreHotView(_ scoreHotView: AC_XQScoreHotView, didSelectItemAt indexPath: IndexPath) {
        let vc = AC_XQScoreMallDetailVC()
        vc.productInfoModel = scoreHotView.dataArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - AC_XQScoreMallViewAllViewDelegate
    
    /// 点击某个cell
    func scoreMallViewAllView(_ scoreMallViewAllView: AC_XQScoreMallViewAllView, didSelectItemAt indexPath: IndexPath) {
        let vc = AC_XQScoreMallDetailVC()
        vc.productInfoModel = self.contentView.allView.dataArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
