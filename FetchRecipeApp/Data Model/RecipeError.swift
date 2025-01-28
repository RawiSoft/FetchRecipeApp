//
//  RecipeError.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//

import Foundation

/**
 An enum representing possible errors that can occur while fetching or processing recipe data.

 - Features:
 - Distinguishes between various error cases, such as network issues, decoding failures, or empty responses.
 - Provides a user-friendly message for each error type via the `userMessage` property.

 - Cases:
 - `networkError`: Indicates a failure to connect to the server or retrieve data.
 - `decodingError`: Represents an issue with decoding the fetched data into the expected format.
 - `emptyResponse`: Occurs when the server returns no recipes or an empty response.
 - `unknownError(String)`: A catch-all case for any other error, with an associated message.
 */
enum RecipeError: Error, Equatable {
		/// Indicates a failure to connect to the server or retrieve data.
	case networkError

		/// Represents an issue with decoding the fetched data into the expected format.
	case decodingError

		/// Occurs when the server returns no recipes or an empty response.
	case emptyResponse

		/// A catch-all case for any other error, with an associated message.
	case unknownError(String)

	/**
	 Provides a user-friendly message describing the error.

	 - Returns: A `String` containing a description of the error suitable for displaying to users.
	 */
	var userMessage: String {
		switch self {
			case .networkError:
				return "Unable to connect to the server. Please check your internet connection."
			case .decodingError:
				return "Data processing failed. Please try again later."
			case .emptyResponse:
				return "No recipes available at this time."
			case .unknownError(let message):
				return message
		}
	}
}
