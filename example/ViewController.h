//
//  ViewController.h
//  example
//
//  Created by Darshan on 10/03/15.
//  Copyright (c) 2015 cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <FacebookSDK/FacebookSDK.h>

@class GPPSignInButton;

@interface ViewController : UIViewController<GPPSignInDelegate,FBLoginViewDelegate>

@property (strong, nonatomic)GPPSignInButton *signInButton;


@end

