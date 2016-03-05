//
//  ViewController.m
//  ColorBlendedDemo
//
//  Created by huangyibiao on 16/3/4.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//
#import "ViewController.h"
#import "HYBTestCell.h"
#import <UITableViewCell+HYBMasonryAutoCellHeight.h>
#import "HYBTestModel.h"

static NSString *kCellIdentifier = @"identifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView = [[UITableView alloc] init];
  self.tableView.frame = self.view.bounds;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass:[HYBTestCell class] forCellReuseIdentifier:kCellIdentifier];
  [self.view addSubview:self.tableView];
  
  for (NSUInteger i = 0; i < 20; ++i) {
    HYBTestModel *model = [[HYBTestModel alloc] init];
    model.uid = [NSString stringWithFormat:@"modelid%ld", i + 1];
    model.title = i % 2 ? @"标哥的技术博客出品" : @"www.henishuo.com";
    model.desc = @"本demo是研究ColorBlended的，也就是图形混合。研究图形混合问题如何解决又如何避免。欢迎大家关注标哥的技术博客http://www.henishuo.com，关注微博：http://weibo.com/huangyibiao520";
    
    model.headImg = @"img13.jpg";

    NSUInteger rand = arc4random() % 16;
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    for (NSUInteger j = 1; j <= rand; ++j) {
      [imgs addObject:[NSString stringWithFormat:@"img%ld.%@", j, j <= 13 ? @"jpg" : @"png"]];
    }
    model.imgs = imgs;
    
    [self.datasource addObject:model];
  }
  [self.tableView reloadData];
}

- (NSMutableArray *)datasource {
  if (_datasource == nil) {
    _datasource = [[NSMutableArray alloc] init];
  }
  
  return _datasource;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HYBTestCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  
  if (!cell) {
    cell = [[HYBTestCell alloc] initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:kCellIdentifier];
    cell.contentView.backgroundColor = [UIColor whiteColor];
  }
  
  HYBTestModel *model = [self.datasource objectAtIndex:indexPath.row];
  [cell configCellWithModel:model isCaculateHeight:NO];
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  HYBTestModel *model = [self.datasource objectAtIndex:indexPath.row];
  
  return [HYBTestCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
    HYBTestCell *cell = (HYBTestCell *)sourceCell;
    [cell configCellWithModel:model isCaculateHeight:YES];
  } cache:^NSDictionary *{
    return @{kHYBCacheUniqueKey : model.uid,
             kHYBCacheStateKey : @"",
             kHYBRecalculateForStateKey : @(NO)
             };
  }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.datasource.count;
}

@end