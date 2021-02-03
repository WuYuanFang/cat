//
//  DK_TimerManager.swift
//  XQAncientCatProject
//
//  Created by yuanfang wu on 2021/1/5.
//  Copyright © 2021 WXQ. All rights reserved.
//

import UIKit
import SwiftDate

let timeNoti = NSNotification.Name.init("TimerNoti")

class DK_TimerManager{
    
    /// 单例
    static let shared = DK_TimerManager()
    private init() {}
    private var timer:DispatchSourceTimer?
    
    // 初始化一个自定义的队列
    private var timerQueue = DispatchQueue.init(label: "com.dk.timerQueue")
    
    // 启动定制起，用于定时更新首页的发病时间和到院时间，并通知界面进行数据切换
    func startTimer() {
        
        if timer != nil && !(timer?.isCancelled ?? false) {
            timer?.cancel()
        }
        // 在global线程里创建一个时间源
        timer = DispatchSource.makeTimerSource(queue: timerQueue)
        // 设定这个时间源是每秒循环一次，立即开始
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        timer?.setEventHandler(handler: {
            // 每秒计时一次返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: timeNoti, object: nil)
            }
            
        })
        // 启动时间源
        timer?.resume()
    }
    
    // 取消时间源
    func cancelTimer() {
        if let time = timer {
            if !time.isCancelled {
                time.cancel()
            }
        }
    }
    
    // 获取时长
    static func getLastTime(_ timeStr:String?,_ type:RefundType) -> String {
        let json = UserDefaults.standard.string(forKey: "XQSMNTCommonGetSystemConfigResModel")
        guard let config = XQSMNTCommonGetSystemConfigResModel.deserialize(from: json) else{
            return ""
        }
        let hours = type == .wash ? config.ToOrderCanRefundTime : type == .foster ? config.FosterRefundTime : 1
        guard let time = timeStr?.xq_toDate() else {
            return ""
        }
        if (time + hours.hours).timeIntervalSince(Date()) > 0 {
            return transToHourMinSec(time: (time + hours.hours).timeIntervalSince(Date()))
        }else{
            return ""
        }
        
    }
    
    
    // 将时间转化为多少年多少月多少天多少小时多少分钟
    func resetTime(_ time:String) -> String {
        let totalTime = time.components(separatedBy: " ")
        var resultTime = ""
        var days = 0
        for str in totalTime {
            if str.contains("y") {
                if str != "0y" {
                    resultTime.append(contentsOf: str.replacingOccurrences(of: "y", with: "年"))
                }
            }else if str.contains("mo") {
                if str != "0mo" {
                    resultTime.append(contentsOf: " \(str.replacingOccurrences(of: "mo", with: "月"))")
                }
            }else if str.contains("w") {
                days += ((Int(str.replacingOccurrences(of: "w", with: "")) ?? 0) * 7)
            }else if str.contains("d") {
                days += Int(str.replacingOccurrences(of: "d", with: "")) ?? 0
                if days > 0 {
                    resultTime.append(contentsOf: " \(days)天")
                }
            }else {
                let strArr = str.components(separatedBy: ":")
                if strArr.count == 2 {
                    for index in 0..<strArr.count {
                        if index == 0 {
                            resultTime.append(contentsOf: "\(strArr[index])分钟")
                        }
                    }
                }else if strArr.count == 3 {
                    for index in 0..<strArr.count {
                        if index == 0 || index == 1 {
                            resultTime.append(contentsOf: "\(strArr[index])\(index == 0 ? "小时" : "分钟")")
                        }
                    }
                }
            }
        }
        return resultTime
    }
    // MARK: - 把秒数转换成时分秒（00:00:00）格式
    ///
    /// - Parameter time: time(Float格式)
    /// - Returns: String格式(00:00:00)
    static func transToHourMinSec(time: Double) -> String {
        let allTime: Int = Int(time)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    
}

enum RefundType {
    case wash      // 洗护
    case foster     // 寄养
    case shop       // 商城
}
