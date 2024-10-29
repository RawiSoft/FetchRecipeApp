//
//  ImageServiceAPI.swift
//  FetchRecipeApp
//
//  Created by Mustafa T. Mohammed on 10/26/24.
//

import Foundation
import SwiftUI
import Kingfisher

    /// A protocol defining the image service for loading and displaying images asynchronously using Kingfisher.
    /// - Note: This protocol facilitates dependency injection and testability by allowing for alternative implementations.
protocol ImageServiceAPI {
    
        /// Loads an image from the specified URL using `Kingfisher.KFImage`.
        /// - Parameter url: The URL of the image to load.
        /// - Returns: A `KFImage` view that can be used in SwiftUI to display the image.
    func loadImage(from url: URL?) -> KFImage
}

    /// Provides an instance of `ImageServiceAPI`.
    /// - Returns: The default implementation, `ImageServiceAPIImpl`.
func injectImageServiceAPI() -> ImageServiceAPI {
    ImageServiceAPIImpl()
}

    /// A concrete implementation of `ImageServiceAPI` for loading and displaying images using Kingfisher.
final class ImageServiceAPIImpl: @preconcurrency ImageServiceAPI {
    
        /// Loads and configures an image using `KFImage` for displaying in SwiftUI.
        /// - Parameter url: The optional URL from which to load the image.
        /// - Returns: A configured `KFImage` instance that is `resizable`, includes a `ProgressView` as a placeholder, caches the original image, and has a fade-in effect.
    @MainActor func loadImage(from url: URL?) -> KFImage {
        KFImage(url)
            .resizable() // Allows the image to be resized within the view
            .placeholder {
                ProgressView() // Displays a loading indicator while the image loads
            }
            .cacheOriginalImage() // Caches the original image for faster loading in future
            .fade(duration: 0.25) // Applies a fade effect for smoother image appearance
    }
}
