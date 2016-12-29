//
//  ViewController.m
//  YZXPieGraphView
//
//  Created by 尹星 on 2016/12/16.
//  Copyright © 2016年 yinixng. All rights reserved.
//

#import "ViewController.h"
#import "ShowTableViewCell.h"
#import "ShowViewController.h"
#import "Header.h"
#import "DataModel.h"
#import "MJExtension.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewConstraint;

/**
 标题
 */
@property (nonatomic, strong) NSMutableDictionary            *titleArr;

/**
 百分比
 */
@property (nonatomic, strong) NSMutableDictionary            *precentageArr;

/**
 设置的颜色
 */
@property (nonatomic, strong) NSMutableDictionary            *colorsArr;

@property (nonatomic, strong) NSMutableArray <DataModel *>   *modelArr;

@property (strong, nonatomic) UIColor *titleColor;

@property (weak, nonatomic) IBOutlet UISwitch *hideTitle;
@property (weak, nonatomic) IBOutlet UISwitch *hideAnnotation;
@property (weak, nonatomic) IBOutlet UITextField *center_x;
@property (weak, nonatomic) IBOutlet UITextField *center_y;
@property (weak, nonatomic) IBOutlet UITextField *redius;
@property (weak, nonatomic) IBOutlet UITextField *titleFont;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扇形图";
    [self customNavigationBarItem];
    [self initializeUserInterface];
}

- (void)initializeUserInterface
{
    self.center_x.text = [NSString stringWithFormat:@"%.2f",self.view.bounds.size.width / 2.0];
    self.center_y.text = @"100";
    self.titleFont.text = @"10.0";
    self.redius.text = @"60.0";
    
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSNumber *key in [self.precentageArr allKeys]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.titleArr[key] forKey:@"title"];
        [dic setObject:self.colorsArr[key] forKey:@"color"];
        [dic setObject:self.precentageArr[key] forKey:@"percentage"];
        [modelArr addObject:dic];
    }
    
    self.modelArr = [DataModel mj_objectArrayWithKeyValuesArray:modelArr];
    
    [self.tableView reloadData];
}

- (void)customNavigationBarItem
{
    UIButton *leftBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftBut setTitle:@"添加" forState:UIControlStateNormal];
    [leftBut sizeToFit];
    [leftBut addTarget:self action:@selector(leftItemPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBut setTitle:@"完成" forState:UIControlStateNormal];
    [rightBut sizeToFit];
    [rightBut addTarget:self action:@selector(rightItemPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftItemPressed
{
    DataModel *model = [[DataModel alloc] init];
    [self.modelArr addObject:model];
    [self.tableView reloadData];
}

- (void)rightItemPressed
{
    [self.view endEditing:YES];
    
    ShowViewController *showVC = [[ShowViewController alloc] init];
    
    NSMutableArray *titles = [NSMutableArray array];
    NSMutableArray *precentages = [NSMutableArray array];
    NSMutableArray *colors = [NSMutableArray array];
    for (DataModel *model in self.modelArr) {
        if (![model.title isEqualToString:@""] && model.title) {
            [titles addObject:model.title];
        }
        if (![model.percentage isEqualToString:@""] && model.percentage) {
            [precentages addObject:model.percentage];
        }
        if (![model.color isEqualToString:@""] && model.color) {
            [colors addObject:ColorDic[model.color]];
        }
    }
    showVC.titleArr = titles.count == 0?nil:titles;
    showVC.precentageArr = precentages.count == 0?nil:precentages;
    showVC.colorsArr = colors.count == 0?nil:colors;
    showVC.hideTitlt = self.hideTitle.on;
    showVC.hideAnnotation = self.hideAnnotation.on;
    showVC.titleColor = self.titleColor;
    showVC.circleCenter = CGPointMake([self.center_x.text floatValue], [self.center_y.text floatValue]);
    showVC.circleRadius = [self.redius.text floatValue];
    showVC.titleFont = [self.titleFont.text floatValue];
    [self.navigationController pushViewController:showVC animated:YES];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"颜色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weak_self = self;
    for (NSString *key in [ColorDic allKeys]) {
        if (![key isEqualToString:@"随机"]) {
            [alertC addAction:[UIAlertAction actionWithTitle:key style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [sender setTitle:key forState:UIControlStateNormal];
                weak_self.titleColor = ColorDic[key];
            }]];
        }
    }
    [alertC addAction:[UIAlertAction actionWithTitle:@"随机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [sender setTitle:@"随机" forState:UIControlStateNormal];
        weak_self.titleColor = ColorDic[@"随机"];
    }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (IBAction)switchPressed:(UISwitch *)sender {
    
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入有效值！" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.percentage.tag = 100 + indexPath.row;
    cell.titleLable.tag = 500 + indexPath.row;
    cell.percentage.text = self.modelArr[indexPath.row].percentage;
    cell.titleLable.text = self.modelArr[indexPath.row].title;
    [cell.colorBut setTitle:self.modelArr[indexPath.row].color?self.modelArr[indexPath.row].color:@"选择" forState:UIControlStateNormal];
    
    
    __weak typeof(self) weak_self = self;
    [cell setContextBlock:^(NSString *content, NSString *type) {
        if ([type isEqualToString:@"color"]) {
            weak_self.modelArr[indexPath.row].color = content;
        }else if ([type isEqualToString:@"per"]) {
            weak_self.modelArr[indexPath.row].percentage = content;
        }else if ([type isEqualToString:@"title"]) {
            weak_self.modelArr[indexPath.row].title = content;
        }
    }];
    self.tableViewConstraint.constant = self.tableView.contentSize.height;
    cell.selectionStyle = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.modelArr removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - 初始化
- (NSMutableDictionary *)colorsArr
{
    if (!_colorsArr) {
        _colorsArr = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"红色",@0,@"橙色",@1,@"蓝色",@2,@"灰色",@3,@"黄色",@4, nil];
    }
    return _colorsArr;
}

- (NSMutableDictionary *)precentageArr
{
    if (!_precentageArr) {
        _precentageArr = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"30",@0,@"3",@1,@"27",@2,@"25",@3,@"15",@4, nil];
    }
    return _precentageArr;
}

- (NSMutableDictionary *)titleArr
{
    if (!_titleArr) {
        _titleArr = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"title1",@0,@"title2",@1,@"title3",@2,@"title4",@3,@"title5",@4, nil];
    }
    return _titleArr;
}

- (NSMutableArray<DataModel *> *)modelArr
{
    if (!_modelArr) {
        _modelArr = [[NSMutableArray alloc] init];
    }
    return _modelArr;
}

@end
