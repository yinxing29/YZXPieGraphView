//
//  ShowViewController.h
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/15.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewController : UIViewController

/**
 标题
 */
@property (nonatomic, strong) NSArray                    *titleArr;

/**
 百分比
 */
@property (nonatomic, strong) NSArray                    *precentageArr;

/**
 设置的颜色
 */
@property (nonatomic, strong) NSArray <UIColor *>        *colorsArr;

@end
