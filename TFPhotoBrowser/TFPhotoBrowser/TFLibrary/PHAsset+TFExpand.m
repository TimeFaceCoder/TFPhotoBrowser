//
//  PHAsset+TFExpand.m
//  TFPhotoBrowser
//
//  Created by Melvin on 2/17/16.
//  Copyright © 2016 TimeFace. All rights reserved.
//

#import "PHAsset+TFExpand.h"


@implementation PHAsset (TFExpand)

#pragma mark -
#pragma mark Privates (Date formatter)
static PHCachingImageManager    *_cachingImageManager = nil;
static PHImageRequestOptions    *_imageRequestOptions = nil;

+ (void)_setupImageManager {
    _cachingImageManager = [[PHCachingImageManager alloc] init];
}

+ (void)_setupImageRequestOptions {
    _imageRequestOptions = [[PHImageRequestOptions alloc] init];
    _imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    _imageRequestOptions.synchronous = YES;
    _imageRequestOptions.networkAccessAllowed = YES;
}


+ (void)initialize {
    [super initialize];
    [self _setupImageManager];
    [self _setupImageRequestOptions];
}


#pragma mark -
#pragma mark Properties (Image)
- (UIImage*)thumbnail {
    __block UIImage *image = nil;
    [_cachingImageManager requestImageForAsset:self
                                    targetSize:CGSizeMake(240, 240)
                                   contentMode:PHImageContentModeAspectFill
                                       options:_imageRequestOptions
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                     image = result;
                                 }];
    
    return image;
}

- (UIImage*)fullScreenImage {
    __block UIImage *image = nil;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize fullScreenSize = CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) *scale, CGRectGetHeight([[UIScreen mainScreen] bounds]) *scale);
    [_cachingImageManager requestImageForAsset:self
                                    targetSize:fullScreenSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:_imageRequestOptions
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                     image = result;
                                 }];
    
    return image;
}

- (UIImage*)fullResolutionImage {
    __block UIImage *image = nil;
    [_cachingImageManager requestImageForAsset:self
                                    targetSize:PHImageManagerMaximumSize
                                   contentMode:PHImageContentModeDefault
                                       options:_imageRequestOptions
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                     image = result;
                                 }];
    
    return image;
}

- (NSString*)fileExtension {
    NSString *fileExtension = @"jpg";
    NSString *filename = [self valueForKey:@"filename"];
    if (filename.length) {
        fileExtension = [filename pathExtension];
    }
    return [fileExtension lowercaseString];
}

- (NSString *)md5 {
    NSString *md5 = nil;
    
    return md5;
}

@end
