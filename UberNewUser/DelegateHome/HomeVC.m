//
//  HomeVC.m
//  Wag
//
//  Created by Elluminati - macbook on 20/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "HomeVC.h"
#import "LoginVC.h"
#import "RegisterVC.h"
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "AFNHelper.h"
#import "AppDelegate.h"

@interface HomeVC ()
{
    CLLocationManager *locationManager;
    BOOL internet;
    NSUserDefaults *prefl;

}
@end

@implementation HomeVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefl =[NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"]);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"] isEqualToString:@"otp_true_not_verified"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:PREF_IS_LOGIN];
    }
    else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"] isEqualToString:@"otp_true_verified"])
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_IS_LOGIN];
    
        [self checkStatus];
}

-(void)checkStatus {
    internet=[APPDELEGATE connected];
    if ([CLLocationManager locationServicesEnabled])
    {
       // [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
        if(internet)
        {
            [self getUserLocation];
            self.lblName.text=NSLocalizedStringFromTable(APPLICATION_NAME,[prefl objectForKey:@"TranslationDocumentName"],nil);
            
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            if([pref boolForKey:PREF_IS_LOGIN]) {
                [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"ALREADY_LOGIN",[prefl objectForKey:@"TranslationDocumentName"],nil)];
                self.navigationController.navigationBarHidden=YES;
               // [[AppDelegate sharedAppDelegate]hideLoadingView];
                [self performSegueWithIdentifier:SEGUE_TO_DIRECT_LOGIN sender:self];
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
            [alert show];
        }
       // [[AppDelegate sharedAppDelegate]hideLoadingView];
    }
    else
    {
        UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enable location access from Setting -> Taxiappz Driver -> Privacy -> Location services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertLocation.tag=100;
        [alertLocation show];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    if([pref boolForKey:PREF_IS_LOGIN]) {
        //[[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"ALREADY_LOGIN",[prefl objectForKey:@"TranslationDocumentName"],nil)];
        self.navigationController.navigationBarHidden=YES;
        [self performSegueWithIdentifier:SEGUE_TO_DIRECT_LOGIN sender:self];
       // [[AppDelegate sharedAppDelegate] hideLoadingView];
    }
    if(![pref boolForKey:PREF_IS_LOGIN])
        self.navigationController.navigationBarHidden=YES;
    [self customFont];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    
    if(![pref boolForKey:PREF_IS_LOGIN])
        self.navigationController.navigationBarHidden=NO;
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark - Actions

-(IBAction)onClickSignIn:(id)sender
{
    //[self performSegueWithIdentifier:@"" sender:self];
}

-(IBAction)onClickRegister:(id)sender
{
    
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //segue.identifier
}

#pragma mark -
#pragma mark - Font & Color

-(void)customFont
{
        [self.btnSignin setBackgroundColor: [UberStyleGuide colorDefault]];
    [self.btnRegister setBackgroundColor: [UberStyleGuide colorSecondary]];
    
    [self.btnSignin setTitle:NSLocalizedStringFromTable(@"TITLE_SIGN_IN",[prefl objectForKey:@"TranslationDocumentName"],nil)forState:UIControlStateNormal];
    [self.btnRegister setTitle:NSLocalizedStringFromTable(@"TITLE_REGISTER", [prefl objectForKey:@"TranslationDocumentName"],nil)forState:UIControlStateNormal];
    //[self.btnRegister setTitle:NSLocalizedStringFromTable(@"TITLE_REGISTER", [pref objectForKey:@"TranslationDocumentName"],nil)forState:UIControlStateNormal];
    
}
#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)getUserLocation
{
    [locationManager startUpdatingLocation];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    locationManager.allowsBackgroundLocationUpdates = NO;
    
#ifdef __IPHONE_8_0
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
#endif
    [locationManager startUpdatingLocation];
}

@end
