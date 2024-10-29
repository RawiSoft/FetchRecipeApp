//
//  RecipeDataModel.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/25/24.
//

import Foundation

    /// A model representing a recipe with various details including cuisine type, name, images, and source URLs.
struct Recipe: Identifiable, Codable {
    
        /// Unique identifier for the recipe.
    let id: UUID
    
        /// The type of cuisine (e.g., Italian, Chinese).
    let cuisine: String
    
        /// The name of the recipe.
    let name: String
    
        /// URL for a larger version of the recipe photo.
    let photoURLLarge: URL?
    
        /// URL for a smaller version of the recipe photo.
    let photoURLSmall: URL?
    
        /// URL for the source of the recipe.
    let sourceURL: URL?
    
        /// URL for a YouTube video of the recipe.
    let youtubeURL: URL?
    
        /// Coding keys to map JSON keys to Swift property names.
        /// - Note: Custom keys are provided to match the JSON structure.
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine, name
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

    /// A response model representing an array of `Recipe` objects.
    /// - Used to decode the JSON response containing recipes from the network.
struct RecipeResponse: Codable {
    
        /// An array of `Recipe` objects retrieved from the response.
    let recipes: [Recipe]?
}
