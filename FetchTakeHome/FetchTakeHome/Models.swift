//
//  Models.swift
//  FetchTakeHome
//
//  Created by Brian Liew on 1/31/25.
//

import Foundation

struct Response: Codable {
    var recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipes = "recipes"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recipes = try container.decode([Recipe].self, forKey: .recipes)
    }
}

struct Recipe: Codable, Identifiable, Hashable {
    var cuisine: String
    var name: String
    var photo_url_large: String?
    var photo_url_small: String?
    var id: String
    var source_url: String?
    var youtube_url: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine = "cuisine"
        case name = "name"
        case photo_url_large = "photo_url_large"
        case photo_url_small = "photo_url_small"
        case id = "uuid"
        case source_url = "source_url"
        case youtube_url = "youtube_url"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cuisine = try container.decode(String.self, forKey: .cuisine)
        self.name = try container.decode(String.self, forKey: .name)
        self.photo_url_large = try container.decodeIfPresent(String.self, forKey: .photo_url_large)
        self.photo_url_small = try container.decodeIfPresent(String.self, forKey: .photo_url_small)
        self.id = try container.decode(String.self, forKey: .id)
        self.source_url = try container.decodeIfPresent(String.self, forKey: .source_url)
        self.youtube_url = try container.decodeIfPresent(String.self, forKey: .youtube_url)
    }
}
