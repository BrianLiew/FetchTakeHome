//
//  CellView.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 1/31/25.
//

import Foundation
import SwiftUI

struct CellView: View {
    
    var image: UIImage?
    var name: String
    var cuisine: String
    
    var body: some View {
        HStack {
            Image(uiImage: self.image ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .padding(10)
            VStack(alignment: .leading) {
                Text(self.name)
                    .font(.headline)
                Text(self.cuisine)
                    .font(.subheadline)
            }
            .padding()
        }
        .padding()
    }
    
}

#Preview {
    CellView(
        image: UIImage(resource: ImageResource(name: "f8b20884-1e54-4e72-a417-dabbc8d91f12", bundle: .main)),
        name: "Title",
        cuisine: "Cuisine")
}

