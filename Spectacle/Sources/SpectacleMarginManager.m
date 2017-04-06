#import "SpectacleMarginManager.h"

#import "SpectacleMargin.h"
#import "SpectacleMarginStorage.h"

@implementation SpectacleMarginManager
{
  id<SpectacleMarginStorage> _marginStorage;
  NSMutableDictionary<NSString *, SpectacleMargin *> *_registeredMarginsByName;
}

- (instancetype)initWithMarginStorage:(id<SpectacleMarginStorage>)marginStorage
{
  if (self = [super init]) {
    _marginStorage = marginStorage;
    _registeredMarginsByName = [NSMutableDictionary new];
  }
  return self;
}

- (void)manageMargins:(NSArray<SpectacleMargin *> *)margins
{
  for (SpectacleMargin *margin in margins) {
    NSString *marginName = margin.marginName;
    SpectacleMargin *existingMargin = _registeredMarginsByName[marginName];
    if (existingMargin) {
      NSLog(@"Unable to add margin %@ as it already exists.", marginName);
      continue;
    }
    _registeredMarginsByName[marginName] = margin;
  }
  [self storeMargins];
}

- (void)storeMargins
{
  [_marginStorage storeMargins:self.margins];
}

- (NSArray<SpectacleMargin *> *)margins
{
  NSMutableArray<SpectacleMargin *> *margins = [NSMutableArray new];
  for (SpectacleMargin *margin in _registeredMarginsByName.allValues) {
    [margins addObject:margin];
  }
  return margins;
}

- (SpectacleMargin *)marginForMarginName:(NSString *)name
{
  return _registeredMarginsByName[name];
}

- (CGRect)adjustRect:(CGRect)rect
{
  return [self adjustRect:rect withMarginName:@"InnerMargin"];
}

- (CGRect)adjustFrameOfScreen:(CGRect)frameOfScreen
{
  return [self adjustRect:frameOfScreen withMarginName:@"OuterMargin"];
}

- (CGRect)adjustRect:(CGRect)rect withMarginName:(NSString *)name
{  NSUInteger marginSize = 0;
  SpectacleMargin *margin = [self marginForMarginName:name];
  if (margin) marginSize = margin.marginSize;
  rect.origin.x += marginSize;
  rect.origin.y += marginSize;
  rect.size.width -= 2 * marginSize;
  rect.size.height -= 2 * marginSize;
  return rect;
}

@end
