//
//  RootView.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootModel.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>


@protocol RootViewDelegate <NSObject>

- (void)startOverBtnTapped;

@end

@interface RootView : UIView <UIAlertViewDelegate>
{
        RootModel *rootModel;
    UILabel *coinLabel;
    UIImageView *coinImageView;
    UIView *coinView;
}

@property (nonatomic, retain) id delegate;

- (id)initWithFrame:(CGRect)_frame andData:(RootModel *)_data;

@end
