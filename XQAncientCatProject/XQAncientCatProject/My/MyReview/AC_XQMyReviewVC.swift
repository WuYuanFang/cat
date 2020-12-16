//
//  AC_XQMyReviewVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh
import XQAlert

class AC_XQMyReviewVC: XQACBaseVC, AC_XQMyReviewViewCellDelegate {
    
    let contentView = AC_XQMyReviewView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.contentView.delegate = self
        
        self.contentView.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            self.getData()
        })
        
        self.contentView.tableView.mj_header?.beginRefreshing()
    }
    
    func getData() {
        let reqModel = XQSMNTBaseReqModel()
        XQSMOrderNetwork.getMyReview(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            var reviewLss = resModel.ReviewLss
            
            for (index, item) in reviewLss.enumerated() {
                
                if let url = item.Photo1WithAddress.sm_getImgUrl() {
                    reviewLss[index].imgArr.append(url)
                }
                if let url = item.Photo2WithAddress.sm_getImgUrl() {
                    reviewLss[index].imgArr.append(url)
                }
                if let url = item.Photo3WithAddress.sm_getImgUrl() {
                    reviewLss[index].imgArr.append(url)
                }
                
                if let date = item.ReviewTime.xq_toDate("yyyy-MM-dd HH:mm:ss") {
                    reviewLss[index].xq_ReviewTime = date.xq_toString("yyyy年MM月dd日")
                }
                
            }
            
            self.contentView.dataArr = reviewLss
            self.contentView.tableView.reloadData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.tableView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - AC_XQMyReviewViewCellDelegate
    
    func myReviewViewCell(_ myReviewViewCell: AC_XQMyReviewViewCell, didSelectJGGImageRowAt index: Int) {
        
        let indexPath = self.contentView.tableView.indexPath(for: myReviewViewCell)
        
        let cellData = self.contentView.dataArr[indexPath?.row ?? 0]
        
        var imgUrlStrArr = [String]()
        for item in cellData.imgArr {
            imgUrlStrArr.append(item.absoluteString)
        }

        XQBrowseImageView.show(imgUrlStrArr, defaultSelectIndex: index)
        
    }
    
    /// 点击删除
    func myReviewViewCell(delete myReviewViewCell: AC_XQMyReviewViewCell) {
        
        guard let indexPath = self.contentView.tableView.indexPath(for: myReviewViewCell) else {
            return
        }
        
        XQSystemAlert.alert(withTitle: "确定删除该评论吗？", message: nil, contentArr: ["删除"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            XQSMOrderNetwork.deleteMyReview(self.contentView.dataArr[indexPath.row].ReviewId).subscribe(onNext: { (resModel) in
                
                self.contentView.tableView.mj_header?.endRefreshing()
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                self.contentView.dataArr.remove(at: indexPath.row)
                self.contentView.tableView.deleteRows(at: [indexPath], with: .left)
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
        
    }
    
    /// 点击商品
    func myReviewViewCell(selectCommodity myReviewViewCell: AC_XQMyReviewViewCell) {
        
        guard let indexPath = self.contentView.tableView.indexPath(for: myReviewViewCell) else {
            return
        }
        
        let vc = AC_XQCommodityDetailVC()
        vc.pId = self.contentView.dataArr[indexPath.row].PId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
