//
//  YZXPieGraphView.h
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/15.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZXPieGraphView : UIView

/**
 初始化界面
 
 @param frame 坐标及大小
 @param titleArr 标题数组(可不设置)
 @param precentageArr 百分比数组(必须设置)
 @param colorArr 颜色数组(可不设置)
 @return 返回self
 */
- (instancetype)initWithFrame:(CGRect)frame withTitleData:(NSArray *)titleArr withPercentageData:(NSArray *)precentageArr withColors:(NSArray *)colorArr;

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
