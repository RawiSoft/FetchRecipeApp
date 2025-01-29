//
//  FetchRecipeAppTests.swift
//  FetchRecipeAppTests
//
//  Created by Mustafa T Mohammed on 1/27/25.
//

import XCTest
@testable import FetchRecipeApp

	// MARK: - Recipe Model Tests
final class RecipeTests: XCTestCase {

	func testRecipeDecoding() throws {
		let json = """
				{
						"cuisine": "Malaysian",
						"name": "Apam Balik",
						"photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
						"photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
						"source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
						"uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
						"youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
				}
				""".data(using: .utf8)!

		let decoder = JSONDecoder()
		let recipe = try decoder.decode(Recipe.self, from: json)

		XCTAssertNotNil(recipe, "Decoded recipe should not be nil")
		XCTAssertEqual(recipe.id, UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8"))
		XCTAssertEqual(recipe.cuisine, "Malaysian")
		XCTAssertEqual(recipe.name, "Apam Balik")
		XCTAssertEqual(recipe.photoURLLarge, URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg"))
		XCTAssertEqual(recipe.sourceURL, URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ"))
	}

	func testRecipeDecodingWithMissingFields() throws {
		let json = """
				{
						"cuisine": "French",
						"name": "Baguette"
				}
				""".data(using: .utf8)!

		let decoder = JSONDecoder()

		XCTAssertThrowsError(try decoder.decode(Recipe.self, from: json), "Decoding should fail due to missing required fields") { error in
			guard case DecodingError.keyNotFound(let key, _) = error else {
				XCTFail("Expected keyNotFound error but got \(error)")
				return
			}
			XCTAssertEqual(key.stringValue, "uuid", "Expected missing key to be 'uuid'")
		}
	}
}

	// MARK: - Recipe Response Tests
final class RecipeResponseTests: XCTestCase {

	func testRecipeResponseDecoding() throws {
		let json = """
				{
						"recipes": [
								{
										"cuisine": "American",
										"name": "Krispy Kreme Donut",
										"uuid": "9e230f96-f93d-4d29-9230-a1f5fd539464"
								}
						]
				}
				""".data(using: .utf8)!

		let decoder = JSONDecoder()
		let response = try decoder.decode(RecipeResponse.self, from: json)

		XCTAssertNotNil(response.recipes)
		XCTAssertEqual(response.recipes?.count, 1)
		XCTAssertEqual(response.recipes?.first?.name, "Krispy Kreme Donut")
		XCTAssertEqual(response.recipes?.first?.id, UUID(uuidString: "9e230f96-f93d-4d29-9230-a1f5fd539464"))
	}
}

	// MARK: - Recipe Error Tests
final class RecipeErrorTests: XCTestCase {

	func testErrorMessages() {
		XCTAssertEqual(RecipeError.networkError.userMessage, "Unable to connect to the server. Please check your internet connection.")
		XCTAssertEqual(RecipeError.decodingError.userMessage, "Data processing failed. Please try again later.")
		XCTAssertEqual(RecipeError.emptyResponse.userMessage, "No recipes available at this time.")
		XCTAssertEqual(RecipeError.unknownError("Something went wrong").userMessage, "Something went wrong")
	}
}

	// MARK: - Image Service Tests
final class ImageServiceTests: XCTestCase {

	let imageService = ImageService.shared
	let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/def8c76f-9054-40ff-8021-7f39148ad4b7/large.jpg")!

	override func setUp() {
		super.setUp()
		imageService.clearCache() // Clear cache before each test
	}

	override func tearDown() {
		imageService.clearCache() // Clear cache after each test
		super.tearDown()
	}

	func testImageCache() async {
		guard let image = await imageService.getImage(url: testURL) else {
			XCTFail("Expected image to be downloaded")
			return
		}

		imageService.addImageToCache(url: testURL, image: image)

		let cachedImage = await imageService.getImage(url: testURL)
		XCTAssertNotNil(cachedImage, "Image should be cached")
		XCTAssertEqual(image.pngData(), cachedImage?.pngData(), "Cached image should be identical to the downloaded image")
	}

	func testDiskCaching() async {
		guard let image = await imageService.getImage(url: testURL) else {
			XCTFail("Expected image to be downloaded")
			return
		}

		imageService.clearCache() // Simulate app restart

		let cachedImage = await imageService.getImage(url: testURL)
		XCTAssertNotNil(cachedImage, "Image should be retrieved from disk cache after memory clear")
		XCTAssertEqual(image.pngData(), cachedImage?.pngData(), "Disk-cached image should match the originally downloaded image")
	}
}

	// MARK: - Network Service API Tests
final class NetworkServiceAPITests: XCTestCase {

	var networkService: NetworkServiceAPIImpl!

	override func setUp() {
		super.setUp()
		networkService = NetworkServiceAPIImpl()
	}

	override func tearDown() {
		networkService = nil
		super.tearDown()
	}

	func testFetchRecipes_Success() async {
		let result = await networkService.fetchRecipes(endPoint: .recipesData)

		switch result {
			case .success(let recipes):
				XCTAssertFalse(recipes.isEmpty, "Expected non-empty list of recipes")
				XCTAssertNotNil(recipes.first?.name, "Recipe name should not be nil")
			case .failure:
				XCTFail("Expected success but got failure")
		}
	}

	func testFetchRecipes_DecodingError() async {
		let result = await networkService.fetchRecipes(endPoint: .malformedData)

		switch result {
			case .success:
				XCTFail("Expected decoding error but got success")
			case .failure(let error):
				XCTAssertEqual(error, .decodingError, "Expected decodingError")
		}
	}
}
