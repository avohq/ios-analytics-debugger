#
# Be sure to run `pod lib lint IosAnalyticsDebugger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IosAnalyticsDebugger'
  s.version          = '1.2.2'
  s.summary          = 'The Avo iOS debugger'

  s.description      = 'Togglable UI to show list of background events, useful to check analytics events in debug builds'

  s.homepage         = 'https://github.com/avohq/ios-analytics-debugger.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Avo (https://www.avo.app)' => 'friends@avo.app' }
  s.source           = { :git => 'https://github.com/avohq/ios-analytics-debugger.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files = 'IosAnalyticsDebugger/Classes/**/*.{h,m}'
  
  s.resource_bundles = {
     'IosAnalyticsDebugger' => ['IosAnalyticsDebugger/Assets/*.xcassets',
                'IosAnalyticsDebugger/Classes/**/*.xib']
  }

end
