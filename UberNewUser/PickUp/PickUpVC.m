//
//  PickUpVC.m
//  UberNewUser
//
//  Created by Elluminati - macbook on 27/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "PickUpVC.h"
#import "SWRevealViewController.h"
#import "AFNHelper.h"
#import "AboutVC.h"
#import "ContactUsVC.h"
#import "ProviderDetailsVC.h"
#import "CarTypeCell.h"
#import "UIImageView+Download.h"
#import "CarTypeDataModal.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UberStyleGuide.h"
#import "EastimateFareVC.h"
#import "UIImageView+Download.h"
#import "UIView+Utils.h"
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPSessionManager.h"
#import "sbMapAnnotation.h"
#import <QuartzCore/QuartzCore.h>
#import "RMwalkerDetails.h"
#import "RMMapper.h"
#import "RMWalker.h"
#import "CancelSchedule_parsing.h"
#import "UserRequestInProgress.h"
#import "UserGetRequestLocation.h"
#import "UserCreateRequest.h"
#import "GetallApplicationtypes.h"
#import "GetApplicationTypeDetails.h"

@interface PickUpVC ()<SWRevealViewControllerDelegate,UITextFieldDelegate>
{
    NSString *strForUserId,*strForUserToken,*strForLatitude,*strForLongitude,*strForRequestID,*strForDriverLatitude,*strForDriverLongitude,*strForTypeid,*strForCurLatitude,*strForCurLongitude,*strMinFare,*strPassCap,*strETA,*Referral,*dist_price,*time_price,*driver_id,*strMobileno;
    NSString  *str_price_per_unit_distance, *str_base_distance,*strPayment_Option, *strForDriverList;
    NSMutableArray *arrForInformation,*arrForApplicationType,*arrForAddress,*arrDriver,*arrType;
    NSMutableDictionary *driverInfo;
    GMSMapView *mapView_;
    BOOL is_paymetCard,is_Fare,is_vehicleselected,is_containsVehicle;
    NSUserDefaults *pref;
    NSString *strType;
    SWRevealViewController *revealViewController;
    NSUserDefaults *prefl ;
    GMSMarker *markerOwner;
    NSString *Hours,*Minutes;
    NSString *MapPickerTag,*StrForDropLat,*StrForDropLong;
    NSString *Hrs,*Mins,*Mode;
    GMSMarker *Pickup_Marker;
}

@end

@implementation PickUpVC
{
    
}

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
  if([[AppDelegate sharedAppDelegate]connected])
  {
      [super viewDidLoad];
      [self DisplayAnalogClock];
      markerOwner = [[GMSMarker alloc] init];
      pref=[NSUserDefaults standardUserDefaults];
      prefl = [[NSUserDefaults alloc]init];
      is_paymetCard=YES;
      // [[AppDelegate sharedAppDelegate] hideLoadingView];
      //    self.navigationController.navigationBar.barTintColor = [UberStyleGuide colorDefault];
      //    self.navigationController.navigationBar.translucent = NO;
      
      
      is_vehicleselected = false;
      [self checkRequestInProgress];
      
      Referral=@"";
      strForTypeid=@"0";
      strPayment_Option = @"1";
      self.btnCancel.hidden=YES;
      arrForAddress=[[NSMutableArray alloc]init];
      arrForApplicationType=[[NSMutableArray alloc]init];
      
      self.tableForCity.hidden=YES;
      self.viewForPreferral.hidden=YES;
      self.viewForReferralError.hidden=YES;
      is_Fare=NO;
      driverInfo=[[NSMutableDictionary alloc] init];
      pref=[NSUserDefaults standardUserDefaults];
      self.viewForDriver.hidden=YES;
      [self.img_driver_profile applyRoundedCornersFullWithColor:[UIColor whiteColor]];
      if(![[pref valueForKey:PREF_IS_REFEREE] boolValue])
      {
          self.viewForPreferral.hidden=NO;
          self.navigationController.navigationBarHidden=YES;
          self.btnMyLocation.hidden=YES;
          self.btnETA.hidden=YES;
      }
      else
      {
          // [self setTimerToCheckDriverStatus];
      }
      
      //--------------
      if([[pref valueForKey:PREF_IS_REFEREE] boolValue])
      {
          self.navigationController.navigationBarHidden=NO;
          [self MapLandingLocation];
          [self getAllApplicationType];
          [super setNavBarTitle:TITLE_PICKUP];
          [self customSetup];
          [self checkForAppStatus];
          [self getPagesData];
          [self.paymentView setHidden:YES];
          if(is_Fare==NO)
          {
              self.viewETA.hidden=YES;
              self.viewForFareAddress.hidden=YES;
              // [self getProviders];
          }
          else
          {
              self.viewETA.hidden=NO;
              self.viewForFareAddress.hidden=YES;
              pref=[NSUserDefaults standardUserDefaults];
              self.lblFareAddress.text=[pref valueForKey:PRFE_FARE_ADDRESS];
              self.lblFare.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),[pref valueForKey:PREF_FARE_AMOUNT]];
              
              //            [self.btnFare setTitle:[NSString stringWithFormat:@"%@",[pref valueForKey:PRFE_FARE_ADDRESS]] forState:UIControlStateNormal];
              //            self.btnFare.titleLabel.numberOfLines=2;
              //            self.btnFare.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
          }
          [self cashBtnPressed:nil];
      }
      //-----------------
      
      [self updateLocationManagerr];
      CLLocationCoordinate2D coordinate = [self getLocation];
      strForCurLatitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
      strForCurLongitude= [NSString stringWithFormat:@"%f", coordinate.longitude];
      strForLatitude=strForCurLatitude;
      strForLongitude=strForCurLatitude;
      [self getAddress];
      GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[strForCurLatitude doubleValue] longitude:[strForCurLongitude doubleValue] zoom:14];
      mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.viewGoogleMap.frame.size.width, self.viewGoogleMap.frame.size.height) camera:camera];
      mapView_.myLocationEnabled = NO;
      mapView_.delegate=self;
      [self.viewGoogleMap addSubview:mapView_];
      [self.view bringSubviewToFront:self.tableForCity];

  }
  else
  {
      UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                    message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                             preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
      [alert addAction:cancelButton];
      [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
      [super viewWillAppear:animated];
      [revealViewController setDelegate:self];
      [self SetLocalization];
      [self customFont];
      [self customSetup];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.viewforPickupLabel.layer.borderWidth = 3;
    self.viewforPickupLabel.layer.borderColor = [[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0] CGColor];
    self.viewForReferralError.hidden=YES;
    self.viewForDriver.hidden=YES;
    self.viewForMarker.center=CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-40);
    self.ViewforETA.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-95);
    self.ViewforETA.layer.cornerRadius = 3;
    self.ViewforETA.layer.masksToBounds = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    pref=[NSUserDefaults standardUserDefaults];
    if([[pref valueForKey:PREF_IS_REFEREE] boolValue])
    {
        self.navigationController.navigationBarHidden=NO;
        //        [self getAllApplicationType];
        [super setNavBarTitle:TITLE_PICKUP];
        [self checkForAppStatus];
        [self getPagesData];
        [self.paymentView setHidden:YES];
        if(is_Fare==NO)
        {
            self.viewETA.hidden=YES;
            self.viewForFareAddress.hidden=YES;
            //            [self getProviders];
        }
        else
        {
            self.viewETA.hidden=NO;
            self.viewForFareAddress.hidden=YES;
            pref=[NSUserDefaults standardUserDefaults];
            self.lblFareAddress.text=[pref valueForKey:PRFE_FARE_ADDRESS];
            self.lblFare.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),[pref valueForKey:PREF_FARE_AMOUNT]];
            if(strETA.length>0)
            {
                self.lblETA.text=strETA;
            }
            else
            {
                self.lblETA.text=@"0 min";
            }
            if (is_containsVehicle)
                self.lblforETA.text = [NSString stringWithFormat:@"%@", strETA];
            else
                self.lblforETA.text = @"--";
            //            [self.btnFare setTitle:[NSString stringWithFormat:@"%@",[pref valueForKey:PRFE_FARE_ADDRESS]] forState:UIControlStateNormal];
            //            self.btnFare.titleLabel.numberOfLines=2;
            //            self.btnFare.titleLabel.lineBreakMode= NSLineBreakByWordWrapping;
        }
        [self cashBtnPressed:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtAddress resignFirstResponder];
    [self.txtDropoffAddress resignFirstResponder];
    //self.viewETA.hidden=YES;
    is_Fare=NO;
    self.viewForFareAddress.hidden=YES;
    self.lblFare.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),strMinFare];
}
- (void)customSetup
{
    revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.panGuestureview addGestureRecognizer:revealViewController.panGestureRecognizer];
        [self.revealButtonItem addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        //        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
}
-(void)SetLocalization
{
    //NSString *check = [prefl objectForKey:@"TranslationDocumentName"];
    NSLog(@"translationdocument name --->> %@",NSLocalizedStringFromTable(@"RIDE_NOW",@"LocalizableSpanish",nil));
    [self.btnRideNow setTitle:NSLocalizedStringFromTable(@"RIDE_NOW",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    
    [self.btnRideLater setTitle:NSLocalizedStringFromTable(@"RIDE_LATER",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    [self.btnPickMeUp setTitle:NSLocalizedStringFromTable(@"PICK ME UP",@"LocalizablePortuguese",nil) forState:UIControlStateNormal];
    [self.btnFare setTitle:NSLocalizedStringFromTable(@"GET FARE ESTIMATE",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    [self.btnFare setTitle:NSLocalizedStringFromTable(@"GET FARE ESTIMATE",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    // [self.btnClose setTitle:NSLocalizedStringFromTable(@"Close",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    // [self.btnClose setTitle:NSLocalizedStringFromTable(@"Close",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    [self.btnPayCancel setTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnPayCancel setTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    [self.btnPayRequest setTitle:NSLocalizedStringFromTable(@"Request",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnPayRequest setTitle:NSLocalizedStringFromTable(@"Request",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    [self.btnSelService setTitle:NSLocalizedStringFromTable(@"SELECT SERVICE YOU NEED",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnSelService setTitle:NSLocalizedStringFromTable(@"SELECT SERVICE YOU NEED",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    [self.bReferralSkip setTitle:NSLocalizedStringFromTable(@"SKIP",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.bReferralSkip setTitle:NSLocalizedStringFromTable(@"SKIP",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    [self.bReferralSubmit setTitle:NSLocalizedStringFromTable(@"ADD",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.bReferralSubmit setTitle:NSLocalizedStringFromTable(@"ADD",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    [self.btnCancel setTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnCancel setTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    [self.btnRatecard setTitle:NSLocalizedStringFromTable(@"RATE CARD",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnRatecard setTitle:NSLocalizedStringFromTable(@"RATE CARD",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
//    [self.btnCard setTitle:NSLocalizedStringFromTable(@"Cash",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
//    [self.btnCash setTitle:NSLocalizedStringFromTable(@"Card",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btndone_ridelatrview setTitle:NSLocalizedStringFromTable(@"Done",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btncancel_ridelatrview setTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnrequest_ridelatrview setTitle:NSLocalizedStringFromTable(@"Request",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    
    [self.btnSOSBack setTitle:NSLocalizedStringFromTable(@"Back",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnSOSPolice setTitle:NSLocalizedStringFromTable(@"Police",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnSOSAmbulance setTitle:NSLocalizedStringFromTable(@"Ambulance",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnSOSFireStation setTitle:NSLocalizedStringFromTable(@"Fire Station",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    
    
    self.lblcard_name.text = NSLocalizedStringFromTable(@"Card",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblcash_name.text = NSLocalizedStringFromTable(@"Cash",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblsosbtn_clickdmsg.text = NSLocalizedStringFromTable(@"CLICK_SOS",[prefl objectForKey:@"TranslationDocumentName"], nil);
    //self.lblselectyourjourney.text = NSLocalizedStringFromTable(@"Select Country", nil);
    self.lblchoosedate_ridelatrview.text = NSLocalizedStringFromTable(@"Please choose Date",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblchoosetime_ridelatrview.text = NSLocalizedStringFromTable(@"Please choose Time",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblnote_ridelatrview.text = NSLocalizedStringFromTable(@"Note",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblthisisjustET_text.text = NSLocalizedStringFromTable(@"This_is_justET",[prefl objectForKey:@"TranslationDocumentName"], nil);
    
    
    self.lETA.text=NSLocalizedStringFromTable(@"ETA",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lMaxSize.text=NSLocalizedStringFromTable(@"MAX SIZE",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lMinFare.text=NSLocalizedStringFromTable(@"MIN FARE",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lSelectPayment.text=NSLocalizedStringFromTable(@"Select Your Payment Type",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lRefralMsg.text=NSLocalizedStringFromTable(@"Referral_Msg",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lRate_basePrice.text=NSLocalizedStringFromTable(@"Base Price :",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lRate_distancecost.text=NSLocalizedStringFromTable(@"Distance Cost :",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lRate_TimeCost.text=NSLocalizedStringFromTable(@"Time Cost :",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblRateCradNote.text=NSLocalizedStringFromTable(@"Rate_card_note",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtAddress.placeholder=NSLocalizedStringFromTable(@"SEARCH",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtPreferral.placeholder=NSLocalizedStringFromTable(@"Enter Referral Code",[prefl objectForKey:@"TranslationDocumentName"], nil);
    
    
}

#pragma mark-
#pragma mark- Custom Font & Color

-(void)customFont
{
    self.txtAddress.font=[UberStyleGuide fontRegular];
    self.txtDropoffAddress.font=[UberStyleGuide fontRegular];
    self.btnCancel=[APPDELEGATE setBoldFontDiscriptor:self.btnCancel];
    self.btnPickMeUp=[APPDELEGATE setBoldFontDiscriptor:self.btnPickMeUp];
    self.btnSelService=[APPDELEGATE setBoldFontDiscriptor:self.btnSelService];
    self.lRate_basePrice.font = [UberStyleGuide fontSemiBold:13.0f];
    self.lRate_distancecost.font = [UberStyleGuide fontSemiBold:13.0f];
    self.lRate_TimeCost.font = [UberStyleGuide fontSemiBold:13.0f];
    self.lblRate_BasePrice.font = [UberStyleGuide fontRegular:13.0f];
    self.lblRate_DistancePrice.font = [UberStyleGuide fontRegular:13.0f];
    self.lblRate_TimePrice.font = [UberStyleGuide fontRegular:13.0f];
    
    [self.btnSOS setTitleColor:[UberStyleGuide colorDefault] forState:(UIControlStateNormal)];
    [self.btnSOSBack setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.btnSOSPolice setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.btnSOSAmbulance setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.btnSOSFireStation setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.lblSOStitle setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.lblTitle setTextColor:[UberStyleGuide colorDefault]];
    [self.btnRideLater setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.btnRideNow setBackgroundColor:[UberStyleGuide colorSecondary]];
    [self.btnRatecard setBackgroundColor:[UberStyleGuide colorSecondary]];
    
    
}

#pragma mark -
#pragma mark - Location Delegate

-(CLLocationCoordinate2D) getLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
}

-(void)updateLocationManagerr
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
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    strForCurLatitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    strForCurLongitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
//    StrForDropLat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
//    StrForDropLong = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSLog(@"Drop Update %@ %@",StrForDropLat,StrForDropLong);
    // GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:newLocation.coordinate zoom:14];
    //[mapView_ animateWithCameraUpdate:updatedCamera];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    
}

#pragma mark-
#pragma mark- Alert Button Clicked Event

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==100)
    {
        if (buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
        }
    }
    if(alertView.tag==911)
    {
        if (buttonIndex == 1)
        {
            NSString *phoneNumber = [@"tel://" stringByAppendingString:@"12345"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            
            
        }
    }
    if(alertView.tag==108)
    {
        if (buttonIndex == 1)
        {
            NSString *phoneNumber = [@"tel://" stringByAppendingString:@"12345"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            
            
        }
    }
    if(alertView.tag==101)
    {
        if (buttonIndex == 1)
        {
            NSString *phoneNumber = [@"tel://" stringByAppendingString:@"12345"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
}

#pragma mark- Google Map Delegate

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    self.ViewDottedline.hidden = NO;
    self.ImageMarkerMapCentre.hidden=YES;
    [self.ViewDottedline.layer setCornerRadius:5.0];
    self.LblGetting_Address.textColor = [UIColor whiteColor];
    self.ViewDottedline.backgroundColor = [UberStyleGuide colorSecondary];
    self.ImgMarkerDottedLine.image = [UIImage imageNamed:@"pin_client_org"];
    if ([MapPickerTag isEqualToString:@"Pickup"])
    {
        self.ViewDottedline.backgroundColor = [UberStyleGuide colorSecondary];
        self.ImgMarkerDottedLine.image = [UIImage imageNamed:@"pin_client_org"];
    }
    else if ([MapPickerTag isEqualToString:@"Destination"])
    {
        self.ViewDottedline.backgroundColor = [UberStyleGuide colorDefault];
        self.ImgMarkerDottedLine.image = [UIImage imageNamed:@"pin_destination"];
    }
    self.ImgXmarkforLocation.hidden = NO;
    self.bottomView.hidden = YES;
    self.viewforPickupLabel.hidden = YES;
    self.btnETA.hidden = YES;
    self.navigationController.navigationBarHidden=YES;
    NSLog(@"Map Dragging");
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    
    NSLog(@"Camera Position Changes");
  
      //strForLatitude=[NSString stringWithFormat:@"%f",position.target.latitude];
      //strForLongitude=[NSString stringWithFormat:@"%f",position.target.longitude];
//    markerOwner.map=nil;
    if (![MapPickerTag isEqualToString:@"Destination"])
    {
        NSLog(@"Destination");
        strForLatitude=[NSString stringWithFormat:@"%f",position.target.latitude];
        strForLongitude=[NSString stringWithFormat:@"%f",position.target.longitude];
//        [self getAddress];
    }
    else
    {
        StrForDropLat=[NSString stringWithFormat:@"%f",position.target.latitude];
        StrForDropLong=[NSString stringWithFormat:@"%f",position.target.longitude];
        NSLog(@"Drop values %@ %@",StrForDropLat,StrForDropLong);
    }
}

- (void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    @try
    {
        NSLog(@"Map Dragging Stopped");
        self.bottomView.hidden = NO;
        self.ViewDottedline.hidden = YES;
        self.ImgXmarkforLocation.hidden = YES;
        self.viewforPickupLabel.hidden = NO;
        self.btnETA.hidden = NO;
        self.navigationController.navigationBarHidden=NO;
        self.ImageMarkerMapCentre.hidden=NO;
        if ([MapPickerTag isEqualToString:@"Destination"])
        {
            
            self.ImageMarkerMapCentre.hidden=YES;
            [self marksoff:position];
            [self GetDropAddress];
            
        }
        //    CLLocationCoordinate2D center;
        //    center.latitude=[strForLatitude doubleValue];
        //    center.longitude = [strForLongitude doubleValue];
        //    GMSMarker *startMarker = [GMSMarker markerWithPosition:center];
        //    startMarker.appearAnimation = kGMSMarkerAnimationPop;
        //    startMarker.icon = [UIImage imageNamed:@"pin_client_org"];
        //    startMarker.map = mapView_;
        // if([strForDriverList isEqualToString:@"No Service Provider found around you."])
        if(strForDriverList)
            NSLog(@"hello");
        else
        {
            [self getETA:[arrDriver objectAtIndex:0]];
        }
        [self getAddress];
        // [self GetDropAddress];
        [self getProviders];
    }
    @catch (NSException *exception)
    {
    
    }
    @finally
    {
        
    }
}

-(void)GetDropAddress
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&key=AIzaSyCgxqkPlvKEo0wptKpZsHSMFgtVxptLLFE",[StrForDropLat floatValue], [StrForDropLong floatValue], [StrForDropLat floatValue], [StrForDropLong floatValue]];
    
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
    
    NSDictionary *getRoutes = [JSON valueForKey:@"routes"];
    NSDictionary *getLegs = [getRoutes valueForKey:@"legs"];
    NSArray *dropAddress = [getLegs valueForKey:@"end_address"];
    NSLog(@"Get Drp Address  Result-%@",dropAddress);
    if (dropAddress.count!=0)
    {
        if ([[[dropAddress objectAtIndex:0]objectAtIndex:0] isEqualToString:@"338, Nigeria"])
        {
            self.txtDropoffAddress.text=@"";
        }
        else
            self.txtDropoffAddress.text=[[dropAddress objectAtIndex:0]objectAtIndex:0];
            self.LblGetting_Address.text=[[dropAddress objectAtIndex:0]objectAtIndex:0];
        [pref setObject:self.txtDropoffAddress.text forKey:@"Dest_Address"];
        [pref synchronize];
    }

}

-(void)getAddress
{
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&key=AIzaSyCgxqkPlvKEo0wptKpZsHSMFgtVxptLLFE",[strForLatitude floatValue], [strForLongitude floatValue], [strForLatitude floatValue], [strForLongitude floatValue]];
    
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
    
    NSDictionary *getRoutes = [JSON valueForKey:@"routes"];
    NSDictionary *getLegs = [getRoutes valueForKey:@"legs"];
    NSArray *getAddress = [getLegs valueForKey:@"end_address"];
    NSLog(@"Get Address  Result-%@",getAddress);
    if (getAddress.count!=0)
    {
            if ([[[getAddress objectAtIndex:0]objectAtIndex:0] isEqualToString:@"338, Nigeria"])
            {
                self.txtAddress.text=@"";
            }
            else
                self.txtAddress.text=[[getAddress objectAtIndex:0]objectAtIndex:0];
                self.LblGetting_Address.text=[[getAddress objectAtIndex:0]objectAtIndex:0];
        
    }
}


#pragma mark - SWRevealViewController Delegate Methods

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        [self.panGuestureview setHidden:YES];
    } else {
        [self.panGuestureview setHidden:NO];
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        [self.panGuestureview setHidden:YES];
        
    } else {
        [self.panGuestureview setHidden:NO];
    }
}


#pragma mark -
#pragma mark - Mapview Delegate
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKAnnotationView *annot=[[MKAnnotationView alloc] init];
    
    SBMapAnnotation *temp=(SBMapAnnotation*)annotation;
    if (temp.yTag==1000)
    {
        annot.image=[UIImage imageNamed:@"pin_driver"];
    }
    if (temp.yTag==1001)
    {
        annot.image=[UIImage imageNamed:@"pin_client_org"];
        
    }
    
    return annot;
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}

-(void)showMapCurrentLocatinn
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    
    GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coordinate zoom:14];
    [mapView_ animateWithCameraUpdate:updatedCamera];
    
    [self getAddress];
}


#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark- Searching Method

- (IBAction)Searching:(id)sender
{
    aPlacemark=nil;
    [placeMarkArr removeAllObjects];
    self.tableForCity.hidden=YES;
    //  CLGeocoder *geocoder;
    NSString *str= @"";
    if ([self.txtAddress isFirstResponder])
        str= self.txtAddress.text;
    else if ([self.txtDropoffAddress isFirstResponder])
        str= self.txtDropoffAddress.text;
    
    NSLog(@"%@",str);
    if(str == nil)
        self.tableForCity.hidden=YES;
   // For searching the nearby places within a radius First
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    NSString *userlocation = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc] init];
    //[dictParam setObject:str forKey:PARAM_ADDRESS];
    [dictParam setObject:str forKey:@"input"]; // AUTOCOMPLETE API
    [dictParam setObject:@"false" forKey:@"sensor"]; // AUTOCOMPLETE API
    //    [dictParam setObject:GOOGLE_KEY forKey:PARAM_KEY];
    [dictParam setObject:Google_Map_API_Key forKey:PARAM_KEY];
    [dictParam setObject:userlocation forKey:@"location"];
    [dictParam setObject:@"500" forKey:@"radius"];
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
    [afn getAddressFromGooglewAutoCompletewithParamData:dictParam withBlock:^(id response, NSError *error)
     {
         if(response)
         {
             //NSArray *arrAddress=[response valueForKey:@"results"];
             NSArray *arrAddress=[response valueForKey:@"predictions"]; //AUTOCOMPLTE API
             
             NSLog(@"AutoCompelete URL: = %@",[[response valueForKey:@"predictions"] valueForKey:@"description"]);
             
             if ([arrAddress count] > 0)
             {
                 self.tableForCity.hidden=NO;
                 
                 placeMarkArr=[[NSMutableArray alloc] initWithArray:arrAddress copyItems:YES];
                 //[placeMarkArr addObject:Placemark]; o
                 [self.tableForCity reloadData];
                 
                 if(arrAddress.count==0)
                 {
                     self.tableForCity.hidden=YES;
                 }
             }
             
         }
         
     }];
    
}

#pragma mark - Tableview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    
    
    NSString *formatedAddress=[[placeMarkArr objectAtIndex:indexPath.row] valueForKey:@"description"]; // AUTOCOMPLETE API
    cell.backgroundColor = [UIColor lightGrayColor];
    // cell.lblTitle.text=currentPlaceMark.name;
    cell.textLabel.text=formatedAddress;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    aPlacemark=[placeMarkArr objectAtIndex:indexPath.row];
    self.tableForCity.hidden=YES;
    // [self textFieldShouldReturn:nil];
    
    [self setNewPlaceData];
  
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return placeMarkArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(void)setNewPlaceData
{
    if ([self.txtAddress isFirstResponder])
    {
        self.txtAddress.text = [NSString stringWithFormat:@"%@",[aPlacemark objectForKey:@"description"]];
        [self textFieldShouldReturn:self.txtAddress];
    }
    else  if ([self.txtDropoffAddress isFirstResponder])
    {
        self.txtDropoffAddress.text = [NSString stringWithFormat:@"%@",[aPlacemark objectForKey:@"description"]];
        [self textFieldShouldReturn:self.txtDropoffAddress];
        [self MarkDropOff];
    }
}


-(void)marksoff:(GMSCameraPosition *)position
{
    markerOwner.map = nil;
    CLLocationCoordinate2D center;
    center.latitude=position.target.latitude;
    center.longitude = position.target.longitude;
    markerOwner.appearAnimation = kGMSMarkerAnimationPop;
    markerOwner.position = center;
    markerOwner.map = mapView_;
}

-(void)MarkDropOff
{
    CLLocationCoordinate2D center;
    if (([self.txtDropoffAddress.text length]>0) && (![MapPickerTag isEqualToString:@"Destination"]))
    {
        CLLocationCoordinate2D center;
        center=[self getLocationFromAddressString:self.txtDropoffAddress.text];
        
        
//                double  latFrom=center.latitude;
//                double  lonFrom=center.longitude;
//        
//                CLLocationCoordinate2D currentOwner;
//                currentOwner.latitude=[strowner_lati doubleValue];
//                currentOwner.longitude=[strowner_longi doubleValue];
       // GMSCameraUpdate *updatedCamera2 = [GMSCameraUpdate setTarget:center zoom:14];
       // [mapView_ animateWithCameraUpdate:updatedCamera2];
//        center.latitude=[[pref objectForKey:@"Destination_Latitude"] doubleValue];
//        center.longitude = [[pref objectForKey:@"Destination_Longitude"] doubleValue];
        markerOwner.position = center;
        markerOwner.appearAnimation = kGMSMarkerAnimationPop;
        markerOwner.icon = [UIImage imageNamed:@"pin_destination"];
        markerOwner.map = mapView_;
    }
    else
    {
        center.latitude = [StrForDropLat doubleValue];
        center.longitude = [StrForDropLong doubleValue];
        markerOwner.position = center;
        markerOwner.appearAnimation = kGMSMarkerAnimationPop;
        markerOwner.icon = [UIImage imageNamed:@"pin_destination"];
        markerOwner.map = mapView_;
    }
    
}

#pragma mark -
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:SEGUE_ABOUT])
    {
        AboutVC *obj=[segue destinationViewController];
        obj.arrInformation=arrForInformation;
    }
    else if([segue.identifier isEqualToString:SEGUE_TO_ACCEPT])
    {
        ProviderDetailsVC *obj=[segue destinationViewController];
        obj.strForLatitude=strForLatitude;
        obj.strForLongitude=strForLongitude;
        obj.strForWalkStatedLatitude=strForDriverLatitude;
        obj.strForWalkStatedLongitude=strForDriverLongitude;
    }
    else if([segue.identifier isEqualToString:@"contactus"])
    {
        ContactUsVC *obj=[segue destinationViewController];
        obj.dictContent=sender;
    }
    else if ([segue.identifier isEqualToString:@"segueToEastimate"])
    {
        EastimateFareVC *obj=[segue destinationViewController];
        obj.strForLatitude=strForLatitude;
        obj.strForLongitude=strForLongitude;
        obj.strMinFare=strMinFare;
        obj.str_base_distance = str_base_distance;
        obj.str_price_per_unit_distance = str_price_per_unit_distance;
    }
}

-(void)goToSetting:(NSString *)str
{
    [self performSegueWithIdentifier:str sender:self];
}

#pragma mark -
#pragma mark - UIButton Action

- (IBAction)eastimateFareBtnPressed:(id)sender
{
    is_Fare=YES;
    self.viewForRateCard.hidden=YES;
    [[AppDelegate sharedAppDelegate]showHUDLoadingView:@"Loading..."];
    [self performSegueWithIdentifier:@"segueToEastimate" sender:nil];
    
}

- (IBAction)closeETABtnPressed:(id)sender
{
    self.viewETA.hidden=YES;
    self.viewForFareAddress.hidden=YES;
    self.lblFare.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),strMinFare];
    is_Fare=NO;
}

- (IBAction)RateCardBtnPressed:(id)sender
{
    self.viewForRateCard.hidden=NO;
}


- (IBAction)ETABtnPressed:(id)sender {
    if (strForTypeid==nil || [strForTypeid isEqualToString:@"0"])
    {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"SELECT_TYPE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        return;
    }
    self.viewETA.hidden=NO;
    self.viewForRateCard.hidden=YES;
    //    [self.btnFare setTitle:NSLocalizedString(@"GET FARE ESTIMATE", nil) forState:UIControlStateNormal];
    //    [self.btnFare setTitle:NSLocalizedString(@"GET FARE ESTIMATE", nil) forState:UIControlStateSelected];
}

- (IBAction)cashBtnPressed:(id)sender
{
    [self.btnCash setSelected:YES];
    [self.btnCard setSelected:NO];
    is_paymetCard=NO;
    strPayment_Option = @"1";
}

- (IBAction)cardBtnPressed:(id)sender
{
    [self.btnCash setSelected:NO];
    [self.btnCard setSelected:YES];
    self.btnPayRequest.enabled=true;
    self.btnPayRequest.alpha=1.0;
    is_paymetCard=YES;
    strPayment_Option = @"0";
}

- (IBAction)requestBtnPressed:(id)sender
{
    if([CLLocationManager locationServicesEnabled])
    {
        if ([strForTypeid isEqualToString:@"0"]||strForTypeid==nil)
        {
            strForTypeid=@"1";
        }
        if(![strForTypeid isEqualToString:@"0"])
        {
            if(((strForLatitude==nil)&&(strForLongitude==nil))
               ||(([strForLongitude doubleValue]==0.00)&&([strForLatitude doubleValue]==0)))
            {
                [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"NOT_VALID_LOCATION",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            }
            else
            {
                if([[AppDelegate sharedAppDelegate]connected])
                {
                    
                    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"REQUESTING",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                    pref=[NSUserDefaults standardUserDefaults];
                    strForUserId=[pref objectForKey:PREF_USER_ID];
                    strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
                    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                    NSString *pickupLat = [pref objectForKey:@"Pickup_Latitude"];
                    NSString *pickupLong = [pref objectForKey:@"Pickup_Longitude"];
                    [dictParam setValue:strForLatitude forKey:PARAM_LATITUDE];
                    [dictParam setValue:strForLongitude  forKey:PARAM_LONGITUDE];
                    NSLog(@"Pickup Latitude 0 %@",pickupLat);
                    NSLog(@"Pickup Longitude 0  %@",pickupLong);
                    if ([self.txtDropoffAddress.text length]>0)
                    {
                        CLLocationCoordinate2D center;
                        center=[self getLocationFromAddressString:self.txtDropoffAddress.text];
                        NSString *Drop_Latitude = [pref objectForKey:@"Destination_Latitude"];
                        NSString *Drop_Longitude = [pref objectForKey:@"Destination_Longitude"];
                        [dictParam setValue:[NSString stringWithFormat:@"%@",Drop_Latitude] forKey:@"d_latitude"];
                        [dictParam setValue:[NSString stringWithFormat:@"%@",Drop_Longitude]  forKey:@"d_longitude"];
                        NSLog(@"Drop Latitude %f",center.latitude);
                        NSLog(@"Drop Longitude %f",center.longitude);
                    }
                    [dictParam setValue:strForLatitude forKey:PARAM_LATITUDE];
                    [dictParam setValue:strForLongitude  forKey:PARAM_LONGITUDE];
                    [dictParam setValue:self.txtAddress.text forKey:@"pickupDetails"];
                    [dictParam setValue:self.txtDropoffAddress.text  forKey:@"dropoffDetails"];
                    
                    NSLog(@"Pickup Latitude %@",strForLatitude);
                    NSLog(@"Pickup Longitude %@",strForLongitude);

                    NSLog(@"Pickup Address %@",self.txtAddress.text);
                    NSLog(@"Drop Address %@",self.txtDropoffAddress.text);
                    //[dictParam setValue:@"22.3023117"  forKey:PARAM_LATITUDE];
                    //[dictParam setValue:@"70.7969645"  forKey:PARAM_LONGITUDE];
                    [dictParam setValue:@"1" forKey:PARAM_DISTANCE];
                    [dictParam setValue:strForUserId forKey:PARAM_ID];
                    [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
                    [dictParam setValue:strForTypeid forKey:PARAM_TYPE];
                    if (is_paymetCard)
                    {
                        [dictParam setValue:@"0" forKey:PARAM_PAYMENT_OPT];
                    }
                    else
                    {
                        [dictParam setValue:@"1" forKey:PARAM_PAYMENT_OPT];
                    }
                    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                    [afn getDataFromPath:FILE_CREATE_REQUEST withParamData:dictParam withBlock:^(id response, NSError *error)
                     {
                         [[AppDelegate sharedAppDelegate]hideLoadingView];
                         NSDictionary *jsonObject = (NSDictionary *) response;
                         NSLog(@"Response check %@",jsonObject);
                         self.paymentView.hidden=YES;
                         if (response)
                         {
                             if([[response valueForKey:@"success"]boolValue])
                             {
                                 NSLog(@"Response check %@",response);
                                 NSDictionary *jsonObject = (NSDictionary *) response;
                                 NSLog(@"Response check %@",jsonObject);
                                 
                                 UserCreateRequest *gettest = [RMMapper objectWithClass:[UserCreateRequestDetail class] fromDictionary:jsonObject];
                                 NSLog(@"Testdata17: %@",gettest.walker);
                                 if([[response valueForKey:@"success"]boolValue])
                                 {
                                     NSMutableDictionary *walker=[response valueForKey:@"walker"];
                                     [self showDriver:walker];
                                     pref=[NSUserDefaults standardUserDefaults];
                                     strForRequestID=[response valueForKey:@"request_id"];
                                     [pref setObject:strForRequestID forKey:PREF_REQ_ID];
                                     [self setTimerToCheckDriverStatus];
                                     [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"COTACCTING_SERVICE_PROVIDER",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                                     [self.btnCancel setHidden:NO];
                                     [self.viewForDriver setHidden:NO];
                                     [APPDELEGATE.window addSubview:self.btnCancel];
                                     [APPDELEGATE.window bringSubviewToFront:self.btnCancel];
                                     [APPDELEGATE.window addSubview:self.viewForDriver];
                                     [APPDELEGATE.window bringSubviewToFront:self.viewForDriver];
                                 }
                             }
                             else
                             {
                                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@""
                                                                                               message:@"error"
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                                        style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction * action)
                                                                {
                                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                                }];
                                 [alert addAction:cancelButton];
                                 [self presentViewController:alert animated:YES completion:nil];
                             }
                         }
                     }];
                }
                else
                {

                    UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                                  message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action)
                                                   {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
                    [alert addAction:cancelButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }
        else
            [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"SELECT_TYPE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Enable location access from Setting -> Blaze Ride -> Privacy -> Location services"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)cancelBtnPressed:(id)sender
{
    [self.paymentView setHidden:YES];
}

- (IBAction)CancelRideLaterBtnPressed:(id)sender
{
    [self.viewForRideLater setHidden:YES];
}

- (IBAction)pickMeUpBtnPressed:(id)sender
{
    if (strForTypeid==nil || [strForTypeid isEqualToString:@"0"])
    {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"SELECT_TYPE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        return;
    }
    else if (!is_containsVehicle) {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"NO_VEHICLE_AVAILABLE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        return;
    }
    [self.viewForRideLater setHidden:YES];
    [self.paymentView setHidden:NO];
    
    
}
- (IBAction)pickMeLaterBtnPressed:(id)sender
{
    [_BackgroundviewAnalogclockview setHidden:YES];//Analog Time Picker
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (strForTypeid==nil || [strForTypeid isEqualToString:@"0"])
    {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"SELECT_TYPE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        return;
    }
    else if (!is_containsVehicle) {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"NO_VEHICLE_AVAILABLE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        return;
    }
    [self.paymentView setHidden:YES];
    [self.viewForRideLater setHidden:NO];
}

-(IBAction)datePickerBtnAction:(id)sender
{
    [_viewDatePicker setHidden:NO];
    [_viewTimePicker setHidden:YES];
    
    [_BackgroundviewAnalogclockview setHidden:NO];//Analog Date & Time Picker created by Gopi
    [_CalendardatepickerView setHidden:NO];
   // _CalendardatepickerView.scope = FSCalendarScopeWeek; //Weekmode Calendar
    [_ViewCalendrDonebutton setHidden:NO];
    [_analogclockview setHidden:YES];
    _CalendardatepickerView.layer.cornerRadius = 5;
    _CalendardatepickerView.layer.masksToBounds = YES;
    _ViewCalendrDonebutton.layer.cornerRadius = 5;
    _ViewCalendrDonebutton.layer.masksToBounds = YES;
    self.ViewCalendrDonebutton.backgroundColor = [UberStyleGuide colorSecondary];
    NSString *DateSelectedatCalendar = [pref objectForKey:@"SelectedCalendarDate"];
    NSLog(@"Testing Date Selected from Calendar %@",DateSelectedatCalendar);
    //self.view.backgroundColor = [UIColor whiteColor];
    
    //    _viewDatePicker = [[UIDatePicker alloc] init];
    _viewDatePicker.datePickerMode=UIDatePickerModeDate;
    self.viewForPicker.hidden=YES;  //Changed by gopi
    //    _viewDatePicker.date=[NSDate date];
    [_viewDatePicker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventValueChanged];
}

-(IBAction)timePickerBtnAction:(id)sender
{
    [_BackgroundviewAnalogclockview setHidden:NO];//Analog Date & Time Picker created by Gopi
    [_CalendardatepickerView setHidden:YES];
    [_ViewCalendrDonebutton setHidden:YES];
    [_analogclockview setHidden:NO];
    [self DisplayAnalogClock];
    
    [_viewDatePicker setHidden:YES];
    [_viewTimePicker setHidden:YES];// Gopi changed
    //    _viewTimePicker = [[UIDatePicker alloc] init];
    _viewTimePicker.datePickerMode=UIDatePickerModeTime;
    self.viewForPicker.hidden=YES;//Gopi changed
    //    _viewDatePicker.date=[NSDate date];
    [_viewTimePicker addTarget:self action:@selector(setTime:) forControlEvents:UIControlEventValueChanged];
}

-(IBAction)btnDonePicker:(id)sender
{
    self.viewForPicker.hidden=YES;
}

-(void)setDate:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
   // NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_viewDatePicker.date]]; //Changed by Gopi
    
    //Added by Gopi
    NSString *DateSelectedatCalendar = [pref objectForKey:@"SelectedCalendarDate"];
    
    [self.btnPickDate setTitle:DateSelectedatCalendar forState:UIControlStateNormal];
}
-(void)setTime:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:SS"];
    //NSString *Time = [dateFormatter stringFromDate:_viewTimePicker.date]; //Changed by Gopi
    
    //Added by Gopi
    Hours = self.analogclockHours.text;
    Minutes = self.analogclockMinutes.text;
    NSLog(@"Set Time Title %@",self.btnPickTime.titleLabel.text);
}

//************ Method for Custom Date & Analog Time picker *************
- (IBAction)CalendrDoneBtn:(id)sender
{
    NSLog(@"Testing Done Button Action");
    NSString *DateSelectedatCalendar = [pref objectForKey:@"SelectedCalendarDate"];
    [self.btnPickDate setTitle:DateSelectedatCalendar forState:UIControlStateNormal];
    [_BackgroundviewAnalogclockview setHidden:YES];
    [_CalendardatepickerView setHidden:YES];
    [_ViewCalendrDonebutton setHidden:YES];
    
}

- (IBAction)DoneButton:(id)sender
{
    [_BackgroundviewAnalogclockview setHidden:YES];//Analog Time Picker
    self.view.backgroundColor = [UIColor whiteColor];
    Hours = self.analogclockHours.text;
    Minutes = self.analogclockMinutes.text;
    NSLog(@"time at lable %@  %@",Hours,Minutes);
    NSString *Time = [NSString stringWithFormat:@"%@:%@ %@",Hrs,Mins,Mode];
   
    [self.btnPickTime setTitle:Time forState:UIControlStateNormal];
}
- (IBAction)ResetButton:(id)sender
{
    [self DisplayAnalogClock];
}

-(void)DisplayAnalogClock
{
    CGFloat Height = [[UIScreen mainScreen] bounds].size.height;
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    
    NSLog(@"iphone Height %f",Height);
    NSLog(@"iphone  Width %f",width);
    self.view.backgroundColor = [UIColor lightGrayColor];
    ESTimePicker *analogtimePicker = [[ESTimePicker alloc] initWithDelegate:self]; // Delegate is optional
    [analogtimePicker setNotation24Hours:NO];
    if([[UIScreen mainScreen] respondsToSelector:NSSelectorFromString(@"scale")])
    {
        if (width == 320.000000 || Height == 568.000000)
        {
           [analogtimePicker setFrame:CGRectMake(30, 70, 180, 180)];
//            CustomTimePicker *TimePickerNew = [[CustomTimePicker alloc] initWithView:self.analogclockview withDarkTheme:false];
//            TimePickerNew.delegate = self;
//            [TimePickerNew setFrame:CGRectMake(10,30,300,500)];
//            TimePickerNew.layer.cornerRadius = 5;
//            TimePickerNew.layer.masksToBounds = YES;
//            [self.analogclockview addSubview:TimePickerNew];
            NSLog(@"iphone 5");
        }
        if (width == 375.000000)
        {
            [analogtimePicker setFrame:CGRectMake(40, 70, 230, 230)];
            NSLog(@"iphone 6");
        }
//        if (width>=3.0)
//        {
//            [analogtimePicker setFrame:CGRectMake(63, 70, 200, 200)];
//        }
    }
    
    [self.BackgroundviewAnalogclockview addSubview:_analogclockview];
    _analogclockview.layer.cornerRadius = 5;
    _analogclockview.layer.masksToBounds = YES;
//    [self.analogclockview addSubview:analogtimePicker];
    [self timePickerHoursChanged:analogtimePicker toHours:12];
    [self timePickerMinutesChanged:analogtimePicker toMinutes:00];
    
    CustomTimePicker *TimePickerNew = [[CustomTimePicker alloc] initWithView:self.analogclockview withDarkTheme:false];
    TimePickerNew.delegate = self;
//    [TimePickerNew setFrame:CGRectMake(0,0,50, 50)];
    TimePickerNew.layer.cornerRadius = 5;
    TimePickerNew.layer.masksToBounds = YES;
    [self.analogclockview addSubview:TimePickerNew];
   
}

- (void)timePickerHoursChanged:(ESTimePicker *)timePicker toHours:(int)hours
{
    if (hours<10)
    {
        [_analogclockHours setText:[NSString stringWithFormat:@"0%i", hours]];
        NSLog(@"Hours Value %d",hours);
    }
    else
    {
        [_analogclockHours setText:[NSString stringWithFormat:@"%i", hours]];
    }
    
}

- (void)timePickerMinutesChanged:(ESTimePicker *)timePicker toMinutes:(int)minutes
{
    if (minutes<10)
    {
        [_analogclockMinutes setText:[NSString stringWithFormat:@"0%i", minutes]];
    }
    else
    {
        [_analogclockMinutes setText:[NSString stringWithFormat:@"%i", minutes]];
    }
    
}

-(void)dismissClockViewWithHours:(NSString *)hours andMinutes:(NSString *)minutes andTimeMode:(NSString *)timeMode
{
    Hrs = hours;
    Mins = minutes;
    Mode = timeMode;
    NSString *Time = [NSString stringWithFormat:@"%@:%@ %@",Hrs,Mins,Mode];
    [self.btnPickTime setTitle:Time forState:UIControlStateNormal];
    [_BackgroundviewAnalogclockview setHidden:YES];
    NSLog(@"%@:%@ %@", hours, minutes, timeMode);
    NSLog(@"Manual Time :%@ %@:00 %@",Hrs,Mins,Mode);
}

-(void)MapLandingLocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        CLLocationCoordinate2D coor;
        coor.latitude=[strForCurLatitude doubleValue];
        coor.longitude=[strForCurLongitude doubleValue];
        coor.latitude=[StrForDropLat doubleValue];
        coor.longitude=[StrForDropLong doubleValue];
        GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coor zoom:14];
        [mapView_ animateWithCameraUpdate:updatedCamera];

    }
    else
    {

        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Enable location access from Setting -> Blaze Ride -> Privacy -> Location services"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//*********** Ending of Time Picker Method ************

- (IBAction)RequestRideLaterBtnPressed:(id)sender
{
    
    NSString *strCurrentTime;
    NSString *RideTime;
    if ([self.btnPickTime.currentTitle isEqualToString:@"Select Time"])
    {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"Kindly select a time",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        return;
    }
    if ([self.btnPickDate.currentTitle isEqualToString:@"Select Date"])
    {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"Kindly select a date",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        return;
    }
    else
    {
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"YYYY-MM-dd"];
        NSDate *date = [dateFormat dateFromString:self.btnPickDate.currentTitle];
        NSString *strCurrentDate = [dateFormat stringFromDate:[NSDate date]];
        NSDate *currentdate = [dateFormat dateFromString:strCurrentDate];
        if ([currentdate compare:date] == NSOrderedDescending)
        {
            [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"Date should not be in past.",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            return;
        }
        else
        {
            NSDateFormatter *timeFormatter2 = [[NSDateFormatter alloc] init];
            
            [timeFormatter2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSTimeZone *timeZone = [NSTimeZone localTimeZone];
            [timeFormatter2 setTimeZone:timeZone];
            
            // *********Analog Clock time convertion begins Added by Gopi***********
            NSString *SelectedTime = [NSString stringWithFormat:@"%@",self.btnPickTime.currentTitle];
            NSLog(@"Slctd Time %@",SelectedTime);
            
            NSString *str = [NSString stringWithFormat:@"%@",self.btnPickTime.currentTitle];
            
            str = [str stringByReplacingOccurrencesOfString:@" "
                                                 withString:@":00 "];
            NSLog(@"Replacedstr %@",str);
            
            NSDate *today = [NSDate date];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            NSString *TodayDatestr = [dateFormat stringFromDate:today];
            NSString *Newstring = [NSString stringWithFormat:@"%@ %@",TodayDatestr,str];
            NSString *TimeForServer;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aaa"];
            NSDate *date = [dateFormatter dateFromString:Newstring];
            [dateFormatter setDateFormat:@"HH:mm"];
            TimeForServer = [dateFormatter stringFromDate: date];
            
            NSLog(@"dateStringpick: %@", TimeForServer);

            NSString *Analogclocktime = [NSString stringWithFormat:@"%@:00",TimeForServer];
           // NSDate *AnalogConvertedtime=[timeFormat dateFromString:Analogclocktime];
            NSLog(@"Timetest is  %@",Analogclocktime);
           // *********Analog Clock time convertion Ends Added by Gopi***********
            
         NSDate *time=[timeFormatter2 dateFromString:[NSString stringWithFormat:@"%@ %@",self.btnPickDate.currentTitle,Analogclocktime]];
            strCurrentTime = [timeFormatter2 stringFromDate:[NSDate date]];
            NSDate *currenttime = [timeFormatter2 dateFromString:strCurrentTime];
            RideTime = [timeFormatter2 stringFromDate:time];
            NSTimeInterval secondsBetween = [time timeIntervalSinceDate:currenttime];
            if ([currenttime compare:time] == NSOrderedDescending||[currenttime compare:time] == NSOrderedSame||secondsBetween/60 < 30)
            {
                [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"Time should be greater than 30 mins.",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                return;
            }
        }
    }
    
    if([CLLocationManager locationServicesEnabled])
    {
        if ([strForTypeid isEqualToString:@"0"]||strForTypeid==nil)
        {
            strForTypeid=@"1";
        }
        if(![strForTypeid isEqualToString:@"0"])
        {
            if(((strForLatitude==nil)&&(strForLongitude==nil))
               ||(([strForLongitude doubleValue]==0.00)&&([strForLatitude doubleValue]==0)))
            {
                [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"NOT_VALID_LOCATION",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            }
            else
            {
                if([[AppDelegate sharedAppDelegate]connected])
                {
                    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"REQUESTING",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                    pref=[NSUserDefaults standardUserDefaults];
                    strForUserId=[pref objectForKey:PREF_USER_ID];
                    strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
                    strMobileno =[pref objectForKey:PREF_MOBILE_NO];
                    
                    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
                   // NSString *tzName = [timeZone name];
                    
                    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                    [dictParam setValue:strForLatitude forKey:PARAM_PICKUP_LATITUDE];
                    [dictParam setValue:strForLongitude forKey:PARAM_PICKUP_LONGITUDE];
                    [dictParam setValue:RideTime forKey:PARAM_SCHEDULE];
                    [dictParam setValue:@"+05:30" forKey:PARAM_USER_TIMEZONE];
                    [dictParam setValue:strForTypeid forKey:PARAM_TYPE_OF_CAR];
                    [dictParam setValue:self.txtAddress.text forKey:PARAM_PICKUP_LOCATION];
                    [dictParam setValue:self.txtDropoffAddress.text forKey:PARAM_DROP_OFF_LOCATION];
                    [dictParam setValue:strForUserId forKey:PARAM_USERID];
                    [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
                    [dictParam setValue:@"" forKey:PARAM_DROPOFF_LATITUDE];
                    [dictParam setValue:@"" forKey:PARAM_DROPOFF_LONGITUDE];
                    
                    
                    //                    [dictParam setValue:strMobileno forKey:PARAM_MOBILE_NUMBER];
                    //                    [dictParam setValue:@"" forKey:PARAM_CUSTOM_ADDRESS];
                    //                    [dictParam setValue:@"" forKey:PARAM_NUMBER_OF_ADULTS];
                    //                    [dictParam setValue:@"" forKey:PARAM_NUMBER_OF_CHILDREN];
                    //                    [dictParam setValue:@"" forKey:PARAM_LUGGAGE_COUNT];
                    //                    [dictParam setValue:@"" forKey:PARAM_RIDE_COMMENT];
                    //                    [dictParam setValue:@"" forKey:PARAM_PICKUP_DETAILS];
                    //                    [dictParam setValue:@"" forKey:PARAM_DROP_OFF_DETAILS];
                    //                    [dictParam setValue:@"" forKey:PARAM_EXECUTIVE_USERID];

                    //'YYYY-MM-DD HH:MM:SS'
                    
                    
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    [manager POST:@"https://ride.blazeride.com/dog/addschedule" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
                    {
                        [[AppDelegate sharedAppDelegate]hideLoadingView];
                        [self.viewForRideLater setHidden:YES];
                        
                        NSLog(@"JSON: %@", responseObject);
                        NSDictionary *result = (NSDictionary*)responseObject;
                        if ([[result objectForKey:@"success"] boolValue])
                        {
                            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                                          message:@"Your ride has been scheduled successfully"
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                                   style:UIAlertActionStyleDefault
                                                                                 handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                            [alert addAction:cancelButton];
                            [self presentViewController:alert animated:YES completion:nil];

                        }
                        else
                        {
                            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                                          message:@"Could not schedule ride right now. kindly try again."
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                                   style:UIAlertActionStyleDefault
                                                                                 handler:^(UIAlertAction * action)
                                                           {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                            [alert addAction:cancelButton];
                            [self presentViewController:alert animated:YES completion:nil];
                        }
                    } failure:^(NSURLSessionTask *operation, NSError *error)
                    {
                        NSLog(@"Error: %@", error);
                    }];
                }
                else
                {
                    UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                                  message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action)
                                                   {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
                    [alert addAction:cancelButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            
        }
        else
            [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"SELECT_TYPE", [prefl objectForKey:@"TranslationDocumentName"], nil)];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Enable location access from Setting -> Blaze Ride -> Privacy -> Location services"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)cancelReqBtnPressed:(id)sender
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([[AppDelegate sharedAppDelegate]connected])
        {
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"CANCLEING",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            
            pref=[NSUserDefaults standardUserDefaults];
            strForUserId=[pref objectForKey:PREF_USER_ID];
            strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strReqId=[pref objectForKey:PREF_REQ_ID];
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            
            [dictParam setValue:strForUserId forKey:PARAM_ID];
            [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
            [dictParam setValue:strReqId forKey:PARAM_REQUEST_ID];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_CANCEL_REQUEST withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 if (response)
                 {
                     if([[response valueForKey:@"success"]boolValue])
                     {
                         NSDictionary *set = response;
                         CancelSchedule_parsing* tester = [RMMapper objectWithClass:[CancelSchedule_parsing class] fromDictionary:set];
                         NSLog(@"Tdata: %@",tester.success);
                         [timerForCheckReqStatus invalidate];
                         timerForCheckReqStatus=nil;
                         [[AppDelegate sharedAppDelegate]hideLoadingView];
                         self.btnCancel.hidden=YES;
                         self.viewForDriver.hidden=YES;
                         //[self.btnCancel removeFromSuperview];
                         [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"REQUEST_CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                         
                     }
                     else
                     {}
                 }
                 
                 
             }];
        }
        else
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                          message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                           }];
            [alert addAction:cancelButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Enable location access from Setting -> Blaze Ride -> Privacy -> Location services"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)myLocationPressed:(id)sender
{
    if ([CLLocationManager locationServicesEnabled])
    {
        CLLocationCoordinate2D coor;
        coor.latitude=[strForCurLatitude doubleValue];
        coor.longitude=[strForCurLongitude doubleValue];
        GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coor zoom:14];
        [mapView_ animateWithCameraUpdate:updatedCamera];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"Please Enable location access from Setting -> Blaze Ride -> Privacy -> Location services"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)selectServiceBtnPressed:(id)sender
{
    UIDevice *thisDevice=[UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        float closeY=(iOSDeviceScreenSize.height-self.btnSelService.frame.size.height);
        
        float openY=closeY-(self.bottomView.frame.size.height-self.btnSelService.frame.size.height);
        if (self.bottomView.frame.origin.y==closeY)
        {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                self.bottomView.frame=CGRectMake(0, openY, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                
            } completion:^(BOOL finished)
             {
             }];
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.bottomView.frame=CGRectMake(0, closeY, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
            } completion:^(BOOL finished)
             {
             }];
        }
    }
}

-(IBAction)btnSOSAction:(id)sender
{
    [self.viewForSOS setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [self.viewForSOS setFrame:self.view.frame];
}

-(IBAction)btnSOSCancel:(id)sender
{
    [self.viewForSOS setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

-(IBAction)btnSOSPolice:(id)sender
{
    UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"SOS" message:NSLocalizedStringFromTable(@"SOS_CALL_POLICE",[prefl objectForKey:@"TranslationDocumentName"], nil) delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
    alertLocation.tag=911;
    [alertLocation show];
}

-(IBAction)btnSOSAmbulance:(id)sender
{
    UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"SOS" message:NSLocalizedStringFromTable(@"SOS_CALL_AMBULANCE", [prefl objectForKey:@"TranslationDocumentName"], nil) delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
    alertLocation.tag=108;
    [alertLocation show];
}

-(IBAction)btnSOSFireStation:(id)sender
{
    UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"SOS" message:NSLocalizedStringFromTable(@"SOS_CALL_FIRESTATION",[prefl objectForKey:@"TranslationDocumentName"], nil) delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"OK", nil];
    alertLocation.tag=101;
    [alertLocation show];
}

#pragma mark -
#pragma mark - Custom WS Methods

-(void)getAllApplicationType
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setValue:strForLatitude forKey:@"user_lat"];
        [dictParam setValue:strForLongitude forKey:@"user_long"];
        arrType=[[NSMutableArray alloc]init];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_APPLICATION_TYPE withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             NSLog(@"Test%@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue])
                 {
                     arrForApplicationType=[[NSMutableArray alloc]init];
                     NSMutableArray *arr=[[NSMutableArray alloc]init];
                     //[arr addObjectsFromArray:[response valueForKey:@"types"]];
                     NSMutableArray *arrtypewithoutvalidation=[[NSMutableArray alloc]init];

                     arrtypewithoutvalidation=[response valueForKey:@"types"];
                     NSString *usergend=[pref valueForKey:@"usergender"];
                     if([usergend isEqual:@"m"])
                     {
                         for(NSArray * a in arrtypewithoutvalidation)
                         {
                             if([[a valueForKey:@"name"] isEqual:@"Pink"])
                             {

                             }
                             else
                             {
                                 [arrType addObject:a];
                                 [arr addObject:a];
                             }
                         }
                     }
                     else
                     {
                         arrType=[response valueForKey:@"types"];
                         [arr addObjectsFromArray:[response valueForKey:@"types"]];
                     }
                     for(NSMutableDictionary *dict in arr)
                     {
                         CarTypeDataModal *obj=[[CarTypeDataModal alloc]init];
                         obj.id_=[dict valueForKey:@"id"];
                         obj.name=[dict valueForKey:@"name"];
                         obj.icon=[dict valueForKey:@"icon"];
                         obj.is_default=[dict valueForKey:@"is_default"];
                         obj.price_per_unit_time=[dict valueForKey:@"price_per_unit_time"];
                         obj.price_per_unit_distance=[dict valueForKey:@"price_per_unit_distance"];
                         obj.base_price=[dict valueForKey:@"base_price"];
                         obj.eta=[dict valueForKey:@"duration"];
                         obj.isSelected=NO;
                         [arrForApplicationType addObject:obj];
                     }
                     [self.collectionView reloadData];
                 }
                 else
                 {
                 }
             }
             
         }];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self MarkDropOff];
}

-(void)setTimerToCheckDriverStatus
{
    if (timerForCheckReqStatus)
    {
        [timerForCheckReqStatus invalidate];
        timerForCheckReqStatus = nil;
    }
    timerForCheckReqStatus = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkForRequestStatus) userInfo:nil repeats:YES];
}

-(void)checkForAppStatus
{
    pref=[NSUserDefaults standardUserDefaults];
    NSString *strReqId=[pref objectForKey:PREF_REQ_ID];
    
    if(strReqId!=nil)
    {
        [self checkForRequestStatus];
    }
    else
    {
        [self RequestInProgress];
    }
}

-(void)checkForRequestStatus
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        pref=[NSUserDefaults standardUserDefaults];
        strForUserId=[pref objectForKey:PREF_USER_ID];
        strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        NSString *strReqId=[pref objectForKey:PREF_REQ_ID];
        
        NSString *strForUrl=[NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",FILE_GET_REQUEST,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken,PARAM_REQUEST_ID,strReqId];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:strForUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue] && [[response valueForKey:@"confirmed_walker"] integerValue]!=0)
                 {
                     NSLog(@"GET REQ--->%@",response);
                     NSString *strCheck=[response valueForKey:@"walker"];
                     
                     if(strCheck)
                     {
                         self.btnCancel.hidden=YES;
                         self.viewForDriver.hidden=YES;
                         //[self.btnCancel removeFromSuperview];
                         
                         [[AppDelegate sharedAppDelegate]hideLoadingView];
                         NSMutableDictionary *dictWalker=[response valueForKey:@"walker"];
                         strForDriverLatitude=[dictWalker valueForKey:@"latitude"];
                         strForDriverLongitude=[dictWalker valueForKey:@"longitude"];
                         if ([[response valueForKey:@"is_walker_rated"]integerValue]==1)
                         {
                             [pref removeObjectForKey:PREF_REQ_ID];
                             return ;
                         }
                         ProviderDetailsVC *vcFeed = nil;
                         for (int i=0; i<self.navigationController.viewControllers.count; i++)
                         {
                             UIViewController *vc=[self.navigationController.viewControllers objectAtIndex:i];
                             if ([vc isKindOfClass:[ProviderDetailsVC class]])
                             {
                                 vcFeed = (ProviderDetailsVC *)vc;
                             }
                         }
                         if (vcFeed==nil)
                         {
                             [timerForCheckReqStatus invalidate];
                             timerForCheckReqStatus=nil;
                             [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"PLEASE_WAIT",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                             [self performSegueWithIdentifier:SEGUE_TO_ACCEPT sender:self];
                         }
                         else
                         {
                             [self.navigationController popToViewController:vcFeed animated:NO];
                         }
                     }
                 }
                 if([[response valueForKey:@"confirmed_walker"] intValue]==0 && [[response valueForKey:@"status"] intValue]==1)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     [timerForCheckReqStatus invalidate];
                     timerForCheckReqStatus=nil;
                     pref=[NSUserDefaults standardUserDefaults];
                     [pref removeObjectForKey:PREF_REQ_ID];
                     
                     [APPDELEGATE hideLoadingView];
                     UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Sorry!"
                                                                                   message:NSLocalizedStringFromTable(@"NO_WALKER",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Ok"
                                                                            style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                    {
                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                    }];
                     [alert addAction:cancelButton];
                     [self presentViewController:alert animated:YES completion:nil];

                     self.btnCancel.hidden=YES;
                     self.viewForDriver.hidden=YES;
                 }
                 else
                 {
                     driverInfo=[response valueForKey:@"walker"];
                     [self showDriver:driverInfo];
                 }
             }
             else
             {}
         }];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)checkRequestInProgress
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        pref=[NSUserDefaults standardUserDefaults];
        strForUserId=[pref objectForKey:PREF_USER_ID];
        strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        
        NSString *strForUrl=[NSString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_GET_REQUEST_PROGRESS,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:strForUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             NSLog(@"RequestInProgress Response %@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue])
                 {
                     if ([[response valueForKey:@"request_id"] integerValue]==-1)
                     {
                         NSLog(@"Invalid Input Request ID");
                     }
                     else
                     {
                         pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:[response valueForKey:@"request_id"] forKey:PREF_REQ_ID];
                         [pref synchronize];
                         [self checkForRequestStatus];
                     }
                     
                 }
                 else
                 {}
             }
         }];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)RequestInProgress
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        pref=[NSUserDefaults standardUserDefaults];
        strForUserId=[pref objectForKey:PREF_USER_ID];
        strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        
        NSString *strForUrl=[NSString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_GET_REQUEST_PROGRESS,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:strForUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             NSLog(@"RequestInProgress Response %@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue])
                 {
                     if ([[response valueForKey:@"request_id"] integerValue]==-1)
                     {
                         NSLog(@"Invalid Input Request ID");
                     }
                     else
                     {
                         pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:[response valueForKey:@"request_id"] forKey:PREF_REQ_ID];
                         [pref synchronize];
                         [self checkForRequestStatus];
                     }
                 }
                 else
                 {}
             }
         }];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)getPagesData
{
    pref=[NSUserDefaults standardUserDefaults];
    strForUserId=[pref objectForKey:PREF_USER_ID];
    strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
    
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@",FILE_PAGE,PARAM_ID,strForUserId];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             NSLog(@"Respond to Request= %@",response);
             [APPDELEGATE hideLoadingView];
             
             if (response)
             {
                 arrPage=[response valueForKey:@"informations"];
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     //   [APPDELEGATE showToastMessage:@"Requset Accepted"];
                 }
             }
             
         }];
        
    }
    else
    {

        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)getProviders
{
    pref=[NSUserDefaults standardUserDefaults];
    strForUserId=[pref objectForKey:PREF_USER_ID];
    strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setValue:strForUserId forKey:PARAM_ID];
    [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
    [dictParam setValue:strForTypeid forKey:PARAM_TYPE];
    [dictParam setValue:strForLatitude forKey:@"usr_lat"];
    [dictParam setValue:strForLongitude forKey:@"user_long"];
    if([[AppDelegate sharedAppDelegate]connected])
    {
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_GET_PROVIDERS withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             //NSDictionary *set = response;
             NSLog(@"Respond to Get Provider= %@",response);
             if (response)
             {
                 strForDriverList = [response valueForKey:@"error"];
                 arrDriver=[response valueForKey:@"walker_list"];
             }
             else
             {
                 arrDriver=[[NSMutableArray alloc] init];
             }
             [self showProvider];
         }];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)showProvider
{
    [mapView_ clear];
    NSString *NewPickLat = [NSString stringWithFormat:@"%f",[[pref objectForKey:@"Pickup_Latitude"]doubleValue]];
    NSString *NewPickLong = [NSString stringWithFormat:@"%f",[[pref objectForKey:@"Pickup_Longitude"]doubleValue]];
    NSString *NewDropLat = [NSString stringWithFormat:@"%f",[[pref objectForKey:@"Destination_Latitude"]doubleValue]];
    NSString *NewDropLong = [NSString stringWithFormat:@"%f",[[pref objectForKey:@"Destination_Longitude"]doubleValue]];
    CLLocationCoordinate2D PickCentre;
    PickCentre.latitude = [NewPickLat doubleValue];
    PickCentre.longitude = [NewPickLong doubleValue];
    Pickup_Marker.position = PickCentre;
    Pickup_Marker.icon = [UIImage imageNamed:@"pin_client_org"];
    Pickup_Marker.map = mapView_;
    
    CLLocationCoordinate2D DropCentre;
    DropCentre.latitude = [NewDropLat doubleValue];
    DropCentre.longitude = [NewDropLong doubleValue];
    markerOwner.position = DropCentre;
    markerOwner.icon = [UIImage imageNamed:@"pin_destination"];
    markerOwner.map = mapView_;

    
    BOOL is_first=YES;
    is_containsVehicle = NO;
    if (is_vehicleselected) {
        for (int i=0; i<arrDriver.count; i++)
        {
            NSDictionary *dict=[arrDriver objectAtIndex:i];
            NSString *strType1=[NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
            if ([[NSString stringWithFormat:@"%@",strForTypeid] isEqualToString:strType1])
            {
                is_containsVehicle = YES;
                GMSMarker *driver_marker;
                driver_marker = [[GMSMarker alloc] init];
                driver_marker.position = CLLocationCoordinate2DMake([[dict valueForKey:@"latitude"]doubleValue],[[dict valueForKey:@"longitude"]doubleValue]);
                driver_marker.icon=[UIImage imageNamed:@"pin_driver"];
                driver_marker.map = mapView_;
                if (is_first)
                {
                    [self getETA:dict];
                    is_first=NO;
                }
            }
        }
    }
    else {
        for (int i=0; i<arrDriver.count; i++)
        {
            is_containsVehicle = YES;
            NSDictionary *dict=[arrDriver objectAtIndex:i];
            GMSMarker *driver_marker;
            driver_marker = [[GMSMarker alloc] init];
            driver_marker.position = CLLocationCoordinate2DMake([[dict valueForKey:@"latitude"]doubleValue],[[dict valueForKey:@"longitude"]doubleValue]);
            driver_marker.icon=[UIImage imageNamed:@"pin_driver"];
            driver_marker.map = mapView_;
            if (is_first)
            {
                [self getETA:dict];
                is_first=NO;
            }
        }
        
    }
    is_first=YES;
    
}

-(void)getETA:(NSDictionary *)dict
{
    CLLocationCoordinate2D scorr=CLLocationCoordinate2DMake([strForLatitude doubleValue], [strForLongitude doubleValue]);
    CLLocationCoordinate2D dcorr=CLLocationCoordinate2DMake([[dict valueForKey:@"latitude"]doubleValue], [[dict valueForKey:@"longitude"]doubleValue]);
    [self calculateRoutesFrom:scorr to:dcorr];
    
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
{
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    
    //    NSString* apiUrlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&key=%@",saddr,daddr,GOOGLE_KEY_NEW];
    NSString* apiUrlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&key=%@",saddr,daddr,Google_Map_Server_Key];
    
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    
    NSError* error = nil;
    //NSData *data = [[NSData alloc]initWithContentsOfURL:apiUrl];
    NSData* data = [NSData dataWithContentsOfURL: apiUrl];
    
    NSDictionary *json =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if ([[json objectForKey:@"status"]isEqualToString:@"REQUEST_DENIED"] || [[json objectForKey:@"status"] isEqualToString:@"OVER_QUERY_LIMIT"] || [[json objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"])
    {
        
    }
    else
    {
        NSDictionary *getRoutes = [json valueForKey:@"routes"];
        NSDictionary *getLegs = [getRoutes valueForKey:@"legs"];
        NSArray *getAddress = [getLegs valueForKey:@"duration"];
        if(getAddress.count>0)
        {
            strETA = [[[getAddress objectAtIndex:0]objectAtIndex:0] valueForKey:@"text"];
            self.lblETA.text= [NSString stringWithFormat:@"%@", strETA];
        }
        else
            
        {
            self.lblETA.text=@"0 min";
            
        }
        
        if (is_containsVehicle)
            self.lblforETA.text = [NSString stringWithFormat:@"%@", strETA];
        else
            self.lblforETA.text = @"--";
        
        
        
    }
    return nil;
}
-(void)showDriver:(NSMutableDictionary *)walker
{
    if([driver_id integerValue]!=[[walker valueForKey:@"id"]integerValue ])
        
        //if(![driver_id isEqualToString:[NSString stringWithFormat:@"%@", [walker valueForKey:@"id"]]])
    {
        driver_id=[walker valueForKey:@"id"];
        self.lbl_driverName.text=[NSString stringWithFormat:@"%@ %@",[walker valueForKey:@"first_name"],[walker valueForKey:@"last_name"]];
        self.lbl_driverRate.text=[NSString stringWithFormat:@"%@", [walker valueForKey:@"rating"]];
        self.lbl_driver_Carname.text=[NSString stringWithFormat:@"%@",[walker valueForKey:@"car_model"]];
        self.lbl_driver_CarNumber.text=[NSString stringWithFormat:@"%@",[walker valueForKey:@"car_number"]];
        [self.img_driver_profile downloadFromURL:[walker valueForKey:@"picture"] withPlaceholder:nil];
    }
}

#pragma mark - UICollectionViewDataSource

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSLog(@"test width %f",self.view.frame.size.width);
    if(arrForApplicationType.count==1)
        return UIEdgeInsetsMake(0, (self.view.frame.size.width/2)-40, 0, 0);
    else if(arrForApplicationType.count==2)
        return UIEdgeInsetsMake(0, (self.view.frame.size.width/2)-80, 0, 0);
    else if(arrForApplicationType.count==3)
        return UIEdgeInsetsMake(0, (self.view.frame.size.width/2)-120, 0, 0);
    else if(arrForApplicationType.count==4)
        return UIEdgeInsetsMake(0, (self.view.frame.size.width/2)-160, 0, 0);
    else
        return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrForApplicationType.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake((CGRectGetWidth(self.view.frame))/2, (CGRectGetHeight(collectionView.frame)));
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 5.0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cartype" forIndexPath:indexPath];
    
    cell.layer.borderWidth=0.8f;
    cell.layer.borderColor=[UIColor colorWithRed:191/255.0 green:191/255.0 blue:191 /255.0 alpha:1.0].CGColor;
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = cell.frame.size.width/2;
    
    CarTypeDataModal *data = [arrForApplicationType objectAtIndex:indexPath.row];
    
    if (data.icon==nil || [data.icon isKindOfClass:[NSNull class]]){
        cell.imgType.image=[UIImage imageNamed:@"button_limo.png"];
    }
    else{
        if ([data.icon isEqualToString:@""]) {
            cell.imgType.image=[UIImage imageNamed:@"button_limo.png"];
        }
        else{
            [cell.imgType downloadFromURL:data.icon withPlaceholder:nil];
        }
    }
    cell.lblTitle.text=data.name;
    cell.lblETA.text = data.eta;
    if ([[NSString stringWithFormat:@"%@",data.id_] isEqualToString:strForTypeid]) {
        NSLog(@"selection testing %ld",(long)indexPath.row);
        if ((long)indexPath.row==0)
            cell.backgroundColor= [UIColor colorWithRed:204/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        else
            cell.backgroundColor= [UIColor colorWithRed:204/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
        
        [cell.lblTitle setTextColor:[UIColor whiteColor]];
        [cell.lblETA setTextColor:[UIColor whiteColor]];
    }
    else {
        [cell.lblTitle setTextColor:[UIColor blackColor]];
        [cell.lblETA setTextColor:[UIColor redColor]];
    }
    
    
    
    //    [cell setCellData:[arrForApplicationType objectAtIndex:indexPath.row]];
    return cell;
    
    /*
     NSDictionary *dictType=[arrForApplicationType objectAtIndex:indexPath.row];
     if (strForTypeid==nil || [strForTypeid isEqualToString:@"0"])
     {
     if ([[dictType valueForKey:@"is_default"]intValue]==1)
     {
     for(CarTypeDataModal *obj in arrForApplicationType)
     {
     obj.isSelected = NO;
     }
     CarTypeDataModal *obj=[arrForApplicationType objectAtIndex:indexPath.row];
     obj.isSelected = YES;
     [self getETA:[arrDriver objectAtIndex:0]];
     NSDictionary  *dict=[arrType objectAtIndex:indexPath.row];
     //strMinFare=[NSString stringWithFormat:@"%@",[dict valueForKey:@"min_fare"]];
     strMinFare=[NSString stringWithFormat:@"%@",[dict valueForKey:@"base_price"]];
     strPassCap=[NSString stringWithFormat:@"%@",[dict valueForKey:@"max_size"]];
     str_base_distance = [NSString stringWithFormat:@"%@",[dict valueForKey:@"base_distance"]];
     str_price_per_unit_distance =  [NSString stringWithFormat:@"%f",[[dict valueForKey:@"price_per_unit_distance"  ] floatValue]];
     if(strETA.length>0)
     {
     self.lblETA.text=strETA;
     }
     else
     {
     self.lblETA.text=@"0 min";
     }
     
     self.lblFare.text=[NSString stringWithFormat:@"$ %@",strMinFare];
     self.lblRate_BasePrice.text=[NSString stringWithFormat:@"$%ld for %@ %@",(long)[strMinFare integerValue],[dict valueForKey:@"base_distance"],[dict valueForKey:@"unit"]];
     self.lblRate_DistancePrice.text = [NSString stringWithFormat:@"$%ld / %@",(long)[[dict valueForKey:@"price_per_unit_distance"] integerValue],[dict valueForKey:@"unit"]];
     NSString *strMin = @"min";
     self.lblRate_TimePrice.text = [NSString stringWithFormat:@"$%ld / %@",(long)[[dict valueForKey:@"price_per_unit_time"] integerValue],strMin];
     self.lblCarType.text=obj.name;
     self.lblSize.text=[NSString stringWithFormat:@"%@ PERSONS",strPassCap];
     strForTypeid=[NSString stringWithFormat:@"%@",obj.id_];
     pref=[NSUserDefaults standardUserDefaults];
     [pref setObject:strMinFare forKey:PREF_FARE_AMOUNT];
     [pref synchronize];
     }
     }
     */
    
    //  cell.imgType.layer.masksToBounds = YES;
    //   cell.imgType.layer.opaque = NO;
    //    cell.imgType.layer.cornerRadius=18;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    is_containsVehicle = NO;
    CarTypeDataModal *objPattern=[arrForApplicationType objectAtIndex:indexPath.row];
    NSString *strTypeid=[NSString stringWithFormat:@"%@",objPattern.id_];
    
    for (int i=0; i<arrDriver.count; i++)
    {
        NSDictionary *dict=[arrDriver objectAtIndex:i];
        strType=[NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
        if ([strTypeid isEqualToString:strType])
        {
            is_containsVehicle = YES;
        }
    }
    
    
    //    if (!is_containsVehicle)
    //    {
    //        return;
    //    }
    
    is_vehicleselected = true;
    for(CarTypeDataModal *obj in arrForApplicationType) {
        obj.isSelected = NO;
    }
    CarTypeDataModal *obj=[arrForApplicationType objectAtIndex:indexPath.row];
    strForTypeid=[NSString stringWithFormat:@"%@",obj.id_];
    for (int i=0; i<arrDriver.count; i++)
    {
        NSDictionary *dict=[arrDriver objectAtIndex:i];
        NSString *strType1=[NSString stringWithFormat:@"%@",[dict valueForKey:@"type"]];
        if ([strForTypeid isEqualToString:strType1])
        {
            is_containsVehicle = YES;
        }
    }
    
    obj.isSelected = YES;
    NSDictionary *dict=[arrType objectAtIndex:indexPath.row];
    strMinFare=[NSString stringWithFormat:@"%@",[dict valueForKey:@"min_fare"]];
    strPassCap=[NSString stringWithFormat:@"%@",[dict valueForKey:@"max_size"]];
    self.lblFare.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),strMinFare];
    self.lblRate_BasePrice.text=[NSString stringWithFormat:@"%@ %ld for %@ %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),(long)[strMinFare integerValue],[dict valueForKey:@"base_distance"],[dict valueForKey:@"unit"]];
    self.lblRate_DistancePrice.text = [NSString stringWithFormat:@"%@ %@ / %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),[dict valueForKey:@"price_per_unit_distance"] ,[dict valueForKey:@"unit"]];
    self.lblSize.text=[NSString stringWithFormat:@"%@ PERSONS",strPassCap];
    NSString *strMin = @"min";
    NSLog(@"Mins---%@",strMin);
    self.lblRate_TimePrice.text = [NSString stringWithFormat:@"%@ %ld / %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),[[dict valueForKey:@"price_per_unit_time"] integerValue],strMin];
    str_base_distance = [NSString stringWithFormat:@"%@",[dict valueForKey:@"base_distance"]];
    //str_price_per_unit_distance =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"price_per_unit_distance"]];
    str_price_per_unit_distance =  [NSString stringWithFormat:@"%f",[[dict valueForKey:@"price_per_unit_distance"  ] floatValue]];
    if ([strForTypeid intValue] !=[obj.id_ intValue])
    {
        // [self selectServiceBtnPressed:nil];
        if(strETA.length>0)
        {
            self.lblETA.text=strETA;
            NSLog(@"checking up ETA %@",strETA);
        }
        else
        {
            self.lblETA.text=@"0 min";
        }
        self.lblFare.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),strMinFare];
        self.lblRate_BasePrice.text=[NSString stringWithFormat:@"%@%ld for %@ %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),(long)[strMinFare integerValue],[dict valueForKey:@"base_distance"],[dict valueForKey:@"unit"]];
        self.lblRate_DistancePrice.text = [NSString stringWithFormat:@"%@%ld / %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),[[dict valueForKey:@"price_per_unit_distance"] integerValue],[dict valueForKey:@"unit"]];
        NSString *strMin = @"min";
        self.lblRate_TimePrice.text = [NSString stringWithFormat:@"%@%ld / %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),[[dict valueForKey:@"price_per_unit_time"] integerValue],strMin];
        self.lblCarType.text=obj.name;
        pref=[NSUserDefaults standardUserDefaults];
        
    }
    [pref setObject:strMinFare forKey:PREF_FARE_AMOUNT];
    [pref synchronize];
    strForTypeid=[NSString stringWithFormat:@"%@",obj.id_];
    [self showProvider];
    if (is_containsVehicle)
        self.lblforETA.text = [NSString stringWithFormat:@"%@", strETA];
    else
        self.lblforETA.text = @"--";
    [self.collectionView reloadData];
    [self setNewPlaceData];
}

#pragma mark
#pragma mark - UITextfield Delegate


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSString *strFullText=[NSString stringWithFormat:@"%@%@",textField.text,string];
    
    if(self.txtAddress==textField)
    {
        if(arrForAddress.count==1)
            self.tableView.frame=CGRectMake(self.tableView.frame.origin.x,86+134, self.tableView.frame.size.width, 44);
        else if(arrForAddress.count==2)
            self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, 86+78, self.tableView.frame.size.width, 88);
        else if(arrForAddress.count==3)
            self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, 86+34, self.tableView.frame.size.width, 132);
        else if(arrForAddress.count==0)
            self.tableView.hidden=YES;
        
        [self.tableView reloadData];
        
    }
   
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==self.txtAddress)
    {
        MapPickerTag = @"Pickup";
        self.ImgDownArrowPickup.image = [UIImage imageNamed:@"PickupDownArrow.png"];
        [self.tableForCity setFrame:CGRectMake(self.viewforPickupLabel.frame.origin.x+15, self.viewforPickupLabel.frame.origin.y+34, self.txtAddress.frame.size.width, 150)];
        if (self.txtAddress.text.length>0)
        {

        }
    }
    if(textField==self.txtDropoffAddress)
    {
        MapPickerTag = @"Destination";
        self.ImgDownArrowPickup.image = [UIImage imageNamed:@"DestinationDownArrow.png"];
        [self.tableForCity setFrame:CGRectMake(self.viewforPickupLabel.frame.origin.x+15, self.viewforPickupLabel.frame.origin.y+70, self.txtDropoffAddress.frame.size.width, 150)];
        
        if (self.txtAddress.text.length>0)
        {

        }
    }
    if (textField==self.txtPreferral)
    {
        self.viewForReferralError.hidden=YES;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField==self.txtAddress  && self.txtAddress.text.length > 0)
    {
        [self getLocationFromString:self.txtAddress.text];
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:1.0] forKey:kCATransactionAnimationDuration];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: [strForLatitude doubleValue]
                                                                longitude: [strForLongitude doubleValue] zoom: 14];
        [mapView_ animateToCameraPosition: camera];
        [CATransaction commit];
        self.ImageMarkerMapCentre.hidden = NO;
    }

    if(textField==self.txtDropoffAddress  && self.txtDropoffAddress.text.length > 0)
    {
        [self getLocationFromAddressString:self.txtDropoffAddress.text];
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:1.0] forKey:kCATransactionAnimationDuration];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[StrForDropLat doubleValue] longitude:[StrForDropLong doubleValue] zoom:14];
        [mapView_ animateToCameraPosition: camera];
        [CATransaction commit];
        self.ImageMarkerMapCentre.hidden = YES;
      
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.tableView.hidden=YES;
    if(textField==self.txtAddress)
    {
        if ([self.txtAddress.text isEqualToString:@""])
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                          message:@"Please Enter a Pickup Location"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                           }];
            [alert addAction:cancelButton];
            [self presentViewController:alert animated:YES completion:nil];
            return YES;
        }
        else 
        {
            [textField resignFirstResponder];
            
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: [strForLatitude doubleValue]
                                                                    longitude: [strForLongitude doubleValue] zoom: 14];
            [mapView_ animateToCameraPosition: camera];
            [CATransaction commit];
            self.ImageMarkerMapCentre.hidden = NO;
        }
    }
    if(textField==self.txtDropoffAddress)
    {
        if ([self.txtDropoffAddress.text isEqualToString:@""])
        {
            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert"
                                                                          message:@"Please Enter a Destination Location"
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                           }];
            [alert addAction:cancelButton];
            [self presentViewController:alert animated:YES completion:nil];
            return YES;
        }
        else
        {
            [textField resignFirstResponder];
            
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[StrForDropLat doubleValue] longitude:[StrForDropLong doubleValue] zoom:14];
            //mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.viewGoogleMap.frame.size.width, self.viewGoogleMap.frame.size.height) camera:camera];
            [mapView_ animateToCameraPosition: camera];
            [CATransaction commit];
            self.ImageMarkerMapCentre.hidden = YES;
        }
    }
    [textField resignFirstResponder];
    return YES;
}

//********************
-(void)getLocationDropFromString:(NSString *)str
{
    NSString *esc_addr =  [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&key=%@", esc_addr, Google_Map_API_Key];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    NSLog(@"WE are testing destination address    %@    %@",[[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"], [[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"]);
    
    if([dict objectForKey:@"results"])
    {
        NSArray *arrAddress=[dict objectForKey:@"results"];
        if ([arrAddress count] > 0)
        {
            self.txtDropoffAddress.text=[[arrAddress objectAtIndex:0] valueForKey:@"formatted_address"];
            NSDictionary *dictLocation=[[[arrAddress objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
            StrForDropLat=[dictLocation valueForKey:@"lat"];
            StrForDropLong=[dictLocation valueForKey:@"lng"];
            // [self getETA:[arrDriver objectAtIndex:0]];
            CLLocationCoordinate2D coor;
            coor.latitude=[strForLatitude doubleValue];
            coor.longitude=[strForLongitude doubleValue];
            GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coor zoom:14];
            [mapView_ animateWithCameraUpdate:updatedCamera];
        }
    }
}

//****************

-(void)getLocationFromString:(NSString *)str
{
    NSString *esc_addr =  [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&key=%@", esc_addr, Google_Map_API_Key];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];

    if([dict valueForKey:@"error_message"])
    {
        NSLog(@"gelocationfromstring response %@", dict);

        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Blaze Ride"
                                                                      message:[dict valueForKey:@"error_message"]
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        if([dict objectForKey:@"results"])
        {
            NSLog(@"WE are testing destination address    %@    %@",[[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"], [[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"]);
            NSArray *arrAddress=[dict objectForKey:@"results"];
            if ([arrAddress count] > 0)
            {
                self.txtAddress.text=[[arrAddress objectAtIndex:0] valueForKey:@"formatted_address"];
                NSDictionary *dictLocation=[[[arrAddress objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
                strForLatitude=[dictLocation valueForKey:@"lat"];
                strForLongitude=[dictLocation valueForKey:@"lng"];
            // [self getETA:[arrDriver objectAtIndex:0]];
                CLLocationCoordinate2D coor;
                coor.latitude=[strForLatitude doubleValue];
                coor.longitude=[strForLongitude doubleValue];
                pref = [NSUserDefaults standardUserDefaults];
                [pref setObject:strForLatitude forKey:@"Pickup_Latitude"];
                [pref setObject:strForLongitude forKey:@"Pickup_Longitude"];
                [pref synchronize];
                GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coor zoom:14];
                [mapView_ animateWithCameraUpdate:updatedCamera];
            }
        }
    }
}

-(CLLocationCoordinate2D) getLocationFromAddressString: (NSString*) addressStr
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"https://maps.google.com/maps/api/geocode/json?sensor=false&address=%@&key=%@", esc_addr, Google_Map_API_Key];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result)
    {
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];

        if([dict valueForKey:@"error_message"])
        {
            NSLog(@"gelocationfromaddressstring response %@", dict);

            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Blaze Ride"
                                                                          message:[dict valueForKey:@"error_message"]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                           {
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                           }];
            [alert addAction:cancelButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            if([dict valueForKey:@"results"])
            {
                NSArray *arrAddress=[dict objectForKey:@"results"];
                if ([arrAddress count] > 0)
                {
                    NSLog(@"WE are testing destination address    %@    %@",[[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"], [[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"]);

                    latitude = [[[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] doubleValue];
                    longitude = [[[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] doubleValue];

                    StrForDropLat = [[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"];
                    StrForDropLong = [[[[[dict objectForKey:@"results"] objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"];
                    pref = [NSUserDefaults standardUserDefaults];
                    [pref setObject:StrForDropLat forKey:@"Destination_Latitude"];
                    [pref setObject:StrForDropLong forKey:@"Destination_Longitude"];
                    [pref synchronize];
                }
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude=latitude;
    center.longitude = longitude;
    NSLog(@"View Controller get Location Logitute : %f",center.latitude);
    NSLog(@"View Controller get Location Latitute : %f",center.longitude);
    return center;
}

#pragma mark -
#pragma mark - Referral btn Action

- (IBAction)btnSkipReferral:(id)sender
{
    Referral=@"1";
    [self createService];
}

- (IBAction)btnAddReferral:(id)sender
{
    Referral=@"0";
    [self createService];
}

-(void)createService
{
    self.viewForReferralError.hidden=YES;
    if([[AppDelegate sharedAppDelegate]connected])
    {
        
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"REQUESTING",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        pref=[NSUserDefaults standardUserDefaults];
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:[pref objectForKey:PREF_USER_ID] forKey:PARAM_ID];
        [dictParam setObject:self.txtPreferral.text forKey:PARAM_REFERRAL_CODE];
        [dictParam setObject:[pref objectForKey:PREF_USER_TOKEN] forKey:PARAM_TOKEN];
        [dictParam setObject:Referral forKey:PARAM_REFERRAL_SKIP];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_APPLY_REFERRAL withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue])
                 {
                     NSLog(@"%@",response);
                     if([[response valueForKey:@"success"]boolValue])
                     {
                         pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                         [pref synchronize];
                         self.viewForPreferral.hidden=YES;
                         self.btnMyLocation.hidden=NO;
                         self.btnETA.hidden=NO;
                         self.navigationController.navigationBarHidden=NO;
                         self.txtPreferral.text=@"";
                         if([Referral isEqualToString:@"0"])
                         {
                             [APPDELEGATE showToastMessage:[response valueForKey:@"error"]];
                         }
                         // [self setTimerToCheckDriverStatus];
                         self.navigationController.navigationBarHidden=NO;
                         //[self getAllApplicationType];
                         [super setNavBarTitle:TITLE_PICKUP];
                         [self customSetup];
                         [self checkForAppStatus];
                         [self getPagesData];
                         [self getProviders];
                         [self.paymentView setHidden:YES];
                         self.viewETA.hidden=YES;
                         [self cashBtnPressed:nil];
                     }
                 }
                 else
                 {
                     self.txtPreferral.text=@"";
                     self.viewForReferralError.hidden=NO;
                     self.lblReferralMsg.text=[response valueForKey:@"error"];
                     self.lblReferralMsg.textColor=[UIColor colorWithRed:205.0/255.0 green:0.0/255.0 blue:15.0/255.0 alpha:1];
                 }
             }
         }];
    }
    else
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                      message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                               preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alert addAction:cancelButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



@end

