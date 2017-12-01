//
//  HistoryCell.m
//  UberforXOwner
//
//  Created by Deep Gami on 15/11/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "ScheduleCell.h"
#import "UIView+Utils.h"

@implementation ScheduleCell
@synthesize imageView;

- (void)awakeFromNib {
    // Initialization code
    [self.imageView applyRoundedCornersFullWithColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
