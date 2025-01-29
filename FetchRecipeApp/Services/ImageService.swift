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
 It utilizes:
 - **In-memory caching** using `NSCache` for fast retrieval.
 - **Disk caching** using `FileManager` to persist images across app restarts.
 */
class ImageService {

		/// The shared singleton instance of the `ImageService`.
	static let shared = ImageService()

		/// In-memory cache for storing downloaded images.
	private let cache = NSCache<NSString, UIImage>()

		/// File manager instance for managing disk storage.
	private let fileManager = FileManager.default

		/// Directory where cached images are stored.
	private let cacheDirectory: URL

		// MARK: - Initializer

		/// Private initializer to enforce the singleton design pattern.
	private init() {
		if let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
			self.cacheDirectory = cacheDir.appendingPathComponent("ImageCache", isDirectory: true)
		} else {
				// Fallback to temporary directory if cache directory retrieval fails
			self.cacheDirectory = fileManager.temporaryDirectory.appendingPathComponent("ImageCache", isDirectory: true)
			print("Warning: Using temporary directory for caching.")
		}

			// Ensure cache directory exists
		do {
			try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
		} catch {
			print("Failed to create cache directory: \(error.localizedDescription)")
		}
	}

		// MARK: - Methods

	/**
	 Fetches an image from cache (memory or disk), or downloads it if necessary.

	 - If the image is in memory, it is returned immediately.
	 - If the image is on disk, it is loaded and cached in memory.
	 - If the image is not cached, it is downloaded, cached in memory, and saved to disk.

	 - Parameter url: The URL of the image to fetch.
	 - Returns: A `UIImage` instance if the image is successfully fetched, or `nil` if the fetch fails.
	 */
	func getImage(url: URL) async -> UIImage? {
		let cacheKey = url.absoluteString as NSString
		let fileURL = cacheDirectory.appendingPathComponent(sanitizedFilename(from: url))

			// Check in-memory cache first
		if let cachedImage = cache.object(forKey: cacheKey) {
			return cachedImage
		}

			// Check disk cache
		if let diskImage = loadImageFromDisk(fileURL: fileURL) {
			cache.setObject(diskImage, forKey: cacheKey) // Add to memory cache
			return diskImage
		}

			// Download from network
		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			if let image = UIImage(data: data) {
				cache.setObject(image, forKey: cacheKey) // Add to memory cache
				saveImageToDisk(image: image, fileURL: fileURL) // Save to disk
				return image
			}
		} catch {
			print("Failed to download image: \(error.localizedDescription)")
		}

		return nil
	}

	/**
	 Loads an image from disk cache.

	 - Parameter fileURL: The file path of the image.
	 - Returns: A `UIImage` if found, otherwise `nil`.
	 */
	private func loadImageFromDisk(fileURL: URL) -> UIImage? {
		guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
		return UIImage(contentsOfFile: fileURL.path)
	}

	/**
	 Saves an image to disk cache.

	 - Parameters:
	 - image: The `UIImage` to save.
	 - fileURL: The file path where the image will be stored.
	 */
	private func saveImageToDisk(image: UIImage, fileURL: URL) {
		guard let data = image.jpegData(compressionQuality: 0.8) else { return }
		do {
			try data.write(to: fileURL, options: .atomic)
		} catch {
			print("Failed to save image to disk: \(error.localizedDescription)")
		}
	}

	/**
	 Checks if an image is already stored in the in-memory cache.

	 - Parameter url: The URL of the image to check.
	 - Returns: `true` if the image is cached, otherwise `false`.
	 */
	func isImageInCache(url: URL) -> Bool {
		let cacheKey = url.absoluteString as NSString
		return cache.object(forKey: cacheKey) != nil
	}

	/**
	 Adds an image to the in-memory cache.

	 - Parameters:
	 - url: The URL associated with the image.
	 - image: The `UIImage` to be stored in cache.
	 */
	func addImageToCache(url: URL, image: UIImage) {
		let cacheKey = url.absoluteString as NSString
		cache.setObject(image, forKey: cacheKey)
	}

	/**
	 Clears all cached images from both memory and disk.
	 */
	func clearCache() {
		cache.removeAllObjects()

		do {
			let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
			for fileURL in fileURLs {
				try fileManager.removeItem(at: fileURL)
			}
		} catch {
			print("Failed to clear disk cache: \(error.localizedDescription)")
		}
	}

	/**
	 Generates a unique filename from a URL string without using hashing.

	 - Parameter url: The URL of the image.
	 - Returns: A sanitized filename to be used for caching.
	 */
	 func sanitizedFilename(from url: URL) -> String {
		let filename = url.deletingQuery().absoluteString
			.replacingOccurrences(of: "https://", with: "")
			.replacingOccurrences(of: "http://", with: "")
			.replacingOccurrences(of: "/", with: "_")
			.replacingOccurrences(of: ":", with: "_")

		return filename + (url.pathExtension.isEmpty ? ".jpg" : ".\(url.pathExtension)")
	}
}

/**
 Helper extension to remove query parameters from a URL.
 */
extension URL {
	func deletingQuery() -> URL {
		guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { return self }
		components.query = nil
		return components.url ?? self
	}
}
