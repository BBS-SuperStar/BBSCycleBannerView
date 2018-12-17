//
//  BBSCycleBannerView.h
//  BBSCycleBannerView
//
//  Created by 付航 on 2018/12/13.
//  Copyright © 2018年 BBS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DidTapImageViewCallBack)(NSInteger index);

@interface BBSCycleBannerView : UIView

@property (nonatomic, copy, readonly) NSArray *imageSourceArray;

//自动循环播放，默认NO
@property (nonatomic, assign) BOOL autoCyclePlay;
@property (nonatomic, assign) NSInteger autoPlayTimeInterval;
@property (nullable, nonatomic, strong) UIImage *placeholderImage;
@property (nullable, nonatomic, copy) DidTapImageViewCallBack didTapImageViewCallBack;

@property (nullable, nonatomic, strong) UIColor *pageIndicatorTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
@property (nullable, nonatomic, strong) UIColor *currentPageIndicatorTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGRect pageControlFrame;

- (instancetype)initWithFrame:(CGRect)frame
         imageSources:(NSArray *)imageSources;
- (void)updateImageSourceData:(NSArray *)images;

@end

NS_ASSUME_NONNULL_END
