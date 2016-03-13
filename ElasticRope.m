//
//  ElasticRope.m
//  ElasticRope
//
//  Created by gukong on 15/11/14.
//  Copyright © 2015年 Nate. All rights reserved.
//

#import "ElasticRope.h"

@interface ElasticRope () {
    CGFloat r1;
    UIBezierPath *cutePath;
    CAShapeLayer *shapeLayer;
    
    UILabel *FPoint;
    UILabel *EPoint;
    UILabel *GPoint;
    UILabel *HPoint;
}
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *tailView;
@end

@implementation ElasticRope

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        r1 = CGRectGetWidth(frame)/2;
        _strictCoefficient = 500;
        [self setupSubViews];
        _headPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        _tailPoint = self.headPoint;
    }
    return self;
}

- (void)setupSubViews {
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
    [_headView.layer setCornerRadius:CGRectGetWidth(_headView.frame)/2];
    [_headView.layer setMasksToBounds:YES];
    [_headView setBackgroundColor:self.tintColor];
    [self addSubview:_headView];
    
    _tailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
    [_tailView.layer setCornerRadius:CGRectGetWidth(_tailView.frame)/2];
    [_tailView.layer setMasksToBounds:YES];
    [_tailView setBackgroundColor:self.tintColor];
    [self addSubview:_tailView];
    
    shapeLayer = [CAShapeLayer layer];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    FPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [FPoint setFont:[UIFont systemFontOfSize:5.f]];
    [FPoint setText:@"F"];
    [FPoint sizeToFit];
    [self addSubview:FPoint];
    
    EPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [EPoint setAdjustsFontSizeToFitWidth:YES];
    [EPoint setFont:[UIFont systemFontOfSize:5.f]];
    [EPoint setText:@"E"];
    [EPoint sizeToFit];
    [self addSubview:EPoint];
    
    GPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [GPoint setAdjustsFontSizeToFitWidth:YES];
    [GPoint setFont:[UIFont systemFontOfSize:5.f]];
    [GPoint setText:@"G"];
    [GPoint sizeToFit];
    [self addSubview:GPoint];
    
    HPoint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [HPoint setAdjustsFontSizeToFitWidth:YES];
    [HPoint setFont:[UIFont systemFontOfSize:5.f]];
    [HPoint setText:@"H"];
    [HPoint sizeToFit];
    [self addSubview:HPoint];
}

- (void)setHeadPoint:(CGPoint)headPoint {
    _headPoint = [self convertPoint:headPoint fromView:self.superview];
    [self setNeedsDisplay];
}

- (void)setTailPoint:(CGPoint)tailPoint {
    _tailPoint = [self convertPoint:tailPoint fromView:self.superview];
    [self setNeedsDisplay];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super tintColor];
    [_headView setBackgroundColor:tintColor];
    [_tailView setBackgroundColor:tintColor];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [_headView setCenter:_headPoint];
    [_tailView setCenter:_tailPoint];
    /**
     *  圆圈之间的距离
     */
    CGFloat distance = sqrtf(powf(_headView.center.x-_tailView.center.x,2)+powf(_headView.center.y-_tailView.center.y, 2)) - r1*2;
    
    /**
     *  y = 2r - k / (x + k/2r)  x ∈ [0,+∞)；y ∈ [0,2r)
     *
     *  k = 200 * r
     *  distance = x
     *  offset = 2r - y
     */
    CGFloat k = _strictCoefficient;
    CGFloat offset = (k*r1)/(distance + (k*r1)/(2*r1));
    
    /**
     *  <#Description#>
     */
    CGPoint anchorPoint = [self anchorPointWithOffset:offset];
    CGPoint anchorPoint1 = [self anchorPoint1WithOffset:offset];
    
    CGPoint headCutPoint1 = [self cutPoint1OfCircle:_headView withPoint:anchorPoint1];
    [FPoint setCenter:headCutPoint1];
    CGPoint headCutPoint = [self cutPointOfCircle:_headView withPoint:anchorPoint];
    [EPoint setCenter:headCutPoint];
    CGPoint tailCutPoint1 = [self cutPoint1OfCircle:_tailView withPoint:anchorPoint];
    [GPoint setCenter:tailCutPoint1];
    CGPoint tailCutPoint = [self cutPointOfCircle:_tailView withPoint:anchorPoint1];
    [HPoint setCenter:tailCutPoint];
    
    cutePath = [UIBezierPath bezierPath];
    
    [cutePath moveToPoint:_headView.center];
    [cutePath addLineToPoint:headCutPoint];
    [cutePath addQuadCurveToPoint:tailCutPoint1 controlPoint:anchorPoint];
    [cutePath addLineToPoint:tailCutPoint];
    [cutePath addQuadCurveToPoint:headCutPoint1 controlPoint:anchorPoint1];
    
    shapeLayer.path = [cutePath CGPath];
    shapeLayer.fillColor = self.tintColor.CGColor;
    [self.layer insertSublayer:shapeLayer below:_tailView.layer];
}

- (CGPoint)cutPointOfCircle:(UIView *)circle withPoint:(CGPoint)point {
    CGPoint centerO = circle.center;
    CGFloat d = sqrtf(powf(centerO.x-point.x,2)+powf(centerO.y-point.y, 2));
    CGFloat radianA = asinf(r1/d);
    CGFloat radianB = atan2(point.y-centerO.y, centerO.x-point.x);
    CGFloat radianQ = radianB-radianA;
    CGFloat x = r1*sinf(radianQ)+centerO.x;
    CGFloat y = r1*cosf(radianQ)+centerO.y;
    if (isnan(x)) {
        x = 0.f;
    }
    if (isnan(y)) {
        y = 0.f;
    }
    return CGPointMake(x, y);
}

- (CGPoint)cutPoint1OfCircle:(UIView *)circle withPoint:(CGPoint)point {
    CGPoint centerO = circle.center;
    CGFloat d = sqrtf(powf(centerO.x-point.x,2)+powf(centerO.y-point.y, 2));
    CGFloat radianA = asinf(r1/d);
    CGFloat radianB = atan2(centerO.x - point.x, point.y - centerO.y);
    CGFloat radianQ = radianB-radianA;
    CGFloat x = centerO.x - r1*cosf(radianQ);
    CGFloat y = centerO.y - r1*sinf(radianQ);
    if (isnan(x)) {
        x = 0.f;
    }
    if (isnan(y)) {
        y = 0.f;
    }
    return CGPointMake(x, y);
}

- (CGPoint)anchorPointWithOffset:(CGFloat)offset {
    CGPoint centerF = _headView.center;
    CGPoint centerS = _tailView.center;
    CGFloat radianA = atan2(centerS.y-centerF.y, centerF.x-centerS.x);
    
    CGPoint midPoint = CGPointMake((_headView.center.x+_tailView.center.x)/2 - r1*sinf(radianA), (_headView.center.y+_tailView.center.y)/2-r1*cosf(radianA));
    CGFloat x = midPoint.x + offset*sinf(radianA);
    CGFloat y = midPoint.y + offset*cosf(radianA);
    if (isnan(x)) {
        x = 0.f;
    }
    if (isnan(y)) {
        y = 0.f;
    }
    return CGPointMake(x, y);
}

- (CGPoint)anchorPoint1WithOffset:(CGFloat)offset {
    CGPoint centerF = _headView.center;
    CGPoint centerS = _tailView.center;
    CGFloat radianA = atan2(centerS.y-centerF.y, centerF.x-centerS.x);

    CGPoint midPoint = CGPointMake((_headView.center.x+_tailView.center.x)/2 + r1*sinf(radianA), (_headView.center.y+_tailView.center.y)/2 + r1*cosf(radianA));
    CGFloat x = midPoint.x - offset*sinf(radianA);
    CGFloat y = midPoint.y - offset*cosf(radianA);
    if (isnan(x)) {
        x = 0.f;
    }
    if (isnan(y)) {
        y = 0.f;
    }
    return CGPointMake(x, y);
}
@end
