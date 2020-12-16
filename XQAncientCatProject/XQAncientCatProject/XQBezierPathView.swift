//
//  XQBezierPathView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/1/6.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQBezierPathView: UIView {

    override func draw(_ rect: CGRect) {
        
        let color = UIColor.orange
        color.set()
        
        
        let p0: CGFloat = 5
        let p1: CGFloat = 20
        let p2: CGFloat = 30
        let p3: CGFloat = 80
        
        
        let bezierPath = UIBezierPath.init()
        bezierPath.move(to: CGPoint.init(x: 20, y: 60))
        bezierPath.addLine(to: CGPoint.init(x: 10, y: p1))
        bezierPath.addLine(to: CGPoint.init(x: 30, y: p2))
        bezierPath.addLine(to: CGPoint.init(x: 50, y: p0))
        bezierPath.addLine(to: CGPoint.init(x: 70, y: p2))
        bezierPath.addLine(to: CGPoint.init(x: 90, y: p1))
        bezierPath.addLine(to: CGPoint.init(x: 80, y: p3))
        bezierPath.addLine(to: CGPoint.init(x: 25, y: p3))
        bezierPath.addLine(to: CGPoint.init(x: 23, y: 70))
        bezierPath.addLine(to: CGPoint.init(x: 70, y: 70))
//        bezierPath.close()
        
        bezierPath.lineWidth = 5
        
        bezierPath.stroke()
        
    }

}
