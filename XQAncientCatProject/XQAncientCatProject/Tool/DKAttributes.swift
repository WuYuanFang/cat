//
//  DKAttributes.swift
//  Cooperation
//
//  Created by yuanfang wu on 2020/7/16.
//  Copyright © 2020 wuyuanfang. All rights reserved.
//

import Foundation
import SwiftRichString


let blackStyle = Style {
    $0.color = UIColor.black
    $0.lineSpacing = 8
}
let color222Style = Style {
    $0.color = "#222222".color
    $0.lineSpacing = 6
}
let color888Style = Style {
    $0.color = "#888888".color
    $0.lineSpacing = 6
}
let blueStyle = Style {
    $0.color = UIColor.blue
    $0.lineSpacing = 6
}
let thremeStyle = Style {
    $0.color = UIColor.ac_mainColor
    $0.lineSpacing = 6
}
let redStyle = Style {
    $0.color = UIColor.red
    $0.lineSpacing = 6
}
let font14 = Style {
    $0.font = UIFont.systemFont(ofSize: 14)
}
let font15 = Style {
    $0.font = UIFont.systemFont(ofSize: 15)
}
let font16 = Style {
    $0.font = UIFont.systemFont(ofSize: 16)
}
let underBlueLine = Style {
    $0.underline = (.single, UIColor.blue)
}
let underRedLine = Style {
    $0.underline = (.single, UIColor.red)
}
let underThremeLine = Style {
    $0.underline = (.single, UIColor.ac_mainColor)
}
let lineSpace6 = Style {
    $0.lineSpacing = 6
}
let lineSpace8 = Style {
    $0.lineSpacing = 8
}
let lineSpace12 = Style {
    $0.lineSpacing = 12
}
let lineSpace18 = Style {
    $0.lineSpacing = 18
}
let centerStyle = Style {
    $0.alignment = .center
}
