//
//  UserApplyReferral.h
//  TaxiAppz
//
//  Created by Spextrum on 17/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"
@interface UserApplyReferral : NSObject<RMMapping>

@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* error;
@property (nonatomic, retain) NSString* first_name;
@property (nonatomic, retain) NSString* last_name;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* is_otp;
@property (nonatomic, retain) NSString* picture;
@property (nonatomic, retain) NSString* bio;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* state;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSString* zipcode;
@property (nonatomic, retain) NSString* login_by;
@property (nonatomic, retain) NSString* social_unique_id;
@property (nonatomic, retain) NSString* device_token;
@property (nonatomic, retain) NSString* device_type;
@property (nonatomic, retain) NSString* otp_status;
@property (nonatomic, retain) NSString* timezone;
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSString* referral_code;
@property (nonatomic, retain) NSString* is_referee;
@property (nonatomic, retain) NSString* promo_count;
@property (nonatomic, retain) NSString* is_referral_active;
@property (nonatomic, retain) NSString* is_referral_active_txt;
@property (nonatomic, retain) NSString* is_promo_active;
@property (nonatomic, retain) NSString* is_promo_active_txt;

@end


/*
 {
 "success": true,
 "id": 590,
 “error” => “Referral process successfully completed.”,
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
--
 {
 "success": true,
 "id": 590,
 “error” => “Referral process successfully completed.”,
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

*/
