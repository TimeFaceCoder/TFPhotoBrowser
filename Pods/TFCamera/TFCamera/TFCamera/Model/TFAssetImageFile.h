//
//  TFAssetImageFile.h
//  TFCamera
//
//  Created by Melvin on 7/16/15.
//  Copyright © 2015 Melvin. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface TFAssetImageFile : NSObject

@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *desc;
@property (nonatomic ,strong) UIImage  *image;
@property (nonatomic ,strong) NSString *path;

- (instancetype)initWithPath:(NSString *)path image:(UIImage *)image;


@end
