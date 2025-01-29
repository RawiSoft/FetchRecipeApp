//
//  RecipeViewModel.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//

import SwiftUI
import Combine

/**
 Enum representing all possible states of the `RecipeViewModel`.

 - Cases:
 - `loading`: Indicates that the data is being fetched.
 - `loaded([Recipe])`: Contains an array of `Recipe` objects when data is successfully fetched.
 - `error(RecipeError)`: Contains an error message when there is an issue fetching data.
 - `empty`: Indicates that no recipes are available.
 */
enum RecipeViewState: Equatable {
	case loading
	case loaded([Recipe])
	case error(RecipeError)
	case empty

	/**
	 Compares two `RecipeViewState` instances for equality.

	 - Parameters:
	 - lhs: The left-hand side `RecipeViewState` to compare.
	 - rhs: The right-hand side `RecipeViewState` to compare.
	 - Returns: A Boolean value indicating whether the two instances are equal.
	 */
	static func ==(lhs: RecipeViewState, rhs: RecipeViewState) -> Bool {
		switch (lhs, rhs) {
			case (.loading, .loading), (.empty, .empty):
				return true
			case (.loaded(let lhsRecipes), .loaded(let rhsRecipes)):
				return lhsRecipes == rhsRecipes
			case (.error(let lhsMessage), .error(let rhsMessage)):
				return lhsMessage == rhsMessage
			default:
				return false
		}
	}
}

/**
 A view model responsible for managing and fetching recipe data for the `RecipeView`.

 This class maintains the app state (`RecipeViewState`), handles data filtering and selection,
 and communicates with `NetworkServiceAPI` and `ImageService` for fetching data and images.

 - Features:
 - Fetches recipes from the network.
 - Filters recipes based on search text and selected cuisine.
 - Provides state updates to the view using `@Published` properties.
 */
@MainActor
class RecipeViewModel: ObservableObject {
		/// Represents the current state of the view model (e.g., loading, loaded, error, or empty).
	@Published private(set) var state: RecipeViewState = .loading

		/// The currently selected recipe for detailed viewing.
	@Published var selectedRecipe: Recipe?

		/// The selected cuisine filter (optional).
	@Published var selectedCuisine: String? = nil

		// MARK: - Dependencies
	private let networkService: NetworkServiceAPI
	private let imageService: ImageService

		// MARK: - Computed Properties

		/// The list of recipes currently loaded in the state.
	var recipes: [Recipe] {
		if case .loaded(let recipes) = state {
			return recipes
		}
		return []
	}

		/// The unique list of available cuisines derived from the loaded recipes.
	var cuisines: [String] {
		Set(recipes.map { $0.cuisine }).sorted()
	}

		/// The filtered list of recipes based on the search text and selected cuisine.
	var filteredRecipes: [Recipe] {
		recipes.filter { recipe in
			let matchesCuisine = selectedCuisine == nil || recipe.cuisine.lowercased() == selectedCuisine?.lowercased()
			return matchesCuisine
		}
	}

		// MARK: - Initializer

	/**
	 Initializes the view model with optional dependencies for testing or production.

	 - Parameters:
	 - networkService: A service conforming to `NetworkServiceAPI` for fetching recipes (defaults to `NetworkServiceAPIImpl`).
	 - imageService: A shared instance of `ImageService` for fetching images (defaults to `.shared`).
	 */
	init(networkService: NetworkServiceAPI = injectNetworkServiceAPI(), imageService: ImageService = .shared) {
		self.networkService = networkService
		self.imageService = imageService
	}

		// MARK: - Methods

	/**
	 Fetches the list of recipes from the network and updates the state based on the result.

	 - Note: Updates the `state` property to `.loading`, `.loaded`, `.empty`, or `.error` based on the result.
	 */
	func fetchRecipes() async {
		state = .loading
		let result = await networkService.fetchRecipes(endPoint: .recipesData)
		switch result {
			case .success(let recipes):
				state = recipes.isEmpty ? .empty : .loaded(recipes)
			case .failure(let error):
				state = .error(mapError(error))
		}
	}

	/**
	 Fetches an image for a given URL.

	 - Parameter url: The URL of the image to fetch.
	 - Returns: A `UIImage` instance if the image was successfully fetched, or `nil` if it failed.
	 */
	func getImage(url: URL) async -> UIImage? {
		return await imageService.getImage(url: url)
	}

		// MARK: - Private Helpers

	/**
	 Maps a `NetworkServiceError` to a `RecipeError` for better user feedback.

	 - Parameter error: The `NetworkServiceError` encountered during a network request.
	 - Returns: A corresponding `RecipeError` for the given `NetworkServiceError`.
	 */
	private func mapError(_ error: NetworkServiceError) -> RecipeError {
		switch error {
			case .noData:
				return .networkError
			case .decodingError:
				return .decodingError
			case .emptyResponse:
				return .emptyResponse
			default:
				return .unknownError("An unknown error occurred.")
		}
	}
}
