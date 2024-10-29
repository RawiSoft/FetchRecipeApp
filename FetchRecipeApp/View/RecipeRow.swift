//
//  RecipeRow.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/25/24.
//
import SwiftUI
import Kingfisher

    /// A view representing a single row in the recipes list, displaying the recipe's image, name, and cuisine type.
struct RecipeRow: View {
    
        /// The recipe data to display in this row.
    let recipe: Recipe
    
    var body: some View {
        HStack {
                // Displays the recipe's image if a valid URL is available.
            if let photoURL = recipe.photoURLSmall {
                injectImageServiceAPI().loadImage(from: photoURL)
                    .frame(width: 50, height: 50) // Set the image frame size
                    .clipShape(RoundedRectangle(cornerRadius: 8)) // Rounds the image corners
            }
            
                // Displays the recipe name and cuisine type.
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline) // Headline font for recipe name
                Text(recipe.cuisine)
                    .font(.subheadline) // Subheadline font for cuisine type
                    .foregroundColor(.secondary) // Secondary color for less emphasis
            }
        }
    }
}
