//
//  resultsViewController.m
//  Earthers
//
//  Created by Ahmed Mahmoud on 4/20/16.
//  Copyright © 2016 spaceAppCairo. All rights reserved.
//

#import "resultsViewController.h"
#import "ApplicationServices.h"
@interface resultsViewController (){
    NSMutableDictionary *openWeatherDataArray;
}
@property (nonatomic, strong) ApplicationServices *service;

@end

@implementation resultsViewController
@synthesize lat;
@synthesize lon;
@synthesize LocationLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"lat: %@ long: %@",lat,lon);
    self.service = [[ApplicationServices alloc] init];
    [self.service getOpenWeatherData:lat :lon completionBlock:^(id result, NSError *error){
        openWeatherDataArray = result;
        NSLog(@"El result %@",openWeatherDataArray);

        [self configLabels];
    }];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)configLabels{
    if ([[[openWeatherDataArray objectForKey:@"sys"]objectForKey:@"country"] isEqualToString:@"none"]){
    LocationLabel.text = [NSString stringWithFormat:@"%@",[openWeatherDataArray objectForKey:@"name"]];
    }else{
        LocationLabel.text = [NSString stringWithFormat:@"%@, %@",[openWeatherDataArray objectForKey:@"name"],[[openWeatherDataArray objectForKey:@"sys"]objectForKey:@"country"]];
    }
   _locationStatusLabel.text = [[NSString stringWithFormat:@"%@",[[openWeatherDataArray objectForKey:@"weather"][0]objectForKey:@"description"]]capitalizedString];
    _tempValue.text = [NSString stringWithFormat:@"%@°",[[openWeatherDataArray objectForKey:@"main"]objectForKey:@"temp"]];
    _pressureValue.text = [NSString stringWithFormat:@"%@ hpa",[[openWeatherDataArray objectForKey:@"main"]objectForKey:@"pressure"]];
    _HumidityValue.text = [NSString stringWithFormat:@"%@%%",[[openWeatherDataArray objectForKey:@"main"]objectForKey:@"humidity"]];
    _windValue.text = [NSString stringWithFormat:@"%@",[[openWeatherDataArray objectForKey:@"wind"]objectForKey:@"speed"]];
    NSString *degrees = [NSString stringWithFormat:@"%@",[[openWeatherDataArray objectForKey:@"wind"]objectForKey:@"deg"]];
    _directionImage.transform = CGAffineTransformMakeRotation([degrees floatValue] * M_PI/180);
    _dewValue.text = [NSString stringWithFormat:@"%@°",[[openWeatherDataArray objectForKey:@"wind"]objectForKey:@"deg"]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
