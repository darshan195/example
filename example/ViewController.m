//
//  ViewController.m
//  example
//
//  Created by Darshan on 10/03/15.
//  Copyright (c) 2015 cognizant. All rights reserved.
//

#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <FacebookSDK/FacebookSDK.h>


@interface ViewController ()
{

    UIImageView *myImageView;
    FBProfilePictureView *Fbpic;
}

@end

static NSString * const kClientId = @"605193397136-qk0e6pq524uiesv2rkricebor68ua8lg.apps.googleusercontent.com";

@implementation ViewController
@synthesize signInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
    
    signInButton = [[GPPSignInButton alloc]initWithFrame:CGRectMake(50, 50.0, 100.0,100.0)];
    [self.view addSubview:signInButton];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
     myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 200.0, 200.0,200.0)];
    [self.view addSubview:myImageView];
    
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions:
     @[@"public_profile", @"email", @"user_friends"]];
    loginView.delegate = self;
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
    }
}

-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        [self getUserInfoFromGoogle];
    }

}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSLog(@"Fetch info method called");
    Fbpic = [[FBProfilePictureView alloc]initWithFrame:CGRectMake(500.0, 700.0, 200.0, 200.0)];
    [self.view addSubview:Fbpic];
    Fbpic.profileID = user.objectID;
}


-(void)getUserInfoFromGoogle
{
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    GTMLoggerError(@"Error: %@", error);
                } else {
                    // Retrieve the display name and "about me" text
                    NSString *description = [NSString stringWithFormat:
                                             @"%@\n%@ %@ %@", person.displayName,
                                             person.gender,person.occupation,person.currentLocation];
                    GTLPlusPersonImage *image = person.image;
                    NSURL *url = [NSURL URLWithString:image.url];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                   
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    [myImageView setImage:img];
                
    
                    NSLog(@"My info is %@",description);
                }
            }];

}



@end
