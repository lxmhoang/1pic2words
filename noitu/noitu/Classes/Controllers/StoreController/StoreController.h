//
//  StoreController.h
//  1word2pics
//
//  Created by Hoang le on 3/27/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreView.h"
#import "StoreModel.h"
#import <StoreKit/StoreKit.h>
#import "IAPHelper.h"
#import "MBProgressHUD.h"

@protocol StoreControllerDelegate <NSObject>

- (void)updateCoininVIew;

@end

@interface StoreController : UIViewController<StoreViewDelegate, UITableViewDataSource, UITableViewDelegate, IAPHelperDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    IAPHelper *iAPHelper;
    StoreView *storeView;
    StoreModel *storeModel;
}

@property (nonatomic, retain) NSArray *listItems;
@property (nonatomic, assign) __weak id delegate;
//- (id)initWithArray:(NSArray *)_array;

@end
