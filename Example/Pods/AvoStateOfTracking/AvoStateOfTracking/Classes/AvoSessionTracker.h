//
//  AvoSessionTracker.h
//  AvoStateOfTracking
//
//  Created by Alex Verein on 05.02.2020.
//

#import <Foundation/Foundation.h>
#import "AvoBatcher.h"

NS_ASSUME_NONNULL_BEGIN

@interface AvoSessionTracker : NSObject

-(instancetype) initWithBatcher: (AvoBatcher *) avoBatcher;

- (void) schemaTracked: (NSNumber *) atUnixTime;

+ (NSString *) cacheKey;

@end

NS_ASSUME_NONNULL_END