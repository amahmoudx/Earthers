//
//  ViewController.h
//  Earthers
//
//  Created by Ahmed Mahmoud on 4/18/16.
//  Copyright © 2016 spaceAppCairo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    UIImagePickerController *imagePicker;
    IBOutlet UIImageView *imageView;
}
- (IBAction)takePhoto:  (UIButton *)sender;

@end

