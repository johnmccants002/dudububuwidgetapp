//
//  Requests.swift
//  DuduBubu
//
//  Created by John McCants on 10/21/23.
//

import SwiftUI

struct Requests: View {
    @EnvironmentObject var viewModel: AuthViewModel

    let dummyMoods: [(mood: String, date: String)] = [
        (mood: "Sleepy", date: "August 12, 2023 5:00PM"),
        (mood: "Happy", date: "August 12, 2023 4:30PM"),
        (mood: "Sad", date: "August 12, 2023 3:15PM"),
        (mood: "Energetic", date: "August 12, 2023 2:45PM"),
        (mood: "Calm", date: "August 12, 2023 1:25PM"),
        // ... add more dummy data if needed
    ]

    // This computed property will replace the 'yourPartner()' function
    var yourPartner: some View {
        VStack {
            if let partner = viewModel.partner, let character = partner.character, let imageString = partner.widgetImage {
                HStack {
                    Spacer()
                    Text("Your \(character): \(partner.username)")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color.purple)
                        .padding(.top)
                    Spacer()
                }
                Image("\(imageString)")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                    .shadow(radius: 10)
                    .cornerRadius(30)

                Text("\(character) since \(Date().formatted())")
                    .bold()
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .padding(.top, 20)

            } else {
                Text("Partner Not Found")
                    .font(.title)
                    .foregroundColor(Color.red)
            }
            Text("Moods")
                .font(.title2)
                .fontWeight(.heavy)
                .padding(.top)
                .foregroundColor(Color.purple)
            ScrollView {
                ForEach(dummyMoods, id: \.date) { moodData in
                    HStack {
                        Text(moodData.mood)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(Color.purple)
                        Spacer()
                        Text(moodData.date)
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal)
        .frame(height: 650)
    }

    var body: some View {
        NavigationView {
            if viewModel.partner != nil {
                yourPartner
            } else {
                List(viewModel.requestUsers) { user in
                    HStack {
                        Text(user.username)
                            .font(.headline)

                        Spacer()

                        Button(action: {
                            viewModel.acceptRequest(userId: user.id, username: user.username) { err in
                                if let err = err {
                                    print(err.localizedDescription)
                                }
                                viewModel.fetchUser()
                            }
                        }, label: {
                            Text("Accept")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        })

                        Button(action: {
                            viewModel.denyRequest(userId: user.id) { err in
                                if let err = err {
                                    print(err.localizedDescription)
                                }
                                viewModel.fetchUser()
                            }
                        }, label: {
                            Text("Deny")
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        })
                    }
                }
                .navigationTitle(viewModel.partner != nil ? "Your Bubu" : "Partner Requests")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRequests()
            }
        }
    }
}

#Preview {
    Requests()
}
