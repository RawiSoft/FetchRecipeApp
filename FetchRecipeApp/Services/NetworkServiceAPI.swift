//
//  NetworkServiceAPI.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//
import Foundation

/**
 A protocol defining the network service for fetching recipes.

 This protocol is designed to abstract the implementation details of network requests, enabling the use of dependency injection for testing.

 - Features:
 - Supports fetching recipes from various endpoints.
 - Can be mocked for unit testing.
 */
protocol NetworkServiceAPI {
	/**
	 Fetches a list of recipes from a specified endpoint.

	 - Parameter endPoint: The endpoint to fetch data from, defined by the `EndPoint` enum.
	 - Returns: A `Result` containing:
	 - `[Recipe]` on success.
	 - `NetworkServiceError` on failure.
	 */
	func fetchRecipes(endPoint: EndPoint) async -> Result<[Recipe], NetworkServiceError>
}

/**
 Returns an instance of `NetworkServiceAPI`.

 - Note: This function allows for flexibility in replacing the implementation with mocks or other concrete types for testing or production.
 */
func injectNetworkServiceAPI() -> NetworkServiceAPI {
	NetworkServiceAPIImpl()
}

/**
 Enum representing possible errors that can occur during network requests.

 - Cases:
 - `invalidURL`: The URL is malformed or invalid.
 - `noData`: No data was returned from the server.
 - `emptyResponse`: The server returned an empty or nil response.
 - `decodingError`: The JSON response could not be decoded.
 */
enum NetworkServiceError: Error {
	case invalidURL
	case noData
	case emptyResponse
	case decodingError
}

/**
 Enum representing different API endpoints for fetching recipes.

 Each endpoint corresponds to a specific type of data or scenario.
 */
enum EndPoint: Codable, CaseIterable {
	case recipesData
	case malformedData
	case emptyData
	case unreachableURL
	/**
	 The URL string associated with each endpoint.

	 - Returns: The URL string for the specified endpoint.
	 */
	var value: String {
		switch self {
			case .recipesData:
				return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
			case .malformedData:
				return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
			case .emptyData:
				return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
			case .unreachableURL:
				return "https://google.con"
		}
	}
}

/**
 A concrete implementation of the `NetworkServiceAPI` protocol responsible for making network requests
 to fetch recipe data from the specified endpoints.

 - Features:
 - Uses `URLSession` for network communication.
 - Parses JSON responses into `RecipeResponse` models.
 - Handles network and decoding errors gracefully.
 */
final class NetworkServiceAPIImpl: NetworkServiceAPI {

		/// The URL session used for making network requests. Defaults to `URLSession.shared`.
	private let session: URLSession

	/**
	 Initializes the network service with a specified URL session.

	 - Parameter session: The URL session to use for network requests. Defaults to `URLSession.shared`.
	 */
	init(session: URLSession = .shared) {
		self.session = session
	}

	/**
	 Fetches recipes from the specified endpoint.

	 - Parameter endPoint: The endpoint from which to fetch recipes.
	 - Returns: A `Result` containing:
	 - `[Recipe]` on success.
	 - `NetworkServiceError` on failure.
	 - Note:
	 - This method performs the network request asynchronously.
	 - Ensures the data is non-empty and decodes it into a `RecipeResponse`.
	 */
	func fetchRecipes(endPoint: EndPoint) async -> Result<[Recipe], NetworkServiceError> {
		guard let url = URL(string: endPoint.value) else {
			return .failure(.invalidURL)
		}

		do {
				// Perform the network request
			let (data, _) = try await session.data(from: url)

				// Ensure that data is not empty
			guard !data.isEmpty else {
				return .failure(.noData)
			}

				// Attempt to decode the JSON response into `RecipeResponse`
			do {
				let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)

					// Ensure the recipes array is non-empty
				guard let recipes = decodedResponse.recipes, !recipes.isEmpty else {
					return .failure(.emptyResponse)
				}
				return .success(recipes)
			} catch {
				print("DecodingError JSON: \(error)")
				return .failure(.decodingError)
			}

		} catch {
				// Handle any network-related errors
			return .failure(.noData) // Optionally replace with more specific error types
		}
	}
}
