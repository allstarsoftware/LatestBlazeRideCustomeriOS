//
//  RMwalkerDetails.h
//  TaxiAppz
//
//  Created by Spextrum on 02/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"
#import "RMWalker.h"

@interface RMwalkerDetails : NSObject<RMMapping>

@property (nonatomic, strong) NSString* success;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSDictionary *current;
@property (nonatomic, strong) NSString* bearing;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* is_near;
@property (nonatomic, strong) RMWalker* walkers;

@end

/*
 
*/
