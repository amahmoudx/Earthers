//
//  ApplicationServices.h
//  Earthers
//
//  Created by Ahmed Mahmoud on 4/20/16.
//  Copyright © 2016 spaceAppCairo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ServiceCompletionBlock)(id result, NSError *error);
@interface ApplicationServices : NSObject
- (void)getOpenWeatherData:(NSString *)lat :(NSString *)lon completionBlock:(ServiceCompletionBlock)completionBlock;
@end
