#import <Foundation/Foundation.h>

#import "SpectacleMacros.h"

@interface SpectacleMargin : NSObject

@property (nonatomic, readonly, copy) NSString *marginName;
@property (nonatomic, readonly, assign) NSUInteger marginSize;

- (instancetype)initWithMarginName:(NSString *)marginName marginSize:(NSUInteger)marginSize NS_DESIGNATED_INITIALIZER;

SPECTACLE_INIT_AND_NEW_UNAVAILABLE

@end
