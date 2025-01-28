//
//  FilterButton.swift
//  FetchRecipeApp
//
//  Created by Mustafa T Mohammed on 1/28/25.
//
import SwiftUI

/**
 A reusable SwiftUI button component designed for filtering recipes by criteria like cuisine.
 The button visually indicates whether it is selected or not and triggers an action when tapped.

 - Features:
 - Customizable title to represent the filter option.
 - Dynamic background color and text color to indicate selection state.
 - Executes a custom action when tapped, allowing for toggle-like behavior.
 */
struct FilterButton: View {
		/// The text displayed on the button, representing the filter option.
	var title: String

		/// Indicates whether the button is currently selected.
	var isSelected: Bool

		/// The action to perform when the button is tapped.
	var action: () -> Void

		// MARK: - Body
	var body: some View {
		Button(action: action) {
			Text(title)
				.padding()
				.background(isSelected ? Color.blue : Color.gray.opacity(0.2)) // Dynamic background color
				.foregroundColor(isSelected ? .white : .primary) // Dynamic text color
				.cornerRadius(8) // Rounded corners
				.font(.subheadline) // Subheadline font size
		}
	}
}
