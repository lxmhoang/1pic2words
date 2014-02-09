//
//  FacebookHelper.h
//  mytcom
//
//  Created by Ngo Xuan Tung on 2/27/11.
//  Copyright 2011 SETA:CINQ Vietnam., Ltd. All rights reserved.
//

#import "PlayModel.h"
#import <Foundation/Foundation.h>
#import "Facebook.h"
#import "UploadDelegate.h"
#import "PublicDelegate.h"

//#import "AppDelegate.h"

#define kFacebookDidAuthorize	@"kFacebookDidAuthorize"
#define kFacebookDidGetName		@"kFacebookDidGetName"


#define kAPIGraphUserPhotosPost 11
#define kAPIGraphPhotoData      12
#define kDefaultThumbURL @"http://gohanvn.com/combine_Imgs/%@.jpg"
#define kDialogFeedUser 13
#define kAppId @"502282736501998"


@protocol FacebookHelperDelegate <NSObject>

@optional
-(void)finishLoginSuccess;
-(void)finishShareSuccess;

@end

@interface FacebookHelper : NSObject<FBSessionDelegate, FBRequestDelegate, FBDialogDelegate> {
	Facebook *facebook;
	id<UploadDelegate> uploadDelegate;
	id<PublicDelegate> publicDelegate;
	NSString *username;
	NSMutableData *responseData;
	NSMutableString *currentMethod;
    id<FacebookHelperDelegate> delegate;
    int currentAPICall;
}

@property (nonatomic, assign) id<UploadDelegate> uploadDelegate;
@property (nonatomic, assign) id<PublicDelegate> publicDelegate;
@property (nonatomic, retain) NSString *username;

- (id)initWithDelegate:(id)_delegate;
+ (BOOL)isAuthorized;
- (void)authorize;
+ (void)deleteCredential;
- (void)uploadImage:(NSData *)data withTitle:(NSString *)title;
- (void)uploadMovie:(NSData *)data withTitle:(NSString *)title;
- (void)sendStatus:(NSString *)status;
- (void)getUsername;

- (void)postToFaceBook:(PlayModel *)_pm;

@end
