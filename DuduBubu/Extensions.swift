//
//  Extensions.swift
//  DuduBubu
//
//  Created by John McCants on 10/21/23.
//

import Foundation
import UIKit
import SwiftUI

extension Color {
    init?(description: String) {
        // Regex to extract floating point numbers from the string
        let regex = try! NSRegularExpression(pattern: "([0-9]*\\.?[0-9]+)", options: [])
        
        let matches = regex.matches(in: description, options: [], range: NSRange(location: 0, length: description.count))
        
        let numbers: [CGFloat] = matches.compactMap {
            guard let range = Range($0.range, in: description) else { return nil }
            return CGFloat(Float(description[range]) ?? 0)
        }
        
        guard numbers.count >= 4 else { return nil }
        
        self.init(.sRGB, red: Double(numbers[0]), green: Double(numbers[1]), blue: Double(numbers[2]), opacity: Double(numbers[3]))
    }
}
