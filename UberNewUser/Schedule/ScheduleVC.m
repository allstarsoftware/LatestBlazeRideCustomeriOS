//
//  SupportVC.m
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "ScheduleVC.h"
#import "ScheduleTableCell.h"
#import "Constants.h"
#import "UIImageView+Download.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "UtilityClass.h"
#import "UberStyleGuide.h"
#import "ScheduleBean.h"
#import "CancelSchedule_parsing.h"

@interface ScheduleVC ()
{
    NSMutableArray *arrHistory;
    NSMutableArray *arrForDate;
    NSMutableArray *arrSchedule;
    
    NSMutableArray *tableData;
    
}

@end

@implementation ScheduleVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    tableData = [[NSMutableArray alloc]init];
    [super setBackBarItem];
    [self getSchedule];
}

-(void)getSchedule
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:@"Loading"];
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setValue:strForUserId forKey:@"userId"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:@"https://ride.blazeride.com/dog/getUserSchedules" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
           
            NSDictionary *set = responseObject;
            NSLog(@"JSON: %@", responseObject);
            
            CancelSchedule_parsing* tester = [RMMapper objectWithClass:[CancelSchedule_parsing class] fromDictionary:set];
            NSLog(@"Tdata: %@",tester.success);
            
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            NSDictionary *result = (NSDictionary*)responseObject;
            if ([[result objectForKey:@"success"] boolValue])
            {
                tableData = [[NSMutableArray alloc]init];
                arrSchedule = [result objectForKey:@"requests"];
                for (int i = 0; i < [arrSchedule count]; i++)
                {
                    ScheduleBean *Beanobj = [[ScheduleBean alloc] init];
                    Beanobj.scheduleId = [[arrSchedule objectAtIndex:i] valueForKey:@"id"];
                    
                    if ([[arrSchedule objectAtIndex:i] valueForKey:@"pickupAddress"] == [NSNull null])
                        Beanobj.PickUpaddress = @"";
                    else
                        Beanobj.PickUpaddress = [[arrSchedule objectAtIndex:i] valueForKey:@"pickupAddress"];
                    if ([[arrSchedule objectAtIndex:i] valueForKey:@"droppAddress"] == [NSNull null])
                        Beanobj.Dropaddress = @"";
                    else
                        Beanobj.Dropaddress = [[arrSchedule objectAtIndex:i] valueForKey:@"droppAddress"];
                    
                    NSLog(@"Schedule Time 24F%@",[[arrSchedule objectAtIndex:i] valueForKey:@"scheduleTime"]);
                    NSString *Time =[[arrSchedule objectAtIndex:i] valueForKey:@"scheduleTime"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"HH:mm";
                    NSDate *date = [dateFormatter dateFromString:Time];
                    dateFormatter.dateFormat = @"hh:mm a";
                    NSString *pmamDateString = [dateFormatter stringFromDate:date];
                    NSLog(@"12Hr Format Time=%@",pmamDateString);
                    
                    Beanobj.ScheduleTime = pmamDateString;
                    Beanobj.ScheduleDate = [[arrSchedule objectAtIndex:i] valueForKey:@"scheduleDate"];
                    Beanobj.ScheduleStatus = [[arrSchedule objectAtIndex:i] valueForKey:@"is_cancelled"];
                    Beanobj.Cartype = [[arrSchedule objectAtIndex:i] valueForKey:@"car_type"];
                    [tableData addObject:Beanobj];
                }
            }
            else {
                
            }
            [self.tableView reloadData];
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            
        }];
    }

}

-(IBAction)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *simpleTableIdentifier = @"ScheduleTableCell";
                         
    ScheduleTableCell *cell = (ScheduleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    ScheduleBean *obj = [[ScheduleBean alloc] init];
    obj = [tableData objectAtIndex:[indexPath row]];
    
       
    if([obj.PickUpaddress isEqualToString:@""])
        cell.lblPickupaddress.text =@"Pickup Address Not Available";
    else
        cell.lblPickupaddress.text = obj.PickUpaddress;
    
    if([obj.Dropaddress isEqualToString:@""])
        cell.lblDropaddress.text =@"Drop Address Not Available";
    else
        cell.lblDropaddress.text = obj.Dropaddress;
    
    NSString *status =[NSString stringWithFormat:@"%@",obj.ScheduleStatus];
    NSLog(@"Status %@",status);
    
    cell.lblDate.text = obj.ScheduleDate;
    cell.lblTime.text = obj.ScheduleTime;
    cell.lblCartype.text = obj.Cartype;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",obj.ScheduleTime ,obj.ScheduleDate];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([status isEqualToString:@"0"])
    {
        [cell.lblRidestatus setText:@"Cancel Ride"];
        cell.lblRidestatus.textColor = [UIColor whiteColor];
    }
    else
    {
      [cell.lblRidestatus setText:@"Ride Cancelled"];
      cell.lblRidestatus.textColor = [UIColor lightGrayColor];
    }
    
    [cell.btnCancel setTag:[obj.scheduleId integerValue]];
    [cell.btnCancel addTarget:self action:@selector(RideCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 195.0;
}

-(void)RideCancel:(id)sender
{
    NSLog(@"Cancel Ride Triggered");
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setValue:[NSString stringWithFormat:@"%ld",(long)[sender tag]] forKey:@"id"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"https://ride.blazeride.com/dog/cancelschedule" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *set = responseObject;
        CancelSchedule_parsing* tester = [RMMapper objectWithClass:[CancelSchedule_parsing class] fromDictionary:set];
        NSLog(@"Tdata: %@",tester.success);
        
        [self getSchedule];
    }failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[AppDelegate sharedAppDelegate]hideLoadingView];
        
    }];

    
}


@end
