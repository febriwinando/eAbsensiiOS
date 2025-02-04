//
//  Item.swift
//  eAbsensiTT
//
//  Created by Diskominfo Tebing Tinggi on 04/02/25.
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
