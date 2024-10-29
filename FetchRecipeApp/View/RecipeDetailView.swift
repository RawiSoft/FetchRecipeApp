//
//  RecipeDetailView.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/29/24.
//

import SwiftUI

    /// A view that displays detailed information about a selected recipe, including its image, name, cuisine type, and links to source and YouTube video.
struct RecipeDetailView: View {
    
        /// The recipe data to display in detail.
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                    // Displays a large recipe image with an overlay gradient from bottom to center.
                if let photoURLLarge = recipe.photoURLLarge {
                    AsyncImage(url: photoURLLarge) { image in
                        image
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
                    } placeholder: {
                        ProgressView()
                            .frame(height: 250)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    
                        // Displays the name of the recipe with a bold title font.
                    Text(recipe.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                        // Displays the cuisine type with a subheadline font and secondary color.
                    Text("Cuisine: \(recipe.cuisine)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                        // Provides a link to the recipe's source website, shown with a link icon and blue color.
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
                    
                        // Provides a link to a YouTube video related to the recipe, shown with a play icon and red color.
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
