//
//  SBNGcdTimer.h
//  iPhoneNews
//
//  Created by jinkai on 17/2/14.
//  Copyright © 2017年 sohu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBNGcdTimer : NSObject

+ (SBNGcdTimer *)shareInstance;

/**
 启动一个timer，默认精度为0.1秒。

 @param timerName timer的名称，作为唯一标识。
 @param interval 执行的时间间隔。
 @param queue timer将被放入的队列，也就是最终action执行的队列。传入nil将自动放到一个子线程队列中。
 @param repeats timer是否循环调用。
 @param action 时间间隔到点时执行的block。
 */
- (void)scheduledGcdTimerWithName:(NSString *)timerName
                     timeInterval:(double)interval
                            queue:(dispatch_queue_t)queue
                          repeats:(BOOL)repeats
                           action:(dispatch_block_t)action;

/**
 取消定时器

 @param timerName timer的名称，作为唯一标识
 */
- (void)cancelGcdTimerWithName:(NSString *)timerName;

/**
 *  是否存在某个名称标识的timer。
 *
 *  @param timerName timer的唯一名称标识。
 *
 *  @return YES表示存在，反之。
 */
- (BOOL)existTimer:(NSString *)timerName;
@end
