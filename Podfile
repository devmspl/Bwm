# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'BWM' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for BWM
  
  pod 'IQKeyboardManagerSwift'

  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  
  pod 'Flurry-iOS-SDK/FlurrySDK'
  pod 'Flurry-iOS-SDK/FlurryMessaging'
  
  pod 'DropDown'
  
  pod 'NVActivityIndicatorView'
  
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'ObjectMapper'

  pod 'R.swift'
  
  pod 'SwiftyUserDefaults'
  pod 'TTInputVisibilityController'
  
  ###
  pod 'RangeSeekSlider'
  pod 'McPicker'
  pod 'YPImagePicker'
  pod 'AlamofireImage'
  ###
  pod 'Permission/Camera'
  pod 'Permission/Location'
  pod 'Permission/Photos'
  pod 'Permission/Notifications'
  
  pod 'UICircularProgressRing'
  
  pod 'DatePickerDialog'
  pod 'SwiftyJSON'
  pod 'Kingfisher'
  
  pod 'GoogleMaps'
  #pod 'Google-Maps-iOS-Utils'
  
  pod 'Starscream', '~> 3.0.2'
  pod 'InputBarAccessoryView'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if target.name == 'MessageKit'
          target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
          end
        end
        config.build_settings['ENABLE_BITCODE'] = 'YES'
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      end
    end
  end

end
