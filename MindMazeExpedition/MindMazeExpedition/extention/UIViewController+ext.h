//
//  UIViewController+ext.h
//  MindMazeExpedition
//
//  Created by MindMaze Expedition on 14/02/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ext)

- (void)expeditionPushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)expeditionPresentModalViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)expeditionAddChildViewController:(UIViewController *)childController;

- (void)expeditionRemoveChildViewController:(UIViewController *)childController;

- (void)expeditionSetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

+ (NSString *)expeditionGetUserDefaultKey;

+ (void)expeditionSetUserDefaultKey:(NSString *)key;

- (void)expeditionSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)expeditionAppsFlyerDevKey;

- (NSString *)expeditionMainHostUrl;

- (BOOL)expeditionNeedShowAdsView;

- (void)expeditionShowAdView:(NSString *)adsUrl;

- (void)expeditionSendEventsWithParams:(NSString *)params;

- (NSDictionary *)expeditionJsonToDicWithJsonString:(NSString *)jsonString;

- (void)expeditionAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)expeditionAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;

@end

NS_ASSUME_NONNULL_END
