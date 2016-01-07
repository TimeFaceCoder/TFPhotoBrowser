//
//  TFiCloudDownloadHelper.m
//  TFPhotoBrowser
//
//  Created by Melvin on 1/5/16.
//  Copyright © 2016 TimeFace. All rights reserved.
//

#import "TFiCloudDownloadHelper.h"

@implementation TFiCloudDownloadHelper

+ (instancetype)sharedHelper {
    static TFiCloudDownloadHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!helper) {
            helper = [[self alloc] init];
        }
    });
    return helper;
}
- (void)cancelImageRequest:(PHImageRequestID)imageRequestID {
    [[PHImageManager defaultManager] cancelImageRequest:imageRequestID];
}

@end
