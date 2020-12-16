//
//  AC_XQSelectVarietiesVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import XQProjectTool

class AC_XQSelectVarietiesVC: XQACBaseVC, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    typealias AC_XQSelectVarietiesVCCallback = (_ sModel: AC_XQSelectVarietiesSectionModel, _ model: AC_XQSelectVarietiesModel) -> ()
    var callback: AC_XQSelectVarietiesVCCallback?
    
    
    let searchView = AC_XQSelectVarietiesVCSearchView()
    
    private let result = "cell"
    private let headerResult = "headerResult"
    var tableView: UITableView!
    var dataArr = [AC_XQSelectVarietiesSectionModel]()
    /// 原分区数据 model
    var osModelArr = [AC_XQSelectVarietiesSectionModel]()
    /// 搜索 model
    var modelArr = [AC_XQSelectVarietiesModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        self.getData()
    }
    
    func initTableView() {
        
        self.xq_navigationBar.contentView.addSubview(self.searchView)
        
        self.tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        self.xq_view.addSubview(self.tableView)
        
        // 布局
        
        
        self.searchView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.xq_navigationBar.backView.snp.right).offset(12)
            make.right.equalTo(-12)
            make.height.equalTo(40)
        }
        
        self.tableView.snp.makeConstraints { (make) in
//            make.top.equalTo(self.searchView.snp.bottom)
//            make.left.right.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        
        // 设置属性
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: result)
        self.tableView.register(AC_XQSelectVarietiesVCHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: self.headerResult)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 44
        self.tableView.tableFooterView = UIView()
//        self.tableView.sectionHeaderHeight = 44
//        self.tableView.separatorStyle = .none
        
        self.tableView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.tableView.backgroundView?.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.xq_navigationBar.statusView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.xq_navigationBar.contentView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.xq_navigationBar.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        self.searchView.tf.delegate = self
        self.searchView.tf.addTarget(self, action: #selector(notification_tfChange(_:)), for: .editingChanged)
        self.searchView.layer.cornerRadius = 10
        self.searchView.layer.masksToBounds = true
        self.searchView.backgroundColor = UIColor.white
    }
    
    func getData() {
        let reqModel = XQSMNTPetGetAllPetVarietiesReqModel()
        SVProgressHUD.show(withStatus: nil)
        XQSMUserPetNetwork.getAllPetVarieties(reqModel).subscribe(onNext: { (resModel) in
            
            if resModel.ErrCode != .succeed {
                SVProgressHUD.showError(withStatus: resModel.ErrMsg)
                return
            }
            
            self.xq_analysisData(with: resModel.PetVarieties)
            
        }, onError: { (error) in
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }).disposed(by: self.disposeBag)
        
//        #if DEBUG
//        self.xq_analysisData(with: [
//            "h",
//            "测试",
//            "啊",
//            "张三",
//            "李四",
//            "王五",
//            "赵六",
//            "逼逼",
//        ])
//        #endif
    }
    
    func xq_analysisData(with strArr: [String]) {
        
        SVProgressHUD.show(withStatus: nil)
        
        DispatchQueue.init(label: "SelectVarietiesVC_pinyin").async {
            
            var sectionModelArr = [AC_XQSelectVarietiesSectionModel]()
            
            // 创建相对于的model, 并且解析拼音
            var modelArr = [AC_XQSelectVarietiesModel]()
            for item in strArr {
                
                let model = AC_XQSelectVarietiesModel()
                model.title = item
                model.pinyin = NSString.xq_transform(toPinyin: item)
                model.pinyinSearch = NSString.xq_transform(toSearchPinyin: item)
                
                modelArr.append(model)
            }
            
            // 排序
            modelArr.sort { (m1, m2) -> Bool in
                m1.pinyin < m2.pinyin
            }
            
            // 分组
            var lastPY = "-"
            for item in modelArr {
                print(item.title, item.pinyin)
                if item.pinyin.hasPrefix(lastPY) {
                    // 同一组
                    sectionModelArr.last?.modelArr.append(item)
                    
                }else {
                    // 不同组了
                    let sModel = AC_XQSelectVarietiesSectionModel()
                    lastPY = String(item.pinyin.prefix(1))
                    sModel.sectionTitle = lastPY.uppercased()
                    sModel.modelArr.append(item)
                    sectionModelArr.append(sModel)
                }
            }
            
            DispatchQueue.main.async {
                self.modelArr = modelArr
                self.osModelArr = sectionModelArr
                self.dataArr = sectionModelArr
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr[section].modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: result, for: indexPath)
        
        cell.textLabel?.text = self.dataArr[indexPath.section].modelArr[indexPath.row].title
        
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        var arr = [String]()
        
        if self.dataArr.count <= 1 {
            return arr
        }
        
        for item in self.dataArr {
            if item.sectionTitle.count >= 1 {
                let a = String(item.sectionTitle.prefix(1))
                arr.append(a)
            }else {
                arr.append("#")
            }
        }
        return arr
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sModel = self.dataArr[indexPath.section]
        self.callback?(sModel, sModel.modelArr[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: self.headerResult) as? AC_XQSelectVarietiesVCHeaderView
        
        headerView?.titleLab.text = self.dataArr[section].sectionTitle
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.dataArr.count <= 1 {
            return 0
        }
        return 44
    }
    
    // MARK: - notificaiton
    @objc
    func notification_tfChange(_ sender: UITextField) {
        if sender.text?.count ?? 0 == 0 {
            self.dataArr = self.osModelArr
            self.tableView.reloadData()
            return
        }
        
        if let models = NSString.xq_filterData(withDataArr: self.modelArr, filterKey: "title", filterText: sender.text) as? [AC_XQSelectVarietiesModel] {
            let sModel = AC_XQSelectVarietiesSectionModel.init()
            sModel.modelArr = models
            self.dataArr = [sModel]
            self.tableView.reloadData()
        }
        
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}


class AC_XQSelectVarietiesSectionModel: NSObject {
    
    @objc var sectionTitle = ""
    
    /// cell model
    @objc var modelArr = [AC_XQSelectVarietiesModel]()
    
    /// 随便传入任何值, 内部不做判断, 是给外部存一些额外的东西
    @objc var sectionId: Any?
    
}

class AC_XQSelectVarietiesModel: NSObject {
    
    @objc var title = ""
    
    /// 拼音
    @objc fileprivate var pinyin = ""
    
    /// 随便传入任何值, 内部不做判断, 是给外部存一些额外的东西
    @objc var mdoelId: Any?
    
    /// 用来搜索的拼音 + 中文
    @objc fileprivate var pinyinSearch = ""
    
}


