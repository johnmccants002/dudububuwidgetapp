//
//  LoginView.swift
//  DuduBubu
//
//  Created by John McCants on 10/18/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel : AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("Subject3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 50)

                Text("DuduBubu Widget App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 50)

                VStack(alignment: .leading, spacing: 15) {
                    Text("Username")
                        .font(.headline)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    Text("Password")
                        .font(.headline)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)

                Button(action: {
                    viewModel.login(email: email, password: password)
                }) {
                    Text("Login")
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

                NavigationLink(destination: SignUpView().environmentObject(AuthViewModel.shared)) {
                    Text("Don't have an account? Sign Up")
                        .fontWeight(.medium)
                }
                .padding(.bottom, 40)

            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



