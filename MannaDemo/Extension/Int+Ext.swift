//
//  Int+Ext.swift
//  MannaDemo
//
//  Created by 정재인 on 2020/11/12.
//

import Foundation

extension Int {
    func dateFormatted(withFormat format : String) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(self))
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = format
             return dateFormatter.string(from: date)
        }
    
    func getTime() -> String {
        var result: String = ""
        
        let hourFormatter = DateFormatter().then {
            $0.locale = Locale(identifier: "ko")
            $0.dateFormat = "HH"
        }
        let minuteFormatter = DateFormatter().then {
            $0.locale = Locale(identifier: "ko")
            $0.dateFormat = "mm"
        }
        
        let currentDate = Date(timeIntervalSince1970: TimeInterval(self / 1000))
        let currentHour = hourFormatter.string(from: currentDate)
        let currentMinute = minuteFormatter.string(from: currentDate)
        
        if Int(currentHour)! >= 0 && Int(currentHour)! < 12 {
            
            result = "\(currentHour)" == "00" ? "오전 12:\(currentMinute)" : "오전 \(currentHour.trimmingCharacters(in: ["0"])):\(currentMinute)"
//            result = "오전 \(currentHour.trimmingCharacters(in: ["0"])):\(currentMinute)"
        } else {
            result = "오후 \(Int(currentHour)! - 12):\(currentMinute)"
        }
        
        return result
    }
}
