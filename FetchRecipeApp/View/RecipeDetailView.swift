//
//  RecipeDetailView.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//

import SwiftUI

/**
 A SwiftUI view that displays detailed information about a selected recipe, including its image, name, cuisine,
 and links to the source and YouTube video.

 This view uses a `Recipe` model to display all the relevant details and fetches the large recipe image asynchronously
 using the `ImageService`.

 - Features:
 - Displays a large recipe image with a gradient overlay for visual appeal.
 - Shows recipe name and cuisine details.
 - Provides links to the recipe's source website and an optional YouTube video.
 - Handles loading states with a progress indicator for the image.
 */
struct RecipeDetailView: View {
		/// The recipe data to display in detail.
	let recipe: Recipe

		/// Holds the fetched recipe image. Initially `nil` until the image is loaded.
	@State private var image: UIImage? = nil

		/// The shared instance of `ImageService` for fetching and caching images.
	private let imageService = ImageService.shared

		// MARK: - Body
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 16) {

					// Recipe Image Section
				/**
				 Displays the recipe's large image. If the image is already loaded, it shows the image with a gradient overlay.
				 Otherwise, a `ProgressView` is displayed while the image is being fetched.
				 */
				if let photoURLLarge = recipe.photoURLLarge {
					if let loadedImage = image {
							// Show the loaded image
						Image(uiImage: loadedImage)
							.resizable()
							.scaledToFill()
							.frame(height: 250)
							.clipped()
							.overlay(
								Rectangle()
									.fill(LinearGradient(
										gradient: Gradient(colors: [.black.opacity(0.6), .clear]),
										startPoint: .bottom,
										endPoint: .center))
							)
					} else {
							// Show a loading indicator while the image is fetched
						ProgressView()
							.frame(height: 250)
							.task {
								if let fetchedImage = await imageService.getImage(url: photoURLLarge) {
									image = fetchedImage
								}
							}
					}
				}

					// Recipe Details Section
				VStack(alignment: .leading, spacing: 10) {
						// Recipe Name
					Text(recipe.name)
						.font(.title)
						.fontWeight(.bold)
						.foregroundColor(.primary)

						// Cuisine Type
					Text("Cuisine: \(recipe.cuisine)")
						.font(.subheadline)
						.foregroundColor(.secondary)

					Divider()

						// Source Link
					if let sourceURL = recipe.sourceURL {
						Link(destination: sourceURL) {
							HStack {
								Image(systemName: "link.circle")
								Text("View Recipe Source")
							}
							.font(.body)
							.foregroundColor(.blue)
						}
					}

						// YouTube Link
					if let youtubeURL = recipe.youtubeURL {
						Link(destination: youtubeURL) {
							HStack {
								Image(systemName: "play.circle")
								Text("Watch on YouTube")
							}
							.font(.body)
							.foregroundColor(.red)
						}
					}
				}
				.padding()
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(Color(.systemBackground))
						.shadow(radius: 5)
				)

				Spacer()
			}
			.padding()
			.background(Color(.secondarySystemBackground))
			.navigationTitle("Recipe Details")
		}
	}
}
