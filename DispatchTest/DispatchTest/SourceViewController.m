//
//  SourceViewController.m
//  DispatchTest
//
//  Created by 王磊 on 16/4/5.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "SourceViewController.h"

@interface SourceViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation SourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"GCD源详解";
}

- (IBAction)dispatch_source_test:(id)sender
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    
    __weak SourceViewController *weakSelf = self;
    dispatch_source_set_event_handler(source, ^{
        NSLog(@"%f", (double)dispatch_source_get_data(source));
        weakSelf.sourceLabel.text = [NSString stringWithFormat:@"%lu", dispatch_source_get_data(source)];
    });
    dispatch_resume(source);
    
    size_t count = 10;
    dispatch_apply(count, queue, ^(size_t i) {
        NSLog(@"====%zu", i);
        dispatch_source_merge_data(source, i);
    });
}


- (IBAction)dispatch_source_timer:(id)sender
{
    static int count = 0;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 2 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"==%@", [NSThread currentThread]);
        count ++;
        
//        self.timerLabel.text = [NSString stringWithFormat:@"%d", count];
    });
    dispatch_resume(_timer);
}

- (IBAction)cancelTimer:(id)sender
{
    dispatch_source_cancel(_timer);
}

@end
