//
//  HYBTestCell.m
//  ColorBlendedDemo
//
//  Created by huangyibiao on 16/3/4.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBTestCell.h"
#import <Masonry.h>
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>
#import "HYBTestModel.h"
#import "UIImage+HYBCrop.h"

@interface HYBTestCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) CATextLayer *descLayer;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HYBTestModel *model;

@end

@implementation HYBTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.headImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.mas_equalTo(10);
      make.width.mas_equalTo(60);
      make.height.mas_equalTo(60);
    }];
       self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.headImageView.backgroundColor = [UIColor whiteColor];
//    self.headImageView.layer.cornerRadius = 30;
//    self.headImageView.clipsToBounds = YES;
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.preferredMaxLayoutWidth = screenWidth - 70 - 20;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.titleLabel.backgroundColor = self.contentView.backgroundColor;
    
    __weak __typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(10);
      make.top.mas_equalTo(weakSelf.headImageView);
      make.right.mas_equalTo(-10);
    }];
    // desc
    self.descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.descLabel];
    self.descLabel.preferredMaxLayoutWidth = screenWidth - 70 - 20;
    self.descLabel.numberOfLines = 0;
    self.descLabel.font = [UIFont systemFontOfSize:13];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.mas_equalTo(weakSelf.titleLabel);
      make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
    }];
    self.descLabel.backgroundColor = self.contentView.backgroundColor;
    
    self.descLayer = [CATextLayer layer];
    [self.descLabel.layer addSublayer:self.descLayer];
    self.descLayer.alignmentMode = kCAAlignmentLeft;
    self.descLayer.wrapped = YES;
    self.descLayer.backgroundColor = self.descLabel.backgroundColor.CGColor;
    
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef)self.descLabel.font.fontName);
    self.descLayer.font = fontRef;
    self.descLayer.fontSize = self.descLabel.font.pointSize;
    CGFontRelease(fontRef);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake((self.descLabel.preferredMaxLayoutWidth - 10) / 2,
                                 (self.descLabel.preferredMaxLayoutWidth - 10) / 2 + 20);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.scrollEnabled = NO;
    [self.contentView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.mas_equalTo(weakSelf.descLabel);
      make.top.mas_equalTo(weakSelf.descLabel.mas_bottom).offset(20);
    }];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"identifeir"];
    self.hyb_lastViewInCell = self.collectionView;
    self.hyb_bottomOffsetToCell = 10;
  }
  
  return self;
}

- (void)configCellWithModel:(HYBTestModel *)model isCaculateHeight:(BOOL)isCalulatedHeight {
  self.titleLabel.text = model.title;
  self.descLabel.text = model.desc;

  if (isCalulatedHeight) {
    self.descLayer.string = model.desc;
  } else {
    // 尝试使用CATextLayer解决中文混合问题，未好使
    // 不知道怎么用才能解决
    // 后续学习到再更新
    CGSize size = [model.desc sizeWithFont:self.descLabel.font
                         constrainedToSize:CGSizeMake(self.descLabel.preferredMaxLayoutWidth, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByCharWrapping];
    self.descLayer.frame = CGRectMake(0, 0, size.width, size.height);
  }
  
  // 优化前
//  NSString *path = nil;
//  if ([model.headImg hasSuffix:@".png"]) {
//    path = model.headImg;
//  } else {
//    path = [[NSBundle mainBundle] pathForResource:model.headImg ofType:nil];
//  }
//  UIImage *image = [UIImage imageNamed:path];
//  self.headImageView.image = image;

  // 优化后
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString *path = nil;
    if ([model.headImg hasSuffix:@".png"]) {
      path = model.headImg;
    } else {
     path = [[NSBundle mainBundle] pathForResource:model.headImg ofType:nil];
    }
    UIImage *image = [[UIImage imageNamed:path] hyb_cropEqualScaleImageToSize:self.headImageView.frame.size];
    // 添加圆角
//    image = [image hyb_addCornerRadius:self.headImageView.frame.size.width / 2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.headImageView setNeedsDisplay];
      self.headImageView.image = image;
    });
  });
  
  
  self.model = model;
  
  CGFloat height = 0;
  if (model.hasCache) {
    height = model.cacheCollectionViewHeight;
  } else {
    if (model.imgs.count >= 1) {
      NSUInteger rows = model.imgs.count / 2;
      height = (rows * ((self.descLabel.preferredMaxLayoutWidth - 10) / 2 + 20));
    }
  }
  
  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(height);
  }];
  
  self.collectionView.delegate = self;
  self.collectionView.dataSource = self;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  [self.collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifeir"
                                                                         forIndexPath:indexPath];
  UIImageView *imgView = [cell.contentView viewWithTag:100];
  
  if (imgView == nil) {
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.frame = CGRectMake(0,
                               0,
                               cell.contentView.bounds.size.width,
                               cell.contentView.bounds.size.height - 20);
    [cell.contentView addSubview:imgView];
    imgView.tag = 100;
    imgView.backgroundColor = [UIColor whiteColor];
//    imgView.layer.cornerRadius = 10;
//    imgView.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"www.henishuo.com";
    [cell.contentView addSubview:titleLabel];
    titleLabel.tag = 101;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.frame = CGRectMake(0, imgView.frame.size.height, imgView.frame.size.width, 20);
    titleLabel.backgroundColor = cell.contentView.backgroundColor;
  }
  
  
  NSUInteger type = 4;
  if (type == 0) {
    // 光栅化
    imgView.layer.shouldRasterize = YES;
  } else if (type == 1) {
    imgView.layer.shadowColor = [UIColor redColor].CGColor;
    imgView.layer.shadowOffset = CGSizeMake(10, 10);
    imgView.layer.shadowOpacity = 0.8;
  } else if (type == 2) {
    // 测试发现未引起离屏渲染
    imgView.layer.edgeAntialiasingMask = kCALayerTopEdge;
    imgView.layer.allowsEdgeAntialiasing = NO;
  } else if (type == 3) {
    // 透明，发现未引起离屏渲染
    imgView.opaque = NO;
    imgView.layer.allowsGroupOpacity = YES;
  } else if (type == 4) {
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
  }
  
//  NSString *imgName = self.model.imgs[indexPath.row];
  // 优化前
//  NSString *path = nil;
//  if ([imgName hasSuffix:@".png"]) {
//    path = imgName;
//  } else {
//    path = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
//  }
//  UIImage *image = [UIImage imageNamed:path];
//  imgView.image = image;
  
NSString *imgName = self.model.imgs[indexPath.row];
if ([self.model.cacheImages objectForKey:imgName]) {
  imgView.image = [self.model.cacheImages objectForKey:imgName];
} else {
  
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    NSString *path = nil;
    if ([imgName hasSuffix:@".png"]) {
      path = imgName;
    } else {
      path = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
    }

    UIImage *image = [[UIImage imageNamed:path] hyb_cropEqualScaleImageToSize:imgView.frame.size];
    image = [image hyb_addCornerRadius:10];
    dispatch_async(dispatch_get_main_queue(), ^{
      imgView.image = image;
      if (image) {
        [self.model.cacheImages setObject:image forKey:imgName];
      }
    });
  });
}
  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.model.imgs.count;
}

@end