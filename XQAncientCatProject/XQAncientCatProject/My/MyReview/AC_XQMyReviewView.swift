//
//  AC_XQMyReviewView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit

class AC_XQMyReviewView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: AC_XQMyReviewViewCellDelegate?
    
    
    
    let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTOrderMyReviewReviewModel]()
    
    var userInfoModel: XQSMNTUserInfoResModel?
    
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
        
        self.tableView.register(AC_XQMyReviewViewCell.classForCoder(), forCellReuseIdentifier: result)
        self.tableView.estimatedRowHeight = 200
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
        //        self.tableView.isScrollEnabled = false
        
        self.userInfoModel = XQSMNTUserInfoResModel.getUserInfoModel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQMyReviewViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.contentLab.text = model.Message
        
        cell.jggView.setImgUrl(model.imgArr)
        
        cell.dateLab.text = model.xq_ReviewTime
        
        cell.starView.starSelectIndex = model.Star - 1
        cell.starView.isUserInteractionEnabled = false
        
        cell.iconImgView.sd_setImage(with: self.userInfoModel?.UserInfo?.AvatarWithAddress.sm_getImgUrl())
        cell.nameLab.text = self.userInfoModel?.UserInfo?.NickName ?? ""
        
        cell.commodityView.imgView.sd_setImage(with: model.PShowImgWithAddress.sm_getImgUrl())
        cell.commodityView.titleLab.text = model.PName
        
        cell.levelImgView.sd_setImage(with: self.userInfoModel?.CurrentRankInfo?.RankAvatarWithAddress.sm_getImgUrl())
        
        cell.delegate = self.delegate
        
        // 评分还没写
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    

}
