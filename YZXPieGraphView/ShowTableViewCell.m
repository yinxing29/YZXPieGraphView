//
//  ShowTableViewCell.m
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/16.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ShowTableViewCell.h"
#import "Header.h"

@interface ShowTableViewCell ()<UITextFieldDelegate>

@end

@implementation ShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ShowTableViewCell" owner:self options:nil] firstObject];
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface
{
    self.percentage.delegate = self;
    self.titleLable.delegate = self;
}

- (IBAction)buttonPressed:(UIButton *)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"颜色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *key in [ColorDic allKeys]) {
        [alertC addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setTitle:key forState:UIControlStateNormal];
            self.contextBlock(key,@"color");
        }]];
    }
    [alertC addAction:[UIAlertAction actionWithTitle:@"随机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"随机" forState:UIControlStateNormal];
        self.contextBlock(@"随机",@"color");
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""]) {
        if (textField.tag < 500) {
            if ([textField.text integerValue] <= 100 && [textField.text integerValue] >= 0) {
                self.contextBlock(textField.text,@"per");
            }
        }else {
            self.contextBlock(textField.text,@"title");
        }
    }
}

@end
