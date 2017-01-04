//
//  YZXPieGraphView.m
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/15.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "YZXPieGraphView.h"

#define WindowWidth [UIScreen mainScreen].bounds.size.width
#define WindowHeight [UIScreen mainScreen].bounds.size.height
#define self_width self.bounds.size.width
#define self_height self.bounds.size.height
#define self_center_x self_width / 2.0
#define self_center_y self_height / 2.0

@interface YZXPieGraphView ()

/**
 记录标题
 */
@property (nonatomic, strong) NSArray                    *titleArr;

/**
 记录百分比
 */
@property (nonatomic, strong) NSArray                    *precentageArr;

/**
 记录设置的颜色
 */
@property (nonatomic, strong) NSArray <UIColor *>        *colorsArr;

/**
 展示扇形图的view
 */
@property (nonatomic, strong) UIView                    *backgroundView;

/**
 展示扇形图的layer
 */
@property (nonatomic, strong) CAShapeLayer               *backgroundLayer;

/**
 半径
 */
@property (nonatomic, assign) CGFloat                    radius;

@end

@implementation YZXPieGraphView

- (instancetype)initWithFrame:(CGRect)frame withTitleData:(NSArray *)titleArr withPercentageData:(NSArray *)precentageArr withColors:(NSArray *)colorArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //判断是否有标题
        if (titleArr) {
            self.titleArr = titleArr;
        }
        
        self.precentageArr = precentageArr;
        
        //判断是否传入颜色
        if (colorArr) {
            self.colorsArr = colorArr;
        }else {
            NSMutableArray *color = [NSMutableArray array];
            //没有传入颜色的时候添加随机颜色
            for (int i = 0; i<self.precentageArr.count; i++) {
                //添加随机颜色
                [color addObject:[UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1]];
            }
            self.colorsArr = color;
        }
        
        //设置默认半径
        if (MIN(self_width, self_height) >= 160) {
            self.radius = 60.0;
        }else {
            self.radius = (MIN(self_width, self_height) - 40) / 2.0;
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (self.precentageArr.count == 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请传入比例!" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertC animated:YES completion:nil];
    }else if (self.titleArr.count != 0 && self.precentageArr.count != self.titleArr.count) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"初始化时传入的数组元素数量不一致!" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertC animated:YES completion:nil];
    }else {
        if (self.colorsArr.count < self.titleArr.count) {
            NSMutableArray *colors = [NSMutableArray array];
            [colors addObjectsFromArray:self.colorsArr];
            for (int i = 0; i<self.titleArr.count; i++) {
                [colors addObject:[UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1]];
                if (colors.count == self.titleArr.count) {
                    self.colorsArr = colors;
                    break;
                }
            }
        }
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        __block CGFloat startAngle;
        __block CGFloat endAngle;
        __weak typeof(self) weak_self = self;
        __block CGFloat circle_x = self.circleCenter.x != 0?self.circleCenter.x:self_center_x;
        __block CGFloat circle_y = self.circleCenter.y != 0?self.circleCenter.y:self_center_y;
        //承载注释的scrollView
        __block UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, (circle_x - self.radius) / 3.0 * 2, self_height)];
        if (!self.hideAnnotation) {
            [self addSubview:scrollView];
        }
        
        [self.precentageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat addAngle = (2 * M_PI) * ([weak_self.precentageArr[idx] floatValue] / 100.0);
            //设置每部分起始点（如果不是第一个就为上部分结束时的角度）
            startAngle = idx == 0?-M_PI:endAngle;
            //每部分终点等于起点+比例角度
            endAngle = startAngle + addAngle;
            CGContextSetFillColorWithColor(context, weak_self.colorsArr[idx].CGColor);
            CGContextMoveToPoint(context, circle_x, circle_y);
            CGContextAddArc(context, circle_x, circle_y, weak_self.radius, startAngle, endAngle, 0);
            CGContextClosePath(context);
            CGContextDrawPath(context, kCGPathFill);
            
            //画标签
            if (weak_self.titleArr.count != 0) {
                //设置标签以及标签线颜色
                UIColor *titleColor;
                titleColor = weak_self.titleColor?weak_self.titleColor:weak_self.colorsArr[idx];
                //标签线的角度
                CGFloat angle = (endAngle + startAngle) / 2.0;
                
                //计算title大小
                //适配title的字体大小
                CGFloat fontSize;
                if (weak_self.radius >= 60.0) {
                    fontSize = 10.0;
                }else if (weak_self.radius <= 50.0 && weak_self.radius > 30.0) {
                    fontSize = 8.0;
                }else if (weak_self.radius <= 30.0 && weak_self.radius > 10.0) {
                    fontSize = 6.0;
                }else {
                    fontSize = 4.0;
                }
                
                //title
                NSString *title = [NSString stringWithFormat:@"%@/%@%%",weak_self.titleArr[idx],weak_self.precentageArr[idx]];
                //设置title字体大小
                UIFont *font = [UIFont systemFontOfSize:weak_self.titleFont != 0?weak_self.titleFont:fontSize];
                NSDictionary *arrts = @{NSFontAttributeName:font};
                CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self_width, self_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:arrts context:nil].size;
                
                if (!weak_self.hideTitlt) {
                    //获取某部分中间的一点(起始点)
                    CGFloat start_x = (weak_self.radius - 5.0) * cos(angle) + circle_x;
                    CGFloat start_y = (weak_self.radius - 5.0) * sin(angle) + circle_y;
                    
                    CGFloat lineLength = weak_self.radius / 3.0;
                    if (weak_self.precentageArr.count >= 10) {
                        lineLength = idx % 2 == 0?weak_self.radius / 3.0:weak_self.radius / 3.0 + 5;
                    }
                    
                    //获取圆形外部一点(结束点)
                    CGFloat end_x = (weak_self.radius + lineLength) * cos(angle) + circle_x;
                    CGFloat end_y = (weak_self.radius + lineLength) * sin(angle) + circle_y;
                    //画线
                    CGContextSetStrokeColorWithColor(context, titleColor.CGColor);
                    CGContextMoveToPoint(context, start_x, start_y);
                    CGContextAddLineToPoint(context, end_x, end_y);
                    CGContextSetLineWidth(context, 1);
                    CGContextDrawPath(context, kCGPathStroke);
                    
                    //添加标题（左右为竖向显示，上下为横向显示）
                    if (angle < M_PI_2 && angle > -M_PI_2) {//右
                        [title drawInRect:CGRectMake(end_x, end_y - titleSize.height / 2.0, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:titleColor}];
                    }else if (angle >= M_PI_2 && angle <= M_PI * 3.0 / 2.0) {//下
                        [title drawInRect:CGRectMake(end_x - titleSize.width / 2.0, end_y, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:titleColor}];
                    }else if (angle > M_PI * 3.0 / 2.0 && angle < -M_PI_2) {//左
                        [title drawInRect:CGRectMake(end_x - titleSize.width, end_y - titleSize.height / 2.0, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:titleColor}];
                    }else if (angle >= -M_PI * 3.0 / 2.0 && angle <= -M_PI_2) {//上
                        [title drawInRect:CGRectMake(end_x - titleSize.width / 2.0, end_y - titleSize.height, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:titleColor}];
                    }
                }
                
                if (!weak_self.hideAnnotation) {
                    //添加注释
                    scrollView.contentSize = CGSizeMake(0, (titleSize.height + 5) * weak_self.precentageArr.count + 5);
                    
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5 + (idx * (5 + titleSize.height)), titleSize.height, titleSize.height)];
                    view.backgroundColor = weak_self.colorsArr[idx];
                    [scrollView addSubview:view];
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10 + titleSize.height, 5 + (idx * (5 + titleSize.height)), titleSize.width, titleSize.height)];
                    label.font = font;
                    label.textColor = titleColor;
                    label.text = title;
                    [scrollView addSubview:label];
                }
            }
        }];
    }
    
    //裁剪超出视图部分
    self.layer.masksToBounds = YES;
}

#pragma mark - setter
- (void)setTitleColor:(UIColor *)titleColor
{
    if (_titleColor != titleColor) {
        _titleColor = titleColor;
    }
}

- (void)setHideTitlt:(BOOL)hideTitlt
{
    if (_hideTitlt != hideTitlt) {
        _hideTitlt = hideTitlt;
    }
}

- (void)setHideAnnotation:(BOOL)hideAnnotation
{
    if (_hideAnnotation != hideAnnotation) {
        _hideAnnotation = hideAnnotation;
    }
}

- (void)setCircleCenter:(CGPoint)circleCenter
{
    if (_circleCenter.x != circleCenter.x) {
        _circleCenter = circleCenter;
    }
}

- (void)setTitleFont:(CGFloat)titleFont
{
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
    }
}

- (void)setCircleRadius:(CGFloat)circleRadius
{
    if (_circleRadius != circleRadius) {
        _circleRadius = circleRadius;
    }
    self.radius = _circleRadius;
}

#pragma mark - 初始化
- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [[NSArray alloc] init];
    }
    return _titleArr;
}

- (NSArray *)precentageArr
{
    if (!_precentageArr) {
        _precentageArr = [[NSArray alloc] init];
    }
    return _precentageArr;
}

- (NSArray *)colorsArr
{
    if (!_colorsArr) {
        _colorsArr = [[NSArray alloc] init];
    }
    return _colorsArr;
}

@end
