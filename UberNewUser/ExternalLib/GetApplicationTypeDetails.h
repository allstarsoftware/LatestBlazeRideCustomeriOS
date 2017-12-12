//
//  GetApplicationTypeDetails.h
//  TaxiAppz
//
//  Created by Spextrum on 21/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMMapper.h"
@interface GetApplicationTypeDetails : NSObject<RMMapping>

@property  int success;
@property (nonatomic, strong) NSArray *types;


@end
