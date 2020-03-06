//
//  AvoStateOfTracking.m
//  AvoStateOfTracking
//
//  Created by Alex Verein on 28.01.2020.
//

#import "AvoStateOfTracking.h"
#import "AvoEventSchemaType.h"
#import "AvoList.h"
#import "AvoObject.h"
#import "AvoInt.h"
#import "AvoFloat.h"
#import "AvoBoolean.h"
#import "AvoString.h"
#import "AvoUnknownType.h"
#import "AvoNull.h"
#import "AvoNetworkCallsHandler.h"
#import "AvoBatcher.h"

@interface AvoStateOfTracking ()

@property (readwrite, nonatomic) AvoSessionTracker * sessionTracker;

@property (readwrite, nonatomic) NSString * appVersion;
@property (readwrite, nonatomic) NSString * appName;
@property (readwrite, nonatomic) NSInteger libVersion;
@property (readwrite, nonatomic) NSString *apiKey;

@property (readwrite, nonatomic) AvoNetworkCallsHandler *networkCallsHandler;
@property (readwrite, nonatomic) AvoBatcher *avoBatcher;

@end

@implementation AvoStateOfTracking

static BOOL logging = NO;
static int maxBatchSize = 30;
static int batchFlushSTime = 30;

+ (BOOL) isLogging {
    return logging;
}

+ (void) setLogging: (BOOL) isLogging {
    logging = isLogging;
}

+ (int) getBatchSize {
    return maxBatchSize;
}

+ (void) setBatchSize: (int) newBatchSize {
    maxBatchSize = newBatchSize;
}

+ (int) getBatchFlushSeconds {
    return batchFlushSTime;
}

+ (void) setBatchFlushSeconds: (int) newBatchFlushSeconds {
    batchFlushSTime = newBatchFlushSeconds;
}

-(instancetype) initWithApiKey: (NSString *) apiKey isDev: (Boolean) isDev {
    self = [super init];
    if (self) {
        if (isDev) {
            [AvoStateOfTracking setBatchFlushSeconds:1];
            [AvoStateOfTracking setLogging:YES];
        }
        
        self.appName = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleIdentifierKey];
        self.appVersion = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleVersionKey];
        self.libVersion = [[[NSBundle bundleForClass:[self class]] infoDictionary][(NSString *)kCFBundleVersionKey] intValue];
        
        self.networkCallsHandler = [[AvoNetworkCallsHandler alloc] initWithApiKey:apiKey appName:self.appName appVersion:self.appVersion libVersion:[@(self.libVersion) stringValue] isDev:isDev];
        self.avoBatcher = [[AvoBatcher alloc] initWithNetworkCallsHandler:self.networkCallsHandler withNotificationCenter: [NSNotificationCenter defaultCenter]];
        
        self.sessionTracker = [[AvoSessionTracker alloc] initWithBatcher:self.avoBatcher];
        
        self.apiKey = apiKey;
    }
    return self;
}

// params are [ String : Any ]
-(NSDictionary<NSString *, AvoEventSchemaType *> *) trackSchemaFromEvent:(NSString *) eventName eventParams:(NSDictionary<NSString *, id> *) params {
    if ([AvoStateOfTracking isLogging]) {
        NSLog(@"Avo State Of Tracking: Supplied event %@ with params %@", eventName, [params description]);
    }
    
    NSDictionary * schema = [self extractSchema:params];
    
    [self trackSchema:eventName eventSchema:schema];
    
    return schema;
}

// schema is [ String : AvoEventSchemaType ]
-(void) trackSchema:(NSString *) eventName eventSchema:(NSDictionary<NSString *, AvoEventSchemaType *> *) schema {
    for(NSString *key in [schema allKeys]) {
        if (![[schema objectForKey:key] isKindOfClass:[AvoEventSchemaType class]]) {
            [NSException raise:@"Schema types should be of type AvoEventSchemaType" format:@"Provided %@", [[[schema objectForKey:key] class] description]];
        }
    }
    
    if ([AvoStateOfTracking isLogging]) {
        
        NSString * schemaString = @"";
        
        for(NSString *key in [schema allKeys]) {
            NSString *value = [[schema objectForKey:key] name];
            NSString *entry = [NSString stringWithFormat:@"\t\"%@\": \"%@\";\n", key, value];
            schemaString = [schemaString stringByAppendingString:entry];
        }
        
        NSLog(@"Avo State Of Tracking: Saved event %@ with schema {\n%@}", eventName, schemaString);
    }
    
    [self.sessionTracker schemaTracked:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
    
    [self.avoBatcher handleTrackSchema:eventName schema:schema];
}

-(NSDictionary<NSString *, AvoEventSchemaType *> *) extractSchema:(NSDictionary<NSString *, id> *) eventParams {
    NSMutableDictionary * result = [NSMutableDictionary new];
    
    for (id paramName in [eventParams allKeys]) {
        id paramValue = [eventParams valueForKey:paramName];
            
        AvoEventSchemaType * paramType = [self objectToAvoSchemaType:paramValue];
        
        [result setObject:paramType forKey:paramName];
    }
    
    return result;
}

-(AvoEventSchemaType *)objectToAvoSchemaType: (id) obj {
    if (obj == [NSNull null]) {
        return [AvoNull new];
    }
    
    Class cl = [obj class];
    NSString * paramType = [cl description];
    
    if ([paramType isEqual: @"__NSCFNumber"]) {
        const char *objCtype = [obj objCType];
        
        if ([@"i" isEqualToString:@(objCtype)]
            || [@"s" isEqualToString:@(objCtype)]
            || [@"q" isEqualToString:@(objCtype)]) {
            return [AvoInt new];
        } else if ([@"c" isEqualToString:@(objCtype)]) {
            return [AvoString new];
        } else {
            return [AvoFloat new];
        }
    } else if ([paramType isEqual: @"__NSCFBoolean"]) {
        return [AvoBoolean new];
    } else if ([paramType isEqual: @"__NSCFConstantString"] ||
               [paramType isEqual: @"__NSCFString"] ||
               [paramType isEqual: @"NSTaggedPointerString"] ||
               [paramType isEqual: @"Swift.__SharedStringStorage"]) {
        return [AvoString new];
    } else if ([paramType containsString: @"NSSet"] ||
               [paramType isEqual: @"__NSSingleObjectSetI"] ||
               [paramType isEqual: @"__NSSingleObjectArrayI"] ||
               [paramType containsString: @"NSArray"]) {
        AvoList * result = [AvoList new];
        
        for (id item in obj) {
            if (item == NSNull.null) {
                [result.subtypes addObject:[AvoNull new]];
            } else {
                [result.subtypes addObject:[self objectToAvoSchemaType:item]];
            }
        }
        
        return result;
    } else if ([paramType containsString: @"NSDictionary"] ||
               [paramType isEqual: @"__NSSingleEntryDictionaryI"]) {
        AvoObject * result = [AvoObject new];
        
        for (id paramName in [obj allKeys]) {
            id paramValue = [obj valueForKey:paramName];
                
            AvoEventSchemaType * paramType = [self objectToAvoSchemaType:paramValue];
            
            [result.fields setObject:paramType forKey:paramName];
        }
        
        return result;
    } else {
        return [AvoUnknownType new];
    }
}

@end
