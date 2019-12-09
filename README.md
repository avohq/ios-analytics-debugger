# IosAnalyticsDebugger

[![Version](https://img.shields.io/cocoapods/v/IosAnalyticsDebugger.svg?style=flat)](https://cocoapods.org/pods/IosAnalyticsDebugger)
[![License](https://img.shields.io/cocoapods/l/IosAnalyticsDebugger.svg?style=flat)](https://cocoapods.org/pods/IosAnalyticsDebugger)
[![Platform](https://img.shields.io/cocoapods/p/IosAnalyticsDebugger.svg?style=flat)](https://cocoapods.org/pods/IosAnalyticsDebugger)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

IosAnalyticsDebugger is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IosAnalyticsDebugger'
```

# Create the debugger manager instance

Obj-C

    AnalyticsDebugger * debugger = [AnalyticsDebugger new];

Swift

    let debugger = AnalyticsDebugger()

# Show the debugger

Obj-C

    [debugger showBubbleDebugger];
    
or

    [debugger showBarDebugger];

Swift
  
    debugger.showBubble()
    
or

    debugger.showBarDebugger()

# Hide the debugger

Obj-C

    [debugger hideDebugger];
    
Swift

    debugger.hide()

# Using with Avo

Obj-C

    [Avo initAvoWithEnv:AVOEnvDev customDestination:[CustomDestination new] debugger:debugger];
    [Avo appOpened];

Swift

    Avo.initAvo(env: AvoEnv.dev, customDestination: CustomDestiation(), debugger: debugger)
    Avo.appOpened()

Then after you call showDebugger in your activity the debugger view will appear with the App Opened event inside.

## Author

Avo (https://www.avo.app), friends@avo.app

## License

IosAnalyticsDebugger is available under the MIT license. See the LICENSE file for more info.
