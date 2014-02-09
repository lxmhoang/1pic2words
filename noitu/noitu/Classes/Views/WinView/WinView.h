//
//  WinView.h
//  1word2pics
//
//  Created by Hoang le on 5/2/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "InputButtonView.h"
#import "Common.h"

@interface WinView : UIView

@property (nonatomic, retain) UIView *v1;

- (id)initWithFrame:(CGRect)frame andWord:(NSString *)_word;

@end
