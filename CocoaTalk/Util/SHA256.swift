//
//  SHA256.swift
//  CocoaTalk
//
//  Created by 최하식 on 6/4/24.
//

import Foundation
import CryptoKit

func sha256(_ input: String) -> String {
    /// 고유성, 보안성(파일이름 모름), 성능최적화(일정한 길이를 가지므로, 파일시스템에서 효율적으로 관리가능)
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
