//
//  AC_XQFosterView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SDCycleScrollView

class AC_XQFosterView: UIView {

    let scrollView = UIScrollView()
    
    /// 轮播图
    let cycleScrollView = SDCycleScrollView()
    
    let headerView = AC_XQBreedViewHeaderView()
    /// 商品评价
    let commentView = AC_XQCommodityDetailViewHeaderViewCommentView()
    /// 选择猫舍?
    let houseView = AC_XQFosterViewSelectHouseView()
    /// 绝育，驱虫
    let selectBaseView = AC_XQFosterViewSelectOtherView()
    /// 疫苗
    let selectVaccinesView = AC_XQFosterViewSelectOtherView()
    /// 加食, 接送, 监控
    let optionView = AC_XQFosterViewOptionView()
    /// 选择宠物
    let petView = AC_XQWashProtectViewSelectPetView()
    /// 选择预约时间
    let appointmentView = AC_XQFosertViewAppointmentTimeView()
    /// 选择寄养天数
    let dayView = AC_XQFosterViewDayView()
    
    /// 支付
    let payView = AC_XQWashProtectViewPayView()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.cycleScrollView.setBottomCorner(with: 40, height: 30)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cycleScrollView.bannerImageViewContentMode = .scaleAspectFill
        self.cycleScrollView.backgroundColor = UIColor.ac_mainColor
        self.xq_addSubviews(self.cycleScrollView, self.scrollView)
        
        self.cycleScrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.cycleScrollView.snp.width).multipliedBy(285.0/375.0)
        }
        
        self.scrollView.xq_addSubviews(self.headerView, self.commentView, self.appointmentView, self.petView, self.payView, self.dayView, self.houseView, self.selectBaseView, self.selectVaccinesView, self.optionView)
        
        // 布局
        
        self.scrollView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(-FootSafeHeight)
            make.top.equalTo(self.cycleScrollView.snp.bottom)
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        self.commentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.height.equalTo(30)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.houseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.commentView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        self.selectBaseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.houseView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.width.equalTo(140)
        }
        
        self.selectVaccinesView.snp.makeConstraints { (make) in
            make.top.equalTo(self.selectBaseView)
            make.left.equalTo(self.selectBaseView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        self.optionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.selectBaseView.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.petView.snp.makeConstraints { (make) in
            make.top.equalTo(self.optionView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.appointmentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.petView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.dayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.appointmentView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.payView.snp.makeConstraints { (make) in
            make.top.equalTo(self.dayView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        
        // 设置属性
        
        self.selectBaseView.fSwitchView.titleLab.text = "是否已绝育"
        self.selectBaseView.sSwitchView.titleLab.text = "是否已驱虫"
        
        self.selectVaccinesView.fSwitchView.titleLab.text = "是否已注射疫苗"
        self.selectVaccinesView.sSwitchView.titleLab.text = "是否已注射狂犬疫苗"
        
        
        
        // 暂时不要评论
        self.commentView.isHidden = true
        self.houseView.snp.remakeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



class AC_XQFosertViewAppointmentTimeView: AC_XQHomePageViewTableViewHeaderView {
    
    private let timeImgView = UIImageView()
    let timeLab = UILabel()
    
    private let changeBtn = UIButton()
    
    typealias AC_XQFosertViewAppointmentTimeViewCallback = () -> ()
    /// 改变了时间
    var callback: AC_XQFosertViewAppointmentTimeViewCallback?
    
    var date: Date?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.timeImgView, self.timeLab, self.changeBtn)
        
        // 布局
        self.timeImgView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 118, height: 51))
            make.bottom.equalToSuperview()
        }
        
        self.timeLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeImgView).offset(25)
            make.left.right.equalTo(self.timeImgView)
        }
        
        self.changeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.timeImgView)
            make.left.equalTo(self.timeImgView.snp.right).offset(12)
        }
        
        
        // 设置属性
        
        self.titleLab.text = "预约时间"
        self.subtitleLab.text = ""
        
        self.timeImgView.image = UIImage.init(named: "appointment_time")
        
        self.timeLab.text = Date().xq_toStringYMD()
        self.date = Date()
        
        self.timeLab.textColor = UIColor.white
        self.timeLab.font = UIFont.systemFont(ofSize: 15)
        self.timeLab.textAlignment = .center
        
        self.changeBtn.setTitle("更改", for: .normal)
        self.changeBtn.setImage(UIImage.init(named: "edit_gray"), for: .normal)
        self.changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.changeBtn.setTitleColor(.init(hex: "#999999"), for: .normal)
        
        self.imgView.image = UIImage.init(named: "foster_date")
        
        

        self.changeBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
            XQAlertSelectFosterAppointmentView.show(8, endHour: 21) { [unowned self] (date) in
                self.date = date
                self.timeLab.text = date.xq_toStringYMD()
                self.callback?()
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


