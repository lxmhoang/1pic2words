//
//  PublicDelegate.h
//  mytcom
//
//  Created by Ngo Xuan Tung on 2/28/11.
//  Copyright 2011 SETA:CINQ Vietnam., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * PublicDelegate provides methods to handle a public progress's events.
 * 
 * @author TungNX <tungnx6030@setacinq.com.vn>
 */
@protocol PublicDelegate

@optional
- (void)publicComplete;
- (void)publicError:(NSError *)error;

@end
