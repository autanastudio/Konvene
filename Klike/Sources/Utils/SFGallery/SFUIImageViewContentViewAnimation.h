//
//  SFUIImageViewContentViewAnimation.h
//  SFGallery
//
//  Created by Yarik Smirnov on 4/24/15.
//  Copyright (c) 2015 SFCD, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFUIImageViewContentViewAnimation : UIImageView

- (UIImage*)sf_image;
- (void)animateToViewMode:(UIViewContentMode)contenMode
                forFrame:(CGRect)frame
            withDuration:(float)duration
              afterDelay:(float)delay
                finished:(void (^)(BOOL finished))finishedBlock;
@end