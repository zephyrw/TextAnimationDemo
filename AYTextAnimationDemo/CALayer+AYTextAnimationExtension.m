//
//  CALayer+AYTextAnimationExtension.m
//  AYTextAnimationDemo
//
//  Created by wpsd on 2017/2/7.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "CALayer+AYTextAnimationExtension.h"
#import <CoreText/CoreText.h>

@implementation CALayer (AYTextAnimationExtension)

- (CAShapeLayer *)setupAnimationTextLayerWithText:(NSString *)text fontSize:(CGFloat)fontSize fontColor:(UIColor *)fontColor {
    
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), fontSize, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text
                                                              attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)str);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex glyphIndex = 0; glyphIndex < CTRunGetGlyphCount(run); glyphIndex++) {
            
            CGGlyph glyph;
            CGPoint position;
            CFRange currentRange = CFRangeMake(glyphIndex, 1);
            CTRunGetGlyphs(run, currentRange, &glyph);
            CTRunGetPositions(run, currentRange, &position);
            
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &t, letter);
            CGPathRelease(letter);
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
    
    CFRelease(letters);
    CFRelease(font);
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = fontColor.CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinBevel;
    pathLayer.strokeStart = 0;
    pathLayer.strokeEnd = 0;
    [self addSublayer:pathLayer];
    
    return pathLayer;
}

@end
