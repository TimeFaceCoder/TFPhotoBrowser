//
//  TFLibraryCollectionViewCell.h
//  TFPhotoBrowser
//
//  Created by Melvin on 12/17/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFLibraryCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *representedAssetIdentifier;

- (void)setThumbnailImage:(UIImage *)thumbnailImage;
- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage;
@end
