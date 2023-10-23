//
//  DubuBubuSelection.swift
//  DuduBubu
//
//  Created by John McCants on 10/21/23.
//

import SwiftUI

struct DubuBubuSelection: View {
    enum Gender {
            case girl, boy, none
        }
        
        @State private var selectedGender: Gender = .none
    @Binding var phase : Int
    @Binding var character: String
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Select your Character")
                .font(.title)
                .padding()
            
            VStack(spacing: 20) {
                Button(action: {
                    selectedGender = .boy
                    character = "Dudu"
                }) {
                    ZStack {
                        if selectedGender == .boy {
                            Color.blue.opacity(0.5)
                        } else {
                            Color.gray.opacity(0.2)
                        }
                        VStack {
                            Text("Dudu")
                                .font(.largeTitle)
                                .foregroundColor(selectedGender == .boy ? .white : .black)
                            Image("Dudu3")
                                .resizable()
                                .scaledToFit()
                        }
                            
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Button(action: {
                    selectedGender = .girl
                    character = "Bubu"
                }) {
                    ZStack {
                        if selectedGender == .girl {
                            Color.pink.opacity(0.5)
                        } else {
                            Color.gray.opacity(0.2)
                        }
                        VStack {
                            Text("Bubu")
                                .font(.largeTitle)
                                .foregroundColor(selectedGender == .girl ? .white : .black)
                            Image("Bubu4")
                                .resizable()
                                .scaledToFit()
                        }
                       
                        
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxHeight: .infinity)

                Button("Next") {
                    // Handle next action
                    phase += 1
                    print("Proceeding with selected gender: \(selectedGender)")
                }
                .padding()
                .background(selectedGender == .none ? Color.gray.opacity(0.5) : Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
     
        }
        .padding(.top)
    
    }
}

#Preview {
    DubuBubuSelection(phase: .constant(0), character: .constant(""))
}
