//
//  WaveView.h
//  YUAnimationDemo
//
//  Created by 于博洋 on 2017/7/13.
//  Copyright © 2017年 于博洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaveView : UIView

@property (nonatomic,assign) CGFloat amplitude; //振幅

@property (nonatomic,assign) CGFloat frequency; //频率

@property (nonatomic,assign) CGFloat density;   //密度

@property (nonatomic,assign) CGFloat primaryWaveLineWidth;  //线的宽

@property (nonatomic,strong) UIColor * primaryWaveLineColor;//线的颜色

- (void)startPhaseAnimation:(CGFloat)speed;

- (void)endPhaseAnimation;

@end
