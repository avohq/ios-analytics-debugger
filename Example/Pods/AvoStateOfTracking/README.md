# AvoStateOfTracking

[![Version](https://img.shields.io/cocoapods/v/AvoStateOfTracking.svg?style=flat)](https://cocoapods.org/pods/AvoStateOfTracking)
[![License](https://img.shields.io/cocoapods/l/AvoStateOfTracking.svg?style=flat)](https://cocoapods.org/pods/AvoStateOfTracking)
[![Platform](https://img.shields.io/cocoapods/p/AvoStateOfTracking.svg?style=flat)](https://cocoapods.org/pods/AvoStateOfTracking)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

AvoStateOfTracking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AvoStateOfTracking'
```

# Initializing

Obj-C

    AvoStateOfTracking *avoSot = [[AvoStateOfTracking alloc] initWithApiKey:@"apiKey" isDev: devFlag];
        
Swift

    let avoSot = AvoStateOfTracking(apiKey: "apiKey", isDev: devFlag)
    
# Enabling logs

Obj-C

    [AvoStateOfTracking setLogging:YES];
        
Swift

    AvoStateOfTracking.setLogging(true)

# Sending event schemas

Whenever you send tracking event call one of the following methods:

### 1.

Obj-C

    [avoSot trackSchemaFromEvent:@"Event Name" eventParams:@{@"id": @"sdf-334fsg-334f", @"number": @41}];
    
Swift
    
    avoSot.trackSchema(fromEvent: "Event Name", eventParams: ["id": "sdf-334fsg-334f", "number": 41])
    
### 2.

Obj-C

    [avoSot trackSchema:@"Event Name" eventSchema:@{@"id": [[AvoString alloc] init], @"number": [[AvoInt alloc] init]}];
    
Swift

    avoSot.trackSchema("Event Name", eventSchema: ["id": AvoString(), "number": AvoInt()])

# Extract event schema manually

Obj-C

    NSDictionary * schema = [avoSot extractSchema:@{@"id": @"sdf-334fsg-334f", @"number": @41}];
    
Swift
    
    let schema = avoSot.extractSchema(["id": "sdf-334fsg-334f", "number": 41])
    
# Batching control

Default batch size is 30 and default batch flust timeout is 30 seconds.
In debug mode default batch size is 1, i.e. every event schema is sent to the server as soon as it is reported.

Obj-C

    [AvoStateOfTracking setBatchSize:15];
    [AvoStateOfTracking setBatchFlustSeconds:10];
    
Swift
    
    AvoStateOfTracking.setBatchSize(15)
    AvoStateOfTracking.setBatchFlustSeconds(10)

## Author

Avo (https://www.avo.app), friends@avo.app

## License

AvoStateOfTracking is available under the MIT license. See the LICENSE file for more info.
