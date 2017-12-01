//
//  UserAddCardToken.h
//  TaxiAppz
//
//  Created by Spextrum on 17/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface UserAddCardToken : NSObject<RMMapping>

@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* owner_id;
@property (nonatomic, retain) NSString* customer_id;
@property (nonatomic, retain) NSString* last_four;
@property (nonatomic, retain) NSString* card_token;
@property (nonatomic, retain) NSString* card_type;
@property (nonatomic, retain) NSString* card_id;
@property (nonatomic, retain) NSString* is_default;

@end


/*
 
 {
 "success": true,
 “id": 1,
 "owner_id": 23,
 "customer_id": 23,
 "last_four": “3232”,
 "card_token" : "gkfhgsfgsfjghsjklh",
 "card_type" : "visa",
 “card_id” : “shfgkjhsjkifghs”,
 “is_default” : true
 }

 
*/
