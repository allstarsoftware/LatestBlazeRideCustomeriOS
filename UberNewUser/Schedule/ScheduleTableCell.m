//
//  ScheduleTableCell.m
//  TaxiAppz
//
//  Created by Spextrum on 08/12/16.
//  Copyright © 2016 Jigs. All rights reserved.
//

#import "ScheduleTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScheduleTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    self.bgview.layer.cornerRadius = 15;
    self.bgview.layer.masksToBounds = YES;
    self.contentview.layer.cornerRadius = 15;
    self.contentview.layer.masksToBounds = YES;
    self.contentview.layer.borderColor = [UberStyleGuide colorSecondary].CGColor;
    self.contentview.layer.borderWidth = 0.5f;
    
    [self.pickuppointview setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.droppointview setBackgroundColor:[UberStyleGuide colorSecondary]];
    [self.imglinebreak setBackgroundColor:[UberStyleGuide colorDefault]];
    
    self.pickuppointview.layer.cornerRadius = self.pickuppointview.frame.size.width/2;
    self.pickuppointview.layer.masksToBounds = YES;
    self.droppointview.layer.cornerRadius = self.droppointview.frame.size.width/2;
    self.droppointview.layer.masksToBounds = YES;
    
    [self.lblTitle setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.lblRidestatus setBackgroundColor:[UberStyleGuide colorSecondary]];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
