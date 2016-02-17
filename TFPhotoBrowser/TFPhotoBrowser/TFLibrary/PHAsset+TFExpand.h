//
//  PHAsset+TFExpand.h
//  TFPhotoBrowser
//
//  Created by Melvin on 2/17/16.
//  Copyright © 2016 TimeFace. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (TFExpand)

@property (nonatomic, weak, readonly) UIImage  *thumbnail;
@property (nonatomic, weak, readonly) UIImage  *fullScreenImage;
@property (nonatomic, weak, readonly) UIImage  *fullResolutionImage;
@property (nonatomic, weak, readonly) NSString *fileExtension;
@property (nonatomic, weak, readonly) NSString *md5;

@end
