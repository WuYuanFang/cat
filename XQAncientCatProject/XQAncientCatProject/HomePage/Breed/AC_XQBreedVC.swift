//
//  AC_XQBreedVC.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/4.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 繁育
class AC_XQBreedVC: XQACBaseVC {
    
    let contentView = AC_XQBreedView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.xq_navigationBar.statusView.backgroundColor = UIColor.clear
        self.xq_navigationBar.contentView.backgroundColor = UIColor.clear
        self.xq_navigationBar.backgroundColor = UIColor.clear
        
        self.view.insertSubview(self.contentView, belowSubview: self.xq_navigationBar)
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.left.right.equalToSuperview()
            
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
