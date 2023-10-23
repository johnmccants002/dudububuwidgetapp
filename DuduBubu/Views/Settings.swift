//
//  Settings.swift
//  DuduBubu
//
//  Created by John McCants on 10/20/23.
//

import SwiftUI

struct Settings: View {
    @State private var selectedPref = 0
    @State private var username: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var userFound: Bool = false
    @State private var selectedUser: User?
    @State private var showingAlert = false
    @State private var errorMessage = ""
    @State private var showErrorSearch = false
    @State private var selectedSex = 0
    
    let sexes = ["Dudu", "Bubu"]
    let preference = ["Dudu", "Bubu"]
    
    var body: some View {
        VStack {
            // Sex Picker
            HStack {
                Text("I am a ")
                    .font(.title3)
                    .fontWeight(.regular)
                    .padding()
                Spacer()
                Picker("DuduBubu", selection: $viewModel.selectedCharacter) {
                    ForEach(0 ..< sexes.count) {
                        Text(self.sexes[$0])
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: viewModel.selectedCharacter) { value in
                    print(value)
                    Task {
                        await viewModel.updateUserDuduBubu(character: sexes[value]) { err in
                            if let err = err {
                                print(err.localizedDescription)
                            }
                        }
                    }
                }
            }

            if let partner = viewModel.partner {
                VStack {
                    HStack {
                        Text("Your Partner")
                        Spacer()
                        Text("\(partner.username)")
                    }
                    .padding()
                    
                    Button(action: {
                        viewModel.removePartner(userId: partner.id)
                        
                    }, label: {
                        Text("Remove")
                    })
                }
            } else {
                // Search for username and send request
                if let sentRequest = viewModel.userSentRequest {
                    HStack {
                        Text("Request sent to \(sentRequest.username)")
                        Spacer()
                        Button("Revoke Request") {
                            viewModel.revokeSendRequest(userId: sentRequest.userId)
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 15) {
                        TextField("Search for username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        
                        if showErrorSearch {
                            Text("Dudu / Bubu not found or is taken")
                        }
                        
                        Button("Find your Partner") {
                            // Handle sending request logic here
                            print("Looking for user")
                            viewModel.searchQueryUsers(text: username) { user in
                                
                                if let user = user {
                                    selectedUser = user
                                    
                                } else {
                                    showErrorSearch = true
                                }
                            }
                            print("Request sent for username: \(username)")
                        }
                        .padding()
                        .background(selectedPref == 1 ? .pink.opacity(0.5) : .blue.opacity(0.5))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        if let selectedUser = selectedUser {
                            VStack {
                                if let character = selectedUser.character {
                                    Text("\(character) Found!")
                                    
                                } else {
                                    Text("Partner Found!")
                                    
                                }
                                
                                if let widgetImage = selectedUser.widgetImage {
                                    Image(widgetImage)
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    if let character = selectedUser.character {
                                        Image(character == "Dudu" ? "Dudu1" : "Bubu1")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                                
                                Button("Send Request") {
                                    
                                    viewModel.sendRequest(userId: selectedUser.id, username: selectedUser.username) { err in
                                        if let err = err {
                                            errorMessage = err.localizedDescription
                                            showingAlert = true
                                        }
                                    }
                                }
                                .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("Error"),
                                          message: Text(errorMessage),
                                          dismissButton: .default(Text("Ok")))
                                }
                            }
                            .frame(width: 400, height: 300, alignment: .center)
                        }
                    }
                    .padding(.top)
                }
            }

            Spacer()

            // Logout Button
            Button(action: {
                // Handle logout logic here
                viewModel.signout()
            }) {
                HStack {
                    Spacer() // push content to center
                    Text("Logout")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    Spacer() // push content to center
                }
            }
            .padding(.horizontal, 20) // Assuming 20 on each side to get 40 in total
            .padding(.bottom)
        }
    }
}

#Preview {
    Settings()
}
