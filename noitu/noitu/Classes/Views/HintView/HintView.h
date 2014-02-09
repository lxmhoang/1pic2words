//
//  HintView.h
//  1word2pics
//
//  Created by Hoang le on 4/5/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "PlayModel.h"
#import "HintCell.h"
#import <QuartzCore/QuartzCore.h>

@protocol HintViewDelegate <NSObject>

- (void)shareFB:(UIGestureRecognizer *)_tap;
- (void)removeALetterFromView;
- (void)revealALetterFromView;
- (void)revealAWordFromView;
- (void)shuffleFromView;
- (void)shareFBFromHint;

@end

@interface HintView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView;
    NSString *hintString;
}

@property (nonatomic, assign) __weak id delegate;




@end
