//
//  ViewController.m
//  QQ
//
//  Created by Guangleijia on 2018/1/5.
//  Copyright © 2018年 YaoMi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *nav;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, assign) CGRect originFrame;

@end

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define NAV_HEIGHT 64.0
#define HEADER_HEIGHT SCREEN_WIDTH*0.8
#define IMAGE_ORIGIN_HEIGHT 80.0

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.extendedLayoutIncludesOpaqueBars = YES;

    
    [self baseInit];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

/** 初始化 UI */
- (void)baseInit{
    
    // headerView
    self.headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    self.originFrame = self.headerView.frame;
    self.headerView.image = [UIImage imageNamed:@"header_image"];
    [self.view addSubview:self.headerView];
    
    
    // tableView
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0,
                                               0,
                                               self.view.bounds.size.width,
                                               self.view.bounds.size.height-NAV_HEIGHT)
                      style:UITableViewStylePlain];
//    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT, 0, 0, 0);
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
//
    // nav
    [self qq_navigationBar];
    [self.view addSubview:self.nav];
}



/** 设置导航 */
- (void)qq_navigationBar{
    self.nav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_HEIGHT)];
    self.nav.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    CGFloat iconHeight = 24.0;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"tabbar_account_highlighted"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(20.0, (NAV_HEIGHT-iconHeight)*0.6, iconHeight, iconHeight);
    [self.nav addSubview:leftButton];


    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"tabbar_invest_highlighted"] forState:UIControlStateNormal];

    rightButton.frame = CGRectMake(SCREEN_WIDTH-iconHeight-20.0, (NAV_HEIGHT-iconHeight)*0.6, iconHeight, iconHeight);
    [self.nav addSubview:rightButton];
}

/** 监听滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat yOffset = self.tableView.contentOffset.y;
    if (yOffset < HEADER_HEIGHT) {
        self.nav.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:yOffset/HEADER_HEIGHT];
    }else{
        self.nav.backgroundColor = [UIColor whiteColor];
    }


    // 向上移动
    if(yOffset >= 0){
        self.headerView.frame = ({
            CGRect frame = _originFrame;
            frame.origin.y = _originFrame.origin.y - yOffset;
            frame;
        });
    }else{ // 放大效果 yOffset<0
        self.headerView.frame = ({
            CGRect frame = _originFrame;
            frame.origin.x = -((HEADER_HEIGHT - yOffset)/0.8 - _originFrame.size.width)*0.5;
            frame.size = CGSizeMake( (HEADER_HEIGHT - yOffset)/0.8, HEADER_HEIGHT - yOffset);
            frame;
        });
    
    }

    NSLog(@"headerHeight = %f\n %@", HEADER_HEIGHT,NSStringFromCGPoint(self.tableView.contentOffset));
}


#pragma mark - delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = @"cellText:";
    cell.contentView.backgroundColor = [UIColor lightTextColor];
    return cell;
}

@end
