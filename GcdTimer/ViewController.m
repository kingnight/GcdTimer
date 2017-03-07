//
//  ViewController.m
//  GcdTimer
//
//  Created by jinkai on 17/2/14.
//  Copyright © 2017年 jinkai. All rights reserved.
//

#import "ViewController.h"
#import "SBNGcdTimer.h"

static NSString *myTimer = @"MyTimer";

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)cancelAction {
    if ([[SBNGcdTimer shareInstance]existTimer:myTimer]) {
        [[SBNGcdTimer shareInstance] cancelGcdTimerWithName:myTimer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SBNGcdTimer shareInstance]scheduledGcdTimerWithName:myTimer timeInterval:1 queue:nil repeats:YES action:^{
            [weakSelf doSomethingEveryTwoSeconds];
        }];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doSomethingEveryTwoSeconds
{
    static NSUInteger n = 0;
    NSLog(@"myTimer runs %lu times!", (unsigned long)n++);
    
    if (n >= 10) {
        [[SBNGcdTimer shareInstance] cancelGcdTimerWithName:myTimer];
    }
}

@end
