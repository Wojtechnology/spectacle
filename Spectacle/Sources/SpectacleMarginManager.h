#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"

@class SpectacleMargin;

@protocol SpectacleMarginStorage;

@interface SpectacleMarginManager : NSObject

- (instancetype)initWithMarginStorage:(id<SpectacleMarginStorage>)marginStorage NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

- (void)manageMargins:(NSArray<SpectacleMargin *> *)margins;

- (void)storeMargins;

- (NSArray<SpectacleMargin *> *)margins;
- (SpectacleMargin *)marginForMarginName:(NSString *)name;

- (CGRect)adjustRect:(CGRect)rect;
- (CGRect)adjustFrameOfScreen:(CGRect)frameOfScreen;

@end
