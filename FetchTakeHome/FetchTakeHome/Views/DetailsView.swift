//
//  DetailsView.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 1/31/25.
//

import SwiftUI

//struct DetailsView: View {
//
//    var image: UIImage
//    var name: String
//    var cuisine: String
//    var source_url: String
//    var youtube_url: String
//
//    @State private var viewModel = DetailsViewModel()
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 10) {
//            Text(self.name)
//                .font(.title)
//                .bold()
//            Text(self.cuisine)
//                .font(.title2)
//            Image(uiImage: self.image)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 300, height: 300, alignment: .center)
//                .padding()
//            Link("Source", destination: URL(string: self.source_url)!)
//                .font(.caption)
//                .foregroundStyle(.blue)
//            Link("YouTube", destination: URL(string: self.youtube_url)!)
//                .font(.caption2)
//                .foregroundStyle(.blue)
//            Spacer()
//        }
//        .padding()
//    }
//}

struct DetailsView: View {
    
    @State var viewModel: DetailsViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(self.viewModel.name)
                .font(.title)
                .bold()
            Text(self.viewModel.cuisine)
                .font(.title2)
            Image(uiImage: self.viewModel.image)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300, alignment: .center)
                .padding()
            HStack(spacing: 50) {
                if let sourceURL = URL(string: self.viewModel.source_url) {
                    Button {
                        UIApplication.shared.open(sourceURL)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 100, height: 50)
                            Text("Source")
                                .foregroundStyle(.white)
                        }
                    }
                }
                if let youtubeURL = URL(string: self.viewModel.youtube_url) {
                    Button {
                        UIApplication.shared.open(youtubeURL)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 100, height: 50)
                                .foregroundStyle(.red)
                            Text("Youtube")
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .bold()
            Spacer()
        }
        .padding()
        .onAppear() {
            Task {
                try await self.viewModel.fetchImage()
            }
        }
    }
}

extension DetailsView {
    
    @Observable
    class DetailsViewModel {
        
        var image: UIImage = UIImage()
        var id: String
        var imageURL: String
        var name: String
        var cuisine: String
        var source_url: String
        var youtube_url: String
        
        init(id: String,
             imageURL: String?,
             name: String,
             cuisine: String,
             source_url: String?,
             youtube_url: String?
        ) {
            self.id = id
            self.imageURL = imageURL ?? ""
            self.name = name
            self.cuisine = cuisine
            self.source_url = source_url ?? ""
            self.youtube_url = youtube_url ?? ""
        }
        
        func fetchImage() async throws -> Void {
            self.image = try await ImageService.fetchImage(urlString: self.imageURL, id: "\(self.id)large")
        }
        
    }
    
}

#Preview {
    DetailsView(viewModel: DetailsView.DetailsViewModel(id: "foo",
                                                        imageURL: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                                                        name: "Title",
                                                        cuisine: "Cuisine",
                                                        source_url: "Source URL",
                                                        youtube_url: "YouTube URL"))
}
