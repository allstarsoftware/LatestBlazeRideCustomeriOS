//
//  RMUserDetails.h
//  testparsecontent
//
//  Created by Spextrum on 27/12/16.
//  Copyright © 2016 InrTrade. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "RMMapper.h"

@interface RMUserDetails : NSObject<RMMapping>

@property (nonatomic, strong) NSString* success;
@property (nonatomic, strong) NSArray* user;


@end
