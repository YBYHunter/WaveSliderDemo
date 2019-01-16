//
//  ViewController.m
//  WaveSliderView
//
//  Created by yu on 2019/1/16.
//  Copyright © 2019 yu. All rights reserved.
//

#import "ViewController.h"
#import "WaveView.h"
#import "UIView+addition.h"

@interface ViewController ()

@property (nonatomic, strong) WaveView *waveView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *densityView;
@property (nonatomic, strong) UIView *frequencyView;
@property (nonatomic, strong) UIView *amplitudeView;

@property (nonatomic, assign) CGFloat currentP;

@property (nonatomic, assign) CGFloat densityNum;
@property (nonatomic, assign) CGFloat frequencyNum;
@property (nonatomic, assign) CGFloat amplitudeNum;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waveView = [[WaveView alloc] init];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveView.frame = CGRectMake(0, 100, 200, 200);
    self.waveView.density = 4.466667;
    self.waveView.frequency = 2.866667;
    self.waveView.amplitude = 1.7;
    self.waveView.primaryWaveLineWidth = 2;
    self.waveView.primaryWaveLineColor = [UIColor redColor];
    [self.view addSubview:self.waveView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.waveView startPhaseAnimation:0.03];
    });
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(0, 0, 0, 2);
    self.lineView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lineView];
    
    [self.view addSubview:self.densityView];
    [self.view addSubview:self.frequencyView];
    [self.view addSubview:self.amplitudeView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.lineView.centerY = self.waveView.centerY;
    
    self.densityView.width = self.view.width;
    self.densityView.height = 64;
    
    self.frequencyView.width = self.view.width;
    self.frequencyView.height = 64;
    
    self.amplitudeView.width = self.view.width;
    self.amplitudeView.height = 64;
    
    self.densityView.top = self.lineView.bottom + 100;
    self.frequencyView.top = self.densityView.bottom + 10;
    self.amplitudeView.top = self.frequencyView.bottom + 10;
    
    UISlider *aslider = [self.densityView viewWithTag:3001];
    UISlider *bslider = [self.frequencyView viewWithTag:3001];
    UISlider *cslider = [self.amplitudeView viewWithTag:3001];
    
    aslider.frame = self.densityView.bounds;
    aslider.top = 10;
    aslider.left = 44;
    aslider.width = self.view.width - 88;
    bslider.frame = aslider.frame;
    cslider.frame = aslider.frame;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchCurrntPoint = [[touches anyObject] locationInView:nil];
    CGFloat p = touchCurrntPoint.x/self.view.width;
    
    self.waveView.density = self.densityNum * p;       //密度
    self.waveView.frequency = self.frequencyNum * p;     //频率
    self.waveView.amplitude = self.amplitudeNum * p;
    self.waveView.width = touchCurrntPoint.x;
    [self.waveView setNeedsLayout];
    
    self.lineView.left = touchCurrntPoint.x;
    self.lineView.width = self.view.width - touchCurrntPoint.x;
    
    _currentP = p;
}

- (UIView *)densityView {
    if (_densityView == nil) {
        _densityView = [[UIView alloc] init];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 3000;
        label.text = @"密度:000000000";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [_densityView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.tag = 3001;
        slider.minimumValue = 0;
        slider.maximumValue = 20;
        slider.value = 0;
        slider.continuous = YES;// 设置可连续变化
        [slider addTarget:self action:@selector(asliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_densityView addSubview:slider];
    }
    return _densityView;
}

- (UIView *)frequencyView {
    if (_frequencyView == nil) {
        _frequencyView = [[UIView alloc] init];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 3000;
        label.text = @"频率:000000000";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [_frequencyView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.tag = 3001;
        slider.minimumValue = 0;
        slider.maximumValue = 50;
        slider.value = 0;
        slider.continuous = YES;
        [slider addTarget:self action:@selector(bsliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_frequencyView addSubview:slider];
    }
    return _frequencyView;
}

- (UIView *)amplitudeView {
    if (_amplitudeView == nil) {
        _amplitudeView = [[UIView alloc] init];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 3000;
        label.text = @"振幅:000000000";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [_amplitudeView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.tag = 3001;
        slider.minimumValue = 0;
        slider.maximumValue = 4;
        slider.value = 0;
        slider.continuous = YES;// 设置可连续变化
        [slider addTarget:self action:@selector(csliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_amplitudeView addSubview:slider];
    }
    return _amplitudeView;
}

- (void)asliderValueChanged:(UISlider *)sender {
    UILabel *label = [self.densityView viewWithTag:3000];
    label.text = [NSString stringWithFormat:@"密度:%.6f", sender.value];
    self.waveView.density = sender.value * _currentP;
    [self.waveView setNeedsLayout];
    
    self.densityNum = sender.value;
}

- (void)bsliderValueChanged:(UISlider *)sender {
    UILabel *label = [self.frequencyView viewWithTag:3000];
    label.text = [NSString stringWithFormat:@"频率:%.6f", sender.value];
    self.waveView.frequency = sender.value * _currentP;
    [self.waveView setNeedsLayout];
    
    self.frequencyNum = sender.value;
}

- (void)csliderValueChanged:(UISlider *)sender {
    UILabel *label = [self.amplitudeView viewWithTag:3000];
    label.text = [NSString stringWithFormat:@"振幅:%.6f", sender.value];
    self.waveView.amplitude = sender.value * _currentP;
    [self.waveView setNeedsLayout];
    self.amplitudeNum = sender.value;
}

@end
