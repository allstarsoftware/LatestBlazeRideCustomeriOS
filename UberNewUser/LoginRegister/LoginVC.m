 //
//  LoginVC.m
//  Uber
//
//  Created by Elluminati - macbook on 21/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "LoginVC.h"
#import "FacebookUtility.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "UtilityClass.h"
#import "UberStyleGuide.h"
#import "RMMapper.h"
#import "RMUser.h"
#import "RMUserDetails.h"
@import GoogleSignIn;
@import Firebase;

@interface LoginVC ()<GIDSignInUIDelegate, GIDSignInDelegate>
{
    NSString *strForSocialId,*strLoginType,*strForEmail;
    AppDelegate *appDelegate;
    NSString *strFirstName, *strLastName;
    UIImage *imgProfile;
    NSMutableArray *arrForCountry;
    NSUserDefaults *prefl;

    NSString *googleuserid;
    NSString *googleuseremail;
    NSString *googleuserfirstname;
    NSString *googleuserlastname;
    NSString *googleusername;

}

@end

@implementation LoginVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefl = [[NSUserDefaults alloc]init];
    
    [super setNavBarTitle:NSLocalizedStringFromTable(@"SIGN IN",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    [super setBackBarItem];
    arrForCountry=[[NSMutableArray alloc]init];
    [self.txtEmail setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPsw setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    strLoginType=@"manual";
    
    self.txtEmail.font=[UberStyleGuide fontRegular];
    self.txtPsw.font=[UberStyleGuide fontRegular];

    self.btnSignIn=[APPDELEGATE setBoldFontDiscriptor:self.btnSignIn];
    self.btnForgotPsw=[APPDELEGATE setBoldFontDiscriptor:self.btnForgotPsw];
    self.btnSignUp=[APPDELEGATE setBoldFontDiscriptor:self.btnSignUp];
    
    
    /*self.txtEmail.text=@"deep.gami077@gmail.com";
    self.txtPsw.text=@"123123";*/
    
    //[self performSegueWithIdentifier:SEGUE_SUCCESS_LOGIN sender:self];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    arrForCountry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

    NSString *reg=[[NSUserDefaults standardUserDefaults]valueForKey:@"reg"];
    if([reg isEqual:@"1"])
    {
        [FIRApp configure];
        [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"reg"];
    }
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;

    [GIDSignIn sharedInstance].uiDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[FacebookUtility sharedObject] logOutFromFacebook];
    [self setLocalization];
    [self customFont];
}

/*
 -(void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 self.navigationController.navigationBarHidden=YES;
 }
 
 -(void)viewWillDisappear:(BOOL)animated
 {
 self.navigationController.navigationBarHidden=NO;
 [super viewWillDisappear:animated];
 }
 */
-(void)setLocalization
{
    
    self.txtEmail.placeholder=NSLocalizedStringFromTable(@"Email",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtPsw.placeholder=NSLocalizedStringFromTable(@"Password",[prefl objectForKey:@"TranslationDocumentName"], nil);
    [self.btnForgotPsw setTitle:NSLocalizedStringFromTable(@"Forgot Password",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnSignIn setTitle:NSLocalizedStringFromTable(@"SIGN IN",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
}
- (void)viewDidAppear:(BOOL)animated
{
     [self.btnSignUp setTitle:NSLocalizedStringFromTable(@"SIGN IN",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
}

- (void)viewDidDisAppear:(BOOL)animated
{
    [[GIDSignIn sharedInstance] signOut];

}

#pragma mark -
#pragma mark - Actions



-(void)getFacebookProfileInfos
{
    /*
     [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
     parameters:@{@"fields": @"picture, email, first_name, last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
     if (!error) {
     strForEmail = [result objectForKey:@"email"];
     strForSocialId=[result valueForKey:@"id"];
     self.txtEmail.text=strForEmail;
     [[AppDelegate sharedAppDelegate]hideLoadingView];
     [self onClickLogin:nil];
     
     }
     else{
     NSLog(@"%@", [error localizedDescription]);
     }
     }];
     
     */
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, email, first_name, last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.txtEmail.text = [result objectForKey:@"email"];
             strForSocialId=[result valueForKey:@"id"];
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             [self onClickLogin:nil];
         }
         else
         {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}

- (IBAction)onClickGoogle:(id)sender
{
    strLoginType=@"google";
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    // ...
    if (error == nil)
    {
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];

        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error)
         {
             if (error)
             {
                 // ...
                 return;
             }
         }];

        googleuserid=user.userID;
        googleusername=user.profile.name;
        googleuserfirstname=user.profile.givenName;
        googleuserlastname=user.profile.familyName;
        googleuseremail=user.profile.email;
        self.txtEmail.text=googleuseremail;
        strForSocialId=googleuserid;
        [self onClickLogin:nil];

        // ...
    }
    else
    {
        // ...
    }
}

- (IBAction)onClickFacebook:(id)sender
{
    //    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
    
    strLoginType=@"facebook";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    NSArray *arraPermissions = [NSArray arrayWithObjects:@"public_profile",@"email", nil];
    [login logInWithReadPermissions:arraPermissions fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    {
                                if (error)
                                {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled)
                                {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in");
                                    [self getFacebookProfileInfos];
                                }
                            }];

    /*
     if (![[FacebookUtility sharedObject]isLogin])
     {
     [[FacebookUtility sharedObject]loginInFacebook:^(BOOL success, NSError *error)
     {
     [APPDELEGATE hideLoadingView];
     if (success)
     {
     NSLog(@"Success");
     appDelegate = [UIApplication sharedApplication].delegate;
     [appDelegate userLoggedIn];
     [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
     if (response) {
     strForSocialId=[response valueForKey:@"id"];
     strForEmail=[response valueForKey:@"email"];
     self.txtEmail.text=strForEmail;
     [[AppDelegate sharedAppDelegate]hideLoadingView];
     [self onClickLogin:nil];
     }
     }];
     }
     }];
     }
     else{
     NSLog(@"User Login Click");
     appDelegate = [UIApplication sharedApplication].delegate;
     [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
     [APPDELEGATE hideLoadingView];
     if (response) {
     strForSocialId=[response valueForKey:@"id"];
     strForEmail=[response valueForKey:@"email"];
     self.txtEmail.text=strForEmail;
     [[AppDelegate sharedAppDelegate]hideLoadingView];
     
     [self onClickLogin:nil];
     }
     }];
     [appDelegate userLoggedIn];
     }
     */
}

-(IBAction)onClickLogin:(id)sender
{
    [self Login];
}

-(void) Login
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if(self.txtEmail.text.length>0)
        {
            [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"LOGIN",[prefl objectForKey:@"TranslationDocumentName"],nil)];
            
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
            [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
            if([strLoginType isEqualToString:@"manual"])
                [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
            // else
            //     [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
            
            [dictParam setValue:strLoginType forKey:PARAM_LOGIN_BY];
            
            if([strLoginType isEqualToString:@"facebook"])
                [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
            else if ([strLoginType isEqualToString:@"google"])
                [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
            else
                [dictParam setValue:self.txtPsw.text forKey:PARAM_PASSWORD];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 NSLog(@"Login Response ---> %@",response);
                 if (response)
                 {
                     if([[response valueForKey:@"success"]boolValue])
                     {
                         RMUserDetails *getrooms = [RMMapper objectWithClass:[RMUserDetails class] fromDictionary:response];
                         NSDictionary *getDict = (NSDictionary *) getrooms.user;
                         RMUser *getUser = [RMMapper objectWithClass:[RMUser class] fromDictionary:getDict];
                          NSLog(@"test%@",getUser.phone);
                         
                         NSString *strLog=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"LOGIN_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"],nil),getUser.first_name];
                         [APPDELEGATE showToastMessage:strLog];
                         NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:[response valueForKey:@"user"] forKey:PREF_LOGIN_OBJECT];
                         [pref setObject:getUser.token forKey:PREF_USER_TOKEN];
                         [pref setObject:getUser.id forKey:PREF_USER_ID];
                         [pref setObject:getUser.phone forKey:PREF_MOBILE_NO];
                         [pref setObject:getUser.is_referee forKey:PREF_IS_REFEREE];
                         [pref setBool:YES forKey:PREF_IS_LOGIN];
                         [pref setObject:[[response valueForKey:@"user"] valueForKey:@"gender"] forKey:@"usergender"];
                         [pref synchronize];
                         [self performSegueWithIdentifier:SEGUE_SUCCESS_LOGIN sender:self];
                     }
                     else
                     {
                         if([[[response valueForKey:@"error_messages"] objectAtIndex:0] isEqualToString:@"The selected social unique id is invalid."]) {
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Kindly signup before signin" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                             [alert show];
                         }
                         else {
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                             [alert show];
                         }
                     }
                 }
             }];
        }
        else
        {
            if(self.txtEmail.text.length==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTable(@"PLEASE_EMAIL",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedStringFromTable(@"PLEASE_PASSWORD",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"],nil) message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil), nil];
        [alert show];
    }
}

/*
-(void)getFacebookProfileInfos {

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, email, first_name, last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.txtEmail.text = [result objectForKey:@"email"];
             strForSocialId=[result valueForKey:@"id"];
             strFirstName = [result objectForKey:@"first_name"];
             strLastName = [result objectForKey:@"last_name"];
             NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[result objectForKey:@"data"] valueForKey:@"url"]]];
             imgProfile = [UIImage imageWithData:data];
             [[AppDelegate sharedAppDelegate]hideLoadingView];
            
             
             
             [self onClickLogin:nil];

             
         }
         else{
             NSLog(@"%@", [error localizedDescription]);
         }
     }];

}

- (IBAction)onClickFacebook:(id)sender
{
    
    strLoginType=@"facebook";
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    NSArray *arraPermissions = [NSArray arrayWithObjects:@"public_profile",@"email", nil];
    [login logInWithReadPermissions:arraPermissions fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in");
                                    [self getFacebookProfileInfos];
                                }
                            }];
}

-(IBAction)onClickLogin:(id)sender
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if(self.txtEmail.text.length>0)
        {
            [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
            
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
            [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
            if([strLoginType isEqualToString:@"manual"])
                [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
            // else
            //     [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
            
            [dictParam setValue:strLoginType forKey:PARAM_LOGIN_BY];
            
            if([strLoginType isEqualToString:@"facebook"])
                [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
            else if ([strLoginType isEqualToString:@"google"])
                [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
            else
                [dictParam setValue:self.txtPsw.text forKey:PARAM_PASSWORD];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Login Response ---> %@",response);
                 if (response)
                 {
                     if([[response valueForKey:@"success"]boolValue])
                     {
                         NSString *strLog=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"LOGIN_SUCCESS", nil),[response valueForKey:@"first_name"]];
                         
                         [APPDELEGATE showToastMessage:strLog];
                         
                         
                         NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                         [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                         [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                         [pref setObject:[response valueForKey:@"phone"] forKey:PREF_MOBILE_NO];
                          [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                         [pref setBool:YES forKey:PREF_IS_LOGIN];
                         [pref synchronize];
                         
                         [self performSegueWithIdentifier:SEGUE_SUCCESS_LOGIN sender:self];
                     }
                     else
                     {
                         if([[[response valueForKey:@"error_messages"] objectAtIndex:0] isEqualToString:@"The selected social unique id is invalid."]) {
                             [self.viewForSocial setHidden:NO];

                         }
                         else {
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                             [alert show];
                         }
                     }
                 }
                 
             }];
        }
        else
        {
            if(self.txtEmail.text.length==0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_PASSWORD", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
}
*/
-(void)FinishFBRegistration {
    if ([self.txtSocialPhone.text length]==0) {
        [APPDELEGATE showToastMessage:@"Phone Number is mandatory"];
        return;
    }
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"Registering",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    NSString *strnumber=[NSString stringWithFormat:@"%@%@",self.btnSocialSelectCountry.titleLabel.text,self.txtSocialPhone.text];
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
    [dictParam setValue:strFirstName forKey:PARAM_FIRST_NAME];
    [dictParam setValue:strLastName forKey:PARAM_LAST_NAME];
    [dictParam setValue:strnumber forKey:PARAM_PHONE];
    [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
    [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
    [dictParam setValue:@"" forKey:PARAM_BIO];
    [dictParam setValue:@"" forKey:PARAM_ADDRESS];
    [dictParam setValue:@"" forKey:PARAM_STATE];
    [dictParam setValue:@"" forKey:PARAM_COUNTRY];
    [dictParam setValue:@"" forKey:PARAM_ZIPCODE];
    [dictParam setValue:@"facebook" forKey:PARAM_LOGIN_BY];
    [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
    
    if(imgProfile)
    {
        UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:imgProfile];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_REGISTER withParamDataImage:dictParam andImage:imgUpload withBlock:^(id response, NSError *error) {
            
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            if (response)
            {
                if([[response valueForKey:@"success"] boolValue])
                {
                    [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"REGISTER_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"],nil)];
//                    strForID=[response valueForKey:@"id"];
//                    strForToken=[response valueForKey:@"token"];
                    [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                    
                    [pref setObject:[[response valueForKey:@"user"] valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                    [pref setObject:[[response valueForKey:@"user"] valueForKey:@"phone"] forKey:PREF_MOBILE_NO];
                    [pref setObject:[[response valueForKey:@"user"] valueForKey:@"id"] forKey:PREF_USER_ID];
                    [pref setObject:[[response valueForKey:@"user"] valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                    [pref setBool:YES forKey:PREF_IS_LOGIN];
                    [pref synchronize];
                    [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
                }
                else
                {
                      if([[[response valueForKey:@"error_messages"] objectAtIndex:0] isEqualToString:@"The selected social unique id is invalid."])
                      {
                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Kindly signup before signin" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                          [alert show];
                      }
                      else
                      {
                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                          [alert show];
                      }
                }
            }
            NSLog(@"REGISTER RESPONSE --> %@",response);
        }];
        
    }
    else
    {
        NSLog(@"not profile");
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        NSLog(@"Parameter Check ---> %@",dictParam);
        [afn getDataFromPath:FILE_REGISTER withParamData:dictParam withBlock:^(id response, NSError *error) {
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            if (response)
            {
                if([[response valueForKey:@"success"] boolValue])
                {
                    [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"REGISTER_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"],nil)];
//                    strForID=[response valueForKey:@"id"];
//                    strForToken=[response valueForKey:@"token"];
                    [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                    
                    [pref setObject:[[response valueForKey:@"user"] valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                    [pref setObject:[[response valueForKey:@"user"] valueForKey:@"id"] forKey:PREF_USER_ID];
                    [pref setObject:[[response valueForKey:@"user"] valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                    [pref setBool:YES forKey:PREF_IS_LOGIN];
                    [pref synchronize];
                    [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
                    
                }
                else
                {
                    if([[[response valueForKey:@"error_messages"] objectAtIndex:0] isEqualToString:@"The selected social unique id is invalid."]) {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Kindly signup before signin" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                    [alert show];
                }
                else {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                    [alert show];
                }

                }
                
            }
            NSLog(@"REGISTER RESPONSE --> %@",response);
        }];
    }
}



-(IBAction)onClickForgotPsw:(id)sender
{
    [self textFieldShouldReturn:self.txtPsw];
    /*
    if (self.txtEmail.text.length==0)
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:@"Enter your email id."];
        return;
    }
    else if (![[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
    {
        [[UtilityClass sharedObject]showAlertWithTitle:@"" andMessage:@"Enter valid email id."];
        return;
    }
     */
}

#pragma mark -
#pragma mark - TextField Delegate
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.txtEmail resignFirstResponder];
    [self.txtPsw resignFirstResponder];
    [self.scrLogin setContentOffset:CGPointMake(0, -65) animated:YES];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int y=0;
    if (textField==self.txtEmail)
    {
        y=50;
    }
    else if (textField==self.txtPsw){
        y=100;
    }
    [self.scrLogin setContentOffset:CGPointMake(0, y) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.txtEmail)
    {
        [self.txtPsw becomeFirstResponder];
    }
    else if (textField==self.txtPsw){
        [textField resignFirstResponder];
        [self.scrLogin setContentOffset:CGPointMake(0, -65) animated:YES];
    }
    return YES;
}

#pragma mark -
#pragma mark - Table Mgmt

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrForCountry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *strForTitle=[NSString stringWithFormat:@"%@  %@",[[arrForCountry objectAtIndex:indexPath.row] valueForKey:@"phone-code"],[[arrForCountry objectAtIndex:indexPath.row] valueForKey:@"name"]];

    cell.textLabel.text = strForTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.btnSocialSelectCountry setTitle:[[arrForCountry objectAtIndex:indexPath.row] valueForKey:@"phone-code"] forState:UIControlStateNormal];
    [self.viewForPhoneBook setHidden:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -
#pragma mark - Font & Color
-(void)customFont
{
    /*[self.btnSignIn setBackgroundColor: [UberStyleGuide colorDefault]];
     [self.btnSignUp setBackgroundColor: [UberStyleGuide colorSecondary]];
     [self.btnForgotPsw setBackgroundColor: [UberStyleGuide colorDefault]];*/
    
    [self.btnSignIn setTitle:NSLocalizedStringFromTable(@"BTN_SIGN_IN",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    [self.btnSignUp setTitle:NSLocalizedStringFromTable(@"BTN_SIGN_IN",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    [self.btnForgotPsw setTitle:NSLocalizedStringFromTable(@"Forgot Password",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    //[self.txtEmail setText:NSLocalizedString(@"PH_EMAIL", nil)];
    //[self.txtPsw setText:NSLocalizedString(@"PH_PASSWORD", nil)];
    
    
}

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
