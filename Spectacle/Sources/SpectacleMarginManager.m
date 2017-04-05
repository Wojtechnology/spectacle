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

- (CGRect)enforceMarginsOfRect:(CGRect)rect frameOfScreen:(CGRect)frameOfScreen
{
  NSUInteger outerMarginSize = 0;
  NSUInteger innerMarginSize = 0;
  SpectacleMargin *outerMargin = [self marginForMarginName:@"OuterMargin"];
  SpectacleMargin *innerMargin = [self marginForMarginName:@"InnerMargin"];
  if (outerMargin) outerMarginSize = outerMargin.marginSize;
  if (innerMargin) innerMarginSize = innerMargin.marginSize;
  
  CGFloat oldX = rect.origin.x;
  if (isEdgeOfScreen(rect.origin.x, frameOfScreen.origin.x)) {
    rect.origin.x = MAX(rect.origin.x, frameOfScreen.origin.x + outerMarginSize);
  } else {
    rect.origin.x += innerMarginSize;
  }
  rect.size.width -= rect.origin.x - oldX;
  
  CGFloat oldY = rect.origin.y;
  if (isEdgeOfScreen(rect.origin.y, frameOfScreen.origin.y)) {
    rect.origin.y = MAX(rect.origin.y, frameOfScreen.origin.y + outerMarginSize);
  } else {
    rect.origin.y += innerMarginSize;
  }
  rect.size.height -= rect.origin.y - oldY;
  
  if (isEdgeOfScreen(CGRectGetMaxX(rect), CGRectGetMaxX(frameOfScreen))) {
    rect.size.width = MIN(rect.size.width, CGRectGetMaxX(frameOfScreen) - rect.origin.x - outerMarginSize);
  } else {
    rect.size.width -= innerMarginSize;
  }
  
  if (isEdgeOfScreen(CGRectGetMaxY(rect), CGRectGetMaxY(frameOfScreen))) {
    rect.size.height = MIN(rect.size.height, CGRectGetMaxY(frameOfScreen) - rect.origin.y - outerMarginSize);
  } else {
    rect.size.height -= innerMarginSize;
  }
  
  return rect;
}

static BOOL isEdgeOfScreen(CGFloat rectCoord, CGFloat screenCoord)
{
  return fabs(rectCoord - screenCoord) < 5.0;
}

@end
