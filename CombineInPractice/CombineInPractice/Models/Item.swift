//
//  Item.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 12/9/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
