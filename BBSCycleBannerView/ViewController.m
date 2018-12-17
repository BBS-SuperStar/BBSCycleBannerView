//
//  ViewController.m
//  BBSCycleBannerView
//
//  Created by 付航 on 2018/12/13.
//  Copyright © 2018年 BBS. All rights reserved.
//

#import "ViewController.h"
#import "BBSCycleBannerView.h"

static const CGFloat CycleBannerViewHeight = 210;
#define UISCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) BBSCycleBannerView *cycleBannerView;

@end

@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCustomSubviews];
}

#pragma mark - ConfigureCustomSubviews

- (void)configureCustomSubviews {
    [self.view addSubview:self.cycleBannerView];
}

#pragma mark - Getters & Setters

- (BBSCycleBannerView *)cycleBannerView {
    if (_cycleBannerView) {
        return _cycleBannerView;
    }
//    NSArray *imageSources = @[[UIImage imageNamed:@"timg.jpeg"],[UIImage imageNamed:@"timg-2.jpeg"],[UIImage imageNamed:@"timg-3.jpeg"],[UIImage imageNamed:@"timg-4.jpeg"]];
    NSArray *imageSources = @[@"http://img0.imgtn.bdimg.com/it/u=2574754745,56165785&fm=26&gp=0.jpg",
                              @"http://img3.imgtn.bdimg.com/it/u=2983077745,3759805380&fm=26&gp=0.jpg",
                              @"http://img1.imgtn.bdimg.com/it/u=2881949786,2793149307&fm=26&gp=0.jpg",
                              @"http://img4.imgtn.bdimg.com/it/u=1492663666,1461041448&fm=26&gp=0.jpg"];
    CGRect frame = CGRectMake(0, 0, UISCREENWIDTH, CycleBannerViewHeight);
    _cycleBannerView = [[BBSCycleBannerView alloc] initWithFrame:frame
                                                    imageSources:imageSources];
    
    _cycleBannerView.autoCyclePlay = YES;
    _cycleBannerView.autoPlayTimeInterval = 2;
    _cycleBannerView.pageIndicatorTintColor = [UIColor yellowColor];
    _cycleBannerView.placeholderImage = [UIImage imageNamed:@"bg"];
    _cycleBannerView.currentPageIndicatorTintColor = [UIColor redColor];
    _cycleBannerView.didTapImageViewCallBack = ^(NSInteger index) {
        NSLog(@"%ld",index);
    };
    return _cycleBannerView;
}

@end
