//
//  AC_XQPetListChildrenViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool

class AC_XQPetListChildrenViewCell: AC_XQShadowCell {
    
    let xq_maskView = UIView()
    
    let iconImgView = UIImageView()
    let deleteBtn = UIButton()
    
    let titleLab = UILabel()
    let genderImgView = UIImageView()
    let idLab = UILabel()
    let messageLab = UILabel()
    let editBtn = UIButton()
    
    let statusLab = UILabel()
    let statusView = AC_XQPetListChildrenViewCellStatusView()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.xq_contentView.xq_addSubviews(self.iconImgView, self.deleteBtn, self.titleLab, self.genderImgView, self.idLab, self.messageLab, self.editBtn, self.statusLab, self.statusView, self.xq_maskView)
        
        // 布局
        
        self.xq_maskView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let iconImgViewSize: CGFloat = 60
        self.iconImgView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(25)
            make.bottom.equalTo(-25)
            make.size.equalTo(CGSize.init(width: iconImgViewSize, height: iconImgViewSize))
        }
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView.snp.bottom)
            make.right.equalTo(self.iconImgView.snp.left)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImgView).offset(-3)
            make.left.equalTo(self.iconImgView.snp.right).offset(20)
        }
        
        self.genderImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.left.equalTo(self.titleLab.snp.right).offset(8)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        
        self.idLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.left.equalTo(self.genderImgView.snp.right).offset(8)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self.iconImgView)
            make.top.equalTo(self.titleLab.snp.bottom).offset(8)
            make.left.equalTo(self.titleLab)
        }
        
        self.editBtn.snp.makeConstraints { (make) in
//            make.bottom.equalTo(self.iconImgView)
            make.top.equalTo(self.messageLab.snp.bottom).offset(8)
            make.left.equalTo(self.titleLab)
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.statusLab.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.right.equalTo(-15)
        }
        
        self.statusView.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(30)
        }
        
        
        // 设置属性
        self.iconImgView.layer.cornerRadius = iconImgViewSize/2
        self.iconImgView.layer.masksToBounds = true
        self.iconImgView.backgroundColor = UIColor.ac_mainColor
        
        self.titleLab.font = UIFont.boldSystemFont(ofSize: 16)
        
        self.messageLab.font = UIFont.systemFont(ofSize: 15)
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        
        self.idLab.font = UIFont.systemFont(ofSize: 13)
        self.idLab.textColor = UIColor.init(hex: "#999999")
        
        self.statusLab.font = UIFont.systemFont(ofSize: 14)
        
        self.deleteBtn.setBackgroundImage(UIImage.init(named: "pet_delete"), for: .normal)
        self.editBtn.setBackgroundImage(UIImage.init(named: "edit"), for: .normal)
        
        self.xq_maskView.backgroundColor = UIColor.init(xq_rgbWithR: 220, g: 220, b: 220, alpha: 0.5)
        
        self.genderImgView.image = UIImage.init(named: "gender_man")
        self.titleLab.text = "糯米"
        self.idLab.text = "ID:1244556677"
        self.messageLab.text = "布偶猫 3个月 1.5"
        self.statusLab.text = "已注销"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class AC_XQPetListChildrenViewCellStatusView: UIButton {
    
    let titleLab = UILabel()
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.imgView)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.left.right.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLab.snp.bottom).offset(6)
            make.size.equalTo(CGSize.init(width: 25, height: 25))
        }
        
        // 设置属性
        
        self.titleLab.numberOfLines = 0
        self.titleLab.textColor = UIColor.white
        self.titleLab.textAlignment = .center
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        
        self.imgView.image = UIImage.init(named: "pet_arrow")
        
        self.titleLab.text = """
        繁
        育
        中
        """
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadUI(_ state: XQSMNTGetMyPetListReqModel.PetState) {
        
        self.isHidden = false
        
        switch state {
        case .breed:
            self.titleLab.text = """
            繁
            育
            中
            """
            self.backgroundColor = UIColor.init(hex: "#AFC4C6")
            
        case .foster:
            self.titleLab.text = """
            寄
            养
            中
            """
            self.backgroundColor = UIColor.init(hex: "#B1D2EB")
            
        case .washProtect:
            self.titleLab.text = """
            洗
            护
            中
            """
            self.backgroundColor = UIColor.init(hex: "#EBD4B1")
            
        default:
            self.isHidden = true
            break
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.xq_corners_addRoundedCorners([.bottomLeft], withRadii: CGSize.init(width: self.frame.width/2, height: self.frame.width/2))
        
    }
    
    
    
}


