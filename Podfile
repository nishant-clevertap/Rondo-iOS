platform :ios, '12.0'

target 'Rondo-iOS' do
  use_frameworks!

  pod 'Crashlytics'

  ## Released Packages
  # if ENV['LEANPLUM_SDK_VERSION'] != nil
    # pod 'Leanplum-iOS-SDK', ENV['LEANPLUM_SDK_VERSION']
    # pod 'Leanplum-iOS-LocationAndBeacons', ENV['LEANPLUM_SDK_VERSION']
  # else
    pod 'Leanplum-iOS-SDK', '2.7.0'
    pod 'Leanplum-iOS-Location', '2.7.0'
  # end

  ## Source
 # pod 'Leanplum-iOS-SDK', :path => '../Leanplum-iOS-SDK'
#    pod 'Leanplum-iOS-Location', :path => '../Leanplum-iOS-Location'
 # pod 'Leanplum-iOS-LocationAndBeacons', :path => '../Leanplum-iOS-Location'

  target 'Rondo-iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
