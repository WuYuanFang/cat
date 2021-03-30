//
//  AC_XQShopCarVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD
import XQAlert

/// 购物车界面
class AC_XQShopCarVC: XQACBaseVC, AC_XQShopCarViewDelegate {
    
    let contentView = AC_XQShopCarView()
    let rightBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadNavigationTitle()
        
        self.xq_view.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        self.xq_navigationBar.backView.setBackImg(with: UIImage.init(named: "back_arrow")?.xq_image(withTintColor: .ac_mainColor))
        rightBtn.setTitle("管理", for: .normal)
        rightBtn.setTitleColor(.ac_mainColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        rightBtn.addTarget(self, action: #selector(respondsToManager), for: .touchUpInside)
        self.xq_navigationBar.contentView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.width.equalTo(80)
            make.height.equalTo(40)
            make.top.equalTo(0)
        }
        
        self.contentView.delegate = self
        
        self.contentView.footerView.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.deleteShop()
        }
        
        self.contentView.footerView.selectBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            sender?.isSelected.toggle()
            
            self.contentView.selectPidArr.removeAll()
            if sender?.isSelected ?? false {
                for item in self.contentView.dataArr {
                    let pid = item.OrderProductInfo?.Pid ?? 0
                    self.contentView.selectPidArr.append(pid)
                }
            }
            
            self.getData()
            
        }
        
        self.contentView.footerView.settlementBtn.xq_addTap { [unowned self] (sender) in
            self.pay()
        }
        
        self.contentView.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            self.getData()
        })
        self.contentView.tableView.mj_header?.beginRefreshing()
    }
    
    func reloadNavigationTitle() {
        if self.contentView.dataArr.count == 0 {
            self.xq_navigationBar.setTitle("购物车")
        }else {
            self.xq_navigationBar.setTitle("购物车(\(self.contentView.dataArr.count))")
        }
        self.xq_navigationBar.backView.titleLab.textColor = .ac_mainColor
    }
    
    /// 去结算
    func pay() {
        
        // 必加蜜, 直接传这个 model 过去
//        self.contentView.cartInfo
        
        self.getData { [unowned self] (cartModel) in
            if cartModel?.CartInfo?.SelectedOrderProductList?.count ?? 0 == 0 {
                SVProgressHUD.showInfo(withStatus: "请选择商品")
                return
            }
            let vc = AC_XQShopMallOrderVC()
            vc.cartModel = cartModel
            vc.isShopCar = true
            vc.callback = { [unowned self] in
                self.contentView.tableView.mj_header?.beginRefreshing()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    /// 删除商品
    func deleteShop() {
        
        if self.contentView.selectPidArr.count == 0 {
            return
        }
        
        XQSystemAlert.alert(withTitle: "是否要删除选中的商品", message: nil, contentArr: ["删除"], cancelText: "取消", vc: self, contentCallback: { (alert, index) in
            
            SVProgressHUD.show(withStatus: nil)
            let reqModel = XQSMNTDelCartProductReqModel.init(PIds: self.contentView.selectPidArr)
            XQSMCartNetwork.delCartProduct(reqModel).subscribe(onNext: { (resModel) in
                
                if resModel.ErrCode != .succeed {
                    SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                    return
                }
                
                SVProgressHUD.dismiss()
                self.contentView.cartInfo = resModel.CartInfo
                
            }, onError: { (error) in
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }).disposed(by: self.disposeBag)
            
        }, cancelCallback: nil)
        
        
        
    }
    
    /// 获取数据
    func getData(_ callback: ( (_ cartModel: XQSMNTCartModel?) -> () )? = nil ) {
        let reqModel = XQSMNTCancelOrSelectCartItemReqModel.init(Selectpids: self.contentView.selectPidArr)
        XQSMCartNetwork.cancelOrSelectCartItem(reqModel).subscribe(onNext: { (resModel) in
            
            self.contentView.tableView.mj_header?.endRefreshing()
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.cartInfo = resModel.CartInfo
            
            callback?(resModel.CartInfo)
//            self.contentView.tableView.reloadData()
            
            self.reloadNavigationTitle()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            self.contentView.tableView.mj_header?.endRefreshing()
        }).disposed(by: self.disposeBag)
    }
    
    // MARK: - responds
    
    @objc func respondsToManager() {
        self.contentView.xq_isEditing = !self.contentView.xq_isEditing
        
        if self.contentView.xq_isEditing {
            self.rightBtn.setTitle("完成", for: .normal)
//            self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(respondsToManager)))
        }else {
            self.rightBtn.setTitle("管理", for: .normal)
//            self.xq_navigationBar.addRightBtn(with: UIBarButtonItem.init(title: "管理", style: .plain, target: self, action: #selector(respondsToManager)))
        }
        
        self.contentView.footerView.managerUILayout(self.contentView.xq_isEditing)
        
    }
    
    // MARK: - AC_XQShopCarViewDelegate
    
    /// 选中某个cell
    /// - Parameters:
    ///   - select: true 选中, false 取消
    func shopCarView(_ shopCarView: AC_XQShopCarView, didSelectRowAt indexPath: IndexPath, select: Bool) {
        self.getData()
    }
    
    /// 数量变化
    func shopCarView(_ shopCarView: AC_XQShopCarView, indexPath: IndexPath, _ numberView: XQNumberView, _ number: Float, _ increaseStatus: Bool) {
        
        let pid = self.contentView.dataArr[indexPath.row].OrderProductInfo?.Pid ?? 0
        let reqModel = XQSMNTChangeProductCountReqModel.init(pid: pid, buyCount: Int(number), Selectpids: self.contentView.selectPidArr)
        XQSMCartNetwork.changeProductCount(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.contentView.cartInfo = resModel.CartInfo
            self.getData()
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
    }
    

}

