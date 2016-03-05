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

@interface HYBTestCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HYBTestModel *model;

@end

@implementation HYBTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.mas_equalTo(10);
      make.width.height.mas_equalTo(60);
    }];
    
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

- (void)configCellWithModel:(HYBTestModel *)model {
  self.titleLabel.text = model.title;
  self.descLabel.text = model.desc;
  NSString *path = [[NSBundle mainBundle] pathForResource:model.headImg ofType:@"jpg"];
  self.headImageView.image = [UIImage imageNamed:path];
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
    imgView.frame = CGRectMake(0,
                               0,
                               cell.contentView.bounds.size.width,
                               cell.contentView.bounds.size.height - 20);
    [cell.contentView addSubview:imgView];
    imgView.tag = 100;
    imgView.layer.shadowPath = nil;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"www.henishuo.com";
    [cell.contentView addSubview:titleLabel];
    titleLabel.tag = 101;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.frame = CGRectMake(0, imgView.frame.size.height, imgView.frame.size.width, 20);
    titleLabel.backgroundColor = cell.contentView.backgroundColor;
  }
  
  NSString *imgName = self.model.imgs[indexPath.row];
  NSString *path = [[NSBundle mainBundle] pathForResource:imgName ofType:@"jpg"];
  imgView.image = [UIImage imageNamed:path];
  
  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.model.imgs.count;
}

@end