//
//  RMUser.h
//  testparsecontent
//
//  Created by Spextrum on 27/12/16.
//  Copyright © 2016 InrTrade. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface RMUser : NSObject

@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* first_name;
@property (nonatomic, strong) NSString* last_name;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* is_otp;
@property (nonatomic, strong) NSString* picture;
@property (nonatomic, strong) NSString* bio;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* zipcode;
@property (nonatomic, strong) NSString* login_by;
@property (nonatomic, strong) NSString* social_unique_id;
@property (nonatomic, strong) NSString* device_token;
@property (nonatomic, strong) NSString* device_type;
@property (nonatomic, strong) NSString* otp_status;
@property (nonatomic, strong) NSString* timezone;
@property (nonatomic, strong) NSString* token;
@property (nonatomic, strong) NSString* referral_code;
@property (nonatomic, strong) NSString* is_referee;
@property (nonatomic, strong) NSString* promo_count;
@property (nonatomic, strong) NSString* is_referral_active;
@property (nonatomic, strong) NSString* is_referral_active_txt;
@property (nonatomic, strong) NSString* is_promo_active;
@property (nonatomic, strong) NSString* is_promo_active_txt;

@end

/*
 
 {
 "success": true,
 "user": {
	"id": 589,
	"first_name": "K",
	"last_name": "J",
	"phone": "+913857467356",
	"email": "vt@v.com",
	"is_otp": true,
	"picture": "",
	"bio": "",
	"address": "",
	"state": "",
	"country": "",
	"zipcode": "6412602",
	"login_by": "manual",
	"social_unique_id": "",
	"device_token": "dsgfhsdghsdghsdg",
	"device_type": "ios",
	"otp_status": true,
	"timezone": "UTC",
	"token": "2y10iudOxDrzdnQpnAd0nQLxDeqxMB4X8xW3LrAuQII08ZyC1xZj0aQO",
	"referral_code": "x4i$VP",
	"is_referee": 0,
	"promo_count": 0,
	"is_referral_active": "1",
	"is_referral_active_txt": "referral on",
	"is_promo_active": "1",
	"is_promo_active_txt": "promo on"
 }
 }
//----------
 {
 "success": true,
 "user": {
	"id": 590,
	"first_name": "K",
	"last_name": "J",
	"phone": "+91385343453",
	"email": "vtv@v.com",
	"is_otp": false,
	"picture": "",
	"bio": "",
	"address": "",
	"state": "",
	"country": "",
	"zipcode": 6412602,
	"login_by": "manual",
	"social_unique_id": "",
	"device_token": "dsgfhsdghsdghsdg",
	"device_type": "ios",
	"otp_status": true,
	"timezone": "UTC",
	"token": "2y10Pkk9XJfEEiP6Y3VepP6Y1wVyZYjp1ipPlVFzuuugXFcyVJHi",
	"referral_code": "9r$TWy",
	"is_referee": 0,
	"promo_count": 0,
	"is_referral_active": true,
	"is_referral_active_txt": "referral on",
	"is_promo_active": true,
	"is_promo_active_txt": "promo on"
 }
 }

 */
