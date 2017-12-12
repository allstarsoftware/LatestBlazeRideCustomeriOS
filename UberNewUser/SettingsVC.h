//
//  SettingsVC.h
//  TaxiAppz
//
//  Created by Spextrum on 09/12/16.
//  Copyright © 2016 Jigs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface SettingsVC : BaseVC <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *viewSelection;
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine1;
@property (weak, nonatomic) IBOutlet UIImageView *imgLine2;
@property (weak, nonatomic) IBOutlet UITableView *tblLanguageList;
@property (weak, nonatomic) IBOutlet UILabel *lbl_languagetitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_language;
@property (weak, nonatomic) IBOutlet UILabel *lbl_languageabbrv;

@property (weak, nonatomic) IBOutlet UIButton *btnlanguageselection;

- (IBAction)btnlanguageselection:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *BgviewForTblview;

@end
