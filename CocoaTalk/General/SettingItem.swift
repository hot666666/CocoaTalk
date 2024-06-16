//
//  SettingItem.swift
//  CocoaTalk
//
//  Created by hs on 6/16/24.
//

import Foundation

protocol SettingItemable {
    var label: String { get }
}

struct SettingItem: Identifiable {
    let id = UUID()
    let item: SettingItemable
}
