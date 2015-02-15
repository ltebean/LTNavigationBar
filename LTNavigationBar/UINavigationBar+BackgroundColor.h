//
//  UINavigationBar+BackgroundColor.h
//  SuiXiang
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015年 ltebean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (BackgroundColor)
@property (nonatomic, strong) UIView *bgView;
- (void)setBgColor:(UIColor *)bgColor;
@end
