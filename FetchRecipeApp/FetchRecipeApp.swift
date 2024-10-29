//
//  FetchRecipeApp.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/25/24.
//
import SwiftUI
import Kingfisher

    /// The main entry point for the FetchRecipeApp.
    /// - This struct configures the app-wide Kingfisher image cache settings and sets up the main view.
@main
struct FetchRecipeApp: App {
    
        /// Initializes the app and configures Kingfisher cache settings.
    init() {
        configureKingfisherCache()
    }
    
        /// The main app scene that loads `RecipeView` in a window group.
    var body: some Scene {
        WindowGroup {
            RecipeView()
        }
    }
    
        /// Configures Kingfisher's image caching policy to optimize memory and disk usage.
        /// - Sets a memory cache limit of 50 MB and a disk cache limit of 200 MB.
        /// - This cache configuration helps balance image loading performance with resource usage.
    private func configureKingfisherCache() {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024 // 50 MB memory cache
        cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024       // 200 MB disk cache
    }
}
