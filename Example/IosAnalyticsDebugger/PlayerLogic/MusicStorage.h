//
//  MusicStorage.h
//  IosAnalyticsDebugger_Example
//
//  Copyright © 2019. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicStorage : NSObject

- (NSArray *) trackInfo: (NSInteger) trackNumber;

- (BOOL) hasNext: (NSInteger) fromPosition;
- (BOOL) hasPrev: (NSInteger) fromPosition;

@end

NS_ASSUME_NONNULL_END
