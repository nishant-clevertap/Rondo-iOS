# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def use_lp_source
  pod 'Leanplum-iOS-SDK', :path => '../Leanplum-iOS-SDK'
#  pod 'Leanplum-iOS-Location', :path => '../Leanplum-iOS-Location'
#  pod 'Leanplum-iOS-LocationAndBeacons', :path => '../Leanplum-iOS-Location'
end

def use_lp_release
  pod 'Leanplum-iOS-SDK', '2.7.0'
  pod 'Leanplum-iOS-LocationAndBeacons', '2.7.0'
end

def shared_pods
  pod 'Eureka'
end

target 'Rondo' do
  use_frameworks!

  # Release pods
  # use_lp_source
  use_lp_release

  # Shared pods
  shared_pods

end
