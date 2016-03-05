//
//  UIImage+HYBCrop.m
//  ColorBlendedDemo
//
//  Created by huangyibiao on 16/3/5.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "UIImage+HYBCrop.h"

@implementation UIImage (HYBCrop)

//// 等比缩放
//- (UIImage *)hyb_cropEqualScaleImageToSize:(CGSize)size {
//    CGFloat scale =  [UIScreen mainScreen].scale;
//  
//  UIGraphicsBeginImageContextWithOptions(size, YES, scale);
//  
//  CGSize aspectFitSize = CGSizeZero;
//  if (self.size.width != 0 && self.size.height != 0) {
//    CGFloat rateWidth = size.width / self.size.width;
//    CGFloat rateHeight = size.height / self.size.height;
//    
//    CGFloat rate = MIN(rateHeight, rateWidth);
//    aspectFitSize = CGSizeMake(self.size.width * rate, self.size.height * rate);
//  }
//  
//  
//  [self drawInRect:CGRectMake(0, 0, aspectFitSize.width, aspectFitSize.height)];
//  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();
//  
//  return image;
//}

// 非等比缩放
- (UIImage *)hyb_cropEqualScaleImageToSize:(CGSize)size {
  CGFloat scale =  [UIScreen mainScreen].scale;
 
  UIGraphicsBeginImageContextWithOptions(size, YES, scale);
  
  [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

@end
