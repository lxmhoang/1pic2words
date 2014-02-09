//
//  RootViewController.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <StoreKit/StoreKit.h>


#import "RootView.h"
#import "RootModel.h"
#import "PlayController.h"
#import "MBProgressHUD.h"
#import "HowController.h"
#include <AudioToolbox/AudioToolbox.h>

#import "StoreController.h"

@interface RootController : UIViewController<RootViewDelegate, StoreControllerDelegate>
{
    NSArray *_products;
    RootView *rootView;
    RootModel *rootModel;
}
- (void)playBtnPressNextLevel;
- (void)startOverBtnTapped;
@end
