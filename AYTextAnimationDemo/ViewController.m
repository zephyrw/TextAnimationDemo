//
//  ViewController.m
//  AYTextAnimationDemo
//
//  Created by wpsd on 2017/2/4.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "CALayer+AYTextAnimationExtension.h"

#define kMainWidth [UIScreen mainScreen].bounds.size.width
#define kMainHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (strong, nonatomic) CALayer *animationLayer;
@property (strong, nonatomic) CAShapeLayer *pathLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _animationLayer = [CALayer layer];
    _animationLayer.frame = CGRectMake(60, 60, CGRectGetWidth(self.view.bounds) - 120, CGRectGetHeight(self.view.bounds));
    [self.view.layer addSublayer:_animationLayer];
    
    _pathLayer = [_animationLayer setupAnimationTextLayerWithText:@"C'est La Vie" fontSize:32 fontColor:[UIColor redColor]];
    [self setupSlider];
}

- (void)setupSlider {
    
    CGFloat leftMargin = 20;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(leftMargin, kMainHeight - 30, kMainWidth - leftMargin * 2, 3)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)sliderValueChanged:(UISlider *)sender {
    self.pathLayer.strokeEnd = sender.value;
}

@end
