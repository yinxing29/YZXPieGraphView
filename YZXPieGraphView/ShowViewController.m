//
//  ShowViewController.m
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/15.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ShowViewController.h"
#import "YZXPieGraphView.h"

@interface ShowViewController ()

@property (nonatomic, strong) YZXPieGraphView                    *pieGraphView;

@end

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扇形图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.piegraphView];
}

- (YZXPieGraphView *)piegraphView
{
    if (!_pieGraphView) {
        _pieGraphView = [[YZXPieGraphView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) withTitleData:self.titleArr
                                         withPercentageData:self.precentageArr
                                                 withColors:self.colorsArr];
        _pieGraphView.center = self.view.center;
        _pieGraphView.backgroundColor = [UIColor greenColor];
        //        _piegraphView.titleFont = 15.0;
        //        _piegraphView.circleRadius = 30.0;
        //        _piegraphView.titleColor = [UIColor blackColor];
        //        _piegraphView.hideTitlt = YES;
        //        _piegraphView.hideAnnotation = YES;
        //        _piegraphView.circleCenter = CGPointMake(CGRectGetMidX(_piegraphView.bounds) + 50, CGRectGetMidY(_piegraphView.bounds));
    }
    return _pieGraphView;
}

@end
