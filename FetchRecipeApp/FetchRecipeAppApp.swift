//
//  FetchRecipeAppApp.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/27/25.
//

import SwiftUI

/**
 The main entry point for the `FetchRecipeApp`.

 This struct represents the application's lifecycle and initializes the root view (`RecipeView`) inside the main `WindowGroup`.

 - Features:
 - Uses the SwiftUI `@main` attribute to define the app's entry point.
 - Loads `RecipeView` as the initial user interface for the app.
 */
@main
struct FetchRecipeAppApp: App {
		/// The body of the app, defining the main scene and its content.
	var body: some Scene {
		WindowGroup {
			RecipeView()
		}
	}
}
