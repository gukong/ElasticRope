//
//  ViewController.m
//  ElasticRope
//
//  Created by gukong on 15/11/14.
//  Copyright © 2015年 Nate. All rights reserved.
//

#import "ViewController.h"
#import "ElasticRope.h"

@interface ViewController ()
{
    ElasticRope *elasticRope;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    elasticRope = [[ElasticRope alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [elasticRope setCenter:CGPointMake(CGRectGetMidX(self.view.frame), 100)];
    [self.view addSubview:elasticRope];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionForGestureRecognizer:)];
    [self.view addGestureRecognizer:panGes];
}

- (void)actionForGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    
    CGPoint dragPoint = [gesture locationInView:self.view];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [elasticRope setHeadPoint:dragPoint];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged){
        [elasticRope setTailPoint:dragPoint];
    }
}

@end
