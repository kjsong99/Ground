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
