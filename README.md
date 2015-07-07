![LTNavigationbar](https://cocoapod-badges.herokuapp.com/v/LTNavigationBar/badge.png)

***

这是一份基于[LTNavigationBar](https://github.com/ltebean/LTNavigationBar)的测试示例代码，复现了我遇到的一个UINavigationBar问题。    

这份代码的目的是模仿京东app首页的导航栏效果，首页的导航栏起初为透明的，向上滑动的时候导航栏逐步变色，直至到一个临界点停止变色，向下滑动的时候又逐步恢复为透明的。注意首页的view是全屏展示的，示例代码中是在storyboard里设置了全屏展示，如果是用xib，就需要设置self.automaticallyAdjustsScrollViewInsets为NO了。

上面的效果是实现了，但是在从首页Push到Next VC，再手势返回的时候，导航栏上的动画效果就乱了。我是用各种排除法最终定位到这个问题的根源在于Next VC里面的一行代码：self.edgesForExtendedLayout = UIRectEdgeNone;
手势返回时的混乱动画如下图所示：

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/problem1.png)

如果把一行注释掉(在示例代码中的NormalViewController类中)，动画是不会乱了，但是会导致如下图所示的问题，大家应该都知道UIRectEdgeNone是干什么用的。

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/problem2.png)


测试了一下京东的app，它是没有这个问题的，用Reveal对它进行了分析，首页的顶部也是使用了UINavigationBar的，这就排除了它使用了假Bar的情况。

之前阳神的[《一个丝滑的全屏滑动返回手势》](http://blog.sunnyxx.com/2015/06/07/fullscreen-pop-gesture/)涉及到了UINavigationBar的动画问题，然而主要是针对真bar与假bar的动画切换问题，对于这个问题似乎无解.

***

## Purpose
It is hard to change the appearance of UINavigationBar dynamically, so I made this lib to make the job easy.


## Demo
#### 1. Changing the background color:
![LTNavigationbar](https://raw.githubusercontent.com/ltebean/LTNavigationBar/master/images/demo.gif)


#### 2. Making navigation bar scroll along with a scroll view:
![LTNavigationbar](https://raw.githubusercontent.com/ltebean/LTNavigationBar/master/images/demo2.gif)

## Usage

First, import this lib:
```objective-c
#import "UINavigationBar+Awesome.h"
```

The category includes lots of method that helps to change UINavigationBar's appearance dynamically:
```objective-c
@interface UINavigationBar (Awesome)
- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setContentAlpha:(CGFloat)alpha;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;
@end
```

You can call the various setter wherever you want, like:
```objective-c
[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor blueColor]];
```

And usually in `viewWillDisappear`, you should call this method to avoid any side effects:
```objective-c
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}
```

See the example for details~ 