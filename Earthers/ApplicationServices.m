//
//  ApplicationServices.m
//  Earthers
//d
//  Created by Ahmed Mahmoud on 4/20/16.
//  Copyright © 2016 spaceAppCairo. All rights reserved.
//

#import "ApplicationServices.h"
#define APP_ID @"d5804710be4d79d35f2030d7cf1a41b5"
@implementation ApplicationServices
- (void)getOpenWeatherData:(NSString *)lat :(NSString *)lon completionBlock:(ServiceCompletionBlock)completionBlock{
    if (lat > 0 && lon >0){
        NSString *const URLString = @"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&appid=%@&units=metric";
        NSURL *msgURL = [NSURL URLWithString:[NSString stringWithFormat:URLString,lat,lon,APP_ID]];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *messageTask = [session dataTaskWithURL:msgURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
            if ([data length] >0 && error == nil){
                
                //process the JSON response
                //use the main queue so that we can interact with the screen
                dispatch_async(dispatch_get_main_queue(), ^{
                   // NSString * MYDATA = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
 
                    NSError *error = nil;
                    
                    //parsing the JSON response
                    NSDictionary *jsonObject = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                error:&error];
                    if (jsonObject != nil && error == nil){
                        //NSLog (@ "JSON data =%@", [jsonObject allValues]);
                        completionBlock(jsonObject, nil);
                    }else {
                        completionBlock(nil, error);
                    }
                });
            }
            else if ([data length] == 0 && error == nil){
                NSLog(@"Empty Response, not sure why?");
            }
            else if (error != nil){
                completionBlock(nil, error);
                // NSLog(@"View Controller Not again, what is the error = %@", error);
            }
        }];
        [messageTask resume];
    }
}
- (void)getOpenWeatherUVIData:(NSString *)lat :(NSString *)lon completionBlock:(ServiceCompletionBlock)completionBlock{
    if (lat > 0 && lon >0){
        NSString *const URLString = @"http://api.owm.io/air/1.0/uvi/current?lat=%@&lon=%@&appid=%@&units=metric";
        NSURL *msgURL = [NSURL URLWithString:[NSString stringWithFormat:URLString,lat,lon,APP_ID]];
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *messageTask = [session dataTaskWithURL:msgURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)  {
            if ([data length] >0 && error == nil){
                
                //process the JSON response
                //use the main queue so that we can interact with the screen
                dispatch_async(dispatch_get_main_queue(), ^{
                    // NSString * MYDATA = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                    
                    NSError *error = nil;
                    
                    //parsing the JSON response
                    NSDictionary *jsonObject = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:NSJSONReadingAllowFragments
                                                error:&error];
                    if (jsonObject != nil && error == nil){
                        //NSLog (@ "JSON data =%@", [jsonObject allValues]);
                        completionBlock(jsonObject, nil);
                    }else {
                        completionBlock(nil, error);
                    }
                });
            }
            else if ([data length] == 0 && error == nil){
                NSLog(@"Empty Response, not sure why?");
            }
            else if (error != nil){
                completionBlock(nil, error);
                // NSLog(@"View Controller Not again, what is the error = %@", error);
            }
        }];
        [messageTask resume];
    }
}
@end
