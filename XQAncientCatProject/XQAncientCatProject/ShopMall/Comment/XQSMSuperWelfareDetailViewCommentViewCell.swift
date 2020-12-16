//
//  XQSMSuperWelfareDetailViewCommentViewCell.swift
//  XQShopMallProject
//
//  Created by WXQ on 2020/4/25.
//  Copyright © 2020 itchen.com. All rights reserved.
//

import UIKit

protocol XQSMSuperWelfareDetailViewCommentViewCellDelegate: NSObjectProtocol {
    
    func superWelfareDetailViewCommentViewCell(_ superWelfareDetailViewCommentViewCell: XQSMSuperWelfareDetailViewCommentViewCell, didSelectJGGImageRowAt index: Int)
    
}

class XQSMSuperWelfareDetailViewCommentViewCell: UITableViewCell, XQJGGViewDelegate {
    
    weak var delegate: XQSMSuperWelfareDetailViewCommentViewCellDelegate?
    
    private let xq_contentView = UIView()
    
    let iconImgView = UIImageView()
    let nameLab = UILabel()
    
    /// 评分星星, 后面再写
    let gradeLab = UILabel()
    let starView = XQStarView.init(frame: CGRect.zero, starCount: 5, starSelectIndex: 0)
    
    let dateLab = UILabel()
    
    let contentLab = UILabel()
    
    
    /// 九宫格
    var jggView: XQJGGView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let iconImgViewSize: CGFloat = 40
        
        let spacing: CGFloat = 6
        
        let itemSize = (system_screenWidth - (12 + iconImgViewSize + 12) * 2 - spacing * 2) / 3
        self.jggView = XQJGGView.init(frame: CGRect.zero, itemSize: itemSize, fixedSpacing: spacing, leadSpacing: 0, tailSpacing: 0)
        
        self.contentView.addSubview(self.xq_contentView)
        self.xq_contentView.xq_addSubviews(self.iconImgView, self.nameLab, self.gradeLab, self.dateLab, self.contentLab, self.jggView, self.starView)
        
        
        // 布局
        
        self.xq_contentView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        
        self.iconImgView.snp.makeConstraints { (make) in
            make.left.top.equalTo(12)
            make.size.equalTo(CGSize.init(width: iconImgViewSize, height: iconImgViewSize))
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView)
            make.left.equalTo(self.iconImgView.snp.right).offset(12)
        }
        
        self.gradeLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom).offset(8)
            make.left.equalTo(self.nameLab)
        }
        
        self.starView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.gradeLab)
            make.left.equalTo(self.gradeLab.snp.right).offset(5)
            make.height.equalTo(15)
        }
        
        self.dateLab.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(self.nameLab)
        }
        
        self.contentLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.gradeLab.snp.bottom).offset(12)
            make.left.equalTo(self.nameLab)
            make.right.equalTo(self.dateLab)
        }
        
        self.jggView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLab.snp.bottom).offset(12)
            make.left.equalTo(self.nameLab)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 设置属性
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        self.xq_contentView.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        
        self.iconImgView.layer.cornerRadius = iconImgViewSize/2
        self.iconImgView.layer.masksToBounds = true
//        self.iconImgView.backgroundColor = UIColor.orange
        
        self.contentLab.numberOfLines = 0
        self.contentLab.font = UIFont.systemFont(ofSize: 15)
        
        self.gradeLab.text = "评分"
        self.gradeLab.font = UIFont.systemFont(ofSize: 13)
        self.gradeLab.textColor = UIColor.init(hex: "#919191")
        
        self.dateLab.text = "2020.04.08"
        self.dateLab.textColor = UIColor.init(hex: "#919191")
        self.dateLab.font = UIFont.systemFont(ofSize: 13)
        
        self.nameLab.text = "EOG4098123568"
        self.nameLab.font = UIFont.systemFont(ofSize: 15)
        
        self.jggView.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - XQJGGViewDelegate
    func jggView(_ jggView: XQJGGView, didSelectRowAt index: Int) {
        self.delegate?.superWelfareDetailViewCommentViewCell(self, didSelectJGGImageRowAt: index)
    }
    
}
