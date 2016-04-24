//
//  ViewController.h
//  Earthers
//
//  Created by Ahmed Mahmoud on 4/18/16.
//  Copyright © 2016 spaceAppCairo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    UIImagePickerController *imagePicker;
    IBOutlet UIImageView *imageView;
    __weak IBOutlet UIScrollView *scrollView;
}
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;
- (IBAction)takePhoto:  (UIButton *)sender;
+(NSString *)documentsPath:(NSString *)fileName;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationStatusLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *resultsView;
@property (weak, nonatomic) IBOutlet UILabel *tempValue;
@property (weak, nonatomic) IBOutlet UILabel *pressureValue;
@property (weak, nonatomic) IBOutlet UILabel *humidityValue;
@property (weak, nonatomic) IBOutlet UILabel *dewValue;
@property (weak, nonatomic) IBOutlet UILabel *windValue;
@property (weak, nonatomic) IBOutlet UIImageView *directionImage;
@property (weak, nonatomic) IBOutlet UIImageView *satelliteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *CapIcon;
@property (weak, nonatomic) IBOutlet UILabel *CapLabel;
@property (weak, nonatomic) IBOutlet UIButton *CapBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Cat1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *Cat2;
@end

