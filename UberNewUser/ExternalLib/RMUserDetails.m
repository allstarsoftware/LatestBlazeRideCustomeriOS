//
//  RMUserDetails.m
//  testparsecontent
//
//  Created by Spextrum on 27/12/16.
//  Copyright © 2016 InrTrade. All rights reserved.
//


#import "RMUserDetails.h"
#import "RMUser.h"

@implementation RMUserDetails

-(Class)rm_itemClassForArrayProperty:(NSString *)property
{
    if ([property isEqualToString:@"user"])
    {
        return [RMUser class];
    }
    
    return nil;
}

@end
