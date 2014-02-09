//
//  PlayController.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PlayView.h"
#import "PlayModel.h"
#include "FacebookHelper.h"
#import "StoreController.h"
#import "HintView.h"
#import "WinView.h"
#import <iAd/iAd.h>


//#import "AppDelegate.h"

@protocol PlayControllerDelegate <NSObject>

- (void)playBtnPressNextLevel;

@end


//@class AppDelegate;


@interface PlayController : UIViewController <PlayViewDelegate, FacebookHelperDelegate, UploadDelegate, StoreControllerDelegate, HintViewDelegate, UIGestureRecognizerDelegate, FBDialogDelegate, ADBannerViewDelegate>
{
//    PlayView *playView;
//    PlayModel *playModel;
    ADBannerView *_bannerView;
    NSNumber *level;
    FacebookHelper* facebook;
    UIImage *screenShotImage;
}

@property (nonatomic, retain) PlayView *playView;
@property (nonatomic, retain) PlayModel *playModel;
@property (nonatomic, assign) id delegate;

//- (void)charPickedFromView:(NSString *)charPicked;

@end
