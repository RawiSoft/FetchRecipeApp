//
//  NetworkServiceAPI.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/25/24.
//

import Foundation

    /// A protocol defining the network service for fetching recipes.
    /// - Note: This protocol allows for the use of dependency injection and mock implementations for testing.
protocol NetworkServiceAPI {
        /// Fetches a list of recipes from a specified endpoint.
        /// - Parameter endPoint: The endpoint to fetch data from, defined by the `EndPoint` enum.
        /// - Returns: A `Result` containing an array of `Recipe` objects on success, or a `NetworkServiceError` on failure.
    func fetchRecipes(endPoint: EndPoint) async -> Result<[Recipe], NetworkServiceError>
}

    /// Returns an instance of `NetworkServiceAPI`.
    /// - Note: This function can be modified to return different implementations for testing or production.
func injectNetworkServiceAPI() -> NetworkServiceAPI {
    NetworkServiceAPIImpl()
}

    /// An enum representing possible errors that can occur during network requests.
enum NetworkServiceError: Error {
    case invalidURL            // URL is malformed or invalid.
    case noData                // No data was returned from the server.
    case emptyResponse         // The server returned an empty or nil response.
    case decodingError         // Decoding the JSON response failed.
}

    /// An enum representing different API endpoints for fetching recipes.
enum EndPoint: Codable, CaseIterable {
    case recipesData
    case malformedData
    case emptyData
    
        /// Returns the URL string associated with each endpoint.
    var value: String {
        switch self {
            case .recipesData:
                return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
            case .malformedData:
                return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
            case .emptyData:
                return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        }
    }
}

    /// A concrete implementation of the `NetworkServiceAPI` protocol responsible for making network requests
    /// to fetch recipe data from the specified endpoints.
final class NetworkServiceAPIImpl: NetworkServiceAPI {
    
        /// The URL session used for making network requests. Defaults to `URLSession.shared`.
    private let session: URLSession
    
        /// Initializes the network service with a specified URL session.
        /// - Parameter session: The URL session to use for network requests. Defaults to `URLSession.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
        /// Fetches recipes from the specified endpoint.
        /// - Parameter endPoint: The endpoint from which to fetch recipes.
        /// - Returns: A `Result` containing an array of `Recipe` objects on success, or a `NetworkServiceError` on failure.
    func fetchRecipes(endPoint: EndPoint) async -> Result<[Recipe], NetworkServiceError> {
        guard let url = URL(string: endPoint.value) else {
            return .failure(.invalidURL)
        }
        
        do {
                // Performs the network request
            let (data, _) = try await session.data(from: url)
            
                // Ensures that data is not empty
            guard !data.isEmpty else {
                return .failure(.noData)
            }
            
                // Attempts to decode the JSON response into `RecipeResponse`
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                
                    // Checks if the recipes array is non-empty
                guard let recipes = decodedResponse.recipes, !recipes.isEmpty else {
                    return .failure(.emptyResponse)
                }
                return .success(recipes)
            } catch {
                print("DecodingError JSON: \(error)")
                return .failure(.decodingError)
            }
            
        } catch {
                // Returns network errors as a failure result
            return .failure(.noData) // or wrap with a different error type if necessary
        }
    }
}
