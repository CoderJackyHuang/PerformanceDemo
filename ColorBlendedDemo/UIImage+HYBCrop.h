//
//  UIImage+HYBCrop.h
//  ColorBlendedDemo
//
//  Created by huangyibiao on 16/3/5.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HYBCrop)

- (UIImage *)hyb_cropEqualScaleImageToSize:(CGSize)size;

- (UIImage *)hyb_addCornerRadius:(CGFloat)cornerRadius;

@end
