//
//  YYUpDownScrollView.h
//  ScrollUpDownView
//
//  Created by 余晔 on 2017/6/15.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYUpDownScrollViewDelegate;
@protocol YYUpDownScrollViewDatasource;

@interface YYUpDownScrollView : UIView

@property (nonatomic,readonly) UIScrollView *scrollView;
@property (nonatomic,readonly) UIPageControl *pageControl;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign,setter = setDataource:) id<YYUpDownScrollViewDatasource> datasource;
@property (nonatomic,assign,setter = setDelegate:) id<YYUpDownScrollViewDelegate> delegate;



- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
- (void)show;
@end


@protocol YYUpDownScrollViewDelegate <NSObject>
@optional
- (void)didClickPage:(YYUpDownScrollView *)csView atIndex:(NSInteger)index;
- (void)ZJZoomScrollView:(YYUpDownScrollView *)mjphoto  WithPhotoIndex:(NSInteger)index;
@end


@protocol YYUpDownScrollViewDatasource <NSObject>

@required
- (NSInteger)zoomScrollView:(YYUpDownScrollView*)zoomScrollView numberOfPagesInSection:(NSInteger)section;
- (UIView *)zoomScrollView:(YYUpDownScrollView*)zoomScrollView pageAtIndex:(NSInteger)index;

@end
