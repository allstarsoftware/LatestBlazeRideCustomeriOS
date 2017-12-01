//
//  GetApplicationTypeDetails.m
//  TaxiAppz
//
//  Created by Spextrum on 21/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import "GetApplicationTypeDetails.h"
#import "GetallApplicationtypes.h"

@implementation GetApplicationTypeDetails

-(Class)rm_itemClassForArrayProperty:(NSString *)property
{
    if ([property isEqualToString:@"types"])
    {
        return [GetallApplicationtypes class];
    }
    
    return nil;
}


@end
