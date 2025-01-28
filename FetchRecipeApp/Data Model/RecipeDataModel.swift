	//
	//  RecipeDataModel.swift
	//  FetchRecipeApp
	//
	//  Created by Mustafa T Mohammed on 1/28/25.
	//
import Foundation

/**
 A model representing a recipe with various details, such as cuisine type, name, images, and source URLs.

 - Features:
 - Conforms to `Identifiable` for use in SwiftUI lists.
 - Conforms to `Codable` for easy decoding from JSON.
 - Conforms to `Equatable` for comparisons between instances.

 - Properties:
 - `id`: A unique identifier for the recipe.
 - `cuisine`: The type of cuisine (e.g., Italian, Chinese).
 - `name`: The name of the recipe.
 - `photoURLLarge`: The URL for a larger version of the recipe's image.
 - `photoURLSmall`: The URL for a smaller version of the recipe's image.
 - `sourceURL`: A URL pointing to the recipe's source website.
 - `youtubeURL`: A URL for a YouTube video related to the recipe.
 */
struct Recipe: Identifiable, Codable, Equatable {
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

	/**
	 Coding keys to map JSON keys to Swift property names.

	 - Note: Custom keys are provided to match the JSON structure returned by the API.
	 */
	enum CodingKeys: String, CodingKey {
		case id = "uuid"
		case cuisine, name
		case photoURLLarge = "photo_url_large"
		case photoURLSmall = "photo_url_small"
		case sourceURL = "source_url"
		case youtubeURL = "youtube_url"
	}
}

/**
 A response model representing an array of `Recipe` objects.

 This model is used to decode JSON responses from the network into a list of recipes.

 - Properties:
 - `recipes`: An array of `Recipe` objects retrieved from the response.
 */
struct RecipeResponse: Codable {
		/// An array of `Recipe` objects retrieved from the response.
	let recipes: [Recipe]?
}
