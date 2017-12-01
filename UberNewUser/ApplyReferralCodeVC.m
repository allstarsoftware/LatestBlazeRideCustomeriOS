//
//  ApplyReferralCodeVC.m
//  UberforXOwner
//
//  Created by Deep Gami on 22/11/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "ApplyReferralCodeVC.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "AppDelegate.h"
#import "UberStyleGuide.h"
#import "UserApplyReferral.h"

@interface ApplyReferralCodeVC ()
{
    NSString *Referral;
    NSUserDefaults *prefl;
}
@end

@implementation ApplyReferralCodeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefl = [[NSUserDefaults alloc]init];
     self.viewForReferralError.hidden=YES;
    
    self.navigationItem.hidesBackButton=YES;
    self.txtCode.font=[UberStyleGuide fontRegular];
    self.btnSubmit=[APPDELEGATE setBoldFontDiscriptor:self.btnSubmit];
    self.btnContinue=[APPDELEGATE setBoldFontDiscriptor:self.btnContinue];
    Referral=@"";
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self SetLocalization];
     self.viewForReferralError.hidden=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.btn_Navi_Title setTitle:NSLocalizedStringFromTable(@"Referral Code",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
}
-(void)SetLocalization
{
    prefl = [[NSUserDefaults alloc]init];
    self.txtCode.placeholder=NSLocalizedStringFromTable(@"Enter Referral Code",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.lblMsg.text=NSLocalizedStringFromTable(@"Referral_Msg",[prefl objectForKey:@"TranslationDocumentName"],nil);
    [self.btnContinue setTitle:NSLocalizedStringFromTable(@"SKIP",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    [self.btnContinue setTitle:NSLocalizedStringFromTable(@"SKIP",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateSelected];
    [self.btnSubmit setTitle:NSLocalizedStringFromTable(@"ADD",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
    [self.btnSubmit setTitle:NSLocalizedStringFromTable(@"ADD",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateSelected];
    self.lblReferralErrorMsg.text = NSLocalizedStringFromTable(@"FAILURE_REFERRAL",[prefl objectForKey:@"TranslationDocumentName"],nil);
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)codeBtnPressed:(id)sender
{
    Referral=@"0";
    [self createService];
}

- (IBAction)ContinueBtnPressed:(id)sender
{
    Referral=@"1";
    [self createService];
}

-(void)createService
{
    self.viewForReferralError.hidden=YES;
    if([[AppDelegate sharedAppDelegate]connected])
    {
        
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"LOADING",[prefl objectForKey:@"TranslationDocumentName"],nil)];
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        NSString *strForUserId=[pref objectForKey:PREF_USER_ID];
        NSString *strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:strForUserId forKey:PARAM_ID];
        [dictParam setObject:self.txtCode.text forKey:PARAM_REFERRAL_CODE];
        [dictParam setObject:strForUserToken forKey:PARAM_TOKEN];
        [dictParam setObject:Referral forKey:PARAM_REFERRAL_SKIP];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_APPLY_REFERRAL withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue])
                 {
                     NSLog(@"%@",response);
                     NSDictionary *set = response;
                     UserApplyReferral *tester = [RMMapper objectWithClass:[UserApplyReferral class] fromDictionary:set];
                     NSLog(@"Tdata: %@",tester.success);
                     if([[response valueForKey:@"success"]boolValue])
                     {
                         NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                         [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                         [pref synchronize];
                         if([Referral isEqualToString:@"0"])
                         {
                         [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"SUCESS_REFERRAL",[prefl objectForKey:@"TranslationDocumentName"],nil)];
                         [self performSegueWithIdentifier:@"segueToAddPayment" sender:self];
                         }
                         else
                         {
                              [self performSegueWithIdentifier:@"segueToAddPayment" sender:self];
                         }
                     }
                 }
                 else
                 {
                     self.txtCode.text=@"";
                     self.viewForReferralError.hidden=NO;
                     self.lblReferralErrorMsg.text=[response valueForKey:@"error"];
                     self.lblReferralErrorMsg.textColor=[UIColor colorWithRed:205.0/255.0 green:0.0/255.0 blue:15.0/255.0 alpha:1];
                 }
             }
             
             
         }];
    }
    else
    {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"],nil) message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil), nil];
        [alert show];
    }


}
#pragma mark-
#pragma mark- TextField Delegate



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtCode resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.viewForReferralError.hidden=YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
