//
//  PlayController.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HowView.h"
#import "PlayModel.h"
#import "StoreController.h"
#import "HintView.h"

#import "WinView.h"
//#include "FacebookHelper.h"

//#import "AppDelegate.h"

@protocol HowControllerDelegate <NSObject>



@end


//@class AppDelegate;


@interface HowController : UIViewController <   StoreControllerDelegate, HintViewDelegate, UIGestureRecognizerDelegate>
{
//    PlayView *playView;
//    PlayModel *playModel;
    NSNumber *level;
//    FacebookHelper* facebook;
    UIImage *screenShotImage;
}

@property (nonatomic, retain) HowView *playView;
@property (nonatomic, retain) PlayModel *playModel;
@property (nonatomic, assign) id delegate;

//- (void)charPickedFromView:(NSString *)charPicked;

@end
