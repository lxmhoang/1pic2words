//
//  ResultView.h
//  noitu
//
//  Created by Hoang Le on 3/25/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "PlayModel.h"
#import <QuartzCore/QuartzCore.h>
#import "InputButtonView.h"
#import "UIDevice+Resolutions.h"

@protocol ResultViewDelegate <NSObject>



@end

@interface ResultView : UIView
{
    PlayModel *playModel;
}

@property (nonatomic, assign) id delegate;

- (id)initWithData:(PlayModel *)_data andDelegate:(id)_delegate;
- (void)setNewChar:(InputButtonView *)_sender atTag:(int)tagOfThatView;
- (void)setFocusWithTag:(int)_focusTag;
//- (void)removeCharWithTag:(int)removedTag;

@end
