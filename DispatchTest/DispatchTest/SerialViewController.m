//
//  SerialViewController.m
//  DispatchTest
//
//  Created by 王磊 on 16/4/5.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "SerialViewController.h"

@implementation SerialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"实现线程同步的两种方式";
}

/**
 *  加入到group中的所有block执行完毕，才会执行notify中的block
 */
- (IBAction)dispatch_group
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"test 1 %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"test 2 %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"test 3 %@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        sleep(5);
        NSLog(@"test 4 %@", [NSThread currentThread]);
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done %@", [NSThread currentThread]);
    });
}

/**
 *  dispatch_semaphore可以同步 并发的线程，控制并发线程的顺序
 */
- (IBAction)dispatch_semaphore
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        NSLog(@"test 1 %@", [NSThread currentThread]);
        sleep(2);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"test 2 %@", [NSThread currentThread]);
    });
    
}

@end
