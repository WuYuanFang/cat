//
//  AC_XQMallSearchResultView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage

/// 瀑布流
class AC_XQMallSearchResultView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    let cellReuseIdentifier = "cellReuseIdentifier"
    var dataArr = [AC_XQMallSearchResultViewModel]()
    
    var columnWidth: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = XQWaterfallCollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = 30
        flowLayout.minimumInteritemSpacing = 16
        
        flowLayout.columnCount = 2
        self.columnWidth = (system_screenWidth - flowLayout.minimumInteritemSpacing)/CGFloat(flowLayout.columnCount)
        
//        flowLayout.estimatedItemSize = CGSize.init(width: flowLayout.columnWidth, height: 200)
        
        self.collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        self.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(AC_XQMallSearchResultViewCell.classForCoder(), forCellWithReuseIdentifier: self.cellReuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        
        
        self.collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [unowned self] in
            if self.collectionView.mj_footer?.isRefreshing ?? false {
                self.collectionView.mj_header?.endRefreshing()
                return
            }
            self.dataArr.removeAll()
            self.collectionView.reloadData()
            self.getData()
        })
        
        self.collectionView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: { [unowned self] in
            if self.collectionView.mj_header?.isRefreshing ?? false {
                self.collectionView.mj_footer?.endRefreshing()
                return
            }
            self.getData()
        })
        
        self.collectionView.mj_header?.beginRefreshing()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getData() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            for _ in 0..<100 {
                let model = AC_XQMallSearchResultViewModel()
                
                let imgRandom = arc4random() % 11
                
                if imgRandom == 0 {
                    model.url = "https://tse1-mm.cn.bing.net/th/id/OIP.TVnKyy6xC55gJJ20nKsAJwAAAA?pid=Api&rs=1"
                }else if imgRandom == 1 {
                    model.url = "https://tse2-mm.cn.bing.net/th/id/OIP.Op3I0izI06N6zLOrrsirLAAAAA?w=150&h=150&c=7&o=5&pid=1.7"
                }else if imgRandom == 2 {
                    model.url = "https://tse1-mm.cn.bing.net/th/id/OIP.XyNnnQRSex7owD9cWBiHfQAAAA?w=300&h=168&c=7&o=5&pid=1.7"
                }else if imgRandom == 3 {
                    model.url = "https://tse1-mm.cn.bing.net/th/id/OIP.YXG2vByq-corqZTSfKDzIgHaFS?w=274&h=188&c=7&o=5&pid=1.7"
                }else if imgRandom == 4 {
                    model.url = "https://tse4-mm.cn.bing.net/th/id/OIP.AHj1DEmYmh03bHLq3VlKxQAAAA?w=300&h=196&c=7&o=5&pid=1.7"
                }else if imgRandom == 5 {
                    model.url = "https://tse3-mm.cn.bing.net/th/id/OIP.61ZzdbNalH2C553YuPQt3AHaEq?w=277&h=178&c=7&o=5&pid=1.7"
                }else if imgRandom == 6 {
                    model.url = "https://tse4-mm.cn.bing.net/th/id/OIP.uvEdINtSXvrs_8aQ1s7-PwAAAA?w=178&h=180&c=7&o=5&pid=1.7"
                }else if imgRandom == 7 {
                    model.url = "https://tse2-mm.cn.bing.net/th/id/OIP.RMWKqwsXfGWcnSHtjg4KiwHaJ4?w=120&h=160&c=7&o=5&pid=1.7"
                }else if imgRandom == 8 {
                    model.url = "http://img1.3lian.com/2015/a1/136/d/242.jpg"
                }else if imgRandom == 9 {
                    model.url = "http://www.51pptmoban.com/d/file/2014/11/26/26916cef4190cdd6d3bca5368b89a346.jpg"
                }else {
                    
                    model.url = "https://tse1-mm.cn.bing.net/th/id/OIP.qAoDUpBBltIa1GobdGdpDgHaEo?w=296&h=181&c=7&o=5&pid=1.7"
                }
                
                self.dataArr.append(model)
            }
            
            self.collectionView.reloadData()
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.endRefreshing()
        }
        
    }
    
    func downLoadImg(_ cell: AC_XQMallSearchResultViewCell, indexPath: IndexPath) {
        let model = self.dataArr[indexPath.row]
        
        cell.imgView.sd_setImage(with: URL.init(string: model.url), placeholderImage: UIImage.init(named: "my_pet")) { [unowned self] (img, error, cacheType, url) in
            
            if let error = error {
                print("wxq error: ", error)
                return
            }
            
            if let img = img {
                let model = self.dataArr[indexPath.row]
                
                if model.imgSize == nil {
                    let scale = img.size.width / img.size.height
                    model.imgSize = CGSize.init(width: self.columnWidth, height: self.columnWidth / scale)
                    // 移除刷新动画
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadItems(at: [indexPath])
                    }
                    
                }
                
            }
            
            switch cacheType {
            case .none:
                print("none")
//                self.collectionView.reloadItems(at: [indexPath])
//                self.collectionView.reloadData()
            case .all:
                print("all")
            case .disk:
                print("disk")
            case .memory:
                print("memory")
            default:
                print("default")
            }
            
            print(img ?? "没有图片", indexPath)
        }
        
        
        return
        
        
        // 随机秒数, 加载图片的秒数
        let random = Float(arc4random() % 60)/10
        
        let after = 0.1 + random
        // 模拟下载图片延迟
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(Int(after * 1000))) {
            
            if let _ = self.dataArr[indexPath.row].imgSize {
                print("已经存在了")
                return
            }
            
            print("刷新: \(indexPath)")
            let width = (self.collectionView.frame.width - 16)/2
            let randomHeight = CGFloat(arc4random() % 200) + 100
            self.dataArr[indexPath.row].imgSize = CGSize.init(width: width, height: randomHeight)
            
//            self.collectionView.reloadItems(at: [indexPath])
            self.collectionView.reloadData()
        }
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! AC_XQMallSearchResultViewCell
        
        cell.contentView.backgroundColor = UIColor.red
        
        let model = self.dataArr[indexPath.row]
        
        self.downLoadImg(cell, indexPath: indexPath)
        if model.imgSize == nil {
            cell.titleLab.text = "\(indexPath.row)请求中."
        }else {
            cell.titleLab.text = "\(indexPath.row)"
        }
        
        cell.bottomLab.text = "\(indexPath.row)"
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let model = self.dataArr[indexPath.row]

        if let size = model.imgSize {
            return CGSize.init(width: self.columnWidth, height: size.height + 40)
        }
        
        return CGSize.init(width: self.columnWidth, height: 100)
    }
    
}


class AC_XQMallSearchResultViewModel: NSObject {
    
    var imgSize: CGSize?
    
    var url: String = ""
    
    
}
