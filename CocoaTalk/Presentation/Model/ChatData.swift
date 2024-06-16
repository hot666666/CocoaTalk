//
//  ChatData.swift
//  CocoaTalk
//
//  Created by hs on 6/14/24.
//

import Foundation

struct ChatData: Hashable, Identifiable {
    var dateStr: String
    var chats: [Chat]
    var id: String { dateStr }
}
