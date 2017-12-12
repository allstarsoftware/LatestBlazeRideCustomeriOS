//
//  ParseContent.h
//  TaxiAppz
//
//  Created by Spextrum on 20/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import "UtilityClass.h"
#import "RMUser.h"
#import "RMUserDetails.h"

// Protocol definition starts here
@protocol SampleProtocolDelegate <NSObject>
@required
- (void) processCompleted;
@end
// Protocol Definition ends here

@interface ParseContent : NSObject
{
    // Delegate to respond back
    id <SampleProtocolDelegate> _delegate;
    
}
@property (nonatomic,strong) id delegate;

-(void)startSampleProcess; // Instance method



+(void)ParseLogin:(NSMutableDictionary *)dictParam; // Instance method

@end
