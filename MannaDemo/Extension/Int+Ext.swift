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
}
