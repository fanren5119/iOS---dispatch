//
//  ViewController.m
//  DispatchTest
//
//  Created by 王磊 on 16/4/1.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "ViewController.h"
#import "BaseQueueViewController.h"
#import "SpecialFunViewController.h"
#import "SourceViewController.h"
#import "SerialViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray            *dataSourceArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    self.dataSourceArray = @[@"三种队列的同步与异步执行效果",
                             @"GCD特殊函数使用",
                             @"GCD源",
                             @"GCD的同步"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        BaseQueueViewController *baseQueueVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BaseQueueViewController"];
        [self.navigationController pushViewController:baseQueueVC animated:YES];
    } else if (indexPath.row == 1) {
        SpecialFunViewController *specialFunVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecialFunViewController"];
        [self.navigationController pushViewController:specialFunVC animated:YES];
    } else if (indexPath.row == 2) {
        SourceViewController *sourceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SourceViewController"];
        [self.navigationController pushViewController:sourceVC animated:YES];
    } else if (indexPath.row == 3) {
        SerialViewController *serialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SerialViewController"];
        [self.navigationController pushViewController:serialVC animated:YES];
    }
}

@end
