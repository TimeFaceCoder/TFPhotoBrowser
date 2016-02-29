//
//  TFAssetCell.h
//  TFPhotoBrowser
//
//  Created by Melvin on 2/16/16.
//  Copyright © 2016 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface TFAssetCell : UICollectionViewCell

@property (nonatomic, copy  ) NSString      *representedAssetIdentifier;
@property (nonatomic, strong, nullable) PHAsset *asset;
@property (nonatomic) BOOL assetSelected;
@property (nonatomic, strong, readonly) UIImageView *selectedBadgeImageView;

@end

NS_ASSUME_NONNULL_END