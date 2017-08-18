//
//  zoomViewController.m
//  ScrollUpDownView
//
//  Created by 余晔 on 2017/6/15.
//  Copyright © 2017年 余晔. All rights reserved.
//

#import "zoomViewController.h"
#import "UIImageView+WebCache.h"
#import "YYUpDownScrollView.h"
//尺寸
#define zScreenHeight [[UIScreen mainScreen] bounds].size.height

#define zScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface zoomViewController ()<YYUpDownScrollViewDelegate,YYUpDownScrollViewDatasource>
@property (nonatomic,strong)YYUpDownScrollView *zoomScrollView;
@property (nonatomic ,strong) NSArray *imageModels;

@end

@implementation zoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    _imageModels = @[@"http://www.wyzu.cn/uploadfile/2012/0831/20120831120146955.jpg",
                     @"http://pic25.nipic.com/20121126/668573_135245356150_2.jpg",
                     @"http://www.wyzu.cn/uploadfile/2012/0831/20120831120146955.jpg"];
    _zoomScrollView = [[YYUpDownScrollView alloc]initWithFrame:CGRectMake(0, 0, zScreenWidth, zScreenHeight)];
    //    _zoomScrollView.tag = _selctItem;
    _zoomScrollView.backgroundColor = [UIColor blueColor];
    _zoomScrollView.delegate = self;
    _zoomScrollView.pageControl.hidden = YES;
    _zoomScrollView.datasource = self;
    _zoomScrollView.currentPage = 0;
    //    [self.view addSubview:_zoomScrollView];
    [_zoomScrollView show];
}


#pragma mark--ZJZoomScrollView代理
- (NSInteger)zoomScrollView:(YYUpDownScrollView *)zoomScrollView numberOfPagesInSection:(NSInteger)section
{
    return  _imageModels.count;
}

- (UIView *)zoomScrollView:(YYUpDownScrollView *)zoomScrollView pageAtIndex:(NSInteger)index{
    
    
    UIImageView *maxImageView = [[UIImageView alloc] init];
    //ImgsModel *imgModel = page[index];
    NSString *dic = _imageModels[index];
    
    NSURL *url = [NSURL URLWithString:dic];
    
    [maxImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    
    return maxImageView;
    
}

//- (void)didClickPage:(YYUpDownScrollView *)csView atIndex:(NSInteger)index{
//    // NSLog(@"点击--%d",index);
//    [UIView animateWithDuration:0.3 animations:^{
//        csView.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [csView removeFromSuperview];
//        // 结束之后显示底部
//        // [self.tabBarController.tabBar setHidden:NO];
//
//    }];
//
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
