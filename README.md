本文就主要讲一下文字动画实现原理。

文字动画可以分为两部分：

* 将文字转化为ShapeLayer
* 通过更改ShapeLayer的StrokeEnd属性值生成动画
## 将文字转换为ShapeLayer
将文字转换为`ShapeLayer`又可以细分为以下几个步骤：

* 创建NSAttributedString并生成CTLineRef
* 使用CTLineRef生成CTRunRef数组
* 遍历CTRunRef数组，得到每个CTRunRef
* 遍历CTRunRef中每个长度为1的区间生成CGGlyph并转换为CGPath路径，将所有路径拼接起来
* 创建ShapeLayer并将生成的路径赋值给该ShapeLayer

以下是每个步骤的实现方式：

#### 创建NSAttributedString并生成CTLineRef
```
// 定义字体属性
CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), fontSize, NULL);
NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font, kCTFontAttributeName,nil];
// 创建NSAttributedString
NSAttributedString *str = [[NSAttributedString alloc] initWithString:text attributes:attrs];
CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)str);
```
#### 使用CTLineRef生成CTRunRef数组
```
CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)str);
CFArrayRef runArray = CTLineGetGlyphRuns(line);
```
#### 遍历CTRunRef数组，得到每个CTRunRef
```
for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
	// 
	CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
	CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
}
```
#### 遍历CTRunRef中每个长度为1的区间生成CGGlyph并转换为CGPath路径，将所有路径拼接起来
```
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
```
#### 创建ShapeLayer并将生成的路径赋值给该ShapeLayer
```
// 创建UIBezierPath
UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:letters];
// 创建并配置CAShapeLayer
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
```
最后，将ShapeLayer添加到动画图层中就行了
## 生成文字动画
通过改变ShapeLayer的StrokeEnd属性值就可以生成文字动画
#### 添加Slider
```
- (void)setupSlider {
    CGFloat leftMargin = 20;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(leftMargin, kMainHeight - 30, kMainWidth - leftMargin * 2, 3)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}
```
#### 实现Slider的ValueChange方法
```
- (void)sliderValueChanged:(UISlider *)sender {
    self.pathLayer.strokeEnd = sender.value;
}
```
至此，一个文字动画就完成了

本文demo的github地址：<a>https://github.com/zephyrw/TextAnimationDemo.git</a>