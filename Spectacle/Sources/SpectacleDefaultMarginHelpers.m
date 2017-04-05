#import "SpectacleDefaultMarginHelpers.h"

static NSArray<SpectacleMargin *> *builtinDefaultMargins(void);

NSArray<SpectacleMargin *> *SpectacleDefaultMargins(void)
{
  NSMutableArray<SpectacleMargin *> *defaultMargins = [NSMutableArray new];
  for (SpectacleMargin *defaultMargin in builtinDefaultMargins()) {
    [defaultMargins addObject:defaultMargin];
  }
  return defaultMargins;
}

static NSArray<SpectacleMargin *> *builtinDefaultMargins(void)
{
  return @[
           [[SpectacleMargin alloc] initWithMarginName:@"OuterMargin" marginSize:0],
           [[SpectacleMargin alloc] initWithMarginName:@"InnerMargin" marginSize:0],
           ];
}
