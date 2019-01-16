//
//  WaveView.m
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/7/13.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import "WaveView.h"

@interface WaveView ()

@property (nonatomic,assign) CGFloat phaseShift;//相移

@property (nonatomic,assign) CGFloat phase;     //阶段

@property (nonatomic, strong) dispatch_source_t timer;



@end


@implementation WaveView

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self context];
        self.phaseShift = -0.15;    //相移
        self.amplitude = 10.0f;     //振幅
        self.density = 5.0f;        //密度
        self.frequency = 1.5;       //频率
        self.primaryWaveLineWidth = 3.0; //线的宽
        self.primaryWaveLineColor = [UIColor whiteColor];
    }
    return self;
}

- (void)startPhaseAnimation:(CGFloat)speed {
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(speed * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        self.phase += self.phaseShift;
        [self setNeedsDisplay];
    });
    dispatch_resume(self.timer);
}

- (void)endPhaseAnimation {
    dispatch_cancel(self.timer);
    self.timer = nil;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    [self.backgroundColor set];
    CGContextFillRect(context, self.bounds);
    
    UIColor * waveColor = self.primaryWaveLineColor;
    CGFloat strokeLineWidth = self.primaryWaveLineWidth;
    CGContextSetLineWidth(context, strokeLineWidth);
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat mid = width / 2.0f;
    const CGFloat maxAmplitude = halfHeight - (strokeLineWidth * 2);
    CGFloat progress = 1.0f;
    CGFloat normedAmplitude = (1.5f * progress - 2.0f) * self.amplitude;
    CGFloat multiplier = MIN(1.0, (progress / 3.0f * 2.0f) + (1.0f / 3.0f));
    [[waveColor colorWithAlphaComponent:multiplier * CGColorGetAlpha(waveColor.CGColor)] set];
    
    if (self.density <= 0) {
        self.density = 0.01;
    }
    for (CGFloat x = 0; x < (width + self.density); x += self.density) {
        CGFloat scaling = -pow(1 / mid * (x - mid), 2) + 1;
        CGFloat y = scaling * maxAmplitude * normedAmplitude * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + halfHeight;
        if (x == 0) {
            CGContextMoveToPoint(context, x, y);
        } else {
            CGContextAddLineToPoint(context, x, y);
        }
    }
    
    CGContextStrokePath(context);
}


















@end
