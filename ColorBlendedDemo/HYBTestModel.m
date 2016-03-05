//
//  HYBTestModel.m
//  ColorBlendedDemo
//
//  Created by huangyibiao on 16/3/4.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBTestModel.h"

@implementation HYBTestModel

- (NSMutableDictionary *)cacheImages {
  if (_cacheImages == nil) {
    _cacheImages = [[NSMutableDictionary alloc] init];
  }
  
  return _cacheImages;
}

@end
