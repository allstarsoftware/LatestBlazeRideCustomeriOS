//
//  User_Referral.h
//  TaxiAppz
//
//  Created by Spextrum on 17/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface User_Referral : NSObject<RMMapping>

@property (nonatomic, retain) NSString* success;
@property (nonatomic, retain) NSString* referral_code;
@property (nonatomic, retain) NSString* Total_refferal;
@property (nonatomic, retain) NSString* Amount_earned;
@property (nonatomic, retain) NSString* Amount_spent;
@property (nonatomic, retain) NSString* Balance_amount;

@end


/*
 {
 "success": true,
 “referral_code” : “23423”,
 “Total_refferal” : 10,
 “Amount_earned” : 19.00,
 “Amount_spent” :101.00,
 “Balance_amount” :10.00
 }

*/
