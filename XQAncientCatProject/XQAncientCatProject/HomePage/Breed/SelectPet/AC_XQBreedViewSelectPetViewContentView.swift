//
//  AC_XQBreedViewSelectPetViewContentView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import XQProjectTool_iPhoneUI

class AC_XQBreedViewSelectPetViewContentView: UIView {
    
    private let contentView = UIView()
    
    let maoxianView = XQSwitchRowView()
    let quchongView = XQSwitchRowView()
    let zhijiaView = XQSwitchRowView()
    let xizaoView = XQSwitchRowView()
    
    /// 警告
    let waringBtn = QMUIButton()
    
    /// 是否曾经繁育成功过
    let alreadBreedView = XQSelectRowView()
    
    let labelCollectionView = XQLabelCollectionView.init(frame: .zero, type: .equalSpacing, dataArr: [
        "6个月以内",
        "6-12个月",
        "一年以上",
    ], cellBorderColor: UIColor.ac_mainColor,
       cellSelectBackColor: UIColor.ac_mainColor,
       cellSelectTitleColor: UIColor.white,
       cellNormalTitleColor: UIColor.ac_mainColor,
       defaultSelectIndexPath: .init(row: 0, section: 0))
    
    /// 周期
    let cycleTimeView = XQRowNumberView()
    
    /// 时长
    let durationTimeView = XQRowNumberView()
    
    /// 性格
    let characterView = XQRowTagView()
    
    /// 能否接受猫咪到新的环境繁育
    let environmentalView = XQSelectRowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.contentView)
        
        self.contentView.xq_addSubviews(self.maoxianView, self.quchongView, self.zhijiaView, self.xizaoView, self.waringBtn, self.alreadBreedView, self.labelCollectionView, self.cycleTimeView, self.durationTimeView, self.characterView, self.environmentalView)
        
        
        // 布局
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        self.maoxianView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(20)
        }
        
        self.zhijiaView.snp.makeConstraints { (make) in
            make.top.equalTo(self.maoxianView.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
        }
        
        self.quchongView.snp.makeConstraints { (make) in
            make.top.equalTo(self.maoxianView)
            make.right.equalTo(-16)
        }
        
        self.xizaoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.zhijiaView)
            make.left.equalTo(self.quchongView)
        }
        
        self.waringBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.zhijiaView.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
        }
        
        // 这里少一个检查报告...因为UI不明确
        
        self.alreadBreedView.snp.makeConstraints { (make) in
            make.top.equalTo(self.waringBtn.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
            make.right.equalTo(self.quchongView)
            make.height.equalTo(44)
        }
        
        self.labelCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.alreadBreedView.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
            make.right.equalTo(self.quchongView)
            make.height.equalTo(75)
            
        }
        
        self.cycleTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.labelCollectionView.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
            make.right.equalTo(self.quchongView)
            make.height.equalTo(30)
        }
        
        self.durationTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cycleTimeView.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
            make.right.equalTo(self.quchongView)
            make.height.equalTo(30)
        }
        
        self.characterView.snp.makeConstraints { (make) in
            make.top.equalTo(self.durationTimeView.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
            make.right.equalTo(self.quchongView)
            make.height.equalTo(30)
        }
        
        self.environmentalView.snp.makeConstraints { (make) in
            make.top.equalTo(self.characterView.snp.bottom).offset(20)
            make.left.equalTo(self.maoxianView)
            make.right.equalTo(self.quchongView)
            make.height.equalTo(30)
            make.bottom.equalTo(-35)
        }
        
        // 设置属性
        
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 10
//        self.contentView.layer.shadowOffset = CGSize.init(width: 8, height: 8)
        self.contentView.layer.shadowOpacity = 0.15
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        
        self.configSwitchView(self.maoxianView, title: "是否有猫藓")
        self.configSwitchView(self.zhijiaView, title: "是否剪指甲")
        self.configSwitchView(self.quchongView, title: "是否驱虫")
        self.configSwitchView(self.xizaoView, title: "是否洗澡")
        
        self.waringBtn.setImage(UIImage.init(named: "waring"), for: .normal)
        self.waringBtn.setTitle("匹配成功后预约到店繁育前3天进行处理", for: .normal)
        self.waringBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        self.configSelectRowView(self.alreadBreedView, title: "是否曾经繁育成功", sureTitle: "是", cancelTitle: "否")
        
        self.alreadBreedView.rightBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            sender?.isSelected.toggle()
        }
        
        self.alreadBreedView.leftBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            sender?.isSelected.toggle()
        }
        
        
        self.configSelectRowView(self.environmentalView, title: "能否接受猫咪到新的环境繁育", sureTitle: "能", cancelTitle: "否")
        
        self.environmentalView.rightBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            sender?.isSelected.toggle()
        }
        
        self.environmentalView.leftBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            sender?.isSelected.toggle()
        }
        
        self.labelCollectionView.titleLab.text = "选择上一次繁育时间间隔"
        self.labelCollectionView.collectionView.isScrollEnabled = false
        
        
        self.cycleTimeView.titleLab.text = "发情周期时间"
        self.cycleTimeView.titleLab.font = UIFont.systemFont(ofSize: 15)
        self.cycleTimeView.numberView.increaseBtn.setImage(UIImage.init(named: "arrow_down_mainColor"), for: .normal)
        
        self.durationTimeView.titleLab.text = "每次发情持续时间"
        self.durationTimeView.numberView.increaseBtn.setBackgroundImage(UIImage.init(named: "arrow_right_mainColor"), for: .normal)
        self.durationTimeView.numberView.decreaseBtn.setBackgroundImage(UIImage.init(named: "arrow_left_mainColor"), for: .normal)
        self.durationTimeView.numberView.suffix = "天"
        self.durationTimeView.numberView.minValue = 1
            
        
        self.characterView.titleLab.text = "猫咪的性格"
//            .decreaseBtn.setImage(UIImage.init(named: "arrow_down_mainColor"), for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configSwitchView(_ switchView: XQSwitchRowView, title: String) {
        switchView.widthAutoLayout()
        switchView.titleLab.text = title
    }
    
    private func configSelectRowView(_ rowView: XQSelectRowView, title: String, sureTitle: String, cancelTitle: String) {
        rowView.titleLab.text = title
        rowView.leftBtn.setTitle(sureTitle, for: .normal)
        rowView.leftBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        rowView.leftBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        rowView.leftBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
        
        rowView.rightBtn.setTitle(cancelTitle, for: .normal)
        rowView.rightBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        rowView.rightBtn.setImage(UIImage.init(named: "select_round_0"), for: .normal)
        rowView.rightBtn.setImage(UIImage.init(named: "select_round_1"), for: .selected)
    }
    
}


/// 选择数量
class XQRowNumberView: UIView {
    
    let titleLab = UILabel()
    let numberView = XQNumberView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.numberView)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.numberView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo(120)
        }
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        
        self.numberView.tf.backgroundColor = UIColor.init(hex: "#F3F3F3")
        self.numberView.tf.textColor = UIColor.init(hex: "#656565")
        self.numberView.btnSize = CGSize.init(width: 25, height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/// 标签
class XQRowTagView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titleLab = UILabel()
    
    var collectionView: UICollectionView!
    private let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        
        let flowLayout = XQEqualSpaceFlowLayout.init(wthType: .right)
        flowLayout.betweenOfCell = 12
        
        flowLayout.estimatedItemSize = CGSize.init(width: 60, height: 30)
//        flowLayout.minimumLineSpacing = 6
//        flowLayout.minimumInteritemSpacing = 6
        flowLayout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.right.equalToSuperview()
        }
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(XQRowTagViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView?.backgroundColor = UIColor.clear
        
        self.dataArr = [
            "温顺", "孤僻", "活泼好动"
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! XQRowTagViewCell
        cell.titleLab.text = self.dataArr[indexPath.row]
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
}

class XQRowTagViewCell: UICollectionViewCell {
    
    let titleLab = UILabel()
    
    var selectBackColor = UIColor.ac_mainColor
    var selectTitleColor = UIColor.white
    
    var normalBackColor = UIColor.white
    var normalTitleColor = UIColor.ac_mainColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.bottom.equalTo(-4)
            make.left.equalTo(7)
            make.right.equalTo(-7)
        }
        
        
        // 设置属性
        
        self.titleLab.font = UIFont.systemFont(ofSize: 12)
        self.titleLab.textAlignment = .center
        
        self.contentView.layer.cornerRadius = 4
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.titleLab.textColor = self.normalTitleColor
        self.contentView.backgroundColor = self.normalBackColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}




