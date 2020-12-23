//
//  AC_XQPetListChildrenView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol AC_XQPetListChildrenViewDelegate: NSObjectProtocol {
    
    /// 点击编辑
    func petListChildrenView(_ petListChildrenView: AC_XQPetListChildrenView, didSelectEditAt indexPath: IndexPath)
    
    /// 点击删除
    func petListChildrenView(_ petListChildrenView: AC_XQPetListChildrenView, didSelectDeleteAt indexPath: IndexPath)
    
    /// 前往相应的页面
    func getToOrderDetail(_ petListChildrenView: AC_XQPetListChildrenView, didSelectAt indexPath: IndexPath)
}

class AC_XQPetListChildrenView: UIView, UITableViewDataSource, UITableViewDelegate {
    

    private let result = "cell"
    var tableView: UITableView!
    var dataArr = [XQSMNTGetMyPetListUserPetInfoModel]()
    
    weak var delegate: AC_XQPetListChildrenViewDelegate?
    
    let addView = AC_XQPetListChildrenViewFooterView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.register(AC_XQPetListChildrenViewCell.classForCoder(), forCellReuseIdentifier: result)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        self.addView.frame = CGRect.init(x: 0, y: 0, width: 0, height: 60 + 12 * 2)
        self.tableView.tableFooterView = self.addView
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath) as! AC_XQPetListChildrenViewCell
        
        let model = self.dataArr[indexPath.row]
        
        cell.statusLab.isHidden = true
        cell.xq_maskView.isHidden = true
        
        cell.idLab.text = "ID:\(model.Id)"
        cell.titleLab.text = "\(model.NickName)"
        cell.messageLab.text = "\(model.PetVarieties) \(model.AgeDesc) \(model.Weight.xq_removeDecimalPointZero())kg"
        
        cell.iconImgView.sd_setImage(with: model.PhotoWithAddress.sm_getImgUrl())
        
        cell.statusView.reloadUI(model.State)
//        cell.statusView.reloadUI(.washProtect)
        
        cell.editBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.petListChildrenView(self, didSelectEditAt: indexPath)
        }
        
        cell.deleteBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.petListChildrenView(self, didSelectDeleteAt: indexPath)
        }
        
        cell.statusView.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            self.delegate?.getToOrderDetail(self, didSelectAt: indexPath)
        }
        
        if model.Sex == "母" {
            cell.genderImgView.image = UIImage.init(named: "gender_woman")
        }else {
            cell.genderImgView.image = UIImage.init(named: "gender_man")
        }
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

}

class AC_XQPetListChildrenViewFooterView: UIView {
    
    let imgView = UIImageView()
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.imgView)
        
        // 布局
        self.imgView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-12)
        }
        
        // 设置属性
        self.imgView.image = UIImage.init(named: "petList_add")
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.contentView.layer.shadowOpacity = 0.15
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
