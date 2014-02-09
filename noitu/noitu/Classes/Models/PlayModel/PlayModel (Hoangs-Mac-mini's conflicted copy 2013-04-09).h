//
//  PlayModel.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PlayModel : NSObject
{
//    int numcharright;
//    int numcharleft;
//    NSString *leftString;
//    NSString *rightString;
//    NSString *answer;
    sqlite3 *_database;
 
}

@property (nonatomic, retain) NSString *leftString, *rightString, *answer, *initString;
@property (nonatomic) int numcharleft,numcharright, level, coins;

- (id)initWithLevel:(int)_level;
- (void)getDataByID:(int)_id;
- (void)removeCharInDB:(NSString *)_char;

@end
