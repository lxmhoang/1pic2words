//
//  IAPHelper.h
//  1word2pics
//
//  Created by Hoang le on 3/27/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Common.h"



#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"


#define kInAppPurchaseProUpgradeProductId @"com.lxmhoang.1word2pics.products.7500coins"

@protocol IAPHelperDelegate <NSObject>

- (void)completeTransaction;
- (void)dismissVC;
- (void)setListProducts:(NSArray *)listProducts;
- (void)IAPFailed;

@end

@interface IAPHelper : NSObject <SKPaymentTransactionObserver, SKProductsRequestDelegate, SKRequestDelegate>
{
    SKProduct *IAPProduct;
    SKProductsRequest *productsRequest;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSArray *productList;

- (void)loadStore;
- (BOOL)canMakePurchase;
- (void)purchaseItem;

@end
