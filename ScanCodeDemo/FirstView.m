//
//  FirstView.m
//  ScanCodeDemo
//
//  Created by chenlishuang on 2017/8/9.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import "FirstView.h"

@implementation FirstView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
- (void)initViews{
    CGRect myRect =CGRectMake((LCDW - 200) /2,(LCDH - 200) / 2 ,200, 200);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, LCDW, LCDH)];
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRect:myRect];
    
    [path appendPath:circlePath];
    
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    
    fillLayer.path = path.CGPath;
    
    fillLayer.fillRule =kCAFillRuleEvenOdd;
    
    fillLayer.fillColor = [UIColor  blackColor].CGColor;
    
    fillLayer.opacity =0.7;
    
    [self.layer addSublayer:fillLayer];
    
    
    NSString * firstStr = @"将二维码放入矩形框内,即可自动扫描";
    
    NSString * secondStr = @"";
    
    
    CGFloat x = 50;
    
    CGFloat y = (LCDH - 200) / 2 + 200;
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width -20;
    
    CGFloat marginY = 15;
    
    UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    
    CGFloat firstH = [self  sizeWithString:firstStr font:font max:CGSizeMake(w, MAXFLOAT)].height;
    
    UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y + marginY, w, firstH)];
    
    firstLabel.text = firstStr;
    
    firstLabel.numberOfLines = 0;
    
    firstLabel.font = font;
    
    firstLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:firstLabel];
    
    
    CGFloat secondH = [self  sizeWithString:secondStr font:font max:CGSizeMake(w, MAXFLOAT)].height;
    
    
    UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y + marginY + 45, w, secondH)];
    
    secondLabel.text = secondStr;
    
    secondLabel.numberOfLines = 0;
    
    secondLabel.font = font;
    
    secondLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:secondLabel];

}

-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font max:(CGSize)maxSize{
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    
    CGSize textSize =  [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize ;
}
@end
