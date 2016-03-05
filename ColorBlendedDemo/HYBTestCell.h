//
//  HYBTestCell.h
//  ColorBlendedDemo
//
//  Created by huangyibiao on 16/3/4.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYBTestModel;

@interface HYBTestCell : UITableViewCell

- (void)configCellWithModel:(HYBTestModel *)model isCaculateHeight:(BOOL)isCalulatedHeight;

@end
