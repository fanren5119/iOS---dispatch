//
//  SpecialFunViewController.m
//  DispatchTest
//
//  Created by 王磊 on 16/4/5.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "SpecialFunViewController.h"

@implementation SpecialFunViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"使用GCD队列的几种特殊函数";
}


#pragma -mark dispatch_apply
/**
 *  在并发队列中执行dispatch_apply
    在执行过程中，同时执行多个循环中的迭代，
    等到dispatch_apply中的block循环迭代完，才继续执行
 */
- (IBAction)dispatch_applyComplicate
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    size_t count = 100;
    dispatch_apply(count, queue, ^(size_t i) {
        NSLog(@"====%zu===%@", i, [NSThread currentThread]);
    });
    
    NSLog(@"========%@", [NSThread currentThread]);
}

/**
 *  在串行队列中执行dispatch_apply
    在执行过程中，串行执行循环，与for循环相同
    等到dispatch_apply中的block循环迭代完，才继续执行
 */
- (IBAction)dispatch_applySerial
{
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
    size_t count = 100;
    dispatch_apply(count, queue, ^(size_t i) {
        NSLog(@"====%zu===%@", i, [NSThread currentThread]);
    });
    NSLog(@"========%@", [NSThread currentThread]);
}

/**
 *  如果是在主队列中执行dispatch_apply会造成线程锁死
 */
- (IBAction)dispatch_applyMain
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    size_t count = 100;
    dispatch_apply(count, queue, ^(size_t i) {
        NSLog(@"====%zu===%@", i, [NSThread currentThread]);
    });
    NSLog(@"========%@", [NSThread currentThread]);
}


#pragma -mark dispatch_barrier_async

/**
 *  dispatch_barrier_async函数会等到队列之前的block执行完，才会执行barrier中block，block执行完毕之后，才会执行队列之后的block
 */
- (IBAction)dispatch_barrier_asyncComplicate
{
    dispatch_queue_t queue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"6==%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
//        NSLog(@"3==%@", [NSThread currentThread]);
        for (int i = 0; i < 10; i ++) {
            NSLog(@"i==%d===%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"4==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
}

/**
 *  如果使用dispatch_get_global_queue，barrier之后的block的执行就不一定会等到barrier执行完
 */
- (IBAction)dispatch_barrier_asyncSerial
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"1==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"6==%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
//        NSLog(@"3==%@", [NSThread currentThread]);
        for (int i = 0; i < 10; i ++) {
            NSLog(@"i==%d===%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"4==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
}


/**
 *  在主队列中使用dispatch_barrier_async，此函数相当于dispatch_async
 */
- (IBAction)dispatch_barrier_asyncMain
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"1==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"6==%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        //        NSLog(@"3==%@", [NSThread currentThread]);
        for (int i = 0; i < 10; i ++) {
            NSLog(@"i==%d===%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"4==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
}

#pragma -mark dispatch_barrier_sync
/**
 *  dispatch_barrier_sync的功能与dispatch_barrier_async相同，不同的是barrier在主线程中执行
 */
- (IBAction)dispatch_barrier_syncComplicate
{
    dispatch_queue_t queue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"1==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"6==%@", [NSThread currentThread]);
    });
    dispatch_barrier_sync(queue, ^{
        //        NSLog(@"3==%@", [NSThread currentThread]);
        for (int i = 0; i < 10; i ++) {
            NSLog(@"i==%d===%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"4==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
}

/**
 *  在dispatch_get_global_queue并发队列上执行，与自定义的并发队列上执行，
    效果相同
 */
- (IBAction)dispatch_barrier_syncSerial
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"1==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"6==%@", [NSThread currentThread]);
    });
    dispatch_barrier_async(queue, ^{
        //        NSLog(@"3==%@", [NSThread currentThread]);
        for (int i = 0; i < 10; i ++) {
            NSLog(@"i==%d===%@", i, [NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"4==%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"5==%@", [NSThread currentThread]);
    });
}


#pragma -mark dispatch_after

/**
 *  延迟执行block，如果是在并发队列中，则该block在分线程中运行
 */
- (IBAction)dispatch_after_Complicate
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"===%@", [NSThread currentThread]);
    });
}

/**
 *  延迟执行block，如果是在创建的队列中，则该block在分线程中运行
 */
- (IBAction)dispatch_after_Serial
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_queue_create(0, 0);
    dispatch_after(time, queue, ^{
        NSLog(@"===%@", [NSThread currentThread]);
    });
}

/**
 *  延迟执行block，如果是在主队列中，则该block是在主线程中运行
 */
- (IBAction)dispatch_after_main
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(time, queue, ^{
        NSLog(@"===%@", [NSThread currentThread]);
    });
}


#pragma -mark dispatch_set_target_queue
/**
 *  dispatch_set_target_queue将多个串行的queue指定到了同一队列，那么这多个串行的queue在目标上就是同步执行，而不是并行执行
 */
- (IBAction)dispatch_set_target_queueSerial
{
    dispatch_queue_t targetQueue = dispatch_queue_create("target.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    dispatch_async(queue1, ^{
        NSLog(@"test1 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"test1 out");
    });
    dispatch_async(queue2, ^{
        NSLog(@"test2 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"test2 out");
    });
    dispatch_async(queue3, ^{
        NSLog(@"test3 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"test3 out");
    });
}

/**
 *  在并发队列中dispatch_set_target_queue没有任何的作用
 */
- (IBAction)dispatch_set_target_queueComplicate
{
    dispatch_queue_t targetQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    dispatch_async(queue1, ^{
        NSLog(@"test1 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"test1 out");
    });
    dispatch_async(queue2, ^{
        NSLog(@"test2 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"test2 out");
    });
    dispatch_async(queue3, ^{
        NSLog(@"test3 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"test3 out");
    });
}

/**
 *  在主队列中，和在串行队列下，相同
 */
- (IBAction)dispatch_set_target_queueMain
{
    dispatch_queue_t targetQueue = dispatch_get_main_queue();
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);
    
    dispatch_async(queue1, ^{
        NSLog(@"test1 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"test1 out");
    });
    dispatch_async(queue2, ^{
        NSLog(@"test2 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"test2 out");
    });
    dispatch_async(queue3, ^{
        NSLog(@"test3 in %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"test3 out");
    });
}

@end
