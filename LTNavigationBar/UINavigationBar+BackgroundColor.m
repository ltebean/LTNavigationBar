//
//  UINavigationBar+BackgroundColor.m
//  SuiXiang
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>


@implementation UINavigationBar (BackgroundColor)
static char const * const bgColorkey = "bgColor";

- (UIView *)bgView
{
    return objc_getAssociatedObject(self, bgColorkey);
}

- (void)setBgView:(UIView *)bgView
{
    objc_setAssociatedObject(self, bgColorkey, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (!self.bgView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        [self insertSubview:self.bgView atIndex:0];
    }
    self.bgView.backgroundColor = bgColor;
}
@end
