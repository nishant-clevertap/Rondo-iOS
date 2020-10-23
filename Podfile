# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'


def use_lp_source
  pod 'Leanplum-iOS-SDK', :path => '../Leanplum-iOS-SDK'
#  pod 'Leanplum-iOS-Location', :path => '../Leanplum-iOS-Location'
#  pod 'Leanplum-iOS-LocationAndBeacons', :path => '../Leanplum-iOS-Location'
end

def use_lp_release
  version = ENV['LEANPLUM_SDK_VERSION']
  if version == nil
    version = "3.1.0-beta2"
  end
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
