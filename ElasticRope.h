//
//  ElasticRope.h
//  ElasticRope
//
//  Created by gukong on 15/11/14.
//  Copyright © 2015年 Nate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElasticRope : UIView

@property (nonatomic, assign) CGPoint headPoint;
@property (nonatomic, assign) CGPoint tailPoint;
@property (nonatomic, assign) CGFloat strictCoefficient; // default 500

@end
