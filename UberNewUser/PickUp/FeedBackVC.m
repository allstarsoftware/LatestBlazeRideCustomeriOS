//
//  FeedBackVC.m
//  UberNewUser
//
//  Created by Deep Gami on 01/11/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//
#import "AFNetworking.h"
#import "FeedBackVC.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "UIImageView+Download.h"
#import "UIView+Utils.h"
#import "PickUpVC.h"
#import "UberStyleGuide.h"
#import "AGPushNoteView.h"
#import "CancelSchedule_parsing.h"
@interface FeedBackVC ()

@end

@implementation FeedBackVC
{
    NSUserDefaults *prefl;
}

#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [super setBackBarItem];
    [self.BGViewforTips setHidden:YES];
    [self.ViewforTips setHidden:YES];
    prefl = [[NSUserDefaults alloc]init];
    
    [AGPushNoteView close];
    self.navigationController.navigationBarHidden=NO;
    
    NSArray *arrName=[self.strFirstName componentsSeparatedByString:@" "];
    
    self.lblFirstName.text=[arrName objectAtIndex:0];
    self.lblLastName.text=[arrName objectAtIndex:1];
    
    self.lblDistance.textColor=[UberStyleGuide colorDefault];
    self.lblTIme.textColor=[UberStyleGuide colorDefault];
    self.lblCost.textColor=[UberStyleGuide colorDefault];
    
    self.lblDistance.text=[NSString stringWithFormat:@"%.2f %@",[[self.dictWalkInfo valueForKey:@"distance"] floatValue],NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    self.lblTIme.text=[self.dictWalkInfo valueForKey:@"time"];
    [self.imgUser applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    [self.imgUser downloadFromURL:self.strUserImg withPlaceholder:nil];
    self.viewForBill.hidden=NO;
    self.txtComments.text=NSLocalizedStringFromTable(@"COMMENT", [prefl objectForKey:@"TranslationDocumentName"], nil);
    [self customSetup];
    [self setPriceValue];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self SetLocalization];
    [self customFont];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[AppDelegate sharedAppDelegate] hideLoadingView];

    [self.btnFeedBack setTitle:NSLocalizedStringFromTable(@"Feedback", [prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}
-(void)SetLocalization
{
    prefl = [[NSUserDefaults alloc]init];
    
    self.lblInvoice.text=NSLocalizedStringFromTable(@"Invoice",[prefl objectForKey:@"TranslationDocumentName"], nil);
//    self.lBasePrice.text=NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil);
//    self.lDistanceCost.text=NSLocalizedStringFromTable(@"DISTANCE COST",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lTimeCost.text=NSLocalizedStringFromTable(@"TIME COST", [prefl objectForKey:@"TranslationDocumentName"],nil);
    self.lPromoBonus.text=NSLocalizedStringFromTable(@"PROMO BONUS",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lreferalBonus.text=NSLocalizedStringFromTable(@"REFERRAL BONUS",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lTotalCost.text=NSLocalizedStringFromTable(@"Total Due",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lComment.text=NSLocalizedStringFromTable(@"COMMENT",[prefl objectForKey:@"TranslationDocumentName"], nil);
    [self.btnConfirm setTitle:NSLocalizedStringFromTable(@"CONFIRM",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnSubmit setTitle:NSLocalizedStringFromTable(@"Submit",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.sharebtn setTitle:NSLocalizedStringFromTable(@"Share",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}
#pragma mark-
#pragma mark- Set Invoice Details

-(void)setPriceValue
{
    NSLog(@"Hiiii %@",dictBillInfo);
    self.LblWaitingcostValue.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"waiting_price"]floatValue]];
    
    self.lblBasePrice.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"base_price"]floatValue]];
    self.lblDistCost.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"distance_cost"]floatValue]];
    self.lblTimeCost.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"time_cost"] floatValue]];
    self.lblTotal.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency",  [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"total"] floatValue]];
    self.lblCost.text = [NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"total"] floatValue]];
    self.lblRferralBouns.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"referral_bonus"] floatValue]];
    self.lblPromoBouns.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[dictBillInfo valueForKey:@"promo_bonus"] floatValue]];
    float totalDist=[[dictBillInfo valueForKey:@"distance_cost"] floatValue];
    float Dist=[[dictBillInfo valueForKey:@"distance"]floatValue];
    float NetDistance = Dist - 1.0;
    NSLog(@"Net Distance=%f",NetDistance);
    NSLog(@"Distance Price=%f",[[dictBillInfo valueForKey:@"distance_price"] floatValue]);
    NSLog(@"Set Base Distance=%f",[[dictBillInfo valueForKey:@"setbase_distance"] floatValue]);
    NSLog(@"Price Per Unit Time=%f",[[dictBillInfo valueForKey:@"price_per_unit_time"] floatValue]);
    NSString *Distance_Price = [dictBillInfo valueForKey:@"distancePrice"];
    NSString *SetBaseDistance = [dictBillInfo valueForKey:@"setbase_distance"];
    NSString *PricePerUnitTime = [dictBillInfo valueForKey:@"price_per_unit_time"];

    
    
    if ([[dictBillInfo valueForKey:@"unit"]isEqualToString:@"kms"])
    {
        totalDist=totalDist*0.621317;
        Dist=Dist*0.621371;
    }
    if(Dist!=0)
    {
//        self.lblPerDist.text=[NSString stringWithFormat:@"%.2f%@ %@",(totalDist/Dist),NSLocalizedStringFromTable(@"Currency",[prefl objectForKey:@"TranslationDocumentName"],nil),NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        if (Dist<[SetBaseDistance doubleValue])
        {
            self.lBasePrice.text=[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            
            self.lDistanceCost.text = [NSString stringWithFormat:@"%@ (%.2f KM)",NSLocalizedString(@"DISTANCE COST", nil),NetDistance];
            
            
            self.lblPerDist.text=[NSString stringWithFormat:@"%.2fPKR %@",[Distance_Price floatValue],NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
            NSLog(@" IF Calling Label Value1 =%@",self.lblPerDist.text);
        }
        else
        {
            self.lBasePrice.text=[NSString stringWithFormat:@"%@ (%.2f KM)",NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil),[SetBaseDistance floatValue]];
            
            self.lDistanceCost.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"DISTANCE COST", nil)];
            
            self.lblPerDist.text=[NSString stringWithFormat:@"%.2fPKR %@",[Distance_Price floatValue],NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
            NSLog(@"Else Calling Label Value2 =%@",self.lblPerDist.text);
        }

        
    }
    else
    {
        self.lBasePrice.text=NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil);
        self.lblPerDist.text=[NSString stringWithFormat:@"0 %@ %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"per mile", [prefl objectForKey:@"TranslationDocumentName"], nil)];
    }
    
    float totalTime=[[dictBillInfo valueForKey:@"time_cost"] floatValue];
    float Time=[[dictBillInfo valueForKey:@"time"]floatValue];
    if(Time!=0)
    {
       //        self.lblPerTime.text=[NSString stringWithFormat:@"%.2f%@ %@",(totalTime/Time),NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"per mins", [prefl objectForKey:@"TranslationDocumentName"], nil)];
        self.lblPerTime.text=[NSString stringWithFormat:@"%.2fPKR %@",[PricePerUnitTime floatValue],NSLocalizedStringFromTable(@"per mins",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    }
    else
    {
        self.lblPerTime.text=[NSString stringWithFormat:@"0 %@ %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"per mins",  [prefl objectForKey:@"TranslationDocumentName"], nil)];
    }
}

- (void)customSetup
{
    self.navigationController.navigationBarHidden=YES;
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.barButton addTarget:self.revealViewController action:@selector( revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:revealViewController.panGestureRecognizer];
        
    }
}

#pragma mark-
#pragma mark- Custom Font

-(void)customFont
{
    self.lblDistance.font=[UberStyleGuide fontRegular];
    self.lblDistCost.font=[UberStyleGuide fontRegular];
    self.lblBasePrice.font=[UberStyleGuide fontRegular];
    self.lblDistance.font=[UberStyleGuide fontRegular];
    self.lblPerDist.font=[UberStyleGuide fontRegular:12.0f];
    self.lblPerTime.font=[UberStyleGuide fontRegular:12.0f];
    self.lblTIme.font=[UberStyleGuide fontRegular];
    self.lblTimeCost.font=[UberStyleGuide fontRegular];
    self.lblTotal.font=[UberStyleGuide fontRegular:30.0f];
    self.lblFirstName.font=[UberStyleGuide fontRegular];
    self.lblLastName.font=[UberStyleGuide fontRegular];
    self.btnFeedBack.titleLabel.font=[UberStyleGuide fontRegular];
    self.lblPromoBouns.font=[UberStyleGuide fontRegular];
    self.lblRferralBouns.font=[UberStyleGuide fontRegular];
    self.btnConfirm.titleLabel.font=[UberStyleGuide fontRegularBold];
    self.btnSubmit.titleLabel.font=[UberStyleGuide fontRegularBold];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-
#pragma makr- Btn Click Events

-(IBAction)ShareOption:(id)sender {
    if ([self.txtComments.text isEqualToString:NSLocalizedStringFromTable(@"COMMENT",[prefl objectForKey:@"TranslationDocumentName"],nil)]) {
        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"Kindly type comments before sharing",[prefl objectForKey:@"TranslationDocumentName"],nil)];
        return;
    }
    NSString *texttoshare = [NSString stringWithFormat:@"Ride Kangaroo Customer \r%@ \rDownload app from: ",self.txtComments.text];

    //this is your text string to share
    //UIImage *imagetoshare = @""; //this is your image to share
    NSArray *activityItems = @[texttoshare];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}


- (IBAction)submitBtnPressed:(id)sender
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"REVIEWING",[prefl objectForKey:@"TranslationDocumentName"],nil)];
        RBRatings rating=[ratingView getcurrentRatings];
        int rate=rating/2.0;
        if(rate==0)
        {
            [[AppDelegate sharedAppDelegate] hideLoadingView];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTable(@"PLEASE_RATE",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil), nil];
            [alert show];

        }
        else
        {
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        NSString *strForUserId=[pref objectForKey:PREF_USER_ID];
        NSString *strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        NSString *strReqId=[pref objectForKey:PREF_REQ_ID];
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setObject:strForUserId forKey:PARAM_ID];
        [dictParam setObject:strForUserToken forKey:PARAM_TOKEN];
        [dictParam setObject:strReqId forKey:PARAM_REQUEST_ID];
        [dictParam setObject:[NSString stringWithFormat:@"%d",rate] forKey:PARAM_RATING];
        NSString *commt=self.txtComments.text;
        if([commt isEqualToString:NSLocalizedStringFromTable(@"COMMENT",[prefl objectForKey:@"TranslationDocumentName"],nil)])
        {
            [dictParam setObject:@"" forKey:PARAM_COMMENT];
        }
        else
        {
            [dictParam setObject:self.txtComments.text forKey:PARAM_COMMENT];
        }

        
        
//        NSString *strForUrl=[NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",FILE_GET_REQUEST,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken,PARAM_REQUEST_ID,strReqId];
        
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_RATE_DRIVER withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             NSLog(@"%@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     NSDictionary *set = response;
                     CancelSchedule_parsing* tester = [RMMapper objectWithClass:[CancelSchedule_parsing class] fromDictionary:set];
                     NSLog(@"Tdata: %@",tester.success);
                    [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"RATING",[prefl objectForKey:@"TranslationDocumentName"],nil)];
                     [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREF_REQ_ID];
                     
                     [self.navigationController popToRootViewControllerAnimated:YES];
                     
                     /*for (UIViewController *vc in self.navigationController.viewControllers)
                      {
                      if ([vc isKindOfClass:[PickUpVC class]])
                      {
                      [self.navigationController popToViewController:vc animated:YES];
                      return ;
                      }
                      }*/
                 }
             }
             
             [[AppDelegate sharedAppDelegate]hideLoadingView];

         }];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"],nil) message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil), nil];
        [alert show];
    }
    

}
#pragma mark -
#pragma mark - UITextField Delegate


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.frame=CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
        
        
    } completion:^(BOOL finished)
     {
     }];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        
    } completion:^(BOOL finished)
     {
     }];
  
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)confirmBtnPressed:(id)sender
{
    self.viewForBill.hidden=YES;
    ratingView=[[RatingBar alloc] initWithSize:CGSizeMake(120, 20) AndPosition:CGPointMake(135, 152)];
    ratingView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:ratingView];

}

#pragma mark-
#pragma mark- ADD Tips Attributes

-(void)DisplayAddTipsView
{
    [self.BGViewforTips setHidden:NO];
    [self.ViewforTips setHidden:NO];
    _ViewforTips.layer.cornerRadius = 5;
    _ViewforTips.layer.masksToBounds = YES;
    _BtnSubmitTips.layer.cornerRadius = 5;
    _BtnSubmitTips.layer.masksToBounds = YES;
    _BtnSkipTips.layer.cornerRadius = 5;
    _BtnSkipTips.layer.masksToBounds = YES;
}

- (IBAction)BtnADDTips:(id)sender
{
    [self DisplayAddTipsView];
    
}
- (IBAction)BtnTipsSubmit:(id)sender
{
    if (self.TipsTxtfield.text.length == 0)
    {
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Please Add Tips"];
    }
    else
    {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSString *Amount = self.TipsTxtfield.text;
        [pref setObject:Amount forKey:@"Amount_Tips"];
        [pref synchronize];
        [self.BGViewforTips setHidden:YES];
        [self.ViewforTips setHidden:YES];
        [self SendAddedTipstoServer];
    }
    
}

- (IBAction)BtnTipsSkip:(id)sender
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:@"NO" forKey:@"Amount_Tips"];
    [pref synchronize];
    [self.BGViewforTips setHidden:YES];
    [self.ViewforTips setHidden:YES];
}

-(void)SendAddedTipstoServer
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        
                NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                NSString *strForUserId=[pref objectForKey:PREF_USER_ID];
                NSString *strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
                NSString *strReqId=[pref objectForKey:PREF_REQ_ID];
       
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        
                [dictParam setValue:strForUserId forKey:PARAM_ID];
                [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
                [dictParam setValue:strReqId forKey:PARAM_REQUEST_ID];
                [dictParam setValue:[pref objectForKey:@"Amount_Tips"] forKey:@"tips"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:@"https://ride.blazeride.com/user/" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             NSLog(@"Added Tips Response: %@", responseObject);
             [APPDELEGATE showToastMessage:@"Tips Added Successfully"];
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             
         }];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"],nil) message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"],nil), nil];
        [alert show];
    }
}


#pragma mark-
#pragma mark- Text Field Delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtComments resignFirstResponder];
    [self.TipsTxtfield resignFirstResponder];
}
// ***************** Custom Done Button for Keyboard ********************
-(void)CustomKeybrdDonebtn
{
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(yourTextViewDoneButtonPressed)];
    [doneBarButton setTintColor:[UIColor blackColor]];
    UIBarButtonItem *flexBarButton2 = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    keyboardToolbar.items = @[flexBarButton,doneBarButton,flexBarButton2];
    self.txtComments.inputAccessoryView = keyboardToolbar;
}

-(void)yourTextViewDoneButtonPressed
{
    [self.txtComments resignFirstResponder];
}
// ***************** Custom Done Button for Keyboard ********************
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self CustomKeybrdDonebtn];
    self.txtComments.text=@"";
    UIDevice *thisDevice=[UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 568)
        {
            if(textView == self.txtComments)
            {
                
                UITextPosition *beginning = [self.txtComments beginningOfDocument];
                
                [self.txtComments setSelectedTextRange:[self.txtComments textRangeFromPosition:beginning
                                                                                  toPosition:beginning]];
//                [UIView animateWithDuration:0.3 animations:^{
//                    
//                    self.view.frame = CGRectMake(0, -210, 320, 568);
//                    
//                } completion:^(BOOL finished) { }];
            }
        }
        else
        {
            if(textView == self.txtComments)
            {
                UITextPosition *beginning = [self.txtComments beginningOfDocument];
                [self.txtComments setSelectedTextRange:[self.txtComments textRangeFromPosition:beginning
                                                                                  toPosition:beginning]];
//                [UIView animateWithDuration:0.3 animations:^{
//                    
//                    self.view.frame = CGRectMake(0, -210, 320, 480);
//                    
//                } completion:^(BOOL finished) { }];
            }
        }
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    UIDevice *thisDevice=[UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 568)
        {
            if(textView == self.txtComments)
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    
//                    self.view.frame = CGRectMake(0, 0, 320, 568);
//                    
//                } completion:^(BOOL finished) { }];
            }
        }
        else
        {
            if(textView == self.txtComments)
            {
//                [UIView animateWithDuration:0.3 animations:^{
//                    
//                    self.view.frame = CGRectMake(0, 0, 320, 480);
//                    
//                } completion:^(BOOL finished) { }];
            }
        }
    }
    if ([self.txtComments.text isEqualToString:@""])
    {
        self.txtComments.text=NSLocalizedStringFromTable(@"COMMENT",[prefl objectForKey:@"TranslationDocumentName"],nil);
    }
    
}

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
