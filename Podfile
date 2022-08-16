# Uncomment the next line to define a global platform for your project
  # platform :ios, '9.0'
platform :ios, '14.2'

target 'TaSh' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!


  # add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  # add pods for any other desired Firebase products
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'FirebaseFirestore'
  pod 'Firebase/Database'


# Optionally, include the Swift extensions if you're using Swift.
pod 'FirebaseFirestoreSwift'

pod 'GoogleSignIn'
# https://firebase.google.com/docs/ios/setup#available-pods

  # Pods for TaSh

  target 'TaShTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TaShUITests' do
    inherit! :search_paths


    # #2020/12/13
    # $pod install時に下記のエラーが出力　
    # [!] The `TaShUITests [Debug]` target overrides the `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES` build setting defined in `Pods/Target Support Files/Pods-TaSh-TaShUITests/Pods-TaSh-TaShUITests.debug.xcconfig'. This can lead to problems with the CocoaPods installation
    #     - Use the `$(inherited)` flag, or
    #     - Remove the build settings from the target.

    # [!] The `TaShUITests [Release]` target overrides the `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES` build setting defined in `Pods/Target Support Files/Pods-TaSh-TaShUITests/Pods-TaSh-TaShUITests.release.xcconfig'. This can lead to problems with the CocoaPods installation
    #     - Use the `$(inherited)` flag, or
    #     - Remove the build settings from the target.
    #
    #[解決策]
    # target 'TashUITests' do の下に「inherit! :search_paths」追加

    # Pods for testing
  end

end

# # add the Firebase pod for Google Analytics
# pod 'Firebase/Analytics'
# # add pods for any other desired Firebase products
# pod 'Firebase/Auth'
# pod 'Firebase/Core'
# pod 'FirebaseFirestore'
# pod 'Firebase/Database'


# # Optionally, include the Swift extensions if you're using Swift.
# pod 'FirebaseFirestoreSwift'

# pod 'GoogleSignIn'
# # https://firebase.google.com/docs/ios/setup#available-pods

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
  end
end
