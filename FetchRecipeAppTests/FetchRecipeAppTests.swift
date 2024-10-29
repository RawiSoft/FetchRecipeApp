//
//  FetchRecipeAppTests.swift
//  FetchRecipeAppTests
//
//  Created by Mustafa T. Mohammed on 10/25/24.
//
import XCTest
@testable import FetchRecipeApp

    /// Mock implementation of `NetworkServiceAPI` for testing purposes.
    /// - Note: This mock allows tests to simulate different network responses without making actual network requests.
class MockNetworkServiceAPI: NetworkServiceAPI {
    
        /// A variable to store the result that will be returned by `fetchRecipes`.
        /// This allows the mock to simulate either success or failure responses.
    private let result: Result<[Recipe], NetworkServiceError>
    
        /// Initializes the mock with a specific result to simulate.
        /// - Parameter result: The result to return when `fetchRecipes` is called.
    init(result: Result<[Recipe], NetworkServiceError>) {
        self.result = result
    }
    
        /// Returns the specified result when `fetchRecipes` is called, simulating a network response.
        /// - Parameter endPoint: The endpoint being requested. This mock disregards the endpoint as it always returns the predefined result.
        /// - Returns: The predefined `Result` set at initialization.
    func fetchRecipes(endPoint: EndPoint) async -> Result<[Recipe], NetworkServiceError> {
        return result
    }
}

    /// Unit tests for `RecipeViewModel` using the mock network service to control and verify its behavior.
class RecipeViewModelTests: XCTestCase {
    
        /// Helper function to create a `RecipeViewModel` with a mock network service.
        /// - Parameter result: The result to be returned by the mock network service.
        /// - Returns: A configured `RecipeViewModel` instance for testing.
    @MainActor private func createViewModel(with result: Result<[Recipe], NetworkServiceError>) -> RecipeViewModel {
        let mockService = MockNetworkServiceAPI(result: result)
        let viewModel = RecipeViewModel(networkService: mockService)
        return viewModel
    }
    
        /// Tests successful fetching of recipes.
        /// - This test verifies that a successful response updates `recipes` with the expected data,
        ///   clears any error message, and sets the loading state to `false`.
    func testFetchRecipesSuccess() async {
            // Arrange
        let sampleRecipes = [
            Recipe(id: UUID(), cuisine: "Italian", name: "Pasta", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        ]
        let viewModel = await createViewModel(with: .success(sampleRecipes))
        
            // Act
        await viewModel.fetchRecipes()
        
            // Assert
        await MainActor.run {
            XCTAssertEqual(viewModel.recipes.count, 1, "Recipes should contain one item.")
            XCTAssertEqual(viewModel.recipes.first?.name, "Pasta", "The recipe name should match the sample recipe.")
            XCTAssertNil(viewModel.errorMessage, "Error message should be nil on success.")
            XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetching.")
        }
    }
    
        /// Tests handling of an empty response.
        /// - This test verifies that an empty response sets `recipes` to empty, provides an appropriate error message,
        ///   and sets the loading state to `false`.
    func testFetchRecipesEmptyResponse() async {
            // Arrange
        let viewModel = await createViewModel(with: .failure(.emptyResponse))
        
            // Act
        await viewModel.fetchRecipes()
        
            // Assert
        await MainActor.run {
            XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty when the response is empty.")
            XCTAssertEqual(viewModel.errorMessage, "No recipes available.", "Expected emptyResponse message.")
            XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetching.")
        }
    }
    
        /// Tests handling of a decoding error response.
        /// - This test verifies that a decoding error sets `recipes` to empty, provides an appropriate error message,
        ///   and sets the loading state to `false`.
    func testFetchRecipesDecodingError() async {
            // Arrange
        let viewModel = await createViewModel(with: .failure(.decodingError))
        
            // Act
        await viewModel.fetchRecipes()
        
            // Assert
        await MainActor.run {
            XCTAssertTrue(viewModel.recipes.isEmpty, "Recipes should be empty on decoding error.")
            XCTAssertEqual(viewModel.errorMessage, "Failed to load recipes. Please try again.", "Expected decoding error message.")
            XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetching.")
        }
    }
}
