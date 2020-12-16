//
//  XQDateString.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/13.
//  Copyright © 2020 WXQ. All rights reserved.
//

import Foundation

extension Date {
    
    /// 转为年月日字符串
    func xq_toStringYMD() -> String {
        return self.xq_toString("yyyy-MM-dd")
    }
    
    /// 转为年月字符串
    func xq_toStringYM() -> String {
        return self.xq_toString("yyyy-MM")
    }
    
    /// 转为年字符串
    func xq_toStringY() -> String {
        return self.xq_toString("yyyy")
    }
    
    /// 默认转为年月日时分秒字符串
    func xq_toString(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFor = DateFormatter()
        dateFor.dateFormat = dateFormat
        return dateFor.string(from: self)
    }
    
}

extension Date {
    
    /// 获取当前是周几
    func xq_weekdayStr() -> String {
        let wd = self.xq_weekday()
        
        var str = ""
        switch wd {
        case 1:
            str = "周日"
            
        case 2:
            str = "周一"
            
        case 3:
            str = "周二"
            
        case 4:
            str = "周三"
            
        case 5:
            str = "周四"
            
        case 6:
            str = "周五"
            
        case 7:
            str = "周六"
        default:
            break
        }
        
        return str
    }
    
    /// 获取当前是周几, 英文
    func xq_weekdayEnglishStr() -> String {
        let wd = self.xq_weekday()
        
        var str = ""
        switch wd {
        case 1:
            str = "Sunday"
            
        case 2:
            str = "Monday"
            
        case 3:
            str = "Tuesday"
            
        case 4:
            str = "Wednesday"
            
        case 5:
            str = "Thursday"
            
        case 6:
            str = "Friday"
            
        case 7:
            str = "Saturday"
        default:
            break
        }
        
        return str
    }
    
    /// 获取当前是周几
    /// 注意，周日是“1”，周一是“2”...
    func xq_weekday() -> Int {
        //        NSDate*date = [NSDate date];
        //
        //
        //        NSCalendar*calendar = [NSCalendar currentCalendar];
        //
        //
        //        NSDateComponents*comps;
        
        //        comps =[calendar components:(NSWeekCalendarUnit |NSWeekdayOrdinalCalendarUnit)
        //
        //
        //                                              fromDate:date];
        //
        //
        //        NSInteger week = [comps week]; // 今年的第几周
        //
        //        NSIntegerweekdayOrdinal = [comps weekdayOrdinal]; // 这个月的第几周
        
        let coms = Calendar.current.component(.weekday, from: self)
        return coms
    }
    
    /// 获取当前的一周时间
    static func xq_getCurrentWeekDates() -> [Date] {
        let result = Date().xq_weekday()
        var dates = [Date]()
        for item in 1...7 {
            let r = item - result
            let date = Date.init(timeIntervalSinceNow: TimeInterval(r * 24 * 60 * 60))
            dates.append(date)
        }
        
        return dates
    }
    
}

extension String {
    
    /// 年月日转为Date
    func xq_toDateYMD() -> Date? {
        return self.xq_toDate("yyyy-MM-dd")
    }
    
    /// 年月转为Date
    func xq_toDateYM() -> Date? {
        return self.xq_toDate("yyyy-MM")
    }
    
    /// 年转为Date
    func xq_toDateY() -> Date? {
        return self.xq_toDate("yyyy")
    }
    
    /// 转为Date
    func xq_toDate(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFor = DateFormatter()
        dateFor.dateFormat = dateFormat
        return dateFor.date(from: self)
    }
    
}


