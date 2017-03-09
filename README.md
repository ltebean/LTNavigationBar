
##UINavigationBar的动画效果问题
***


先说说这份代码，这是一份基于[LTNavigationBar](https://github.com/ltebean/LTNavigationBar)的测试示例代码，复现了我遇到的一个UINavigationBar问题。    

此代码的目的是模仿京东app首页的导航栏效果，首页的导航栏起初为透明的，向上滑动的时候导航栏逐步变色，直至到一个临界点停止变色，向下滑动的时候又逐步恢复为透明的。注意首页的view是全屏展示的，示例代码中是在storyboard里设置了全屏展示，如果是用xib，就需要设置self.automaticallyAdjustsScrollViewInsets为NO了。

上面的效果是实现了，但是在从首页Push到Next VC（点击首页右上角的Push按钮），再手势返回的时候，导航栏上的动画效果就乱了。我是用各种排除法最终定位到这个问题的根源在于Next VC里面的一行代码：self.edgesForExtendedLayout = UIRectEdgeNone;

手势返回时的混乱动画如下图所示：

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/problem1.png)

如果把一行注释掉(在示例代码中的NormalViewController类中)，动画是不会乱了，但是会导致如下图所示的问题，大家应该都知道UIRectEdgeNone是干什么用的。

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/problem2.png)


测试了一下京东的app，它是没有这个问题的，用Reveal对它进行了分析，首页的顶部也是使用了UINavigationBar的，这就排除了它使用了假Bar的情况。

之前阳神的[《一个丝滑的全屏滑动返回手势》](http://blog.sunnyxx.com/2015/06/07/fullscreen-pop-gesture/)涉及到了UINavigationBar的动画问题，然而主要是针对真bar与假bar的动画切换问题，对于这个问题似乎无解.

###问题进展更新

怀疑是因为过早地在首页的viewWillAppear中对导航栏的alpha进行了设置，于是把首页里的viewWillAppear更换成viewDidAppear，仍然使用self.edgesForExtendedLayout = UIRectEdgeNone; 这样就不会出现上面的返回时的透明UINavigationBar效果，而是出现了下面的效果：

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/problem3.png)

###京东app首页导航栏分析

还是再对京东app首页的导航栏深究一下吧。

在京东app首页里面点击菜单上的“全部”按钮Push到“百宝箱”页面，手势返回的时候效果如下图所示，可以看到它的NavBar的动画切换不是默认的CrossFade效果，而是全屏切换的，与[《一个丝滑的全屏滑动返回手势》](http://blog.sunnyxx.com/2015/06/07/fullscreen-pop-gesture/)一文中的真bar与假bar切换效果毫无二致。京东app的其它页面也基本上都是这个效果。

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/jdSwipeBack.png)

用Reveal对上面所说的手势返回瞬间进行了分析，发现了一个关键的ScreenShotView：

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/jdScreenShot.png)

而这个ScreenShotView又分成了两个UIImageView，一个为导航栏截图，一个内容截图：

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/jdScreenShotNavBar.png)

![LTNavigationbar](https://raw.githubusercontent.com/wonderffee/LTNavigationBar/master/images/jdScreenShotMainView.png)

可以看见，从首页Push到“百宝箱”页面时，京东app对首页的导航栏和内容分别做了截图保存到ScreenShotView中。对其它页面的Pop操作进行同样的Reveal分析，基本上也都是利用到了这个ScreenShotView，似乎这样就确保了UINavigationBar pop动画不是默认的CrossFade的效果？

我仍然有点疑惑的是，如果是在push时对上一屏（设为VC A）进行了截图并覆盖了上一屏的View，在被pop的VC（设为 B）有导航栏的情况下，pop VC B时应该依旧存在针对B导航栏的CrossFade动画效果，而在京东app上的pop操作是没有这个动画效果的。

待续...


***

![LTNavigationbar](https://cocoapod-badges.herokuapp.com/v/LTNavigationBar/badge.png)

## swift version

[https://github.com/ltebean/LTNavigationBar/tree/swift3.0](https://github.com/ltebean/LTNavigationBar/tree/swift3.0)

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
- (void)lt_setElementsAlpha:(CGFloat)alpha;
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