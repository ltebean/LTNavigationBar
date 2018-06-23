//
//  UINavigationBar+Awesome.m
//  LTNavigationBar
//
//  Created by ltebean on 15-2-15.
//  Copyright (c) 2015 ltebean. All rights reserved.
//

#import <objc/runtime.h>
#import "UINavigationBar+Awesome.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation UINavigationBar (Awesome)
static char overlayKey;
static char queuedBackgroundColorKey;

+ (void)load
{
#if !TARGET_INTERFACE_BUILDER
    //swizzle method didMoveToWindow
    Class class = [self class];
    
    SEL originalSelector = @selector(didMoveToWindow);
    SEL swizzledSelector = @selector(lt_DidMoveToWindow);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
#endif
}

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)queuedBackgroundColor
{
    return objc_getAssociatedObject(self, &queuedBackgroundColorKey);
}

- (void)setQueuedBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, &queuedBackgroundColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    //for better performance, minimize call self.overlay
    UIView *bgOverlay = self.overlay;
    if (!bgOverlay)
    {
        if (self.subviews.count == 0)
        {
            /*We call layoutIfNeeded to force subviews to be created. However, it only work for iOS 11 and below.
              For iOS 12, the subviews of navigation bar is created after navigation bar didMoveToWindow,
              so we need to swizzle didMoveToWindow method, see class method + (void)load */
            [self layoutIfNeeded];
        }
        
        if (self.subviews.count > 0)
        {
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            
            bgOverlay = [[UIView alloc] initWithFrame:[self.subviews firstObject].bounds];
            bgOverlay.userInteractionEnabled = NO;
            bgOverlay.translatesAutoresizingMaskIntoConstraints = NO;
            //[self.subviews firstObject] is _UIBarBackground
            [[self.subviews firstObject] insertSubview:bgOverlay atIndex:0];
            
            //_UIBarBackground's frame can be changed, so we use auto layout
            CGFloat topOffset = 0;
            if (SYSTEM_VERSION_LESS_THAN(@"11.0"))
            {
                /*For iOS below 11.0, the _UIBarBackground of standalone UINavigationBar
                  won't extend to status bar, so we do it manually. BUT what if UINavigationBar
                  is in a UINavigationController, don't worry, -20 does no harm.
                /*/
                topOffset = -20;
            }
            NSString *vVisualFormat = [NSString stringWithFormat:@"V:|-(%i)-[overlay]-(0)-|", (int)topOffset];
            NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:vVisualFormat
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"overlay":bgOverlay}];
            NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[overlay]-(0)-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"overlay":bgOverlay}];
            [bgOverlay.superview addConstraints:vConstraints];
            [bgOverlay.superview addConstraints:hConstraints];

            self.overlay = bgOverlay;
        }
    }
    
    if (bgOverlay)
    {
        bgOverlay.backgroundColor = backgroundColor;
    }
    else
    {
        self.queuedBackgroundColor = backgroundColor;
    }
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setElementsAlpha:(CGFloat)alpha
{
    if (SYSTEM_VERSION_LESS_THAN(@"11.0"))
    {
        [[self valueForKey:@"_leftViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
            view.alpha = alpha;
        }];
        
        [[self valueForKey:@"_rightViews"] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger i, BOOL *stop) {
            view.alpha = alpha;
        }];
        
        UIView *titleView = [self valueForKey:@"_titleView"];
        titleView.alpha = alpha;
        //when viewController first load, the titleView maybe nil
        [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
                obj.alpha = alpha;
            }
            else if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
                obj.alpha = alpha;
            }
        }];
    }
    else
    {
        [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            if (![obj isKindOfClass:NSClassFromString(@"_UIBarBackground")])
            {
                //_UINavigationBarLargeTitleView, _UINavigationBarContentView, _UINavigationBarModernPromptView
                if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")])
                {
                    [[obj subviews] enumerateObjectsUsingBlock:^(UIView *subObj, NSUInteger idx, BOOL *stop) {
                        if (![subObj isKindOfClass:[UILabel class]])
                        {
                            subObj.alpha = alpha;
                        }
                        else
                        {
                            [self lt_setTitleLabelAlpha:alpha titleLabel:(UILabel*)subObj];
                        }
                    }];
                }
                else
                {
                    if (obj.subviews.count > 0)
                    {
                        [[obj subviews] enumerateObjectsUsingBlock:^(UIView *subObj, NSUInteger idx, BOOL *stop) {
                            subObj.alpha = alpha;
                        }];
                    }
                    else
                    {
                        obj.alpha = alpha;
                    }
                }
            }
        }];
    }
}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

- (void)lt_DidMoveToWindow
{
    [self lt_DidMoveToWindow];
    UIColor *queuedColor = self.queuedBackgroundColor;
    if (queuedColor != nil)
    {
        if (self.subviews.count == 0)
        {
            [self layoutSubviews];
        }
        
        if (self.subviews.count > 0)
        {
            [self lt_setBackgroundColor:queuedColor];
            self.queuedBackgroundColor = nil;
        }
    }
}

//set the alpha value of title label by set text color
- (void)lt_setTitleLabelAlpha:(CGFloat)alpha titleLabel:(UILabel*)label
{
    NSDictionary *attr = [self titleTextAttributes];
    UIColor *textColor = [attr valueForKey:NSForegroundColorAttributeName];
    if (textColor == nil)
    {
        textColor = label.textColor;
    }
    if (textColor == nil)
    {
        textColor = [UIColor blackColor];
    }
    textColor = [textColor colorWithAlphaComponent:alpha];
    
    NSMutableDictionary *newAttr = [[NSMutableDictionary alloc] initWithCapacity:attr.count + 1];
    if (attr.count > 0)
    {
        [newAttr addEntriesFromDictionary:attr];
    }
    [newAttr setObject:textColor forKey:NSForegroundColorAttributeName];
    [self setTitleTextAttributes:newAttr];
}

@end
