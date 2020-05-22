# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

version = ENV['LEANPLUM_SDK_VERSION']
if version == nil
  version = "2.8.0"
end

def use_lp_source
  pod 'Leanplum-iOS-SDK', :path => '../Leanplum-iOS-SDK'
#  pod 'Leanplum-iOS-Location', :path => '../Leanplum-iOS-Location'
#  pod 'Leanplum-iOS-LocationAndBeacons', :path => '../Leanplum-iOS-Location'
end

def use_lp_release
  pod 'Leanplum-iOS-SDK', version
  pod 'Leanplum-iOS-LocationAndBeacons', version
end

def shared_pods
  pod 'Eureka'
end

target 'Rondo-iOS' do
  use_frameworks!

  # Release pods
  # use_lp_source
  use_lp_release

  # Shared pods
  shared_pods

end
