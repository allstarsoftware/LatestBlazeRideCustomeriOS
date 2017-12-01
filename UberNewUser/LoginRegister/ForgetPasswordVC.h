//
//  ForgetPasswordVC.h
//  UberforXOwner
//
//  Created by Deep Gami on 14/11/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "BaseVC.h"
#import "JVFloatLabeledTextField.h"

@interface ForgetPasswordVC : BaseVC <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *txtEmail;
- (IBAction)signBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *forgetpassword;

@end
