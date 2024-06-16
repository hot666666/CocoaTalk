//
//  String+Extension.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/5/24.
//

import Foundation

extension String {
    var monthAndDay: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            let currentYear = Calendar.current.component(.year, from: Date())
            let yearOfDate = Calendar.current.component(.year, from: date)
            dateFormatter.dateFormat = yearOfDate == currentYear ? "M월 d일" : "yyyy년 M월 d일"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
