//
//  ViewController.m
//  FBAndGooglePlace
//
//  Created by bhavik on 9/9/16.
//  Copyright © 2016 bhavik@zaptech. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC()
{
    ApplicationData *objAppData;
    PlaceLocateVC  *objviewController;
    BOOL *isPush;

}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    isPush = false;
    objAppData  = [ApplicationData sharedInstance];
    objviewController =(PlaceLocateVC *) [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"PlaceLocateVC"];
    //fb login method
    self.btnFBlogin.delegate = self;
    self.btnFBlogin.readPermissions = @[@"public_profile",@"email"];
    //google method
    [GIDSignInButton class];
    
    GIDSignIn *signIn = [GIDSignIn sharedInstance];
    signIn.shouldFetchBasicProfile = YES;
    signIn.delegate = self;
    signIn.uiDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Private method implementation

-(void)toggleHiddenState:(BOOL)shouldHide{
    //self.lblUsername.hidden = shouldHide;
    //self.lblEmail.hidden = shouldHide;
    //self.profilePicture.hidden = shouldHide;
}


#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
  //  [self.navigationController pushViewController:objviewController animated:YES];
}
-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    objAppData.objUserData.username = [user objectForKey:@"name"];
    objAppData.objUserData.socialId = [user objectForKey:@"id"];
    objAppData.objUserData.emailaddress = [user objectForKey:@"email"];
    
    if (isPush) {
    }
    else {
        isPush = true;
        [self.navigationController pushViewController:objviewController animated:YES];
    }
}
-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{

}
-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark - GIDSignInDelegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if(error) {
        NSLog(@"%@",[error description]);
    }
    else {
        objAppData.objUserData.username = user.profile.name;
        objAppData.objUserData.emailaddress = user.profile.email;
        objAppData.objUserData.socialId = user.userID;
        if (isPush) {
            
        }
        else {
            isPush = true;
            [self.navigationController pushViewController:objviewController animated:YES];
        }
    }
}
- (void)presentSignInViewController:(UIViewController *)viewController {
    [[self navigationController] pushViewController:viewController animated:YES];
}

@end
