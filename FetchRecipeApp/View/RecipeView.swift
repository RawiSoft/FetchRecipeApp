//
//  RecipeView.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//


import SwiftUI

/**
 A SwiftUI view that displays a list of recipes, with features such as filtering by cuisine, pull-to-refresh,
 and detailed recipe view. The view interacts with a `RecipeViewModel` to fetch, filter, and manage the recipe data.

 - Features:
 - Horizontal scrolling grid for filtering recipes by cuisine.
 - Pull-to-refresh functionality to reload recipes.
 - Displays error, loading, or empty states based on the app's current state.
 - Navigation to a detailed recipe view when a recipe is selected.
 */
struct RecipeView: View {
		/// The view model responsible for managing recipe data and application state.
	@StateObject private var viewModel = RecipeViewModel()

		// MARK: - Body
	var body: some View {
		NavigationView {
			VStack {
					// Filters (Horizontal Grid)
				/**
				 Displays a horizontal scrollable list of available cuisines. Users can filter the recipe list
				 by selecting a cuisine. Clicking a selected cuisine again removes the filter.
				 */
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						ForEach(viewModel.cuisines, id: \.self) { cuisine in
							FilterButton(
								title: cuisine,
								isSelected: viewModel.selectedCuisine == cuisine
							) {
									// Toggle the filter on/off for the selected cuisine
								viewModel.selectedCuisine = viewModel.selectedCuisine == cuisine ? nil : cuisine
							}
						}
					}
					.padding(.horizontal)
				}

					// List of Recipes
				Group {
					if viewModel.state == .loading {
							// Loading State
						ProgressView("Loading recipes...")
							.progressViewStyle(CircularProgressViewStyle(tint: .blue))
							.padding()
							.frame(maxWidth: .infinity, maxHeight: .infinity)
					} else if case .error(let error) = viewModel.state {
							// Error State
						Text(error.localizedDescription)
							.foregroundColor(.red)
							.padding()
					} else if viewModel.state == .empty {
							// Empty State
						Text("No recipes available.")
							.foregroundColor(.gray)
							.padding()
					} else {
							// Loaded Recipes
						List(viewModel.filteredRecipes) { recipe in
							RecipeRow(recipe: recipe, viewModel: viewModel)
								.padding()
								.background(Color.white)
								.cornerRadius(10)
								.shadow(radius: 5)
								.onTapGesture {
									viewModel.selectedRecipe = recipe
								}
						}
						.listStyle(PlainListStyle())
						.refreshable {
							await viewModel.fetchRecipes()
						}
					}
				}
			}
			.navigationTitle("Recipes")
			.task {
					// Fetch recipes when the view first appears
				await viewModel.fetchRecipes()
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
						// Refresh Button
					Button(action: {
						Task { await viewModel.fetchRecipes() }
					}) {
						Image(systemName: "arrow.clockwise.circle.fill")
							.imageScale(.large)
							.foregroundColor(.blue)
					}
				}
			}
				// Present detailed recipe view when a recipe is selected
			.sheet(item: $viewModel.selectedRecipe) { recipe in
				RecipeDetailView(recipe: recipe)
			}
		}
	}
}
