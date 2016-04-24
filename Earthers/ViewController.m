//
//  ViewController.m
//  Earthers
//
//  Created by Ahmed Mahmoud on 4/18/16.
//  Copyright © 2016 spaceAppCairo. All rights reserved.
//

#import "ViewController.h"
#import "resultsViewController.h"
#import "ApplicationServices.h"
#import <MessageUI/MessageUI.h>
#import "RadioButton.h"
@interface ViewController ()<MFMailComposeViewControllerDelegate>
{
    NSMutableDictionary *openWeatherDataArray;
    #define FILE_EXTENSION    @".png"
    #define IMAGE_NAME        @"CameraImage"
    NSString *lat;
    NSString *lon;
    NSString *degrees;
}
@property (nonatomic, strong) ApplicationServices *service;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [self navigationBarEdits];
    [self.Cat1 addTarget:self action:@selector(disableOtherSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self.Cat2 addTarget:self action:@selector(disableOtherSegmentedControl:) forControlEvents:UIControlEventValueChanged];
}
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.view layoutIfNeeded];
    [self.view updateConstraints];
}
-(void)navigationBarEdits{
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    logo.frame = CGRectMake(75, 0, 40, 33);
    logo.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logo;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takePhoto:(UIButton *)sender {
    [self presentViewController:imagePicker animated:YES completion:nil];
}
+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"%@", fullPath);
    
    return fullPath;
}
#pragma mark - Image Picker Controller delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *fileSavePath = [ViewController documentsPath:IMAGE_NAME];
    fileSavePath = [fileSavePath stringByAppendingString:FILE_EXTENSION];
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //This checks to see if the image was edited, if it was it saves the edited version as a .png
    if ([info objectForKey:UIImagePickerControllerEditedImage]) {
        //save the edited image
        NSData *imgPngData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerEditedImage]);
        [imgPngData writeToFile:fileSavePath atomically:YES];
        
        
    }else{
        //save the original image
        NSData *imgPngData = UIImagePNGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage]);
        [imgPngData writeToFile:fileSavePath atomically:YES];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    lat = [NSString stringWithFormat:@"%f",locationManager.location.coordinate.latitude];
    lon =  [NSString stringWithFormat:@"%f",locationManager.location.coordinate.longitude];
    _resultsView.hidden=NO;
    _CapBtn.hidden=YES;
    _CapIcon.hidden=YES;
    _CapLabel.hidden=YES;
    _sendButton.hidden=NO;
    [self loadImage];
    self.service = [[ApplicationServices alloc] init];
    [self.service getOpenWeatherData:lat :lon completionBlock:^(id result, NSError *error){
        openWeatherDataArray = result;
       // NSLog(@"El result %@",openWeatherDataArray);
        
        [self configLabels];
    }];
}
-(void)configLabels{
    if ([[[openWeatherDataArray objectForKey:@"sys"]objectForKey:@"country"] isEqualToString:@"none"]){
        _locationLabel.text = [NSString stringWithFormat:@"%@",[openWeatherDataArray objectForKey:@"name"]];
    }else{
        _locationLabel.text = [NSString stringWithFormat:@"%@, %@",[openWeatherDataArray objectForKey:@"name"],[[openWeatherDataArray objectForKey:@"sys"]objectForKey:@"country"]];
    }
    _locationStatusLabel.text = [[NSString stringWithFormat:@"%@",[[openWeatherDataArray objectForKey:@"weather"][0]objectForKey:@"description"]]capitalizedString];
    _tempValue.text = [NSString stringWithFormat:@"%@°",[[openWeatherDataArray objectForKey:@"main"]objectForKey:@"temp"]];
    _pressureValue.text = [NSString stringWithFormat:@"%@ hpa",[[openWeatherDataArray objectForKey:@"main"]objectForKey:@"pressure"]];
    _humidityValue.text = [NSString stringWithFormat:@"%@%%",[[openWeatherDataArray objectForKey:@"main"]objectForKey:@"humidity"]];
    _windValue.text = [NSString stringWithFormat:@"%@",[[openWeatherDataArray objectForKey:@"wind"]objectForKey:@"speed"]];
    degrees = [NSString stringWithFormat:@"%@",[[openWeatherDataArray objectForKey:@"wind"]objectForKey:@"deg"]];
    _directionImage.transform = CGAffineTransformMakeRotation([degrees floatValue] * M_PI/180);
    NSString *DewVal = [NSString stringWithFormat:@"%@°",[[openWeatherDataArray objectForKey:@"wind"]objectForKey:@"deg"]];
    float dewFVal = [DewVal floatValue];
    _dewValue.text = [NSString stringWithFormat:@"%.1f°",dewFVal];
    
    NSString *ImageURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=16&scale=1&size=600x300&maptype=satellite&key=AIzaSyCx-JIUt-rFnFgkA3WWvFRJmMNKcaDvS0o&format=png&visual_refresh=true&markers=size:mid|color:0xff0000|label:|%@,%@",lat,lon,lat,lon];
    
    NSURL *imageURL = [NSURL URLWithString:[ImageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
       // NSLog(@"a7la msa %@",imageURL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.satelliteImageView.image = [UIImage imageWithData:imageData];
        });
    });

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadImage{
    NSString *path = [NSString stringWithFormat:@"%@%@",[ViewController documentsPath:IMAGE_NAME], FILE_EXTENSION];
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    _IconImageView.image = thumbNail;
}
- (IBAction)sendAction:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg_iPhone.png"] forBarMetrics:UIBarMetricsDefault];
        controller.navigationBar.tintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        [controller setSubject:@"User Photo Send for Nasa"];
        NSString *selectedCat;
        if (_Cat1.selectedSegmentIndex != -1){
            selectedCat = [_Cat1 titleForSegmentAtIndex:_Cat1.selectedSegmentIndex];
        }else if(_Cat2.selectedSegmentIndex != -1){
            selectedCat = [_Cat2 titleForSegmentAtIndex:_Cat2.selectedSegmentIndex];
        }
        
        NSString *mailContent=[NSString stringWithFormat:@"Hello,<br />Temp:%@ <br />Pressure: %@ <br/>Humidity:%@<br/>Wind Speed:%@ , Dir:%@<br />Clouds:%@<br />Selected Category:%@",_tempValue.text,_pressureValue.text,_humidityValue.text,_windValue.text,degrees,_dewValue.text,selectedCat];
        [controller setMessageBody:mailContent isHTML:YES];
        [controller setToRecipients:[NSArray arrayWithObjects:@"ahmedmahmoud7654@gmail.com",nil]];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        UIImage *ui = imageView.image;
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(ui)];
        [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"userImage"];
        UIImage *uix = _satelliteImageView.image;
        NSData *imageDatax = [NSData dataWithData:UIImagePNGRepresentation(uix)];
        [controller addAttachmentData:imageDatax mimeType:@"image/png" fileName:@"userImage"];

        if (controller) [self presentModalViewController:controller animated:YES];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"alrt" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil] ;
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
        switch (result) {
            case MFMailComposeResultCancelled:
                NSLog(@"cancel?");
                break;
            case MFMailComposeResultSaved:
                NSLog(@"saved?");
                break;
            case MFMailComposeResultSent:
                NSLog(@"Sent succed");
                [controller dismissModalViewControllerAnimated:YES];
                break;
            case MFMailComposeResultFailed:
                NSLog(@"sent failue");
                NSLog(@"%@",error);
                break;
            default:
                break;
        }
    [self dismissModalViewControllerAnimated:YES];
}
- (void) disableOtherSegmentedControl:(id)sender
{
    if (sender == self.Cat1)
    {
        self.Cat2.selectedSegmentIndex = -1;
    }
    
    else if (sender == self.Cat2)
    {
        self.Cat1.selectedSegmentIndex = -1;
    }
}
@end
