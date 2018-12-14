//
//  BBSCycleBannerView.m
//  BBSCycleBannerView
//
//  Created by 付航 on 2018/12/13.
//  Copyright © 2018年 BBS. All rights reserved.
//

#import "BBSCycleBannerView.h"


@interface UIImageView (LoadImage)

- (void)updateImageWithData:(id)data;

@end

@implementation UIImageView (LoadImage)

- (void)updateImageWithData:(id)data {
    if ([data isMemberOfClass:[UIImage class]]) {
        self.image = data;
    }
    else if ([data isKindOfClass:[NSString class]]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:data];
            UIImage *image = [UIImage imageWithData:imageData];
            dispatch_async(dispatch_get_main_queue(), ^{
               self.image = image;
            });
        });
    }
}

@end

@interface BBSCycleBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *left;
@property (nonatomic, strong) UIImageView *middle;
@property (nonatomic, strong) UIImageView *right;
@property (nonatomic, copy) NSArray *imageSourceArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation BBSCycleBannerView

#pragma mark - LifeCycle

- (void)dealloc {
    NSLog(@"轮播图释放了");
}

- (instancetype)initWithFrame:(CGRect)frame
         imageSources:(NSArray *)imageSources {
   self = [self initWithFrame:frame];
    if (self) {
        [self updateImageSourceData:imageSources];
        
        // app启动或者app从后台进入前台都会调用这个方法
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        // 添加检测app进入后台的观察者
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

//解决timer和view相互强引用，无法释放问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self stopTimer];
    }
}

#pragma mark - CommonInitialization

- (void)commonInitialization {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.left];
    [self.scrollView addSubview:self.middle];
    [self.scrollView addSubview:self.right];
    [self addSubview:self.pageControl];
}

#pragma mark - Public

- (void)updateImageSourceData:(NSArray *)images {
    self.imageSourceArray = images;
    self.currentIndex = 0;
    self.left.image = self.imageSourceArray.lastObject;
    self.middle.image = self.imageSourceArray[0];
    self.right.image = self.imageSourceArray[1];
    self.pageControl.numberOfPages = self.imageSourceArray.count;
    self.pageControl.currentPage = self.currentIndex;
}

#pragma mark - EventResponse

- (void)didTapImageView:(UITapGestureRecognizer *)singleTap {
    if (self.didTapImageViewCallBack) {
        self.didTapImageViewCallBack(self.currentIndex);
    }
}

- (void)applicationBecomeActive {
    [self startTimer];
}

- (void)applicationEnterBackground {
    [self stopTimer];
}

#pragma mark - Private

- (void)updateItemViewsWithLeftIndex:(NSInteger)leftIndex
                         centerIndex:(NSInteger)centerIndex
                          rightIndex:(NSInteger)rightIndex {
    self.pageControl.currentPage = self.currentIndex;
    [self.left updateImageWithData:self.imageSourceArray[leftIndex]];
    [self.middle updateImageWithData:self.imageSourceArray[centerIndex]];
    [self.right updateImageWithData:self.imageSourceArray[rightIndex]];
    
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0)];
}

- (void)updateItemViewsWithOffset:(CGFloat)offsetX {
    CGFloat scrollViewWidth = CGRectGetWidth(self.scrollView.bounds);
    NSInteger imageViewCount = self.imageSourceArray.count;
    if (offsetX >= scrollViewWidth * 2 - 0.5) {
        ++self.currentIndex;
        
        if (self.currentIndex == imageViewCount - 1) {
            [self updateItemViewsWithLeftIndex:self.currentIndex - 1 centerIndex:self.currentIndex rightIndex:0];
        }
        else if (self.currentIndex == imageViewCount) {
            self.currentIndex = 0;
            [self updateItemViewsWithLeftIndex:imageViewCount - 1 centerIndex:0 rightIndex:1];
        }
        else {
            [self updateItemViewsWithLeftIndex:self.currentIndex - 1 centerIndex:self.currentIndex rightIndex:self.currentIndex + 1];
        }
    }
    
    if (offsetX <= 0.5) {
        --self.currentIndex;
        
        if (0 == self.currentIndex) {
            [self updateItemViewsWithLeftIndex:imageViewCount - 1 centerIndex:0 rightIndex:1];
        }
        else if (self.currentIndex == -1) {
            self.currentIndex = imageViewCount - 1;
            [self updateItemViewsWithLeftIndex:self.currentIndex - 1 centerIndex:self.currentIndex rightIndex:0];
        }
        else {
            [self updateItemViewsWithLeftIndex:self.currentIndex - 1 centerIndex:self.currentIndex rightIndex:self.currentIndex + 1];
        }
    }
}

- (void)startTimer {
    [self stopTimer];
    
    if (self.imageSourceArray.count <= 1) {
        return;
    }
    
    if (self.autoCyclePlay) {
        [self performSelector:@selector(autoPlayMethod)
                   withObject:nil
                   afterDelay:self.autoPlayTimeInterval];
    }
}

- (void)stopTimer {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(autoPlayMethod)
                                               object:nil];
}

- (void)autoPlayMethod {
    NSInteger imageViewCount = self.imageSourceArray.count;
    if (self.scrollView.isDragging || imageViewCount <= 1 || self.scrollView.isTracking || self.scrollView.isDecelerating) {
        return;
    }
    
    [self.scrollView scrollRectToVisible:self.right.frame animated:YES];
    if (self.autoCyclePlay) {
        [self performSelector:@selector(autoPlayMethod)
                   withObject:nil
                   afterDelay:self.autoPlayTimeInterval];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateItemViewsWithOffset:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self startTimer];
}

#pragma mark - Getters

- (UIScrollView *)scrollView {
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [UIScrollView new];
    [_scrollView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width * 3, self.frame.size.height)];
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    return _scrollView;
}

- (UIImageView *)left {
    if (_left) {
        return _left;
    }
    _left = [UIImageView new];
    _left.backgroundColor = [UIColor whiteColor];
    [_left setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
    [_left addGestureRecognizer:singleTap];
    _left.userInteractionEnabled = YES;
    return _left;
}

- (UIImageView *)middle {
    if (_middle) {
        return _middle;
    }
    _middle = [UIImageView new];
    _middle.backgroundColor = [UIColor whiteColor];
    [_middle setFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
    [_middle addGestureRecognizer:singleTap];
    _middle.userInteractionEnabled = YES;
    return _middle;
}

- (UIImageView *)right {
    if (_right) {
        return _right;
    }
    _right = [UIImageView new];
    [_right setFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
    _right.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImageView:)];
    [_right addGestureRecognizer:singleTap];
    _right.userInteractionEnabled = YES;
    return _right;
}

- (NSInteger)autoPlayTimeInterval {
    return _autoPlayTimeInterval > 0 ? _autoPlayTimeInterval : 3;
}

- (UIPageControl *)pageControl {
    if (_pageControl) {
        return _pageControl;
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.scrollView.bounds) - 100) / 2, (CGRectGetHeight(self.scrollView.bounds) - 40), 100, 30)];
    return _pageControl;
}

#pragma mark - Setters

- (void)setAutoCyclePlay:(BOOL)autoCyclePlay {
    _autoCyclePlay = autoCyclePlay;
    if (_autoCyclePlay) {
        [self startTimer];
    }
    else {
        [self stopTimer];
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    _pageControlFrame = pageControlFrame;
    self.pageControl.frame = pageControlFrame;
}

@end
