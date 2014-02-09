//
//  PlayModel.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Common.h"
#import "ASIHTTPRequest.h"

@interface PlayModel : NSObject <NSURLConnectionDelegate>
{
//    int numcharright;
//    int numcharleft;
//    NSString *leftString;
//    NSString *rightString;
//    NSString *answer;
    sqlite3 *_database;
    NSMutableData *wsData;
 
}

@property (nonatomic, retain) NSString *leftString, *rightString, *answer, *initString, *hintString, *leftSource, *rightSource;
@property (nonatomic) int numcharleft,numcharright, level, coins;
@property (nonatomic, retain) UIImage *leftImage, *rightImage;

- (id)initWithLevel:(int)_level;
- (void)getDataByID:(int)_id;
- (void)getDataFromAPIByID:(int)_id;
//- (void)revealCharInDB:(int)r;
- (void)removeCharInDB:(int)_r;
//- (void)revealCharInDB:(NSString *)_char;

@end
