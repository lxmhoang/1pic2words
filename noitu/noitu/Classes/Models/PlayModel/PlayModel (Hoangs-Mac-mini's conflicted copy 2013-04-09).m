//
//  PlayModel.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "PlayModel.h"

@implementation PlayModel

@synthesize numcharright, numcharleft, leftString, rightString, answer, initString, level, coins;

- (id)initWithLevel:(int)_level;
{
    coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
    NSLog(@"coins: %d ", coins);
    
    self = [super init];
    if (self)
    {
        if (sqlite3_open([[self getDBPath] UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }else{
            [self getDataByID:_level];
        }
        
    }
    return self;
}

- (void)removeCharInDB:(NSString *)_char
{
    initString = [initString stringByReplacingOccurrencesOfString:[_char lowercaseString] withString:@"*"];
    NSString *query = @"UPDATE resources SET chars = ? WHERE id = ?";
    sqlite3_stmt *statement = nil;
    sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil);
    sqlite3_bind_text(statement, 1, [initString UTF8String], -1, nil);
    sqlite3_bind_int(statement, 2, level);

    if (sqlite3_step(statement))
    {
        NSLog(@"Done");
    }
    sqlite3_finalize(statement);
}

- (void)getDataByID:(int)_id
{
    level = _id;
    NSString *query = @"SELECT leftString, numcharleft, leftImage, rightString, numcharright, rightImage, answer, answerImage, diffLevel, chars FROM resources WHERE id = ? and available = ?";    
    sqlite3_stmt *statement = nil;
    sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil);
    sqlite3_bind_int(statement, 1, _id);
    sqlite3_bind_int(statement, 2, 1);
    if (sqlite3_step(statement))
    {
        leftString = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
        numcharleft = sqlite3_column_int(statement, 1);
        rightString =  [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
        numcharright = sqlite3_column_int(statement, 4);
        answer = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement,6)];
        initString = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement,9)];
        
        //        co loi xay ra
        
    }else{
		//       cau lenh excute thanh cong
    }
    sqlite3_finalize(statement);

}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory ,    NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"noitu.sqlite"];
}

@end