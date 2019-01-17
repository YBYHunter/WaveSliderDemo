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
@property (nonatomic, strong) UIView *phaseShiftView;

@property (nonatomic, assign) CGFloat currentP;

@property (nonatomic, assign) CGFloat densityNum;
@property (nonatomic, assign) CGFloat frequencyNum;
@property (nonatomic, assign) CGFloat amplitudeNum;
@property (nonatomic, assign) CGFloat phaseShiftNum;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.waveView = [[WaveView alloc] init];
    self.waveView.backgroundColor = [UIColor clearColor];
    self.waveView.frame = CGRectMake(0, 100, self.view.width, 200);
    self.waveView.density = 4.466667;
    self.waveView.frequency = 2.866667;
    self.waveView.amplitude = 1.7;
    
    self.densityNum = 4.466667;
    self.frequencyNum = 2.866667;
    self.amplitudeNum = 1.7;
    self.phaseShiftNum = -0.05;
    _currentP = 1;
    
    self.waveView.primaryWaveLineWidth = 2;
    self.waveView.primaryWaveLineColor = [UIColor redColor];
    [self.view addSubview:self.waveView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.waveView startPhaseAnimation:0.01];
    });
    
    self.lineView = [[UIView alloc] init];
    self.lineView.frame = CGRectMake(0, 0, 0, 2);
    self.lineView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.lineView];
    
    [self.view addSubview:self.densityView];
    [self.view addSubview:self.frequencyView];
    [self.view addSubview:self.amplitudeView];
    [self.view addSubview:self.phaseShiftView];
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
    
    self.phaseShiftView.width = self.view.width;
    self.phaseShiftView.height = 64;
    
    self.densityView.top = self.lineView.bottom + 100;
    self.frequencyView.top = self.densityView.bottom + 10;
    self.amplitudeView.top = self.frequencyView.bottom + 10;
    self.phaseShiftView.top = self.amplitudeView.bottom + 10;
    
    UISlider *aslider = [self.densityView viewWithTag:3001];
    UISlider *bslider = [self.frequencyView viewWithTag:3001];
    UISlider *cslider = [self.amplitudeView viewWithTag:3001];
    UISlider *dslider = [self.phaseShiftView viewWithTag:3001];
    
    aslider.frame = self.densityView.bounds;
    aslider.top = 10;
    aslider.left = 44;
    aslider.width = self.view.width - 88;
    bslider.frame = aslider.frame;
    cslider.frame = aslider.frame;
    dslider.frame = aslider.frame;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchCurrntPoint = [[touches anyObject] locationInView:nil];
    CGFloat p = touchCurrntPoint.x/self.view.width;
    
    self.waveView.density = self.densityNum;       //密度
    self.waveView.frequency = self.frequencyNum * p;     //频率
    self.waveView.amplitude = self.amplitudeNum;
    self.waveView.phaseShift = self.phaseShiftNum;
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
        slider.value = self.densityNum;
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
        slider.value = self.frequencyNum;
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
        slider.value = self.amplitudeNum;
        slider.continuous = YES;// 设置可连续变化
        [slider addTarget:self action:@selector(csliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_amplitudeView addSubview:slider];
    }
    return _amplitudeView;
}

- (UIView *)phaseShiftView {
    if (_phaseShiftView == nil) {
        _phaseShiftView = [[UIView alloc] init];
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 3000;
        label.text = @"速度:000000000";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor blackColor];
        [label sizeToFit];
        [_phaseShiftView addSubview:label];
        
        UISlider *slider = [[UISlider alloc] init];
        slider.tag = 3001;
        slider.minimumValue = -1;
        slider.maximumValue = 1;
        slider.value = self.phaseShiftNum;
        slider.continuous = YES;
        [slider addTarget:self action:@selector(dsliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_phaseShiftView addSubview:slider];
    }
    return _phaseShiftView;
}

- (void)asliderValueChanged:(UISlider *)sender {
    UILabel *label = [self.densityView viewWithTag:3000];
    label.text = [NSString stringWithFormat:@"密度:%.6f", sender.value];
    self.waveView.density = sender.value;
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
    
    self.waveView.amplitude = sender.value;
    [self.waveView setNeedsLayout];
    
    self.amplitudeNum = sender.value;
}

- (void)dsliderValueChanged:(UISlider *)sender {
    UILabel *label = [self.phaseShiftView viewWithTag:3000];
    label.text = [NSString stringWithFormat:@"速度:%.6f", sender.value];
    
    self.waveView.phaseShift = sender.value;
    [self.waveView setNeedsLayout];
    
    self.phaseShiftNum = sender.value;
}

@end
