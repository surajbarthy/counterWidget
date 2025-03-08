//
//  Item.swift
//  MintTrackerDemo
//
//  Created by Suraj Barthy on 3/5/25.
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
