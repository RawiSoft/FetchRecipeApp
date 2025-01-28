//
//  RecipeRow.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//
import SwiftUI

/**
 A SwiftUI view that displays a row representing a single recipe. This includes the recipe's image, name, and cuisine.
 If the image is not already loaded, it fetches the image asynchronously using the `RecipeViewModel`.

 - Important: This view depends on `RecipeViewModel` for loading images. It observes changes in the view model to
 update the UI when the image is loaded.
 */
struct RecipeRow: View {
		/// The `Recipe` object containing the relevant metadata for display.
	let recipe: Recipe

		/// The view model responsible for fetching image data and managing recipe states.
	@ObservedObject var viewModel: RecipeViewModel

		/// A state property holding the recipe's downloaded image. It is `nil` until the image is fetched.
	@State private var recipeImage: UIImage?

		// MARK: - Body
	var body: some View {
		HStack {
				// If the image is already fetched, display it; otherwise show a placeholder icon.
			if let recipeImage = recipeImage {
				Image(uiImage: recipeImage)
					.resizable()
					.scaledToFit()
					.frame(width: 100, height: 100)
			} else {
				Image(systemName: "photo")
					.frame(width: 100, height: 100)
					.foregroundColor(.gray)
					// Task to fetch the image asynchronously when the view appears
					.task {
							// Safely unwrap the URL or provide a fallback
						if let photoURLSmall = recipe.photoURLSmall {
							recipeImage = await viewModel.getImage(url: photoURLSmall)
						}
					}
			}

				// Text display for the recipe's name and cuisine
			VStack(alignment: .leading) {
				Text(recipe.name)
					.font(.headline)
					.foregroundStyle(.black)
				Text(recipe.cuisine)
					.font(.subheadline)
					.foregroundStyle(.gray)
			}

			Spacer()
		}
	}
}
