//
//  RecipeViewModel.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/25/24.
//

import SwiftUI

    /// A view model class responsible for managing recipe data and handling error states.
    /// - Note: This class is intended to be used with SwiftUI views and is marked with `@MainActor`
    /// to ensure that UI updates happen on the main thread.
@MainActor
class RecipeViewModel: ObservableObject {
    
        /// The network service used for fetching recipes, allowing for dependency injection.
        /// Set to `internal` to allow access during testing.
    var networkService: NetworkServiceAPI
    
        /// An array of `Recipe` objects that represents the list of recipes fetched from the network.
    @Published var recipes: [Recipe] = []
    
        /// An optional error message string that holds any errors encountered during data fetching.
        /// This value can be used to display error messages to the user.
    @Published var errorMessage: String? = nil
    
        /// A boolean flag indicating the loading state of the view model.
        /// When `true`, data is currently being loaded, and when `false`, loading has completed.
    @Published var isLoading = false
    
        /// Initializes the view model with a network service.
        /// - Parameter networkService: The network service used for fetching recipes.
    init(networkService: NetworkServiceAPI = injectNetworkServiceAPI()) {
        self.networkService = networkService
    }
    
        /// Fetches a list of recipes asynchronously from the network.
        /// - Important: Ensure that `networkService` is properly configured to return a valid network service instance.
        /// - Note: The method sets `isLoading` to `true` while fetching data and resets it to `false` when done.
    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil
        
            // Fetch recipes from the network service
        let result = await networkService.fetchRecipes(endPoint: .recipesData)
        
        switch result {
            case .success(let recipes):
                self.recipes = recipes
            case .failure(let error):
                print("Fetch Error:", error)
                
                    // Handles network-specific errors and sets a user-friendly error message.
                switch error {
                    case .emptyResponse:
                        errorMessage = "No recipes available."
                    default:
                        errorMessage = "Failed to load recipes. Please try again."
                }
        }
        
        isLoading = false
    }
}
