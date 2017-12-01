//
//  UserGetRequestLocation.h
//  TaxiAppz
//
//  Created by Spextrum on 17/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface UserGetRequestLocation : NSObject<RMMapping>

@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSString* Latitude;
@property (nonatomic, retain) NSString* Longitude;
@property (nonatomic, retain) NSString* Bearing;
@property (nonatomic, retain) NSString* Distance;

@end


/*
 
 {
 "success": true,
	“Latitude” : “11.74854”,
 “Longitude” : “76.53436”,
 “Bearing” : “0.65656”,
 “Distance” :
 }

 
*/
