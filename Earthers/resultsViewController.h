//
//  resultsViewController.h
//  Earthers
//
//  Created by Ahmed Mahmoud on 4/20/16.
//  Copyright © 2016 spaceAppCairo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultsViewController : UIViewController
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lon;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempValue;
@property (weak, nonatomic) IBOutlet UILabel *pressureValue;
@property (weak, nonatomic) IBOutlet UILabel *HumidityValue;
@property (weak, nonatomic) IBOutlet UILabel *windValue;
@property (weak, nonatomic) IBOutlet UILabel *dewValue;
@property (weak, nonatomic) IBOutlet UIImageView *directionImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
