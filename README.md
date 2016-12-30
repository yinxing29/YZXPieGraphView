# YZXPieGraphView
扇形图
- (instancetype)initWithFrame:(CGRect)frame withTitleData:(NSArray *)titleArr withPercentageData:(NSArray *)precentageArr withColors:(NSArray *)colorArr;

初始化方法，必须传入“比例数组”，如（@[@"30",@"30",@"40"]）表示比例）(30%,30%,40%)。“标题数组”和“颜色数组”可以不传，但是如果传入了“标题数组”，则数量和“比例数组”要相同，
“颜色数组”没有要求，当数量不对时会自动填充随机颜色。其他参数可以选择性设置。
@file:///Users/yinxing/Desktop/扇形图.png
