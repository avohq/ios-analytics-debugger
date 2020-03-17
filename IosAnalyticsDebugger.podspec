#
# Be sure to run `pod lib lint IosAnalyticsDebugger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IosAnalyticsDebugger'
  s.version          = '1.1.5'
  s.summary          = 'The Avo iOS debugger'

  s.description      = 'Togglable UI to show list of background events, useful to check analytics events in debug builds'

  s.homepage         = 'https://github.com/avohq/ios-analytics-debugger.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Avo (https://www.avo.app)' => 'friends@avo.app' }
  s.source           = { :git => 'https://github.com/avohq/ios-analytics-debugger.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'IosAnalyticsDebugger/Classes/**/*'
  
  s.resources = "IosAnalyticsDebugger/Assets/*.xcassets"
  
  # s.resource_bundles = {
  #   'IosAnalyticsDebugger' => ['IosAnalyticsDebugger/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
