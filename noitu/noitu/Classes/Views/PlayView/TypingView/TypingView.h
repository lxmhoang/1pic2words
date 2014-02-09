//
//  TypingView.h
//  noitu
//
//  Created by Hoang le on 3/21/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Common.h"
#import "PlayModel.h"
#import <QuartzCore/QuartzCore.h>

#import "UIDevice+Resolutions.h"

#import "InputButtonView.h"

@protocol TypingViewDelegate <NSObject>



@end

@interface TypingView : UIView 
{
    PlayModel *playModel;
}

@property (nonatomic, assign) id delegate;

- (id)initWithData:(PlayModel *)_data andDelegate:(id)_delegate;

@end
