//
//  TFLibraryCollectionViewCell.h
//  TFPhotoBrowser
//
//  Created by Melvin on 12/17/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TFCollectionViewType) {
    /**
     *  默认
     */
    TFCollectionViewTypeNone          = 0,
    /**
     *  打开相机
     */
    TFCollectionViewTypeCamera        = 1,
    /**
     *  打开相册
     */
    TFCollectionViewTypeLibrary       = 2,
};

@interface TFLibraryCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) TFCollectionViewType    viewType;
@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;

- (void)setThumbnailImage:(UIImage *)thumbnailImage;
- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage;
@end
