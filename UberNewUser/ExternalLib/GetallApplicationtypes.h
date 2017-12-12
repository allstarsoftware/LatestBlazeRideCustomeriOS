//
//  GetallApplicationtypes.h
//  TaxiAppz
//
//  Created by Spextrum on 21/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"
@interface GetallApplicationtypes : NSObject<RMMapping>

@property (nonatomic, strong) NSString* base_distance;
@property (nonatomic, strong) NSString* base_price;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString* duration;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* is_default;
@property (nonatomic, strong) NSString* max_size;
@property (nonatomic, strong) NSString* min_fare;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* price_per_unit_distance;
@property (nonatomic, strong) NSString* price_per_unit_time;
@property (nonatomic, strong) NSString* unit;

@end

/*
 {
 success = 1;
 types =     (
 {
 "base_distance" = 5;
 "base_price" = 25;
 currency = "$";
 duration = "";
 icon = "http://192.168.1.11:2222/taxidemo/public/uploads/148498581613717.png";
 id = 1;
 "is_default" = 1;
 "max_size" = 3;
 "min_fare" = 25;
 name = MINI;
 "price_per_unit_distance" = "1.5";
 "price_per_unit_time" = "0.25";
 unit = kms;
 },
 {
 "base_distance" = 1;
 "base_price" = 9;
 currency = "$";
 duration = "<null>";
 icon = "http://www.taxiappz.com/taxidemo/public/uploads/14755770841639654750.png";
 id = 2;
 "is_default" = 0;
 "max_size" = 4;
 "min_fare" = 9;
 name = SEDAN;
 "price_per_unit_distance" = "1.5";
 "price_per_unit_time" = 1;
 unit = kms;
 },
 {
 "base_distance" = 1;
 "base_price" = 10;
 currency = "$";
 duration = "<null>";
 icon = "http://www.taxiappz.com/taxidemo/public/uploads/14755771021824045731.png";
 id = 3;
 "is_default" = 0;
 "max_size" = 4;
 "min_fare" = 10;
 name = SUV;
 "price_per_unit_distance" = 2;
 "price_per_unit_time" = 1;
 unit = kms;
 },
 {
 "base_distance" = 1;
 "base_price" = 9;
 currency = "$";
 duration = "<null>";
 icon = "http://www.taxiappz.com/taxidemo/public/uploads/1475126852406235949.png";
 id = 4;
 "is_default" = 0;
 "max_size" = 6;
 "min_fare" = 9;
 name = "People Mover";
 "price_per_unit_distance" = "1.75";
 "price_per_unit_time" = 1;
 unit = kms;
 }
 );
 }
 */
