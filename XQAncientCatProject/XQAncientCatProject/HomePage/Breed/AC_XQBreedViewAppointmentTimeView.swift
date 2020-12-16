//
//  AC_XQBreedViewAppointmentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import SVProgressHUD

class AC_XQBreedViewAppointmentTimeView: AC_XQHomePageViewTableViewHeaderView {
    
    private let disposeBag = DisposeBag()
    
    private let timeImgView = UIImageView()
    let timeLab = UILabel()
    
    private let changeBtn = UIButton()
    
    typealias AC_XQBreedViewAppointmentTimeViewCallback = () -> ()
    /// 改变了时间
    var callback: AC_XQBreedViewAppointmentTimeViewCallback?
    
    /// 附近商店信息
    private var _ShopInfo: XQSMNTToShopIndexModel?
    var ShopInfo: XQSMNTToShopIndexModel? {
        set {
            _ShopInfo = newValue
            self.reloadAppointmentDate()
        }
        get {
            return _ShopInfo
        }
    }
    
    
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
        
        
//        self.reloadAppointmentDate()
//        self.timeLab.text = self.getNowAppointmentTime()
//        let year = Date().xq_toStringY()
//        let dateStr = year + "年" + (self.timeLab.text ?? "")
//        if let date = dateStr.xq_toDate("yyyy年MM月dd日 HH:mm") {
//            self.date = date
//        }
        
        self.timeLab.textColor = UIColor.white
        self.timeLab.font = UIFont.systemFont(ofSize: 15)
        self.timeLab.textAlignment = .center
        
        self.changeBtn.setTitle("更改", for: .normal)
        self.changeBtn.setImage(UIImage.init(named: "edit_gray"), for: .normal)
        self.changeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.changeBtn.setTitleColor(.init(hex: "#999999"), for: .normal)
        
        self.imgView.image = UIImage.init(named: "foster_date")
        
        

        self.changeBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            
            let reqModel = XQSMNTToShopGetShopOrderTimeReqModel.init(shopId: self.ShopInfo?.Id ?? 0, theDateCount: 5)
            SVProgressHUD.show(withStatus: nil)
            XQSMToShopNetwork.getShopOrderTime(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                
                XQAlertSelectAppointmentView.show(resModel.Lss ?? []) { (date) in
                    self.date = date
                    self.timeLab.text = date.xq_toString("MM月dd日 HH:mm")
                    self.callback?()
                }
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 获取最近能能预约的时间点
    private func getNowAppointmentTime() -> String {
        
        let str = Date().xq_toString("MM月dd日 HH:mm")
        
        var mStr = str.components(separatedBy: ":").last ?? "45"
        
//        var hStr = str.components(separatedBy: " ").last?.components(separatedBy: ":").first ?? "01"
        
        if let m = Int(mStr) {
            
            let result = m + (15 - (m % 15))
            
            if result >= 60 {
                mStr = "00"
                // 这里不判断那么多了, 什么小时+1, h == 24 的
            }else {
                mStr = "\(result)"
            }
            
        }
        
        var arr = str.components(separatedBy: ":")
        arr[1] = mStr
        return arr.joined(separator: ":")
    }
    
    /// 获取最近可预约时间
    func reloadAppointmentDate() {
        let reqModel = XQSMNTToShopGetShopOrderTimeReqModel.init(shopId: self.ShopInfo?.Id ?? 0, theDateCount: 5)
        XQSMToShopNetwork.getShopOrderTime(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            // 获取最近可选的
            if let select = XQSMNTToShopGetShopOrderTimeResModel.getNormalSelectIndexPath(resModel.Lss ?? [], count: 1),
                let minuteModel = select.model.TimeList?[select.hour].SmallTimes?[select.minute] {
                
                let str = select.model.TheYear + "-" + select.model.TheMonth + "-" + select.model.TheDay + " " + minuteModel.TimeTitle
                if let date = str.xq_toDate("yyyy-MM-dd HH:mm") {
                    self.date = date
                    
                }
                
                self.timeLab.text = select.model.TheDate + " " + minuteModel.TimeTitle
                
                self.callback?()
            }
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    
    
    
}
