#import "SpectacleMarginJSONStorage.h"

#import "SpectacleUtilities.h"

@implementation SpectacleMarginJSONStorage

- (NSArray<SpectacleMargin *> *)loadMargins
{
  NSError *error;
  NSURL *marginsFileURL = findMarginsFileURL(&error);
  if (!marginsFileURL) {
    NSLog(@"Unable to locate the margins file: %@", error.localizedDescription);
    return nil;
  }
  if (![[NSFileManager defaultManager] fileExistsAtPath:[marginsFileURL path]]) {
    return nil;
  }
  NSData *content = [NSData dataWithContentsOfURL:marginsFileURL];
  NSArray<NSDictionary *> *jsonArray = [NSJSONSerialization JSONObjectWithData:content
                                                                       options:0
                                                                         error:&error];
  if (!jsonArray) {
    NSLog(@"Deserializing margins failed: %@", error.localizedDescription);
    return nil;
  }
  return marginsFromJsonObject(jsonArray);
}

- (void)storeMargins:(NSArray<SpectacleMargin *> *)margins
{
  NSError *error;
  NSURL *marginsFileURL = findMarginsFileURL(&error);
  if (!marginsFileURL) {
    NSLog(@"Unable to locate the margins file: %@", error.localizedDescription);
    return;
  }
  NSData *contents = [NSJSONSerialization dataWithJSONObject:jsonObjectFromMargins(margins)
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  if (![contents writeToURL:marginsFileURL atomically:YES]) {
    NSLog(@"Unable to store margins at location: %@", [marginsFileURL path]);
  }
}

static NSURL *findMarginsFileURL(NSError **error)
{
  NSURL *marginsFileURL = [[SpectacleUtilities findOrCreateSpectacleDirectory:error] URLByAppendingPathComponent:@"Margins.json"];
  return marginsFileURL.URLByResolvingSymlinksInPath;
}

static NSArray<NSDictionary *> *jsonObjectFromMargins(NSArray<SpectacleMargin *> *margins)
{
  NSMutableArray<NSDictionary *> *jsonArray = [NSMutableArray new];
  for (SpectacleMargin *margin in margins) {
    [jsonArray addObject:@{
                           @"margin_name" : margin.marginName,
                           @"margin_size" : [NSNumber numberWithUnsignedInteger:margin.marginSize],
                           }];
  }
  return jsonArray;
}

static NSArray<SpectacleMargin *> *marginsFromJsonObject(NSArray<NSDictionary *> *jsonArray)
{
  NSMutableArray<SpectacleMargin *> *margins = [NSMutableArray new];
  for (NSDictionary *jsonObject in jsonArray) {
    NSString *marginName = jsonObject[@"margin_name"];
    NSUInteger marginSize = [jsonObject[@"margin_size"] unsignedIntegerValue];
    [margins addObject:[[SpectacleMargin alloc] initWithMarginName:marginName marginSize:marginSize]];
  }
  return margins;
}

@end
