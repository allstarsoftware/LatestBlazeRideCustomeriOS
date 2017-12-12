//
//  ParseContent.m
//  TaxiAppz
//
//  Created by Spextrum on 20/01/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import "ParseContent.h"


@interface ParseContent()

@end

@implementation ParseContent


-(void)startSampleProcess{
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self.delegate
                                   selector:@selector(processCompleted) userInfo:nil repeats:NO];
}

/*+(void)ParseLogin:(NSMutableDictionary *)dictParam{
 
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    AFNHelper *afn_new=[[AFNHelpernew alloc]initWithRequestMethod:POST_METHOD];
    [afn_new getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
     {
         [[AppDelegate sharedAppDelegate]hideLoadingView];
         if (response)
         {
             if([[response valueForKey:@"success"]boolValue])
             {
                 RMUserDetails *getrooms = [RMMapper objectWithClass:[RMUserDetails class] fromDictionary:response];
                 NSDictionary *getDict = (NSDictionary *) getrooms.user;
                 RMUser *getUser = [RMMapper objectWithClass:[RMUser class] fromDictionary:getDict];
                 NSLog(@"GetDate: %@",getrooms.user);
                 
                 [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                 [pref setObject:[NSString stringWithFormat:@"%@",getUser.token] forKey:PREF_USER_TOKEN];
                 [pref setObject:[NSString stringWithFormat:@"%@",getUser.id] forKey:PREF_USER_ID];
                 [pref setObject:[NSString stringWithFormat:@"%@",getUser.phone] forKey:PREF_MOBILE_NO];
                 [pref setObject:[NSString stringWithFormat:@"%@",getUser.is_referee] forKey:PREF_IS_REFEREE];
                 [pref setBool:YES forKey:PREF_IS_LOGIN];
                 [pref synchronize];
                 
//                 [self performSegueWithIdentifier:SEGUE_SUCCESS_LOGIN sender:self];
             }
             else
             {
                 if([[[response valueForKey:@"error_messages"] objectAtIndex:0] isEqualToString:@"The selected social unique id is invalid."]) {
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Kindly signup before signin" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", [pref objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 else {
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", [pref objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
                     [alert show];
                 }
                 
             }
         }
         
     }];

}*/

@end
