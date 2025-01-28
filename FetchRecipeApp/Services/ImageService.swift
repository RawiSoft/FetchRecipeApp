//
//  ImageService.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//

import Foundation
import UIKit

/**
 A singleton service class responsible for managing image fetching and caching.

 This service provides an asynchronous method to fetch images from a given URL.
 It utilizes `NSCache` for in-memory caching and optionally supports downloading images from the network if they are not already cached.

 - Features:
 - In-memory caching using `NSCache`.
 - Asynchronous image fetching with `URLSession`.
 - Singleton design for shared access across the app.
 */
class ImageService {

		/// The shared singleton instance of the `ImageService`.
	static let shared = ImageService()

		/// In-memory cache for storing downloaded images.
	private let cache = NSCache<NSString, UIImage>()

		/// Default file manager instance (currently unused, but can be extended for file-based caching).
	private let fileManager = FileManager.default

		// MARK: - Initializer

		/// Private initializer to enforce the singleton design pattern.
	private init() {}

		// MARK: - Methods

	/**
	 Fetches an image from the given URL, with caching to optimize performance.

	 - If the image is already cached in memory, it is returned immediately.
	 - If the image is not cached, it is downloaded from the network and stored in the cache for future use.

	 - Parameter url: The URL of the image to fetch.
	 - Returns: A `UIImage` instance if the image is successfully fetched or `nil` if the fetch fails.
	 - Note: This method runs asynchronously and should be called within an `async` context.
	 */
	func getImage(url: URL) async -> UIImage? {
			// Generate a unique cache key based on the URL
		let cacheKey = url.absoluteString as NSString

			// Check if the image is already in the cache
		if let cachedImage = cache.object(forKey: cacheKey) {
			return cachedImage
		}

			// If the image is not in cache, download it from the network
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			if let image = UIImage(data: data) {
					// Cache the image for future use
				cache.setObject(image, forKey: cacheKey)
				return image
			}
		} catch {
				// Log any errors encountered during the download
			print("Failed to download image: \(error.localizedDescription)")
		}

			// Return nil if the image cannot be fetched
		return nil
	}
}
