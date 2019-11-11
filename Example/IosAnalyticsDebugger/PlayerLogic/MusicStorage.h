//
//  MusicStorage.h
//  IosAnalyticsDebugger_Example
//
//  Created by Alex Verein on 11/11/2019.
//  Copyright © 2019 Alexey Verein. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicStorage : NSObject

- (NSArray *) trackInfo: (NSInteger) trackNumber;

- (BOOL) hasNext: (NSInteger) fromPosition;
- (BOOL) hasPrev: (NSInteger) fromPosition;

@end

NS_ASSUME_NONNULL_END
