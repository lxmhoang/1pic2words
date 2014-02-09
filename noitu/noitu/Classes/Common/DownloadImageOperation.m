//
//  DownloadImageOperation.m
//  1word2pics
//
//  Created by Hoang le on 4/15/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "DownloadImageOperation.h"

@implementation DownloadImageOperation

- (void)main
{
    NSDictionary *dataDict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"DictionaryKeys"]];
    dataDict = [dataDict objectForKey:@"data"];
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    docDir = [docDir stringByAppendingString:@"/"];
    
    for (NSDictionary *tmpDict in dataDict) {
        
                
        if (([tmpDict objectForKey:@"leftImage"]==nil)||([tmpDict objectForKey:@"rightImage"]==nil))
            continue;
        if (self.isCancelled)
            break;
        
        if ([tmpDict objectForKey:@"left Image"]==nil){
            NSLog(@"asdfasdF");
        }
        
            NSLog(@"left Image %@",[tmpDict objectForKey:@"leftImage"]);
        if (![fileManager fileExistsAtPath:[docDir stringByAppendingString:[tmpDict objectForKey:@"leftImage"]]])
        {
            NSLog(@"left Image %@",[tmpDict objectForKey:@"leftImage"]);
            NSString *testURL = [NSString stringWithFormat:kURLForLeftImage,[tmpDict objectForKey:@"leftImage"]];
            ASIHTTPRequest *requestLeftImage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:testURL]];
            [requestLeftImage startSynchronous];
            UIImage *image = [[UIImage alloc] initWithData:[requestLeftImage responseData]];
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
            [data1 writeToFile:[NSString stringWithFormat:@"%@/%@",docDir,[tmpDict objectForKey:@"leftImage"]] atomically:YES];
        }
                      NSLog(@"right Image %@",[tmpDict objectForKey:@"rightImage"]);
        NSString *rightFile = [docDir stringByAppendingString:[tmpDict objectForKey:@"rightImage"]];
        if (![fileManager fileExistsAtPath:rightFile])
        {
              NSLog(@"right Image %@",[tmpDict objectForKey:@"rightImage"]);
            NSString *testURL = [NSString stringWithFormat:kURLForLeftImage,[tmpDict objectForKey:@"rightImage"]];
            ASIHTTPRequest *requestLeftImage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:testURL]];
            [requestLeftImage startSynchronous];
            UIImage *image = [[UIImage alloc] initWithData:[requestLeftImage responseData]];
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
            [data1 writeToFile:[NSString stringWithFormat:@"%@/%@",docDir,[tmpDict objectForKey:@"rightImage"]] atomically:YES];
        }
        
        
       
    }
}

@end
