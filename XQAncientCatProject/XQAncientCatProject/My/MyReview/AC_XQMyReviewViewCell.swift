//
//  AC_XQMyReviewViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQMyReviewViewCellDelegate: NSObjectProtocol {
    /// 点击九宫格图片
    func myReviewViewCell(_ myReviewViewCell: AC_XQMyReviewViewCell, didSelectJGGImageRowAt index: Int)
    /// 点击删除
    func myReviewViewCell(delete myReviewViewCell: AC_XQMyReviewViewCell)
    /// 点击商品
    func myReviewViewCell(selectCommodity myReviewViewCell: AC_XQMyReviewViewCell)
    
}

class AC_XQMyReviewViewCell: UITableViewCell, XQJGGViewDelegate {

    weak var delegate: AC_XQMyReviewViewCellDelegate?
    
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
    
    let levelImgView = UIImageView()
    
    let commodityView = AC_XQMyReviewViewCellCommodityView()
    
    let deleteBtn = UIButton()
    
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
        self.xq_contentView.xq_addSubviews(self.iconImgView, self.nameLab, self.gradeLab, self.dateLab, self.contentLab, self.jggView, self.starView, self.commodityView, self.deleteBtn, self.levelImgView)
        
        
        // 布局
        
        self.xq_contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
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
        }
        
        self.levelImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.nameLab)
            make.left.equalTo(self.nameLab.snp.right).offset(10)
            make.size.equalTo(20)
        }
        
        self.commodityView.snp.makeConstraints { (make) in
            make.top.equalTo(self.jggView.snp.bottom).offset(12)
            make.left.equalTo(self.nameLab)
            make.right.equalToSuperview()
        }
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.commodityView.snp.bottom).offset(8)
            make.right.equalTo(-12)
            make.size.equalTo(25)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 设置属性
        
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.xq_contentView.backgroundColor = UIColor.white
        
        
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
        
        self.deleteBtn.setImage(UIImage.init(named: "review_delete_list"), for: .normal)
        self.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.myReviewViewCell(delete: self)
        }
        
        self.commodityView.xq_addTap { [unowned self] (sender) in
            self.delegate?.myReviewViewCell(selectCommodity: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - XQJGGViewDelegate
    func jggView(_ jggView: XQJGGView, didSelectRowAt index: Int) {
        self.delegate?.myReviewViewCell(self, didSelectJGGImageRowAt: index)
    }

}

/// 商品view
class AC_XQMyReviewViewCellCommodityView: UIView {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
//    let messageLab = UILabel()
    let arrowImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.imgView, self.titleLab, self.arrowImgView)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.top.left.equalTo(12)
            make.bottom.equalTo(-12)
            make.size.equalTo(60)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.imgView.snp.right).offset(16)
            make.right.equalTo(self.arrowImgView.snp.left).offset(-6)
        }
        
        self.arrowImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-6)
            make.size.equalTo(20)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        self.imgView.layer.cornerRadius = 4
        self.imgView.layer.masksToBounds = true
        self.imgView.contentMode = .scaleAspectFill
        
        self.arrowImgView.image = UIImage.init(named: "arrow_right")
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.xq_corners_addRoundedCorners([.topLeft, .bottomRight], withRadii: CGSize.init(width: 15, height: 15))
        
    }
}
