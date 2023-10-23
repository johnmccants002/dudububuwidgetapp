//
//  DataService.swift
//  DuduBubuWidgetExtension
//
//  Created by John McCants on 10/18/23.
//

import Foundation
import SwiftUI

struct DataService {
    
    @AppStorage("image", store: UserDefaults(suiteName: "group.com.johnmccants.DuduBubu")) private var image = "Subject"
    
    func log() {
        image = "Subject2"
    }
    
    func progress() -> String {
        return image
    }
}
