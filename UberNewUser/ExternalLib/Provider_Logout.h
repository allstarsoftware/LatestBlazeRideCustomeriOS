//
//  Provider_Logout.h
//  TaxiAppz
//
//  Created by Spextrum on 17/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface Provider_Logout : NSObject<RMMapping>

@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSString* error;

@end

/*
 
 {
 "success": true,
 “error": “successfully log-out”
 }

 
*/
