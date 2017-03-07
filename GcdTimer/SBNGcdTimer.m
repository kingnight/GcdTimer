//
//  SBNGcdTimer.m
//  iPhoneNews
//
//  Created by jinkai on 17/2/14.
//  Copyright © 2017年 sohu. All rights reserved.
//

#import "SBNGcdTimer.h"

@interface SBNGcdTimer ()

@property (nonatomic, strong) NSMutableDictionary *timerContainer;

@end

@implementation SBNGcdTimer

#pragma mark - Public Method

+ (SBNGcdTimer *)shareInstance{
    static SBNGcdTimer *gcdTimer = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gcdTimer = [[SBNGcdTimer alloc]init];
    });
    
    return gcdTimer;
}

- (void)scheduledGcdTimerWithName:(NSString *)timerName
                     timeInterval:(double)interval
                            queue:(dispatch_queue_t)queue
                          repeats:(BOOL)repeats
                           action:(dispatch_block_t)action{
    if (nil == timerName || timerName.length==0) {
        return;
    }
    if (nil == queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
       timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [self.timerContainer setObject:timer forKey:timerName];
    }

    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0.1 * NSEC_PER_SEC);
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        action();
        
        if (!repeats) {
            [weakSelf cancelGcdTimerWithName:timerName];
        }
    });
    dispatch_resume(timer);
}

- (void)cancelGcdTimerWithName:(NSString *)timerName{
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        return;
    }
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
}

- (BOOL)existTimer:(NSString *)timerName
{
    if ([self.timerContainer objectForKey:timerName]) {
        return YES;
    }
    return NO;
}

#pragma mark - Property

- (NSMutableDictionary *)timerContainer
{
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

@end
