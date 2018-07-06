//
//  MXPopAnimation.m
//  MXNotebook
//
//  Created by yellow on 2017/8/8.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXPopAnimation.h"

@implementation MXPopAnimation

//返回动画持续时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //获取起点controller
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    //获取终点controller
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //获取转场容器视图
    UIView *containerView = [transitionContext containerView];
    
    //设置终点视图的frame
    //CGRect frame = [transitionContext initialFrameForViewController:fromVC];
    //CGRect offScreenFrame = frame;
    //先将其设置到屏幕外边，通过动画进入
    //offScreenFrame.origin.x = offScreenFrame.size.width;
    //toVC.view.frame = offScreenFrame;
    
    toVC.view.alpha = 0;
    
    //添加视图
    [containerView addSubview:toVC.view];
    
    //执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //设置缩放和透明度
        //fromVC.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
        //fromVC.view.alpha = 0.5;
        //设置位置
        //toVC.view.frame = frame;
        //fromVC.navigationController.navigationBar.alpha = 0;
        //toVC.navigationController.navigationBar.alpha = 1;
        fromVC.view.alpha = 0;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        //fromVC.view.transform = CGAffineTransformIdentity;
        fromVC.view.alpha = 1;
        //toVC.view.alpha = 0;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
