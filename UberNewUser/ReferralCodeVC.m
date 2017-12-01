//
//  ReferralCodeVC.m
//  UberforXOwner
//
//  Created by Deep Gami on 21/11/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "ReferralCodeVC.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "User_Referral.h"

@interface ReferralCodeVC ()
{
    NSString *strForReferralCode;
    NSUserDefaults *prefl;
}

@end

@implementation ReferralCodeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefl = [[NSUserDefaults alloc]init];
   
    [super setBackBarItem];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getReferralCode];
     [self SetLocalization];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.btnNavigation setTitle:NSLocalizedStringFromTable(@"Referral Code", [prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}
-(void)SetLocalization
{
    
    self.lblYour.text=NSLocalizedStringFromTable(@"Your Referral Code is",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lblCredit.text=NSLocalizedStringFromTable(@"Your Referral Credit",[prefl objectForKey:@"TranslationDocumentName"], nil);
    [self.btnShare setTitle:NSLocalizedStringFromTable(@"Share With your friend",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnShare setTitle:NSLocalizedStringFromTable(@"Share With your friend",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateHighlighted];
    [self.btnShare setTitle:NSLocalizedStringFromTable(@"Share With your friend",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateSelected];
    self.lblyourrefcodeis.text = NSLocalizedStringFromTable(@"Your Referral Code is",[prefl objectForKey:@"TranslationDocumentName"], nil);
    //self.lblCode.text = NSLocalizedString(@"Referral Code", nil);
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
//    strForReferralCode=[pref valueForKey:PREF_REFERRAL_CODE];
//    if (strForReferralCode==nil)
//    {
//    
//        [self getReferralCode];
//    }
//    else
//    {
//        self.lblCode.text=strForReferralCode;
//        
//    }
//    self.btnNavigation.titleLabel.font=[UberStyleGuide fontRegular];
//    self.btnShare.titleLabel.font=[UberStyleGuide fontRegularBold];
//    //self.lblCode.font=[UberStyleGuide fontRegular];
//   // self.lblYour.font=[UberStyleGuide fontRegular];
//}
//
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getReferralCode
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        NSString *strForUserId=[pref objectForKey:PREF_USER_ID];
        NSString *strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        
        
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_REFERRAL,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue])
                 {
                     NSDictionary *set = response;
                     User_Referral *tester = [RMMapper objectWithClass:[User_Referral class] fromDictionary:set];
                     NSLog(@"Tdata: %@",tester.success);
                     strForReferralCode=[response valueForKey:@"referral_code"];
                     [pref setObject:strForReferralCode forKey:PREF_REFERRAL_CODE];
                     [pref synchronize];
                     self.lblCode.text=strForReferralCode;
                     self.lblBalance.text=[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil),[response valueForKey:@"balance_amount"]];
                 }
                 else
                 {}
             }
             
         }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"], nil) message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"], nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil), nil];
        [alert show];
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)shareBtnPressed:(id)sender
{
    //[self shareMail];
    
    NSString *texttoshare = [NSString stringWithFormat:@"%@ : %@",NSLocalizedStringFromTable(@"My Referral code is",[prefl objectForKey:@"TranslationDocumentName"], nil),strForReferralCode]; //this is your text string to share
    //UIImage *imagetoshare = @""; //this is your image to share
    NSArray *activityItems = @[texttoshare];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
    
}
-(void)shareMail
{
    if(strForReferralCode)
    {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer=[[MFMailComposeViewController alloc]init ];
        mailer.mailComposeDelegate=self;
        NSArray *toRecipients=[[NSArray alloc]initWithObjects:@"",nil];
        NSString *msg=[NSString stringWithFormat:@"Sign up for Uber For X with my referral code %@, and get the first ride worth %@x free!",strForReferralCode,NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"], nil)];
       [mailer setSubject:@"SHARE REFERRAL CODE"];
        [mailer setMessageBody:msg isHTML:NO];
       // [mailer setToRecipients:toRecipients];
        
      //  NSData *dataObj = UIImageJPEGRepresentation(shareImage, 1);
       // [mailer addAttachmentData:dataObj mimeType:@"image/jpeg" fileName:@"iBusinessCard.jpg"];
        
        [mailer setDefinesPresentationContext:YES];
        [mailer setEditing:YES];
        [mailer setModalInPopover:YES];
        [mailer setNavigationBarHidden:NO animated:YES];
        [mailer setWantsFullScreenLayout:YES];
        
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    }
    else
        
    {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"NO_REFERRAL",[prefl objectForKey:@"TranslationDocumentName"], nil)];

    }
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
   
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled");
            [self.tabBarController setSelectedIndex:0];
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MFMailComposeResultSent:
            [self showAlert:@"Mail sent successfully." message:@"Success"];
            [self dismissViewControllerAnimated:YES completion:NULL];
            
            NSLog(@"Mail send successfully");
            break;
        case MFMailComposeResultSaved:
            [self showAlert:@"Mail saved to drafts successfully." message:@"Mail saved"];
            NSLog(@"Mail Saved");
            break;
        case MFMailComposeResultFailed:
            [self showAlert:[NSString stringWithFormat:@"Error:%@.", [error localizedDescription]] message:@"Failed to send mail"];
            NSLog(@"Mail send error : %@",[error localizedDescription]);
            break;
        default:
            break;
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


@end
