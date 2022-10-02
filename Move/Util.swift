//
//  Util.swift
//  Move
//
//  Created by 송경진 on 2022/10/02.
//

import Foundation

class Util{
    static func setDate(row: Int, inputDate: String) -> String? {
        let current_year_string = Date().year()
        let current_month_string = Date().month()
        let current_day_string = Date().day()
        let current_hour_string = Date().hour()
        
        guard let date = inputDate.dateUTC(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")else{
            return nil
        }
        if date.year() == current_year_string &&
            date.month() == current_month_string &&
            date.day() == current_day_string{
            if date.hour() == current_hour_string {
                return "방금전"
            }else{
                return String(Int(current_hour_string)! - Int(date.hour())!) + "시간 전"
            }
        }else{
            return date.month() + "월" + date.day() + "일"
        }
       
    }
}



extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func year() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
    
    func month() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter.string(from: self)
    }
    
    func day() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: self)
    }
    
    func hour() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: self)
    }
    
    func min() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter.string(from: self)
    }
    
    func stringUTC(format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}

extension String{
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func dateUTC(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
