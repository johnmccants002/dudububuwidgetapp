//
//  SignUpView.swift
//  DuduBubu
//
//  Created by John McCants on 10/18/23.
//

import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var email: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isShowingSelection = false
    @State var character: String = ""
    
    @State var phase: Int = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if phase == 0 {
                    DubuBubuSelection(phase: $phase, character: $character)
                } else {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 50)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email")
                            .font(.headline)
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        Text("Username")
                            .font(.headline)
                        TextField("Enter your username", text: $username)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        Text("Password")
                            .font(.headline)
                        SecureField("Enter your password", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        
                        Text("Confirm Password")
                            .font(.headline)
                        SecureField("Confirm your password", text: $confirmPassword)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    
                    Button(action: {
                        viewModel.registerUser(email: email, password: password, username: username, character: character)
                        
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
