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

/**
 标签以及标签线颜色(可不设置)
 */
@property (nonatomic, strong) UIColor                    *titleColor;

/**
 是否隐藏标题(可不设置)
 */
@property (nonatomic, assign) BOOL                       hideTitlt;

/**
 是否隐藏注释(可不设置)
 */
@property (nonatomic, assign) BOOL                       hideAnnotation;

/**
 圆的中心点(可不设置)
 */
@property (nonatomic, assign) CGPoint                    circleCenter;

/**
 圆的半径(可不设置)
 */
@property (nonatomic, assign) CGFloat                    circleRadius;

/**
 标题的字体大小(可不设置)
 */
@property (nonatomic, assign) CGFloat                    titleFont;

@end
