//
//  UserCreateRequestDetail.h
//  TaxiAppz
//
//  Created by Spextrum on 17/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface UserCreateRequestDetail : NSObject<RMMapping>

@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSString* unique_id;
@property (nonatomic, retain) NSString* is_referral_active;
@property (nonatomic, retain) NSString* is_referral_active_txt;
@property (nonatomic, retain) NSString* is_promo_active;
@property (nonatomic, retain) NSString* is_promo_active_txt;
@property (nonatomic, retain) NSString* request_id;
@property (nonatomic, retain) NSString* walker;
@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* first_name;
@property (nonatomic, retain) NSString* last_name;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSString* picture;
@property (nonatomic, retain) NSString* bio;
@property (nonatomic, retain) NSString* latitude;
@property (nonatomic, retain) NSString* longitude;
@property (nonatomic, retain) NSString* type;
@property (nonatomic, retain) NSString* car_model;
@property (nonatomic, retain) NSString* car_number;
@property (nonatomic, retain) NSString* rating;
@property (nonatomic, retain) NSString* num_rating;

@end


/*
 {
 "success": true,
 "unique_id": 1,
 "is_referral_active": true,
 "is_referral_active_txt": "referral on",
 "is_promo_active": true,
 "is_promo_active_txt": "promo on",
 "request_id": 2243,
 "walker": {
	"unique_id": 1,
	"id": 78,
	"first_name": "Test",
	"last_name": "Driver",
	"phone": "+50688887777",
	"picture": "http://www.taxiappz.com/taxidemo/public/uploads/dc2c77ffee82eb10f168bb12c96ec2fca8067154.jpg",
	"bio": "bio",
	"latitude": 11.0146746,
	"longitude": 76.9814543,
	"type": 1,
	"car_model": "Myth",
	"car_number": "sry I",
	"rating": 2.5,
	"num_rating": 2
 }
 }

*/
