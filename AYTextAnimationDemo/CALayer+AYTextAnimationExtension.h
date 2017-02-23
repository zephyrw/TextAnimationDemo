//
//  CALayer+AYTextAnimationExtension.h
//  AYTextAnimationDemo
//
//  Created by wpsd on 2017/2/7.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALayer (AYTextAnimationExtension)

- (CAShapeLayer *)setupAnimationTextLayerWithText:(NSString *)text fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor;

@end
