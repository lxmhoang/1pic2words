//
//  UploadDelegate.h
//  mytcom
//
//  Created by Ngo Xuan Tung on 2/28/11.
//  Copyright 2011 SETA:CINQ Vietnam., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * UploadDelegate provides methods to handle an upload progress's events.
 * 
 * @author TungNX <tungnx6030@setacinq.com.vn>
 */
@protocol UploadDelegate

@optional
- (void)uploadProgress:(float)progress;
- (void)uploadError:(NSError *)error;
- (void)uploadCompeleteWithURLString:(NSString *)URLString;

@end
