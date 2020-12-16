//
//  AC_XQOrderLogisticsViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/7.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQOrderLogisticsViewCell: UITableViewCell {

    let lineView = UIView()
    let imgView = UIImageView()
    let titleLab = UILabel()
//    let titleLab = UITextView()
    let timeLab = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.timeLab)
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        
        self.lineView.mas_makeConstraints { (make) in
            make?.top.bottom()?.equalTo()(self.contentView)
            make?.left.equalTo()(self.contentView)?.offset()(40)
            make?.width.mas_equalTo()(1)
        }
        
        let size = CGFloat(8)
        
        self.imgView.mas_makeConstraints { (make) in
            make?.center.equalTo()(self.lineView)
            make?.size.mas_equalTo()(CGSize.init(width: size, height: size))
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(self.lineView.snp.right).offset(30)
            make.right.equalToSuperview().offset(-16)
//            make.height.equalTo(200)
        }
        
        self.timeLab.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.titleLab.mas_bottom)?.offset()(4)
            make?.left.equalTo()(self.titleLab)
            make?.right.equalTo()(self.contentView)?.offset()(-30)
            make?.bottom.equalTo()(self.contentView)?.offset()(-20)
        }
        
        self.setViewType(false, lineType: 0)
        
        // 设置属性
        
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.titleLab.numberOfLines = 0
        
//        self.titleLab.dataDetectorTypes = .phoneNumber
//        self.titleLab.isEditable = false
//        self.titleLab.isSelectable = true
        
        self.timeLab.font = UIFont.systemFont(ofSize: 14)
        self.timeLab.textColor = UIColor.gray
        
        self.lineView.backgroundColor = UIColor.gray
        
        self.imgView.backgroundColor = UIColor.gray
        
        self.selectionStyle = .none
    }
    
    /// 改变布局
    ///
    /// - Parameters:
    ///   - done: 是否完成
    ///   - lineType: 0: 中间, 1: 第一个, 2: 最后一个, 3: 只有一个数据
    func setViewType(_ done: Bool, lineType: Int) {
        
        var textColor = UIColor.black
        var size = CGFloat(8)
        var image: UIImage? = nil
        
        if done {
            
            size = CGFloat(20)
            image = UIImage.init(named: "system_check_on")
            textColor = UIColor.ac_mainColor
            
        }
        
        if lineType == 0 {
            
            self.lineView.mas_remakeConstraints { (make) in
                make?.top.bottom()?.equalTo()(self.contentView)
                
                make?.left.equalTo()(self.contentView)?.offset()(40)
                make?.width.mas_equalTo()(1)
            }
            
        }else if lineType == 1 {
            
            self.lineView.mas_remakeConstraints { (make) in
                make?.height.equalTo()(self.contentView)?.multipliedBy()(0.5)
                make?.bottom.equalTo()(self.contentView)
                
                make?.left.equalTo()(self.contentView)?.offset()(40)
                make?.width.mas_equalTo()(1)
            }
            
            
            
        }else if lineType == 2 {
            
            self.lineView.mas_remakeConstraints { (make) in
                make?.height.equalTo()(self.contentView)?.multipliedBy()(0.5)
                make?.top.equalTo()(self.contentView)
                
                make?.left.equalTo()(self.contentView)?.offset()(40)
                make?.width.mas_equalTo()(1)
            }
            
        }else if lineType == 3 {
            
            self.lineView.mas_remakeConstraints { (make) in
                make?.height.mas_equalTo()(1)
                make?.centerY.equalTo()(self.contentView)
                
                make?.left.equalTo()(self.contentView)?.offset()(40)
                make?.width.mas_equalTo()(1)
            }
            
        }
        
        self.imgView.mas_remakeConstraints { (make) in
            make?.centerX.equalTo()(self.lineView)
            make?.centerY.equalTo()(self.contentView)
            make?.size.mas_equalTo()(CGSize.init(width: size, height: size))
        }
        
        self.imgView.layer.cornerRadius = size/2
        self.imgView.image = image
        self.titleLab.textColor = textColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
