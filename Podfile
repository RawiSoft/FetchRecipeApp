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
