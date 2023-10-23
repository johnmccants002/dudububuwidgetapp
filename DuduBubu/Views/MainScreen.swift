//
//  MainScreen.swift
//  DuduBubu
//
//  Created by John McCants on 10/20/23.
//

import SwiftUI
import WidgetKit

struct MainScreen: View {
    @AppStorage("image", store: UserDefaults(suiteName: "group.com.johnmccants.DuduBubu")) var image = "Subject"
   
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isShowingSettingsView = false
    @State private var isShowingRequestsView = false

    var body: some View {
        NavigationView {  // Wrap everything inside a NavigationView
            VStack {
                VStack {
                    Text("Preview")
                        .font(.headline)
                        .padding(.top)
                    
                    VStack {
                        Image(viewModel.user?.widgetImage != nil ? viewModel.selectedImage : "")
                            .resizable()
                            .scaledToFit()
                            .padding(20) // You can adjust this padding based on your widget content's needs
                    }
                    .frame(width: 200, height: 200, alignment: .center)
                    .background(viewModel.user?.widgetImage != nil ? viewModel.backgroundColor : nil)
                    .cornerRadius(30) // More rounded corners to resemble iOS widgets
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5) // Adds shadow
                    .padding(.bottom)
                }
                .padding()
                ColorPicker("Background Color", selection: $viewModel.backgroundColor)
                
               
                
                Text("Select a \(viewModel.selectedCharacter == 0 ? "Dudu" : "Bubu")")
                    .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0))
                    .font(.title3)
                
                ScrollView {
                    ImageSlider(character: viewModel.selectedCharacter == 0 ? "Dudu" : "Bubu", selectedImageName: $viewModel.selectedImage)
                }
           
                
                Button(action: {
                    image = viewModel.selectedImage
                    WidgetCenter.shared.reloadTimelines(ofKind: "DuduBubuWidget")
                    viewModel.updateWidget(image: viewModel.selectedImage, backgroundColor: viewModel.backgroundColor.description)
                }) {
                    Text("Set Widget Status")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding()
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)
                        .padding(.horizontal, 20)
                }
            }
            .padding()
            .navigationBarTitle("DuduBubu", displayMode: .inline)  // Add a navigation title
            .navigationBarItems(trailing:   // Add a settings button on the top right
      
                NavigationLink(destination: Settings().environmentObject(AuthViewModel.shared), isActive: $isShowingSettingsView)
              {
                    Image(systemName: "gearshape")  // Use the gearshape symbol for settings
                }
            )
            .navigationBarItems(leading:
                                    NavigationLink(destination: Requests().environmentObject(AuthViewModel.shared), isActive: $isShowingRequestsView)
                                  {
                                        Image(systemName: "person")
                                    }
            
            )
            .toolbar {
                               ToolbarItem(placement: .principal) {
                                   Image("Subject3")
                                       .resizable()
                                       .scaledToFit()
                               }
                           }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
