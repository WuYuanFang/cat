//
//  AC_XQShopMallCommentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/29.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import HandyJSON

protocol AC_XQShopMallCommentViewDelegate: NSObjectProtocol {
    
    /// 点击评论图片
    func shopMallCommentView(_ shopMallCommentView: AC_XQShopMallCommentView, didSelectJGGImageRowAt cellIndexPath: IndexPath, imageIndex: Int)
    
}

class AC_XQShopMallCommentView: UIView, UITableViewDelegate, UITableViewDataSource, XQSMSuperWelfareDetailViewCommentViewCellDelegate {
    
    weak var delegate: AC_XQShopMallCommentViewDelegate?
    
    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTAroundShopProductReviewsModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.xq_addSubviews(self.tableView)
        
        // 布局
        
        self.tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        // 设置属性
        
        //        self.adImgView.backgroundColor = UIColor.orange
        
        self.tableView.register(XQSMSuperWelfareDetailViewCommentViewCell.classForCoder(), forCellReuseIdentifier: result)
        self.tableView.estimatedRowHeight = 200
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
        //        self.tableView.isScrollEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! XQSMSuperWelfareDetailViewCommentViewCell
        
        let model = self.dataArr[indexPath.row]
                
        if model.NoShowName == 1 {
            cell.nameLab.text = "匿名"
            cell.iconImgView.image = nil
        }else {
            cell.iconImgView.sd_setImage(with: model.UAvatarWithAddress.sm_getImgUrl())
            cell.nameLab.text = model.UName
        }
        
        cell.contentLab.text = model.Message
        
        cell.jggView.setImgUrl(model.imgArr)
        cell.dateLab.text = model.xq_ReviewTime
        cell.starView.starSelectIndex = model.Star - 1
        cell.starView.isUserInteractionEnabled = false
        
        cell.delegate = self
        
        // 评分还没写
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - XQSMSuperWelfareDetailViewCommentViewCellDelegate
    
    func superWelfareDetailViewCommentViewCell(_ superWelfareDetailViewCommentViewCell: XQSMSuperWelfareDetailViewCommentViewCell, didSelectJGGImageRowAt index: Int) {
        if let indexPath = self.tableView.indexPath(for: superWelfareDetailViewCommentViewCell) {
            self.delegate?.shopMallCommentView(self, didSelectJGGImageRowAt: indexPath, imageIndex: index)
        }
        
    }
    
    
}


