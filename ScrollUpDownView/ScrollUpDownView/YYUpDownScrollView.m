//
//  YYUpDownScrollView.m
//  ScrollUpDownView
//
//  Created by 余晔 on 2017/6/15.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "YYUpDownScrollView.h"

#define kPadding 10

@interface YYUpDownScrollView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    NSInteger _totalPages;
    NSInteger _curPage;
    
    NSMutableArray *_curViews;
}

@end

@implementation YYUpDownScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect frame = self.bounds;
        frame.origin.x -= kPadding;
        frame.size.width += (2 * kPadding);
        
        
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        //        _scrollView.backgroundColor = [UIColor redColor];
        _scrollView.delegate = self;
        //        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        //        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentSize = CGSizeMake(frame.size.width * 3, 0);
        self.scrollView.contentOffset = CGPointMake(0 * frame.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.bounces = YES;
        _scrollView.bouncesZoom = YES;
        
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        // rect.origin.y = rect.size.height - 30;
        rect.origin.y = rect.size.height - 100;//yn coding 改过这一行代码
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        
        [self addSubview:_pageControl];
        
        _curPage = 0;
        
    }
    return self;
}

- (void)show
{
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar;  //iOS9之后可以设置window优先级来隐藏状态栏
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        //            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade]; //iOS9之后方法用 [contentViewController prefersStatusBarHidden] 这个方法会有警告。
    }];
}

- (void)setDataource:(id<YYUpDownScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource zoomScrollView:self numberOfPagesInSection:0];
    if (_totalPages == 0) {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _curPage = currentPage;
    [self loadData];
}
- (void)loadData
{
    
    _pageControl.currentPage = _curPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        [self createScrollerView:i];
        
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page {
    
    NSInteger pre = [self validPageValue:_curPage-1];
    NSInteger last = [self validPageValue:_curPage+1];
    
    if (!_curViews) {
        _curViews = [[NSMutableArray alloc] init];
    }
    
    [_curViews removeAllObjects];
    
    [_curViews addObject:[_datasource zoomScrollView:self pageAtIndex:pre]];
    [_curViews addObject:[_datasource zoomScrollView:self pageAtIndex:page]];
    [_curViews addObject:[_datasource zoomScrollView:self pageAtIndex:last]];
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
    
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [_delegate didClickPage:self atIndex:_curPage];
    }
    
}

- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [_curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            [self createScrollerView:i];
            //            UIImageView *v = [_curViews objectAtIndex:i];
            //            v.userInteractionEnabled = YES;
            //            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
            //                                                                                        action:@selector(singleTap:)];
            //            [v addGestureRecognizer:singleTap];
            //            [singleTap release];
            //            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            //            [_scrollView addSubview:v];
        }
    }
}

- (void)createScrollerView:(int)i
{
    
    UIScrollView *scaleView = [[UIScrollView alloc] init];
    //        scaleView.backgroundColor = [UIColor orangeColor];
    scaleView.tag = i + 101;
    scaleView.delegate = self;
    scaleView.bouncesZoom = YES;
    scaleView.bounces = NO;
    scaleView.showsVerticalScrollIndicator = YES;
    scaleView.showsHorizontalScrollIndicator = YES;
    scaleView.minimumZoomScale = 0.5;
    scaleView.maximumZoomScale = 3.0;
    scaleView.zoomScale = 1.0;
    
    
    CGRect zoomFrame = self.bounds;
    zoomFrame.origin.x -= kPadding;
    zoomFrame.size.width += (2 * kPadding);
    zoomFrame.origin.x = zoomFrame.size.width*i + kPadding;
    zoomFrame.origin.y = 0;
    scaleView.frame = zoomFrame;
    scaleView.contentSize = CGSizeMake(zoomFrame.size.width, self.frame.size.height);
    [_scrollView addSubview:scaleView];
    
    UIImageView  *v = [_curViews objectAtIndex:i];
    CGSize sizef = [[UIScreen mainScreen] bounds].size;
    v.bounds = CGRectMake(0, 0, sizef.width, sizef.height);
    v.center = self.center;
    v.tag = i + 201;
    v.contentMode = UIViewContentModeScaleAspectFit;
    v.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(singleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [v addGestureRecognizer:singleTap];
    //        [singleTap release];
    //        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
    [scaleView addSubview:v];
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    if (aScrollView == _scrollView) {
        int x = aScrollView.contentOffset.x;
        NSInteger interphoto = _curPage;
        
        CGRect frame = self.bounds;
        frame.origin.x -= kPadding;
        frame.size.width += (2 * kPadding);
        
        //往下翻一张
        if(x >= (2*frame.size.width)) {
            _curPage = [self validPageValue:_curPage+1];
            [self loadData];
        }
        
        //往上翻
        if(x <= 0) {
            _curPage = [self validPageValue:_curPage-1];
            [self loadData];
        }
        if(interphoto != _curPage && self.delegate && [self.delegate respondsToSelector:@selector(ZJZoomScrollView:WithPhotoIndex:)])
        {
            [self.delegate ZJZoomScrollView:self WithPhotoIndex:_curPage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    if (aScrollView == _scrollView) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
        
    }
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    NSLog(@"缩放比例:%f",scale);
}

//用户使用捏合手势时调用
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView) {
        UIImageView *imgeView = (UIImageView *)[scrollView viewWithTag:(scrollView.tag + 100)];
        if (imgeView.subviews.count <= 1 && imgeView.image) return imgeView;
    }
    return nil;
}
//缩放中
#define MAX(A,B) __NSMAX_IMPL__(A,B,__COUNTER__)
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView != _scrollView)
    {
        UIImageView *imgeView = (UIImageView *)[scrollView viewWithTag:(scrollView.tag + 100)];
        if (!imgeView.image)return;
        
        if (scrollView.zoomScale<1.0) {
            CGRect imageGalleryFrame;
            imageGalleryFrame = [[UIScreen mainScreen] bounds];
            CGFloat xcenter = imageGalleryFrame.size.width * 0.5, ycenter = imageGalleryFrame.size.height * 0.5;
            imgeView.center = CGPointMake(xcenter, ycenter);
        }
        else if(scrollView.zoomScale>=1.0)
        {
            CGFloat xcenter = scrollView.contentSize.width * 0.5, ycenter = scrollView.contentSize.height * 0.5;
            imgeView.center = CGPointMake(xcenter, ycenter);
        }
        
        
        NSString *str = NSStringFromCGPoint(imgeView.center);
        NSLog(@"imgCenter:%@",str);
    }
    
}



@end
