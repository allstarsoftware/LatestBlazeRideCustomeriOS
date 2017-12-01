//
//  PickUpVC.h
//  UberNewUser
//
//  Created by Elluminati - macbook on 27/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "BaseVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "CustomTimePicker.h"
#import "ESTimePicker.h"
#import "FSCalendar.h"
#import "KLCPopup.h"
@interface PickUpVC : BaseVC<MKMapViewDelegate,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,GMSMapViewDelegate,UIAlertViewDelegate,ESTimePickerDelegate,FSCalendarDelegate,FSCalendarDataSource,CustomTimePickerDelegate>
{
    NSTimer *timerForCheckReqStatus;
    CLLocationManager *locationManager;
    NSDictionary* aPlacemark;
    NSMutableArray *placeMarkArr;
}

/////// Outlets
@property (weak, nonatomic) IBOutlet UIView *ViewDottedline;
@property (weak, nonatomic) IBOutlet UIImageView *ImgXmarkforLocation;
@property (weak, nonatomic) IBOutlet UIImageView *ImgDownArrowPickup;
@property (weak, nonatomic) IBOutlet UIImageView *ImgDottedLine;
@property (weak, nonatomic) IBOutlet UILabel *LblGetting_Address;
@property (weak, nonatomic) IBOutlet UIImageView *ImageMarkerMapCentre;
@property (strong, nonatomic) IBOutlet UIImageView *ImgMarkerDottedLine;

// Outlets Created by Gopi for Custom Date & Time Picker
@property (weak, nonatomic) IBOutlet UIView *analogclockview;
@property (weak, nonatomic) IBOutlet UILabel *analogclockHours;
@property (weak, nonatomic) IBOutlet UILabel *analogclockMinutes;
@property (weak, nonatomic) IBOutlet UIView *BackgroundviewAnalogclockview;
@property (weak, nonatomic) IBOutlet FSCalendar *CalendardatepickerView;
@property (weak, nonatomic) IBOutlet UIView *ViewCalendrDonebutton;



@property (weak, nonatomic) IBOutlet UITableView *tableForCity;
@property (weak,nonatomic) IBOutlet UILabel *lblcard_name;
@property (weak,nonatomic) IBOutlet UILabel *lblcash_name;
@property (weak,nonatomic) IBOutlet UILabel *lblsosbtn_clickdmsg;
@property (weak,nonatomic) IBOutlet UILabel *lblselectyourjourney;
@property (weak,nonatomic) IBOutlet UIButton *btncancel_ridelatrview;
@property (weak,nonatomic) IBOutlet UIButton *btnrequest_ridelatrview;
@property (weak,nonatomic) IBOutlet UILabel *lblnote_ridelatrview;
@property (weak,nonatomic) IBOutlet UILabel *lblchoosedate_ridelatrview;
@property (weak,nonatomic) IBOutlet UILabel *lblchoosetime_ridelatrview;
@property (weak,nonatomic) IBOutlet UIButton *btndone_ridelatrview;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewGoogleMap;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) IBOutlet UIButton* revealButtonItem;
@property(nonatomic,weak)IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIView *viewForMarker;
@property (weak, nonatomic) IBOutlet UITextField *txtPreferral;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtDropoffAddress;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnMyLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnETA;
@property (weak, nonatomic) IBOutlet UIView *viewForPreferral;
@property (weak, nonatomic) IBOutlet UIView *viewForFareAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblFareAddress;
@property (weak, nonatomic) IBOutlet UIView *viewForReferralError;
@property (weak, nonatomic) IBOutlet UILabel *lblReferralMsg;
@property (weak, nonatomic) IBOutlet UIView *ViewforETA;
@property (weak, nonatomic) IBOutlet UILabel *lblforETA;

/////// Actions

- (IBAction)pickMeUpBtnPressed:(id)sender;
- (IBAction)cancelReqBtnPressed:(id)sender;

- (IBAction)myLocationPressed:(id)sender;
- (IBAction)selectServiceBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelService;
@property (weak, nonatomic) IBOutlet UIButton *btnPickMeUp;

-(void)goToSetting:(NSString *)str;

@property (weak, nonatomic) IBOutlet UIView *paymentView;
- (IBAction)ETABtnPressed:(id)sender;
- (IBAction)cashBtnPressed:(id)sender;
- (IBAction)cardBtnPressed:(id)sender;
- (IBAction)requestBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCash;
@property (weak, nonatomic) IBOutlet UIButton *btnCard;
- (IBAction)btnSkipReferral:(id)sender;
- (IBAction)btnAddReferral:(id)sender;

//ETA View

@property (weak, nonatomic) IBOutlet UIView *viewETA;
@property (weak, nonatomic) IBOutlet UILabel *lblETA;
@property (weak, nonatomic) IBOutlet UILabel *lblSize;
@property (weak, nonatomic) IBOutlet UILabel *lblFare;
- (IBAction)eastimateFareBtnPressed:(id)sender;
- (IBAction)closeETABtnPressed:(id)sender;
- (IBAction)RateCardBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnRatecard;
@property (weak, nonatomic) IBOutlet UIView *viewForRateCard;
@property (weak, nonatomic) IBOutlet UILabel *lblthisisjustET_text;
// Payment Method

////for Localization

@property (weak, nonatomic) IBOutlet UIButton *btnFare;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UILabel *lMinFare;
@property (weak, nonatomic) IBOutlet UILabel *lETA;
@property (weak, nonatomic) IBOutlet UILabel *lMaxSize;
@property (weak, nonatomic) IBOutlet UILabel *lSelectPayment;
@property (weak, nonatomic) IBOutlet UIButton *btnPayCancel;

@property (weak, nonatomic) IBOutlet UIButton *btnPayRequest;

@property (weak, nonatomic) IBOutlet UILabel *lRefralMsg;
@property (weak, nonatomic) IBOutlet UIButton *bReferralSubmit;

@property (weak, nonatomic) IBOutlet UIButton *bReferralSkip;

//// view for rate card

@property (weak, nonatomic) IBOutlet UILabel *lRate_basePrice;
@property (weak, nonatomic) IBOutlet UILabel *lRate_distancecost;
@property (weak, nonatomic) IBOutlet UILabel *lRate_TimeCost;
@property (weak, nonatomic) IBOutlet UILabel *lblRate_BasePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRate_DistancePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblRate_TimePrice;

@property (weak, nonatomic) IBOutlet UILabel *lblRateCradNote;

@property (weak, nonatomic) IBOutlet UILabel *lblCarType;

///// for driver detail

@property (weak, nonatomic) IBOutlet UIView *viewForDriver;
@property (weak, nonatomic) IBOutlet UILabel *lbl_driverName;
@property (weak, nonatomic) IBOutlet UIImageView *img_driver_profile;
@property (weak, nonatomic) IBOutlet UILabel *lbl_driverRate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_driver_Carname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_driver_CarNumber;


//New Update
@property (weak, nonatomic) IBOutlet UIView *viewForSOS;
@property (weak, nonatomic) IBOutlet UIView *viewForRideLater;
@property (weak, nonatomic) IBOutlet UIButton *btnPickDate;
@property (weak, nonatomic) IBOutlet UIButton *btnPickTime;
@property (weak, nonatomic) IBOutlet UIView *viewForPicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *viewDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *viewTimePicker;
@property (strong, nonatomic) IBOutlet UIView *viewforPickupLabel;
@property (weak, nonatomic) IBOutlet UIView *panGuestureview;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnRideNow;
@property (weak, nonatomic) IBOutlet UIButton *btnRideLater;

//SOS View
@property (weak, nonatomic) IBOutlet UILabel *lblSOStitle;
@property (weak, nonatomic) IBOutlet UIButton *btnSOS;
@property (weak, nonatomic) IBOutlet UIButton *btnSOSPolice;
@property (weak, nonatomic) IBOutlet UIButton *btnSOSAmbulance;
@property (weak, nonatomic) IBOutlet UIButton *btnSOSFireStation;
@property (weak, nonatomic) IBOutlet UIButton *btnSOSBack;

@end
