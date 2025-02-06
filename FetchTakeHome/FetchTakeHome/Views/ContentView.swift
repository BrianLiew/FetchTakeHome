//
//  ContentView.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 1/31/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if !self.viewModel.recipes.isEmpty {
                    List(viewModel.recipes, id: \.id) { recipe in
                        NavigationLink(value: recipe) {
                            CellView(
                                image: viewModel.smallImages[recipe.id],
                                name: recipe.name,
                                cuisine: recipe.cuisine
                            )
                        }
                    }
                    .refreshable {
                        await viewModel.fetch()
                    }
                    .navigationDestination(for: Recipe.self) { recipe in
                        DetailsView(viewModel: DetailsView.DetailsViewModel(id: recipe.id,
                                                                            imageURL: recipe.photo_url_large,
                                                                            name: recipe.name,
                                                                            cuisine: recipe.cuisine,
                                                                            source_url: recipe.source_url,
                                                                            youtube_url: recipe.youtube_url))
                    }
                }
                else {
                    Text("No recipes available")
                        .font(.caption2)
                }
            }
        }
        .onAppear() {
            Task {
                await viewModel.fetch()
            }
        }
        .alert("Oops! There's an issue", isPresented: $viewModel.hasError) {
            Button("Try Again") {
                Task {
                    viewModel.hasError = false
                    await viewModel.fetch()
                }
            }
        } message: {
            Text($viewModel.errorMessage.wrappedValue)
        }
    }
    
}

extension ContentView {
    
    @Observable
    class ContentViewModel {
        
        var recipes: [Recipe] = []
        var smallImages: [String: UIImage] = [:]
        var largeImages: [String: UIImage] = [:]
        var hasError: Bool = false
        var errorMessage: String = ""
        
        func fetch() async {
            do {
                let data = try await NetworkService.fetch(urlString: APIURLs.allRecipesURL)
                self.recipes = data.recipes
                try await fetchAllImages()
            } catch let error {
                self.handleError(error)
            }
        }
        
        private func fetchAllImages() async throws {
            do {
                for recipe in recipes {
                    if let photoURLSmallString = recipe.photo_url_small {
                        smallImages[recipe.id] = try await ImageService.fetchImage(urlString: photoURLSmallString, id: "\(recipe.id)small")
                    }
                }
            } catch let error {
                throw error
            }
        }
        
        private func handleError(_ error: Error) {
            self.hasError = true
            
            switch (error) {
            case let error as NetworkError:
                self.errorMessage = error.errorDescription
            case let error as AppError:
                self.errorMessage = error.errorDescription
            case let error as DecodingError:
                self.errorMessage = "Decoding Error: \(error.localizedDescription)"
            default:
                self.errorMessage = "Unexpected Error"
            }
        }
        
    }
    
}

#Preview {
    ContentView()
}
