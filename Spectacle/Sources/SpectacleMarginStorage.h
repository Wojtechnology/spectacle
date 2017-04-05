#import <Foundation/Foundation.h>

#import "SpectacleMargin.h"

@protocol SpectacleMarginStorage <NSObject>

- (NSArray<SpectacleMargin *> *)loadMargins;

- (void)storeMargins:(NSArray<SpectacleMargin *> *)margins;

@end
