//
//  LoginVC.h
//  Uber
//
//  Created by Elluminati - macbook on 21/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "BaseVC.h"
#import "Reachability.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "JVFloatLabeledTextField.h"

@interface LoginVC : BaseVC<UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@property NetworkStatus internetConnectionStatus;
@property(nonatomic,weak)IBOutlet UIScrollView *scrLogin;
@property(nonatomic,weak)IBOutlet JVFloatLabeledTextField *txtEmail;
@property(nonatomic,weak)IBOutlet JVFloatLabeledTextField *txtPsw;

- (IBAction)onClickFacebook:(id)sender;

-(IBAction)onClickLogin:(id)sender;
-(IBAction)onClickForgotPsw:(id)sender;


@property (nonatomic, weak) IBOutlet UITableView *tblPhoneBook;
@property(strong, nonatomic) IBOutlet UIView *viewForSocial;
@property(strong, nonatomic) IBOutlet UIView *viewForPhoneBook;
@property (weak, nonatomic) IBOutlet UIButton *btnSocialSelectCountry;
@property(strong, nonatomic) IBOutlet UITextField *txtSocialPhone;

@property (weak, nonatomic) IBOutlet GIDSignInButton *btngoogleplus;

@end
