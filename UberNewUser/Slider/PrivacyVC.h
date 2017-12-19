//
//  PrivacyVC.h
//  Blaze Ride
//
//  Created by Mohammed Arshad on 27/10/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import "BaseVC.h"

@interface PrivacyVC : BaseVC <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webViewTerms;
- (IBAction)backBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigation;

@end
