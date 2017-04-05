#import "SpectacleMargin.h"

@implementation SpectacleMargin

- (instancetype)initWithMarginName:(NSString *)marginName marginSize:(NSUInteger)marginSize
{
  if (self = [super init]) {
    _marginName = marginName;
    _marginSize = marginSize;
  }
  return self;
}

@end
