//
//  TFCaptionView.h
//  TFPhotoBrowser
//
//  Created by Melvin on 9/1/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPhotoProtocol.h"

@interface TFCaptionView : UIToolbar
// Init
- (id)initWithPhoto:(id<TFPhoto>)photo;
- (void)setupCaption;
- (CGSize)sizeThatFits:(CGSize)size;
@end
