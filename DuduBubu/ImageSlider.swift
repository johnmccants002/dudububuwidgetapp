//
//  ImageSlider.swift
//  DuduBubu
//
//  Created by John McCants on 10/18/23.
//

import SwiftUI

struct ImageSlider: View {
    
    @State private var selection = 0
    var character : String
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3) // 3 columns

    // 1
    private let imageNames = ["Subject2", "Subject3", "Subject4", "Subject5", "Subject", "Subject6", "Subject8", "Subject9", "Subject10", "Subject11"]
    
    @Binding var selectedImageName: String

    // Generate the "Dudu" and "Bubu" arrays
    static let buburange = 1...6
    static let dudurange = 1...12
    
    static let duduImages = dudurange.map { "Dudu\($0)" }
    static let bubuImages = buburange.map { "Bubu\($0)" }
    
    var body: some View {
        VStack {
            // The grid of images
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(character == "Dudu" ? ImageSlider.duduImages : ImageSlider.bubuImages, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            selectedImageName = imageName
                        }
                }
            }
            
            // Display the name of the tapped image (if any)
       
        }
        .padding()
    }
}

struct ImageSlider_Previews: PreviewProvider {
    static var previews: some View {
        // 4
        ImageSlider(character: "Dudu", selectedImageName: .constant("Subject"))
            .previewLayout(.fixed(width: 400, height: 300))
    }
}
