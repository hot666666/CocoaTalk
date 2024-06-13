//
//  Date+Extension.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import Foundation

extension Date {
    var monthAndDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: self)
    }
    
    var fullDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    var YMDDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 EEEE"
        return dateFormatter.string(from: self)
    }
    
    
}
