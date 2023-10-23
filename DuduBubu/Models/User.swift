//
//  User.swift
//  TwitterSwiftUI
//
//  Created by John McCants on 7/4/22.
//

import Foundation
import Firebase

struct User: Identifiable {
    let id, username, email: String
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == self.id }
    var partner: String?
    var widgetImage: String?
    var backgroundString: String?
    var character: String?
    
    
    
    init(dict: [String: Any]) {
        self.id = dict["uid"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.partner = dict["partner"] as? String ?? nil
        self.widgetImage = dict["widgetImage"] as? String ?? nil
        self.backgroundString = dict["background"] as? String ?? nil
        self.character = dict["character"] as? String ?? nil
        
        
    }
    
}

struct SentRequest {
    let username, userId: String
    
    init(dict: [String: Any]) {
        self.username = dict["username"] as? String ?? ""
        self.userId = dict["userId"] as? String ?? ""
    }
}
