# FetchRecipeApp

A SwiftUI app for fetching and displaying recipes, integrating networking, caching, and clean architecture principles for an efficient and modular design.

## Steps to Run the App

### 1. Clone the Repository
```bash
git clone https://github.com/username/FetchRecipeApp.git
cd FetchRecipeApp
```
### 2. Install Dependencies
The project uses Kingfisher for image caching, installed via CocoaPods. Run the following command to install dependencies:

pod file: 
```bash 
# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'FetchRecipeApp' do
	# Comment the next line if you don't want to use dynamic frameworks
	#  source 'https://github.com/CocoaPods/Specs.git'
	use_frameworks!
	inhibit_all_warnings!
	post_install do |installer|

		installer.pods_project.targets.each do |target|
			target.build_configurations.each do |config|
				if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 16.0
					config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
				end
			end
		end
	end
  pod 'Kingfisher', :inhibit_warnings => true
end
```

```bash
pod install
```
After installation, open the .xcworkspace file instead of .xcodeproj to work with the project.

### 3. Open in Xcode
Open FetchRecipeApp.xcworkspace in Xcode.

### 4. Build and Run
Select an appropriate simulator or physical device.
Press Cmd + R to build and run the app.
Focus Areas
I prioritized several key areas for the project:

Networking and Error Handling: Creating a robust and async network layer that uses protocols for dependency injection to facilitate testing.
Data Decoding and State Management: Building reliable decoding logic and managing state effectively with @Published properties.
Caching: Using Kingfisher for efficient image caching, setting memory and disk cache limits for optimized performance.
This approach ensures that the app remains responsive, modular, and easy to maintain.

### Time Spent
I spent approximately 8 hours on the project:

3 hours on setting up the project, configuring the network layer, and handling dependencies.
3 hours building UI views and implementing state management.
1 hour on caching and performance optimizations.
1 hour on testing, debugging, and documentation.


### Trade-offs and Decisions
Chose URLSession over Alamofire: I decided to use URLSession to keep the project dependency-light, which benefits maintainability and aligns with Apple’s native networking stack.
Image Caching with Kingfisher: To balance performance with simplicity, I integrated Kingfisher, allowing for efficient image caching with minimal setup.
Weakest Part of the Project
The weakest part of the project might be the limited UI/UX enhancement. While functionality is solid, adding interactive design elements would improve the overall user experience.

### External Code and Dependencies
Kingfisher: For asynchronous image loading and caching, to enhance performance with minimal configuration.
CocoaPods: Used as the dependency manager to simplify dependency installation and integration.
Additional Information
Testing the networking layer was simplified using dependency injection. This structure enables mocking, allowing for isolated tests of network behavior without real API calls.

