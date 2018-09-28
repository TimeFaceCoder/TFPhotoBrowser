//
//  TFPhotoBrowserNewNavigationBarView.m
//  TFPhotoBrowser
//
//  Created by TFAppleWork-Summer on 2017/9/25.
//

#import "TFPhotoBrowserNewNavigationBar.h"

@implementation TFPhotoBrowserNewNavigationBar

#pragma mark - lazy load.

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFit = [super sizeThatFits:size];
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        if (sizeThatFit.height < 64.f) {
            sizeThatFit.height = 64.f;
        }
    }
    return sizeThatFit;
}

- (void)setFrame:(CGRect)frame {
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        frame.size.height = 64;
    }
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([UIApplication sharedApplication].isStatusBarHidden) {
        return;
    }
    
    for (UIView *subview in self.subviews) {
        NSString* subViewClassName = NSStringFromClass([subview class]);
        if ([subViewClassName containsString:@"UIBarBackground"]) {
            subview.frame = self.bounds;
        }else if ([subViewClassName containsString:@"UINavigationBarContentView"]) {
            CGRect subViewFrame = subview.frame;
            if (CGRectGetHeight(subview.frame) < 64) {
                subViewFrame.origin.y = 64 - CGRectGetHeight(subview.frame);
            }else {
                subViewFrame.origin.y = 0;
            }
            subview.frame = subViewFrame;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
