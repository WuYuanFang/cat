//
//  AC_XQShopMallCommentVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class AC_XQShopMallCommentVC: XQACBaseVC, AC_XQShopMallCommentViewDelegate {

    let contentView = AC_XQShopMallCommentView()
    
    var pId = 0
    
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
        let reqModel = XQSMNTProductInfoReqModel.init(PId: self.pId)
        XQSMAroundShopNetwork.getProductReviews(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            var reviewLss = resModel.Reviews
            for (index, item) in resModel.Reviews.enumerated() {
                
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
    
    
    // MARK: - AC_XQShopMallCommentViewDelegate
    
    /// 点击评论图片
    func shopMallCommentView(_ shopMallCommentView: AC_XQShopMallCommentView, didSelectJGGImageRowAt cellIndexPath: IndexPath, imageIndex: Int) {
        
        let cellData = self.contentView.dataArr[cellIndexPath.row]
        
        var imgUrlStrArr = [String]()
        for item in cellData.imgArr {
            imgUrlStrArr.append(item.absoluteString)
        }

        XQBrowseImageView.show(imgUrlStrArr, defaultSelectIndex: imageIndex)
        
    }
    
}
