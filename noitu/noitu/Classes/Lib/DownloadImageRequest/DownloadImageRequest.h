//
//  DownloadImageRequest.h
//  Task4_Flickr
//
//  Created by Hoang Le on 12/18/12.
//  Copyright (c) 2012 Hoang Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@interface DownloadImageRequest :ASIHTTPRequest

@property (nonatomic) int index;

- (id)initWithURL:(NSURL *)newURL indexOfRequest:(int)_index;

//+ (id)requestWithURL:(NSURL *)newURL indexOfRequest:(NSIndexPath *)_index;


@end
