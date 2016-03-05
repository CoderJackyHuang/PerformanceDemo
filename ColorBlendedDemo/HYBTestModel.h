//
//  HYBTestModel.h
//  ColorBlendedDemo
//
//  Created by huangyibiao on 16/3/4.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYBTestModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSArray  *imgs;
@property (nonatomic, copy) NSString *headImg;

// 由于可能没有图片，此时不能通过0判断是否缓存过
@property (nonatomic, assign) CGFloat cacheCollectionViewHeight;
@property (nonatomic, assign) BOOL hasCache;

@end
