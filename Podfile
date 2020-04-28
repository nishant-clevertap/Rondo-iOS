platform :ios, '12.0'

target 'Rondo-iOS' do
  use_frameworks!

  pod 'Crashlytics'

  ## Released Packages
  version = ENV['LEANPLUM_SDK_VERSION']
  if version == nil
    version = "2.7.0"
  end
  pod 'Leanplum-iOS-SDK', version
  pod 'Leanplum-iOS-LocationAndBeacons', version

  ## Source
#  pod 'Leanplum-iOS-SDK', :path => '../Leanplum-iOS-SDK'
#    pod 'Leanplum-iOS-Location', :path => '../Leanplum-iOS-Location'
 # pod 'Leanplum-iOS-LocationAndBeacons', :path => '../Leanplum-iOS-Location'

  target 'Rondo-iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
