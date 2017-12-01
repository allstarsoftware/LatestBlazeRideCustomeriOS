//
//  RMWalker.h
//  TaxiAppz
//
//  Created by Spextrum on 02/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"
@interface RMWalker : NSObject<RMMapping>

@property (nonatomic, strong) NSString* success;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSDictionary *current;
@property (nonatomic, strong) NSString* bearing;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* is_near;

@end

/*
 
 {
 "success": true,
 "walkers": [
	{
 "id": 79,
 "current": {
    "latitude": 11.0146746,
    "longitude": 76.9814556
 },
 "bearing": 0,
 "type": 1,
 "is_near": true
	},
	{
 "id": 78,
 "current": {
 "latitude": 11.0146746,
 "longitude": 76.98146
 },
 "bearing": 0,
 "type": 1,
 "is_near": false
	}
 ]
 }
 
 
 */
