//
//  NetworkCallsHandler.h
//  AvoInspector
//
//  Created by Alex Verein on 07.02.2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvoNetworkCallsHandler : NSObject

@property (readonly, nonatomic) NSString *apiKey;
@property (readonly, nonatomic) NSString *appName;
@property (readonly, nonatomic) NSString *appVersion;
@property (readonly, nonatomic) NSString *libVersion;
@property (readonly, nonatomic) Boolean isDev;

- (instancetype) initWithApiKey: (NSString *) apiKey appName: (NSString *)appName appVersion: (NSString *) appVersion libVersion: (NSString *) libVersion isDev: (Boolean) isDev;

- (void) callInspectorWithBatchBody: (NSArray *) batchBody completionHandler:(void (^)(NSError *error))completionHandler;

- (NSMutableDictionary *) bodyForTrackSchemaCall:(NSString *) eventName schema:(NSDictionary *) schema;
- (NSMutableDictionary *) bodyForSessionStartedCall;

@end

NS_ASSUME_NONNULL_END
