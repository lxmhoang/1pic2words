//
//  PlayModel.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "HowModel.h"

@implementation HowModel

@synthesize numcharright, numcharleft, leftString, rightString, answer, initString, level, coins, leftImage, rightImage, hintString, leftSource, rightSource;

- (id)initWithLevel:(int)_level;
{
    coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
    NSLog(@"coins: %d ", coins);
    hintString = @"@@@@";
    self = [super init];
    if (self)
    {
//        [self getDataFromAPIByID:_level];
        if (sqlite3_open([[self getDBPath] UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }else{
            [self getDataByID:0];
        }
        
    }
    return self;
}

//- (void)revealCharInDB:(int)r
//{
//    NSString *revealedChar = [initString substringWithRange:NSMakeRange(r, 1)];
//    NSString *newInitString = [NSString stringWithString:[initString stringByReplacingCharactersInRange:NSMakeRange(r, 1) withString:[revealedChar uppercaseString]]];
////    [NSString stringWithString:[initString stringByReplacingOccurrencesOfString:[_char lowercaseString] withString:[_char uppercaseString] options:NSLiteralSearch range:[initString rangeOfString:[_char lowercaseString]]]];
//    initString = [newInitString retain];
//    NSString *query = @"UPDATE resources SET chars = ? WHERE level = ?";
//    sqlite3_stmt *statement = nil;
//    sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil);
//    sqlite3_bind_text(statement, 1, [newInitString UTF8String], -1, nil);
//    sqlite3_bind_int(statement, 2, level);
//    
//    if (sqlite3_step(statement))
//    {
//        NSLog(@"Done");
//    }
//    sqlite3_finalize(statement);
//}

- (void)removeCharInDB:(int)_r
{
    NSString *newInitString = [NSString stringWithString:[initString stringByReplacingCharactersInRange:NSMakeRange(_r,1) withString:@"*"]];
    
//    [NSString stringWithString:[initString stringByReplacingOccurrencesOfString:[_char lowercaseString] withString:@"*" options:NSLiteralSearch range:[initString rangeOfString:[_char lowercaseString]]]];
    initString = [newInitString retain];
    NSString *query = @"UPDATE resources SET chars = ? WHERE level = ?";
    sqlite3_stmt *statement = nil;
    sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil);
    sqlite3_bind_text(statement, 1, [newInitString UTF8String], -1, nil);
    sqlite3_bind_int(statement, 2, level);

    if (sqlite3_step(statement))
    {
        NSLog(@"Done");
    }
    sqlite3_finalize(statement);
}

- (void)getDataFromAPIByID:(int)_id
{
    level = _id;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURLForPlayModel,_id]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSData *responseData = [request responseData];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        NSLog(@"response : %@",dictionary);
//        answer = [(NSString *)[dictionary objectForKey:@"answer"] retain];
//        answer = [NSString stringWithString:[dictionary objectForKey:@"answer"]];
        answer = [[NSString alloc]initWithString:[dictionary objectForKey:@"answer"]];
        NSLog(@"%@",answer);
        leftString = [[NSString alloc]initWithString:[dictionary objectForKey:@"leftString"]];
        rightString = [[NSString alloc]initWithString:[dictionary objectForKey:@"rightString"]];
        initString = [[NSString alloc]initWithString:[dictionary objectForKey:@"chars"]];
        
//        leftString =  [(NSString *)[dictionary objectForKey:@"leftString"] retain];
        numcharleft = [[dictionary objectForKey:@"numcharLeft"] intValue];
//        rightString = [(NSString *)[dictionary objectForKey:@"rightString"] retain];
        numcharright = [[dictionary objectForKey:@"numcharRight"] intValue];
//        initString = [(NSString *)[dictionary objectForKey:@"chars"] retain];
//        answer = @"arrest";
//        leftString = @"arrow";
//        numcharleft = 3;
//        rightString = @"chest";
//        numcharright = 3;
//        initString = @"sabtqplsrre";
//        leftImage = [dictionary objectForKey:@"leftImage"];
//        rightImage = [dictionary objectForKey:@"rightImage"];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
        NSString *url = [NSString stringWithFormat:kURLForLeftImage,[dictionary objectForKey:@"leftImage"]];
        [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"url : %@",url);
        
        ASIHTTPRequest *requestLeftImage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [requestLeftImage startSynchronous];
        leftImage = [UIImage imageWithData:[requestLeftImage responseData]];
        
//        leftImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        url = [NSString stringWithFormat:kURLForLeftImage,[dictionary objectForKey:@"rightImage"]];
        [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        ASIHTTPRequest *requestRightImage = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        [requestRightImage startSynchronous];
        rightImage = [UIImage imageWithData:[requestRightImage responseData]];
        
//        rightImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:kURLForLeftImage,[dictionary objectForKey:@"rightImage"]]]]];
        
    }
    
//    NSURLRequest *req = [NSURLRequest requestWithURL:];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:YES];
}

- (void)getDataByID:(int)_id
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    level = _id;
    NSString *query = @"SELECT leftString, numcharleft, leftImage, rightString, numcharright, rightImage, answer, answerImage, diffLevel, chars, leftSource, rightSource FROM resources WHERE level = ?  ";    
    sqlite3_stmt *statement = nil;
    sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil);
    sqlite3_bind_int(statement, 1, _id);
//    sqlite3_bind_int(statement, 2, 1);
    if (sqlite3_step(statement))
    {
        leftString = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
        numcharleft = sqlite3_column_int(statement, 1);
        rightString =  [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
        numcharright = sqlite3_column_int(statement, 4);
        answer = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement,6)];
        initString = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement,9)];
        NSString *leftImageName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
        NSString *rightImageName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
        NSString *pathLeft = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",leftImageName]];
        NSString *pathRight = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@",rightImageName]];
        
//        NSFileManager *f	ileManager = [NSFileManager defaultManager];
//        BOOL success = [fileManager fileExistsAtPath:pathLeft];
        
        leftImage = [[UIImage alloc] initWithContentsOfFile:pathLeft];
        rightImage = [[UIImage alloc] initWithContentsOfFile:pathRight];
        leftSource = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 10)];
        rightSource = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 11)];
        NSLog(@"Height img : %f",rightImage.size.height);
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