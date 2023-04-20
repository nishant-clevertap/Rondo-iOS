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
    version = "6.0.5-beta2"
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

target 'RichPush' do
  use_frameworks!
  platform :ios, '10.0'
  pod 'CTNotificationService'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
