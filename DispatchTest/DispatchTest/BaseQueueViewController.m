//
//  BaseQueueViewController.m
//  DispatchTest
//
//  Created by 王磊 on 16/4/1.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "BaseQueueViewController.h"

@interface BaseQueueViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation BaseQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"三种队列的同步与异步执行效果";
    
}

/**
 *  同步--全局并发队列
 没有创建新的线程，串行执行任务
 */
- (IBAction)syncRunComplicateFun
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; i ++) {
        dispatch_sync(queue, ^{
            NSLog(@"异步执行%d=====%@",i, [NSThread currentThread]);
        });
    }
    NSLog(@"主线程====%@", [NSThread currentThread]);
}


/**
 *  异步--全局并发队列
 创建了新线程，并发执行任务
 */
- (IBAction)asyncRunComplicateFun
{
    NSLog(@"主线程====%@", [NSThread currentThread]);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10; i ++) {
        dispatch_async(queue, ^{
            NSLog(@"异步执行%d=====%@",i, [NSThread currentThread]);
        });
    }
    
}


/**
 *  同步--手动创建串行队列
 没有创建新线程，串行执行任务
 */
- (IBAction)syncRunSerialFun
{
    dispatch_queue_t queue = dispatch_queue_create("serial queu", NULL);
    for (int i = 0; i < 10; i ++) {
        dispatch_sync(queue, ^{
            NSLog(@"异步执行%d=====%@",i, [NSThread currentThread]);
        });
    }
    NSLog(@"主线程====%@", [NSThread currentThread]);
}

/**
 *  异步--手动创建串行队列
 创建了新的线程，串行执行任务
 */
- (IBAction)asyncRunSerialFun
{
    dispatch_queue_t queue = dispatch_queue_create("serial queu", NULL);
    for (int i = 0; i < 10; i ++) {
        dispatch_async(queue, ^{
            NSLog(@"异步执行%d=====%@",i, [NSThread currentThread]);
        });
    }
    NSLog(@"主线程====%@", [NSThread currentThread]);
}


/**
 *  同步--主队列
 没有创建新线程，串行执行任务
 */
- (IBAction)syncRunMainQueueFun
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"异步执行=====%@", [NSThread currentThread]);
    });
    NSLog(@"主线程====%@", [NSThread currentThread]);
    
    //这里会造成死锁
    //在主线程中加入一个同步的线程，而此线程又在主队列中，主队列中有两个线程（主线程，插入的同步线程）
    //要执行同步线程中的block，需等待主线程执行完毕
    //而主线程却在等待此线程的block返回，才能继续执行下去
    //从而造成了死锁
}


/**
 *  异步---主队列
 没有创建新线程，串行执行任务
 */
- (IBAction)asyncRunMainQueueFun
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    for (int i = 0; i < 10; i ++) {
        dispatch_async(queue, ^{
            NSLog(@"异步执行%d=====%@",i, [NSThread currentThread]);
        });
    }
    NSLog(@"主线程====%@", [NSThread currentThread]);
}

@end
