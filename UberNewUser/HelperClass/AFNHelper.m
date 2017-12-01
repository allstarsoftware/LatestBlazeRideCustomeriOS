//
//  AFNHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "AFNHelper.h"
#import "AFNetworking.h"
#import "Constants.h"

@implementation AFNHelper

@synthesize strReqMethod;

#pragma mark -
#pragma mark - Init

-(id)initWithRequestMethod:(NSString *)method
{
    if ((self = [super init])) {
        self.strReqMethod=method;
    }
    return self;
}

#pragma mark -
#pragma mark - Methods

-(void)getDataFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    //    [raw urlEncodeUsingEncoding:NSUTF8Encoding]
    
    NSRange match;
    match = [path rangeOfString: @"application"];
    NSRange match1;
    match1 = [path rangeOfString: @"request/path"];
    
    NSString *url;
    
    if (match.location == NSNotFound)
    {
        url =[[NSString stringWithFormat:@"%@%@",API_URL,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    else
    {
        url =[[NSString stringWithFormat:@"%@%@",SERVICE_URL,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    if ([path containsString:@"addSchedule"])
    {
        url =[[NSString stringWithFormat:@"%@%@",RIDE_LATER_URL,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"URL %@",url);
    /*
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     [manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"JSON: %@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     }];
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     [manager GET:@"http://example.com/resources.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
     NSLog(@"JSON: %@", responseObject);
     } failure:^(NSURLSessionTask *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     }];
     -------------
     NSURL *URL = [NSURL URLWithString:@"http://example.com/resources/123.json"];
     NSURLRequest *request = [NSURLRequest requestWithURL:URL];
     AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
     op.responseSerializer = [AFJSONResponseSerializer serializer];
     [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"JSON: %@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     }];
     [[NSOperationQueue mainQueue] addOperation:op];
     
     NSURL *URL = [NSURL URLWithString:@"http://example.com/resources/123.json"];
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
     NSLog(@"JSON: %@", responseObject);
     } failure:^(NSURLSessionTask *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     }];
     
     */
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/x-www-form-urlencoded"];
    
    if ([self.strReqMethod isEqualToString:POST_METHOD])
    {
        [manager POST:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                if(responseObject==nil)
                    dataBlock(responseObject,nil);
                else
                    dataBlock(responseObject,nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
            
        }];
    }
    else{
        [manager GET:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                if(responseObject==nil)
                    dataBlock(responseObject,nil);
                else
                    dataBlock(responseObject,nil);
            }
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
            
        }];
    }
}

#pragma mark -
#pragma mark - Post methods(multipart image)

-(void)getDataFromPath:(NSString *)path withParamDataImage:(NSMutableDictionary *)dictParam andImage:(UIImage *)image withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {
        NSString *url=[[NSString stringWithFormat:@"%@%@",API_URL,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval=600;
        //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
        [manager POST:url parameters:dictParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             // [formData appendPartWithFormData:imageToUpload name:PARAM_PICTURE];
             [formData appendPartWithFileData:imageToUpload name:PARAM_PICTURE fileName:@"temp.jpg" mimeType:@"image/jpg"];
             
             //[formData appendPartWithFileURL:filePath name:@"image" error:nil];
         }
             progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                 DLog(@"Success: %@", responseObject);
                 if (dataBlock) {
                     dataBlock(responseObject,nil);
                 }
             }
              failure:^(NSURLSessionTask *operation, NSError *error) {
                  DLog(@"Error: %@", error);
                  if (dataBlock) {
                      dataBlock(nil,error);
                  }
              }];
    }
}

#pragma mark-
#pragma mark- Google GeoCoder

-(void)getAddressFromGooglewithParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    //[raw urlEncodeUsingEncoding:NSUTF8Encoding]
    NSString *url=[[NSString stringWithFormat:@"%@",Address_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@[@"text/html",@"application/json"], nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/x-www-form-urlencoded"];
    
    if ([self.strReqMethod isEqualToString:POST_METHOD]) {
        [manager POST:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                if(responseObject==nil)
                    dataBlock(responseObject,nil);
                else
                    dataBlock(responseObject,nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
        }];
    }
    else{
        [manager GET:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                if(responseObject==nil)
                    dataBlock(responseObject,nil);
                else
                    dataBlock(responseObject,nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
        }];
    }
}

-(void)getAddressFromGooglewAutoCompletewithParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    //[raw urlEncodeUsingEncoding:NSUTF8Encoding]
    NSString *url=[[NSString stringWithFormat:@"%@",AutoComplete_URL] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@[@"text/html",@"application/json"], nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"application/x-www-form-urlencoded"];
    
    if ([self.strReqMethod isEqualToString:POST_METHOD]) {
        [manager POST:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                if(responseObject==nil)
                    dataBlock(responseObject,nil);
                else
                    dataBlock(responseObject,nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
        }];
    }
    else{
        [manager GET:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            DLog(@"JSON: %@", responseObject);
            if (dataBlock) {
                if(responseObject==nil)
                    dataBlock(responseObject,nil);
                else
                    dataBlock(responseObject,nil);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            DLog(@"Error: %@", error);
            if (dataBlock) {
                dataBlock(nil,error);
            }
        }];
    }
}

@end
