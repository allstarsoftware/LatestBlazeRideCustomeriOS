//
//  PrivacyVC.m
//  Blaze Ride
//
//  Created by Mohammed Arshad on 27/10/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import "PrivacyVC.h"

@interface PrivacyVC ()

@end

@implementation PrivacyVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"PLEASE_WAIT", nil)];
    [super setBackBarItem];

    NSURL *websiteUrl = [NSURL URLWithString:PRIVACY_URL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webViewTerms loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.btnNavigation setTitle:NSLocalizedString(@"Privacy", nil) forState:UIControlStateNormal];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [APPDELEGATE hideLoadingView];
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
