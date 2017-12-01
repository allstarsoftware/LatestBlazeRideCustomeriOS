//
//  UserRequestInProgress.h
//  TaxiAppz
//
//  Created by Spextrum on 17/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface UserRequestInProgress : NSObject<RMMapping>

@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSString* request_id;

@end


/*
 {
 "success": true,
 “request_id” : 323
 }

*/
