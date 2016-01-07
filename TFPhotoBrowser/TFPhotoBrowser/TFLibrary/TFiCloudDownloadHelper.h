//
//  TFiCloudDownloadHelper.h
//  TFPhotoBrowser
//
//  Created by Melvin on 1/5/16.
//  Copyright © 2016 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface TFiCloudDownloadHelper : NSObject

+ (instancetype)sharedHelper;

- (void)cancelImageRequest:(PHImageRequestID)imageRequestID;
@end
