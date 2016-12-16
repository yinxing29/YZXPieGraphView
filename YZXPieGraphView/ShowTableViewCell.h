//
//  ShowTableViewCell.h
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/16.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ContentBlock)(NSString *content, NSString *type);

@interface ShowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *percentage;
@property (weak, nonatomic) IBOutlet UITextField *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *colorBut;

@property (nonatomic, strong) ContentBlock                    contextBlock;

- (void)setContextBlock:(ContentBlock)contextBlock;

@end
