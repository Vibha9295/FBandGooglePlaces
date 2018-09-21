//
//  ViewController.h
//  FBAndGooglePlace
//
//  Created by bhavik on 9/9/16.
//  Copyright © 2016 bhavik@zaptech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "ApplicationData.h"
#import "PlaceLocateVC.h"

@interface LoginVC : UIViewController <FBLoginViewDelegate,GIDSignInDelegate,GIDSignInUIDelegate>

//@property(weak,nonatomic)IBOutlet FBLoginView *btnFBLogin;

@property (weak, nonatomic) IBOutlet FBLoginView *btnFBlogin;
@property (weak, nonatomic) IBOutlet GIDSignInButton *btnGoogleLogin;

@end

