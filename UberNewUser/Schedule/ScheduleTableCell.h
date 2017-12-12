//
//  ScheduleTableCell.h
//  TaxiAppz
//
//  Created by Spextrum on 08/12/16.
//  Copyright © 2016 Jigs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIView *bgview;
@property (weak,nonatomic) IBOutlet UIView *contentview;
@property (weak,nonatomic) IBOutlet UIView *pickuppointview;
@property (weak,nonatomic) IBOutlet UIView *droppointview;
@property (weak,nonatomic) IBOutlet UILabel *lblPickupaddress;
@property (weak,nonatomic) IBOutlet UILabel *lblDropaddress;
@property (weak,nonatomic) IBOutlet UILabel *lblTitle;
@property (weak,nonatomic) IBOutlet UILabel *lblRidestatus;
@property (weak,nonatomic) IBOutlet UILabel *lblCartype;
@property (weak,nonatomic) IBOutlet UILabel *lblTime;
@property (weak,nonatomic) IBOutlet UILabel *lblDate;
@property (weak,nonatomic) IBOutlet UIImageView *imglinebreak;
@property (weak,nonatomic) IBOutlet UIButton *btnCancel;

@end
