//
//  TFAsset.m
//  TFPhotoBrowser
//
//  Created by Melvin on 12/17/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "TFAsset.h"
#import <CommonCrypto/CommonDigest.h>


@interface TFAsset()

@property (nonatomic, strong) ALAsset        * alAsset;
@property (nonatomic, strong) PHAsset        * phAsset;
@property (nonatomic, assign) NSInteger      dateTimeInteger;// yyyyMMddHH < long max:2147483647
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSString       * fileExtension;
@property (nonatomic, assign) BOOL           isPHAsset;

// Properties (ALAsset or PHAsset)
@property (nonatomic, strong) NSURL          * url;
@property (nonatomic, strong) NSString       * localIdentifier;
@property (nonatomic, strong) NSString       * md5;
@property (nonatomic, strong) CLLocation     * location;
@property (nonatomic, strong) NSDate         * date;
@property (nonatomic, assign) TFAssetType    type;
@property (nonatomic, assign) double         duration;

@property (nonatomic, assign) CGSize         thumbnailSize;
@property (nonatomic, assign) CGSize         aspectRatioThumbnailSize;
@property (nonatomic, assign) CGSize         fullScreenSize;

@end
@implementation TFAsset
#pragma mark -
#pragma mark Privates (Date formatter)
static NSDateFormatter          *_dateFormatter       = nil;
static PHCachingImageManager    *_cachingImageManager = nil;
+ (void)_setupDateFormatter {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [_dateFormatter setDateFormat:@"yyyyMMddHH"];
}
+ (void)_setupImageManager {
    _cachingImageManager = [[PHCachingImageManager alloc] init];
}

#pragma mark -
#pragma mark Basics
- (id)initWithALAsset:(ALAsset *)asset {
    self = super.init;
    if (self) {
        self.alAsset = asset;
        NSDate* date = self.date;
        self.dateTimeInteger = [_dateFormatter stringFromDate:date].integerValue;
        if (self.dateTimeInteger < 1900000000) {
            self.dateTimeInteger += 1900000000;
        }
        self.timeInterval = date.timeIntervalSince1970;
        self.type = TFAssetTypeUnInitiliazed;
        self.isPHAsset = NO;
    }
    return self;
}
- (id)initWithPHAsset:(PHAsset *)asset {
    self = super.init;
    if (self) {
        self.isPHAsset = YES;
        self.phAsset = asset;
        NSDate* date = self.date;
        self.dateTimeInteger = [_dateFormatter stringFromDate:date].integerValue;
        if (self.dateTimeInteger < 1900000000) {
            self.dateTimeInteger += 1900000000;
        }
        self.timeInterval = date.timeIntervalSince1970;
        self.type = TFAssetTypeUnInitiliazed;
    }
    return self;
}

+ (void)initialize {
    [self _setupDateFormatter];
    [self _setupImageManager];
}

- (NSComparisonResult)compare:(TFAsset *)asset {
    if (_timeInterval > asset.timeInterval) {
        return (NSComparisonResult)NSOrderedDescending;
    } if (_timeInterval < asset.timeInterval) {
        return (NSComparisonResult)NSOrderedAscending;
    } else {
        return (NSComparisonResult)NSOrderedSame;
    }
}

- (BOOL)isEqual:(TFAsset *)asset {
    if (asset == self) {
        return YES;
    }
    if (!asset || ![asset isKindOfClass:self.class]) {
        return NO;
    }
    if (self.isPHAsset) {
        return [self.localIdentifier isEqual:asset.localIdentifier];
    }
    else {
        return [self.url isEqual:asset.url];
    }
}

- (NSUInteger)hash {
    if (self.isPHAsset) {
        return [self.localIdentifier hash];
    }
    else {
        return [self.url hash];
    }
}


#pragma mark -
#pragma mark Properties (Status)
- (BOOL)deleted {
    if (self.isPHAsset) {
        return (self.phAsset.localIdentifier == nil);
    }
    else {
        return (self.alAsset.defaultRepresentation == nil);
    }
    return NO;
}

#pragma mark -
#pragma mark Properties (Image)
- (UIImage*)thumbnail {
    if (self.isPHAsset) {
        //阻塞线程
        [_cachingImageManager requestImageForAsset:self.phAsset
                                        targetSize:self.thumbnailSize
                                       contentMode:PHImageContentModeAspectFill
                                           options:nil
                                     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
         {
         }];
    }
    else {
        return [UIImage imageWithCGImage:self.alAsset.thumbnail];
    }
    return nil;
}

- (UIImage*)aspectRatioThumbnail {
    if (self.isPHAsset) {
        
    }
    else {
        return [UIImage imageWithCGImage:self.alAsset.aspectRatioThumbnail];
    }
    return nil;
}

- (UIImage*)fullScreenImage {
    if (self.isPHAsset) {
        
    }
    else {
        ALAssetRepresentation* rep = self.alAsset.defaultRepresentation;
        if (rep) {
            UIImage *image = [UIImage imageWithCGImage:rep.fullScreenImage
                                                 scale:rep.scale
                                           orientation:0];
            return image;
        } else {
            // deleted
            return nil;
        }
    }
    return nil;
}

- (UIImage*)fullResolutionImage {
    if (self.isPHAsset) {
        
    }
    else {
        ALAssetRepresentation* rep = self.alAsset.defaultRepresentation;
        if (rep) {
            UIImage* image = [UIImage imageWithCGImage:rep.fullResolutionImage
                                                 scale:rep.scale
                                           orientation:0];
            return image;
        } else {
            // deleted
            return nil;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark Properties (ALAsset)
- (NSURL*)url {
    if (_url == nil) {
        _url = [self.alAsset valueForProperty:ALAssetPropertyAssetURL];
    }
    return _url;
}

- (NSString *)localIdentifier {
    if (_localIdentifier == nil) {
        _localIdentifier = self.phAsset.localIdentifier;
    }
    return _localIdentifier;
}

- (NSString *)md5 {
    if (_md5 == nil) {
        if (self.isPHAsset) {
            _md5 = [self getMD5StringFromNSString:self.localIdentifier];
        }
        else {
            _md5 = [self getMD5StringFromNSString:[self.url absoluteString]];
        }
    }
    return _md5;
}

- (CLLocation*)location {
    if (_location == nil) {
        if (self.isPHAsset) {
            _location =  self.phAsset.location;
        }
        else {
            _location = [self.alAsset valueForProperty:ALAssetPropertyLocation];
        }
    }
    return _location;
}

- (double)duration {
    if (_duration == 0 && _type == TFAssetTypeVideo) {
        if (self.isPHAsset) {
            _duration =  self.phAsset.duration;
        }
        else {
            NSNumber* number = [self.alAsset valueForProperty:ALAssetPropertyDuration];
            _duration = number.doubleValue;
        }
    }
    return _duration;
}

- (NSDate*)date {
    if (_date == nil) {
        if (self.isPHAsset) {
            _date =  self.phAsset.modificationDate;
        }
        else {
            _date = [self.alAsset valueForProperty:ALAssetPropertyDate];
        }
    }
    return _date;
}

- (CGSize)size {
    if (self.isPHAsset) {
        return CGSizeMake(self.phAsset.pixelWidth, self.phAsset.pixelHeight);
    }
    else {
        return self.alAsset.defaultRepresentation.dimensions;
    }
}

- (TFAssetType)type {
    if (_type == TFAssetTypeUnInitiliazed) {
        if (self.isPHAsset) {
            switch (self.phAsset.mediaType) {
                case PHAssetMediaTypeUnknown: {
                    self.type = TFAssetTypeUnknown;
                    break;
                }
                case PHAssetMediaTypeImage: {
                    self.type = TFAssetTypePhoto;
                    break;
                }
                case PHAssetMediaTypeVideo: {
                    self.type = TFAssetTypeVideo;
                    break;
                }
                case PHAssetMediaTypeAudio: {
                    self.type = TFAssetTypeAudio;
                    break;
                }
                default: {
                    self.type = TFAssetTypeUnknown;
                    break;
                }
            }
        }
        else {
            NSString* typeString = [self.alAsset valueForProperty:ALAssetPropertyType];
            if ([typeString isEqualToString:ALAssetTypePhoto]) {
                self.type = TFAssetTypePhoto;
            } else if ([typeString isEqualToString:ALAssetTypeVideo]) {
                self.type = TFAssetTypeVideo;
            } else if ([typeString isEqualToString:ALAssetTypeUnknown]) {
                self.type = TFAssetTypeUnknown;
            }
        }
    }
    return _type;
}

- (NSString*)fileExtension {
    if (_fileExtension == nil) {
        if (self.isPHAsset) {
            //
            //            _fileExtension = self.phAsset
        }
        else {
            _fileExtension = self.url.pathExtension.uppercaseString;
        }
    }
    return _fileExtension;
}

#pragma mark -
#pragma mark Properties (Attribute)
- (BOOL)isJPEG {
    NSString* fileExtension = self.fileExtension;
    return [fileExtension isEqualToString:@"JPG"] | [fileExtension isEqualToString:@"JPEG"];
}

- (BOOL)isPNG {
    return [self.fileExtension isEqualToString:@"PNG"];
}

- (BOOL)isVideo {
    return self.type == TFAssetTypeVideo;
}

- (BOOL)isPhoto {
    return self.type == TFAssetTypePhoto;
}

- (BOOL)isScreenshot {
    if (self.isPNG) {
        CGSize size = UIScreen.mainScreen.bounds.size;
        size.width *= UIScreen.mainScreen.scale;
        size.height *= UIScreen.mainScreen.scale;
        return CGSizeEqualToSize(size, self.size);
    }
    return NO;
}


- (NSString *)getMD5StringFromNSString:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    NSMutableString *result = [NSMutableString string];
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat: @"%02x", (int)(digest[i])];
    }
    return [result copy];
}

#pragma mark -
#pragma mark APIs
+ (TFAsset*)assetFromAL:(ALAsset*)asset {
    return [[self alloc] initWithALAsset:asset];
}
+ (TFAsset*)assetFromPH:(PHAsset*)asset {
    return [[self alloc] initWithPHAsset:asset];
}

@end
