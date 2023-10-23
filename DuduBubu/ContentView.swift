//
//  ContentView.swift
//  DuduBubu
//
//  Created by John McCants on 10/18/23.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage("image", store: UserDefaults(suiteName: "group.com.johnmccants.DuduBubu")) var image = "Subject"
    
    @State private var selectedImageFromGallery: String = "Subject"
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    func checkThis() {
        guard let defaults = UserDefaults(suiteName: "group.com.johnmccants.DuduBubu") else { return }
        print(defaults.value(forKey: "selectedImageName"))
    }
    var body: some View {
        
        if viewModel.userSession != nil {
            MainScreen()
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
