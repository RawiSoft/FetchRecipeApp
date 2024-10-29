//
//  RecipeView.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/25/24.
//

import SwiftUI

    /// A view that displays a list of recipes fetched from the network.
    /// - Note: This view uses `RecipeViewModel` as its data source and displays a loading indicator, error messages,
    /// and recipes list based on the state of the view model.
struct RecipeView: View {
    
        /// The view model responsible for fetching and managing recipe data.
    @StateObject private var viewModel = RecipeViewModel()
    
        /// The selected recipe for which details are shown when tapped.
        /// This state is used to present `RecipeDetailView` as a sheet.
    @State private var selectedRecipe: Recipe?
    
    var body: some View {
        NavigationView {
            Group {
                    // Display loading view if data is being fetched
                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                }
                    // Display error message if an error occurs
                else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                    // Display a message if no recipes are available
                else if viewModel.recipes.isEmpty {
                    Text("No recipes available.")
                }
                    // Display the list of recipes
                else {
                    List(viewModel.recipes) { recipe in
                        RecipeRow(recipe: recipe)
                            .onTapGesture {
                                selectedRecipe = recipe // Set selected recipe on tap
                            }
                    }
                        // Allows the user to refresh the recipes list by pulling down
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
                }
            }
                // Fetch recipes when the view appears
            .onAppear {
                Task { await viewModel.fetchRecipes() }
            }
            .navigationTitle("Recipes")
            .toolbar {
                    // Toolbar button to manually refresh the recipes list
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        Task { await viewModel.fetchRecipes() }
                    }
                }
            }
                // Presents `RecipeDetailView` as a sheet when a recipe is selected
            .sheet(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
}
